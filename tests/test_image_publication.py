from pathlib import Path
import subprocess
import unittest


class ImagePublication(unittest.TestCase):
    def test_image_generator_respects_publication_exclusions(self):
        root = Path(__file__).resolve().parents[1]
        script = r'''
require 'bundler/setup'
require 'jekyll'
require 'jekyll-imagemagick'
require 'tmpdir'
require 'fileutils'
patch = File.join(Dir.pwd, '_plugins', 'image_publication.rb')
require patch if File.exist?(patch)
Dir.mktmpdir do |source|
  FileUtils.mkdir_p(File.join(source, 'assets/img'))
  %w[prof_pic.jpg kicad_main_board.png].each do |name|
    File.write(File.join(source, 'assets/img', name), 'fixture')
  end
  site = Jekyll::Site.new(Jekyll.configuration({
    'source' => source, 'destination' => File.join(source, '_site'),
    'exclude' => ['assets/img/prof_pic.jpg'], 'plugins' => []
  }))
  generator = JekyllImagemagick::ImageGenerator.new
  files = generator.send(:get_files_to_transform, site, ['assets/img/'], ['.jpg', '.png'])
  abort 'excluded portrait was transformed' if files.any? { |p| p.end_with?('prof_pic.jpg') }
  abort 'public board missing' unless files.any? { |p| p.end_with?('kicad_main_board.png') }
end
'''
        result = subprocess.run(['ruby', '-e', script], cwd=root, capture_output=True, text=True)
        self.assertEqual(result.returncode, 0, result.stdout + result.stderr)
