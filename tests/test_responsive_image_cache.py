from pathlib import Path
import subprocess
import unittest

ROOT = Path(__file__).resolve().parents[1]


class ResponsiveCache(unittest.TestCase):
    def test_real_converter_cache_invalidation_and_publication(self):
        script = r'''
require 'bundler/setup'
require 'jekyll'
require 'jekyll-imagemagick'
require 'tmpdir'
require 'fileutils'
require File.join(Dir.pwd, '_plugins/image_publication.rb')
module ConversionCounter
  def run(*args)
    $conversions += 1
    result = super
    File.binwrite(args[0], "changed during conversion") if $mutate
    result
  end
end
JekyllImagemagick::ImageConvert.singleton_class.prepend(ConversionCounter)
Dir.mktmpdir do |root|
  source = File.join(root, 'source')
  FileUtils.mkdir_p(File.join(source, 'assets/img'))
  FileUtils.cp('Gemfile.lock', File.join(source, 'Gemfile.lock'))
  input = File.join(source, 'assets/img/board.png')
  system('convert', '-size', '20x10', 'xc:blue', input, exception: true)
  build = lambda do |dest, options = {}|
    site = Jekyll::Site.new(Jekyll.configuration({
      'source' => source, 'destination' => File.join(root, dest), 'plugins' => [],
      'imagemagick' => {'enabled' => true, 'input_directories' => ['assets/img/'],
        'input_formats' => ['.png'], 'widths' => [10, 15],
        'output_formats' => {'webp' => '-quality 85'}}
    }.merge(options)))
    $conversions = 0
    JekyllImagemagick::ImageGenerator.new.generate(site)
    [site, $conversions]
  end
  a, count = build.call('a')
  abort 'cold conversion count' unless count == 2
  original = File.binread(File.join(root, 'a/assets/img/board-10.webp'))
  b, count = build.call('b')
  abort 'fresh destination must hit cache' unless count == 0
  abort 'registration lost' unless b.static_files.size == 2
  abort 'bytes changed' unless original == File.binread(File.join(root, 'b/assets/img/board-10.webp'))
  # Existing output cannot hide changed bytes, even if timestamps are unchanged.
  stamp = File.mtime(input)
  system('convert', '-size', '20x10', 'xc:red', input, exception: true)
  File.utime(stamp, stamp, input)
  _, count = build.call('b')
  abort 'same-mtime changed source accepted' unless count == 2
  entries = Dir[File.join(source, '.jekyll-cache/responsive-images-v1/*.cache')]
  abort 'cache absent' if entries.empty?
  entries.each { |p| File.binwrite(p, 'interrupted') }
  _, count = build.call('b')
  abort 'corrupt entry accepted retained output' unless count == 2
  # Relevant tool environment changes must invalidate the same destination.
  ENV['MAGICK_THREAD_LIMIT'] = '1'
  _, count = build.call('b')
  abort 'tool environment change accepted stale output' unless count == 2
  ENV.delete('MAGICK_THREAD_LIMIT')
  # Exclusions are enforced before lookup, including previously cached inputs.
  excluded, count = build.call('excluded', {'exclude' => ['assets/img/board.png']})
  abort 'excluded image registered' unless excluded.static_files.empty? && count == 0
  # Width/settings changes invalidate even when destinations remain.
  changed = {'enabled' => true, 'input_directories' => ['assets/img/'],
    'input_formats' => ['.png'], 'widths' => [10, 15],
    'output_formats' => {'webp' => '-quality 50'}}
  _, count = build.call('b', {'imagemagick' => changed})
  abort 'settings change accepted stale output' unless count == 2
  entries = Dir[File.join(source, '.jekyll-cache/responsive-images-v1/*.cache')]
  entries.each { |p| File.binwrite(p, 'null' + "\n") }
  _, count = build.call('b', {'imagemagick' => changed})
  abort 'invalid metadata accepted' unless count == 2
  # A symlink cache root is optional failure, never an outside write.
  cache = File.join(source, '.jekyll-cache/responsive-images-v1')
  FileUtils.rm_rf(cache)
  outside = File.join(root, 'outside'); Dir.mkdir(outside)
  File.symlink(outside, cache)
  _, count = build.call('unsafe')
  abort 'unsafe cache did not regenerate' unless count == 2 && Dir.children(outside).empty?
  File.unlink(cache)
  $mutate = true
  begin
    build.call('changing')
    abort 'changed source accepted'
  rescue IOError
    abort 'changed source poisoned cache' unless Dir[File.join(cache, '*.cache')].empty?
  end
end
'''
        result = subprocess.run(['ruby', '-e', script], cwd=ROOT, capture_output=True, text=True)
        self.assertEqual(result.returncode, 0, result.stdout + result.stderr)

    def test_concurrent_records_and_interrupted_writes(self):
        script = r'''
require File.join(Dir.pwd, '_plugins/responsive_image_cache.rb')
require 'tmpdir'
Dir.mktmpdir do |root|
  cache = File.join(root, 'cache')
  children = 6.times.map do
    fork { ResponsiveImageCache.new(cache).fetch(['same']) { 'verified bytes' }; exit! 0 }
  end
  children.each { |pid| Process.wait(pid); abort 'writer failed' unless $?.success? }
  File.binwrite(File.join(cache, 'interrupted.partial'), 'broken')
  c = ResponsiveImageCache.new(cache)
  abort 'concurrent record invalid' unless c.fetch(['same']) { abort 'cache miss' } == 'verified bytes'
  abort 'partial accepted' unless c.fetch(['new']) { 'new bytes' } == 'new bytes'
  outside = File.join(root, 'outside'); Dir.mkdir(outside)
  File.symlink(outside, File.join(root, 'link'))
  c = ResponsiveImageCache.new(File.join(root, 'link/child'))
  abort 'fallback failed' unless c.fetch(['x']) { 'fallback' } == 'fallback'
  abort 'write escaped through parent link' unless Dir.children(outside).empty?
end
'''
        result = subprocess.run(['ruby', '-e', script], cwd=ROOT, capture_output=True, text=True)
        self.assertEqual(result.returncode, 0, result.stdout + result.stderr)

    def test_incomplete_record_and_nonregular_entry_regenerate(self):
        script = r'''
require File.join(Dir.pwd, '_plugins/responsive_image_cache.rb')
require 'tmpdir'
require 'timeout'
Dir.mktmpdir do |root|
  c = ResponsiveImageCache.new(root)
  key = Digest::SHA256.hexdigest(JSON.generate(['incomplete']))
  path = File.join(root, key + '.cache')
  File.write(path, JSON.generate({'key' => key, 'sha256' => 'wrong'}) + "\n")
  abort 'incomplete record failed' unless c.fetch(['incomplete']) { 'regenerated' } == 'regenerated'
  File.unlink(path)
  system('mkfifo', path, exception: true)
  Timeout.timeout(2) do
    abort 'nonregular record failed' unless c.fetch(['incomplete']) { 'regenerated' } == 'regenerated'
  end
end
'''
        result = subprocess.run(['ruby', '-e', script], cwd=ROOT, capture_output=True, text=True)
        self.assertEqual(result.returncode, 0, result.stdout + result.stderr)
