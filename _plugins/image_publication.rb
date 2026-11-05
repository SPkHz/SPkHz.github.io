require 'jekyll-imagemagick'
require 'pathname'

# The upstream generator scans the filesystem, bypassing Jekyll's static-file
# exclusions. Apply the same explicit source exclusions before conversion.
module ImagePublication
  private

  def get_files_to_transform(site, directories, formats)
    files = super.reject do |file|
      relative = Pathname.new(file).relative_path_from(Pathname.new(site.source)).to_s
      site.config.fetch('exclude', []).any? do |excluded|
        prefix = excluded.to_s.delete_suffix('/')
        relative == prefix || relative.start_with?(prefix + '/') ||
          File.fnmatch?(prefix, relative, File::FNM_PATHNAME | File::FNM_DOTMATCH)
      end
    end
    files.each do |file|
      raise IOError, 'image input must be a regular source file' unless File.lstat(file).file?
      ResponsiveImageCache.safe_path!(file)
      raise IOError, 'image input escapes source' unless File.expand_path(file).start_with?(File.realpath(site.source) + '/')
    end
    files
  end
end

JekyllImagemagick::ImageGenerator.prepend(ImagePublication)

require_relative 'responsive_image_cache'
require_relative 'responsive_image_identity'
require 'open3'

module VerifiedResponsiveImages
  private

  def generate_output_paths(site, tuples)
    root = ResponsiveImageCache.safe_path!(site.dest)
    tuples.each do |_input, output, _edge|
      expanded = File.expand_path(output)
      raise IOError, 'image destination escapes output' unless expanded.start_with?(root + '/')
      relative = Pathname.new(File.dirname(expanded)).relative_path_from(Pathname.new(root))
      current = root
      relative.each_filename do |part|
        next if part == '.'
        current = File.join(current, part)
        Dir.mkdir(current) unless File.exist?(current) || File.symlink?(current)
        ResponsiveImageCache.safe_path!(current)
        raise IOError, 'image parent must be a directory' unless File.directory?(current)
      end
    end
  end

  def generate_files(site, tuples, formats)
    return super if ENV['SPKGHIO_IMAGE_CACHE'] == 'off'

    cache = ResponsiveImageCache.new(File.join(site.source, '.jekyll-cache/responsive-images-v1'))
    settings = begin
      converter = ENV.fetch('PATH', '').split(File::PATH_SEPARATOR).map { |p| File.join(p, 'convert') }
                     .find { |p| File.file?(p) && File.executable?(p) }
      raise IOError, 'ImageMagick unavailable' unless converter
      identity = ResponsiveImageIdentity.fingerprint(File.realpath(converter), @config)
      code = [__FILE__, File.join(site.source, 'Gemfile.lock')] +
             Dir[File.join(__dir__, 'responsive_image_*.rb')] +
             Dir[File.join(Gem.loaded_specs.fetch('jekyll-imagemagick').full_gem_path, 'lib/**/*.rb')]
      [@config, site.config.fetch('exclude', []), RUBY_DESCRIPTION, identity,
       ENV.select { |k, _| k.match?(/\A(?:MAGICK|LC_|OMP_)/) || %w[LANG SOURCE_DATE_EPOCH].include?(k) }.sort,
       code.sort.map { |p| Digest::SHA256.file(p).hexdigest }]
    rescue SystemCallError, IOError
      Jekyll.logger.warn('Responsive cache:', 'tool identity unavailable; converting without cache')
      nil
    end
    generated = 0
    tuples.each do |input, output, edge|
      ResponsiveImageCache.safe_path!(input)
      ResponsiveImageCache.safe_path!(File.dirname(output))
      raise IOError, 'image destination escapes output' unless File.expand_path(output).start_with?(File.realpath(site.dest) + '/')
      raise IOError, 'unsafe image output' if File.symlink?(output) || (File.exist?(output) && !File.file?(output))
      relative = Pathname.new(input).relative_path_from(Pathname.new(site.source)).to_s
      digest = Digest::SHA256.file(input).hexdigest
      converted = false
      data = cache.fetch(settings && [relative, digest, edge, File.extname(output), settings]) do
        # A cache miss must not inherit upstream's mtime-only acceptance.
        File.unlink(output) if File.exist?(output)
        generated += super(site, [[input, output, edge]], formats)
        converted = true
        raise IOError, 'Image conversion failed' unless File.file?(output) && File.size?(output)
        raise IOError, 'Image source changed during conversion' unless Digest::SHA256.file(input).hexdigest == digest
        File.binread(output)
      end
      raise IOError, 'Image source changed during generation' unless Digest::SHA256.file(input).hexdigest == digest
      next if converted

      Tempfile.create(['responsive-', File.extname(output)], File.dirname(output)) do |file|
        file.binmode
        file.write(data)
        file.flush
        File.rename(file.path, output)
      end
      # Upstream uses <= mtime, so make verified restored bytes strictly newer.
      stamp = [Time.now, File.mtime(input) + 1].max
      File.utime(stamp, stamp, output)
      generated += super(site, [[input, output, edge]], formats)
    end
    Jekyll.logger.info('Responsive cache:', "hits=#{cache.hits} misses=#{cache.misses} restored_bytes=#{cache.bytes}")
    generated
  end
end

JekyllImagemagick::ImageGenerator.prepend(VerifiedResponsiveImages)

# Preserve the locked converter command and return shape, but require successful
# completion: upstream logs failures and otherwise discards the exit status.
module VerifiedImageConversion
  def run_cmd(command)
    output, error, status = Open3.capture3(command)
    raise IOError, 'ImageMagick conversion failed' unless status.success?
    [output.lines.first, error.lines.first]
  end
end

JekyllImagemagick::ImageConvert.singleton_class.prepend(VerifiedImageConversion)
