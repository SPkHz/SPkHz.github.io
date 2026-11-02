import importlib.util
from pathlib import Path
import tempfile
import unittest

ROOT = Path(__file__).resolve().parents[1]
REQUIRED = ('assets/js/search-data.js', 'assets/img/kicad_main_board.png',
            'assets/img/og-kicad-main-board.png', '.well-known/security.txt')


class BuiltSite(unittest.TestCase):
    def setUp(self):
        source = ROOT / 'scripts/validate_built_site.py'
        self.assertTrue(source.exists(), 'built site validator must exist')
        spec = importlib.util.spec_from_file_location('built_site', source)
        self.module = importlib.util.module_from_spec(spec)
        spec.loader.exec_module(self.module)
        self.temp = tempfile.TemporaryDirectory()
        self.addCleanup(self.temp.cleanup)
        self.root = Path(self.temp.name)
        for name in REQUIRED:
            p = self.root / name
            p.parent.mkdir(parents=True, exist_ok=True)
            p.write_text('fixture')
        (self.root / 'index.html').write_text('<html>Safe</html>')

    def test_valid(self):
        self.assertEqual(self.module.validate_site(self.root), [])

    def test_social_images_require_absolute_https_urls(self):
        for attribute, name in (('property', 'og:image'), ('name', 'twitter:image')):
            for url in ('/assets/img/card.png', '//example.com/card.png', 'http://example.com/card.png'):
                with self.subTest(name=name, url=url):
                    (self.root / 'index.html').write_text(f'<meta {attribute}="{name}" content="{url}">')
                    self.assertTrue(self.module.validate_site(self.root))
            (self.root / 'index.html').write_text(f'<meta {attribute}="{name}" content="https://spkhz.github.io/assets/img/card.png">')
            self.assertEqual(self.module.validate_site(self.root), [])

    def test_missing_required(self):
        for name in REQUIRED:
            p = self.root / name
            p.unlink()
            self.assertTrue(self.module.validate_site(self.root))
            p.write_text('fixture')

    def test_unsafe_html(self):
        for html in ('<img src="http://example.com/a.png">',
                     '<script src="//example.com/a.js"></script>',
                     '<script src="https://example.com/a.js"></script>',
                     '<link rel="stylesheet" href="https://example.com/a.css">',
                     '<a href="https://example.com" target="_blank">Link</a>',
                     '<img srcset="https://example.com/a.png 1x, http://example.com/b.png 2x">'):
            with self.subTest(html=html):
                (self.root / 'index.html').write_text(html)
                self.assertTrue(self.module.validate_site(self.root))

    def test_pinned_resource(self):
        (self.root / 'index.html').write_text(
            '<script src="https://cdn.example.com/lib@1.2.3/file.js" '
            'integrity="sha384-' + 'A' * 64 + '" crossorigin="anonymous"></script>')
        self.assertEqual(self.module.validate_site(self.root), [])

    def test_css_svg_and_browser_url_interpretation(self):
        fixtures = (
            '<div style="background:url(http://example.com/pixel.png)"></div>',
            '<style>@import "https://example.com/remote.css";</style>',
            r'<style>body { background:url(\68 ttp://example.com/a.png) }</style>',
            '<svg><image href="http://example.com/a.png"/></svg>',
            '<script src="https://evil.example/x.js" src="/assets/safe.js"></script>',
            '<base href="https://evil.example/"><script src="/assets/safe.js"></script>',
        )
        for fixture in fixtures:
            with self.subTest(fixture=fixture):
                (self.root / 'index.html').write_text(fixture)
                self.assertTrue(self.module.validate_site(self.root))

    def test_standalone_css_and_svg(self):
        for name, content in (
            ('unsafe.css', '@import url("https://example.com/a.css");'),
            ('unsafe.svg', '<svg><image href="http://example.com/a.png"/></svg>'),
        ):
            path = self.root / name
            path.write_text(content)
            self.assertTrue(self.module.validate_site(self.root))
            path.unlink()


if __name__ == '__main__':
    unittest.main()
