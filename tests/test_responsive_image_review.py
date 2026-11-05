from pathlib import Path
import subprocess
import unittest

ROOT = Path(__file__).resolve().parents[1]
PRELUDE = r'''
require 'bundler/setup'
require 'jekyll'
require 'jekyll-imagemagick'
require 'tmpdir'
require 'fileutils'
require 'timeout'
require File.join(Dir.pwd, '_plugins/image_publication.rb')
def fixture(root)
  source = File.join(root, 'source')
  FileUtils.mkdir_p(File.join(source, 'assets/img/nested'))
  FileUtils.cp('Gemfile.lock', File.join(source, 'Gemfile.lock'))
  system('convert', '-size', '20x10', 'xc:blue', File.join(source, 'assets/img/nested/board.png'), exception: true)
  source
end
def build(source, dest)
  site = Jekyll::Site.new(Jekyll.configuration({'source' => source, 'destination' => dest,
    'plugins' => [], 'imagemagick' => {'enabled' => true, 'input_directories' => ['assets/img/'],
    'input_formats' => ['.png'], 'widths' => [10], 'output_formats' => {'webp' => '-quality 85'}}}))
  JekyllImagemagick::ImageGenerator.new.generate(site)
  abort 'registration missing' unless site.static_files.size == 1
end
'''


class ReviewRegressions(unittest.TestCase):
    def run_ruby(self, body):
        result = subprocess.run(['ruby', '-e', PRELUDE + body], cwd=ROOT, capture_output=True, text=True)
        self.assertEqual(result.returncode, 0, result.stdout + result.stderr)

    def test_nonzero_conversion_cannot_commit_partial_bytes(self):
        self.run_ruby(r'''
Dir.mktmpdir do |root|
  cache = ResponsiveImageCache.new(File.join(root, 'cache'))
  output = File.join(root, 'output')
  begin
    cache.fetch(['conversion']) do
      JekyllImagemagick::ImageConvert.run_cmd("printf partial > #{output}; exit 1")
      File.binread(output)
    end
    abort 'failed conversion was accepted'
  rescue IOError
    abort 'failed conversion populated cache' unless Dir[File.join(root, 'cache/*.cache')].empty?
  end
  result = cache.fetch(['conversion']) do
    JekyllImagemagick::ImageConvert.run_cmd("printf complete > #{output}")
    File.binread(output)
  end
  abort 'retry failed' unless result == 'complete'
end
''')

    def test_failed_or_missing_identity_probe_regenerates(self):
        self.run_ruby(r'''
Dir.mktmpdir do |root|
  source = fixture(root)
  bin = File.join(root, 'bin'); Dir.mkdir(bin)
  File.symlink('/usr/bin/convert', File.join(bin, 'convert'))
  File.write(File.join(bin, 'ldd'), "#!/bin/sh\nexit 1\n"); File.chmod(0700, File.join(bin, 'ldd'))
  original = ENV['PATH']
  ENV['PATH'] = bin + ':' + original
  build(source, File.join(root, 'failed-probe'))
  ENV['PATH'] = bin
  File.unlink(File.join(bin, 'ldd'))
  build(source, File.join(root, 'missing-probe'))
  abort 'unidentified toolchain cached' unless Dir[File.join(source, '.jekyll-cache/responsive-images-v1/*.cache')].empty?
ensure
  ENV['PATH'] = original
end
''')

    def test_codec_bytes_invalidate_without_converter_change(self):
        self.run_ruby(r'''
abort 'module identity unavailable' unless defined?(ResponsiveImageIdentity)
Dir.mktmpdir do |root|
  converter = File.realpath('/usr/bin/convert')
  config = {'input_formats' => ['.png'], 'output_formats' => {'webp' => '-quality 85'}}
  configure, = Open3.capture2e(converter, '-list', 'configure')
  coders = configure[/^CODER_PATH\s+(.+)$/, 1]
  FileUtils.cp(File.join(coders.strip, 'webp.so'), File.join(root, 'webp.so'))
  old = ENV['MAGICK_CODER_MODULE_PATH']; ENV['MAGICK_CODER_MODULE_PATH'] = root
  a = ResponsiveImageIdentity.fingerprint(converter, config)
  File.open(File.join(root, 'webp.so'), 'ab') { |file| file.write('identity change') }
  b = ResponsiveImageIdentity.fingerprint(converter, config)
  abort 'codec bytes omitted' if a == b
ensure
  ENV['MAGICK_CODER_MODULE_PATH'] = old
end
''')

    def test_output_symlink_rejected_before_external_mkdir(self):
        self.run_ruby(r'''
Dir.mktmpdir do |root|
  source = fixture(root)
  dest = File.join(root, 'dest'); FileUtils.mkdir_p(File.join(dest, 'assets'))
  outside = File.join(root, 'outside'); Dir.mkdir(outside)
  File.symlink(outside, File.join(dest, 'assets/img'))
  begin
    build(source, dest)
    abort 'output symlink accepted'
  rescue IOError
    abort 'external directory created before rejection' unless Dir.children(outside).empty?
  end
end
''')

    def test_input_fifo_rejected_before_hashing(self):
        self.run_ruby(r'''
Dir.mktmpdir do |root|
  source = fixture(root)
  system('mkfifo', File.join(source, 'assets/img/fifo.png'), exception: true)
  Timeout.timeout(3) do
    begin
      build(source, File.join(root, 'dest'))
      abort 'input FIFO accepted'
    rescue IOError
    end
  end
end
''')
