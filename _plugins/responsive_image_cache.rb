require 'digest'
require 'json'
require 'tempfile'
require 'fileutils'

# Disposable, local cache. A single atomically renamed record commits metadata
# and bytes together. No paths are read from records; names are SHA-256 keys.
class ResponsiveImageCache
  LIMIT = 64 * 1024 * 1024
  attr_reader :hits, :misses, :bytes

  def initialize(root)
    @root = File.expand_path(root)
    @hits = @misses = @bytes = 0
  end

  def self.safe_path!(path)
    expanded = File.expand_path(path)
    raise IOError, 'unsafe image/cache path' unless File.realpath(expanded) == expanded
    expanded
  end

  def prepare_root
    current = File::SEPARATOR
    @root.split(File::SEPARATOR).reject(&:empty?).each do |part|
      current = File.join(current, part)
      begin
        Dir.mkdir(current, 0o700) unless File.exist?(current) || File.symlink?(current)
      rescue Errno::EEXIST
        # Another builder may have created the directory.
      end
      self.class.safe_path!(current)
      raise IOError, 'cache parent is not a directory' unless File.directory?(current)
    end
  end

  def fetch(identity)
    if identity.nil?
      @misses += 1
      return yield
    end
    key = Digest::SHA256.hexdigest(JSON.generate(identity))
    begin
      prepare_root
      self.class.safe_path!(@root)
      path = File.join(@root, key + '.cache')
      File.open(path, File::RDONLY | File::NOFOLLOW | File::NONBLOCK) do |file|
        raise IOError, 'not a regular cache record' unless file.stat.file?
        header = file.gets(4096)
        meta = JSON.parse(header || '')
        data = file.read(LIMIT + 1) || ''.b
        if meta.is_a?(Hash) && meta['key'] == key && data.bytesize <= LIMIT && !data.empty? &&
           meta['sha256'] == Digest::SHA256.hexdigest(data)
          @hits += 1
          @bytes += data.bytesize
          return data
        end
      end
    rescue SystemCallError, IOError, JSON::ParserError, TypeError
      # Missing, incompatible, unsafe or incomplete caches never prevent conversion.
    end
    @misses += 1
    data = yield
    begin
      self.class.safe_path!(@root)
      if data.bytesize <= LIMIT && !data.empty?
        Tempfile.create(['image-', '.partial'], @root) do |file|
          file.binmode
          file.write(JSON.generate({'key' => key, 'sha256' => Digest::SHA256.hexdigest(data)}) + "\n")
          file.write(data)
          file.flush
          file.fsync
          self.class.safe_path!(@root)
          File.rename(file.path, File.join(@root, key + '.cache'))
        end
      end
    rescue SystemCallError, IOError
      # Cache storage is optional, including read-only/full filesystems.
    end
    data
  end
end
