require 'digest'
require 'open3'

# Conservative identity for the site's raster formats. If a reliable identity
# cannot be established, generation continues without reading/writing the cache.
module ResponsiveImageIdentity
  CODERS = {'jpg' => 'jpeg', 'jpeg' => 'jpeg', 'png' => 'png',
            'gif' => 'gif', 'tif' => 'tiff', 'tiff' => 'tiff', 'webp' => 'webp'}.freeze

  def self.probe(*args)
    output, status = Open3.capture2e(*args)
    raise IOError, 'image identity probe failed' unless status.success?
    output
  end

  def self.fingerprint(converter, config)
    configure = probe(converter, '-list', 'configure')
    descriptions = [probe(converter, '-version'), configure,
                    probe(converter, '-list', 'policy'), probe(converter, '-list', 'delegate')]
    fields = configure.lines.filter_map do |line|
      match = line.match(/\A([A-Z_]+)\s+(\/.*)\s*\z/)
      [match[1], match[2].strip] if match
    end.to_h
    formats = config.fetch('input_formats', []).map { |f| f.delete_prefix('.').downcase } + config.fetch('output_formats', {}).keys.map(&:downcase)
    coders = formats.map { |f| CODERS.fetch(f) { raise IOError, 'uncertified image coder' } }.uniq
    module_dirs = ENV.fetch('MAGICK_CODER_MODULE_PATH', '').split(File::PATH_SEPARATOR) + [fields['CODER_PATH']].compact
    modules = []
    if descriptions.first.include?('Modules')
      coders.each do |coder|
        found = module_dirs.map { |dir| File.join(dir, coder + '.so') }.select { |p| File.file?(p) }
        raise IOError, 'cannot identify raster coder module' if found.empty?
        modules.concat(found)
      end
    end
    config_dirs = ENV.fetch('MAGICK_CONFIGURE_PATH', '').split(File::PATH_SEPARATOR) +
                  %w[CONFIGURE_PATH SHARE_PATH SHAREARCH_PATH].filter_map { |k| fields[k] } +
                  [File.join(Dir.home, '.config/ImageMagick'), File.join(Dir.home, '.magick')]
    configuration = config_dirs.flat_map { |dir| Dir[File.join(dir, '**', '*')].select { |p| File.file?(p) } }
    binaries = [converter] + modules
    libraries = binaries.flat_map do |binary|
      linkage = probe('ldd', binary)
      raise IOError, 'unresolved image library' if linkage.include?('not found')
      linkage.split.select { |part| part.start_with?('/') }
    end
    files = (binaries + libraries + configuration).map { |p| File.realpath(p) }.uniq.sort
    [descriptions, files.map { |p| [p, Digest::SHA256.file(p).hexdigest] }]
  end
end
