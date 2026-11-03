from pathlib import Path
import subprocess
import unittest

ROOT = Path(__file__).resolve().parents[1]


class NativeStyles(unittest.TestCase):
    @classmethod
    def setUpClass(cls):
        result = subprocess.run(['bundle', '_4.0.15_', 'exec', 'ruby', '-rsass-embedded', '-e',
                                 'source = File.read("assets/css/main.scss").sub(/\\A---.*?---/m, "").gsub("{{ site.max_width }}", "930px"); '
                                 'print Sass.compile_string(source, load_paths: ["_sass"], style: :compressed).css'],
                                cwd=ROOT, check=True, capture_output=True, text=True)
        cls.css = result.stdout

    def test_core_stylesheet_within_budget_without_optimizer(self):
        self.assertLessEqual(len(self.css.encode()), 65536)

    def test_runtime_widget_states_survive_sass_compilation(self):
        for selector in ('mjx-container', 'ninja-keys::part(ninja-selected)',
                         '.medium-zoom-overlay', 'swiper-container::part(button-next)',
                         '.tab-content>li.active', '#toc-sidebar', '.copy'):
            with self.subTest(selector=selector):
                self.assertIn(selector, self.css)
