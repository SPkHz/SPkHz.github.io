from pathlib import Path
import unittest

ROOT = Path(__file__).resolve().parents[1]
REMOVED = ('chartjs', 'diff2html', 'echarts', 'leaflet', 'lightbox2', 'mermaid',
           'photoswipe', 'plotly', 'polyfill', 'pseudocode', 'spotlight',
           'vega', 'venobox', 'tikzjax', 'typograms', 'google_fonts', 'analytics')


class FrontendSupplyChain(unittest.TestCase):
    def test_inactive_executables_removed(self):
        for name in ('_includes/scripts.liquid', '_includes/head.liquid'):
            source = (ROOT / name).read_text().lower()
            for integration in REMOVED:
                with self.subTest(name=name, integration=integration):
                    self.assertNotIn(integration, source)

    def test_distill_not_used(self):
        for directory in ('_pages', '_posts', '_projects'):
            for path in (ROOT / directory).rglob('*.md'):
                if any(part.startswith('.') for part in path.relative_to(ROOT).parts):
                    continue
                self.assertNotIn('layout: distill', path.read_text())

    def test_cdn_urls_are_resolved(self):
        self.assertNotIn('{{version}}', (ROOT / '_config.yml').read_text())
