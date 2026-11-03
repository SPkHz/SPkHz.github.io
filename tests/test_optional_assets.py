from pathlib import Path
import subprocess
import unittest

ROOT = Path(__file__).resolve().parents[1]


class OptionalAssets(unittest.TestCase):
    def render(self, template, content):
        code = r'''
require 'jekyll'
site = Jekyll::Site.new(Jekyll.configuration('quiet' => true))
config = site.config.merge('search_enabled' => false, 'enable_math' => false, 'back_to_top' => false, 'enable_progressbar' => false)
page = {'images' => {'slider' => true, 'compare' => true}, 'url' => '/fixture/'}
puts Liquid::Template.parse(File.read(ARGV[0])).render!({'site' => config, 'page' => page, 'content' => STDIN.read}, registers: {site: site})
'''
        result = subprocess.run(['bundle', '_4.0.15_', 'exec', 'ruby', '-e', code, str(ROOT / template)],
                                input=content, cwd=ROOT, text=True, capture_output=True, check=True)
        return result.stdout

    def test_flags_without_widget_elements_do_not_load_optional_resources(self):
        for template in ('_includes/head.liquid', '_includes/scripts.liquid'):
            output = self.render(template, '<p>Plain technical content.</p>')
            for library in ('swiper', 'img-comparison-slider'):
                with self.subTest(template=template, library=library):
                    self.assertNotIn('/npm/' + library + '@', output)

    def test_declared_widget_consumers_keep_their_pinned_resources(self):
        content = '<swiper-container></swiper-container><img-comparison-slider></img-comparison-slider>'
        for template in ('_includes/head.liquid', '_includes/scripts.liquid'):
            output = self.render(template, content)
            for library in ('swiper', 'img-comparison-slider'):
                with self.subTest(template=template, library=library):
                    self.assertIn('/npm/' + library + '@', output)
            self.assertIn('integrity="sha384-', output)
            self.assertIn('crossorigin="anonymous"', output)
