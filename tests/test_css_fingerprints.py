"""Exercise final-byte fingerprints using real files and the Ruby hook."""
import hashlib
import json
from pathlib import Path
import subprocess
import tempfile
import unittest

ROOT = Path(__file__).resolve().parents[1]


class CssFingerprints(unittest.TestCase):
    def run_hook(self, directory, baseurl=''):
        code = r'''
require 'json'
module Liquid
  class Template
    def self.register_filter(_filter); end
  end
end
require ARGV.shift
Site = Struct.new(:dest, :config)
site = Site.new(ARGV.shift, {'baseurl' => ARGV.shift})
Jekyll::CacheBust.finalize_site_css(site)
'''
        return subprocess.run(['ruby', '-e', code, str(ROOT / '_plugins/cache-bust.rb'),
                               str(directory), baseurl], text=True, capture_output=True)

    def test_final_bytes_baseurl_queries_and_repeated_watch_writes(self):
        with tempfile.TemporaryDirectory() as temp:
            root = Path(temp)
            css = root / 'assets/css/main.css'
            css.parent.mkdir(parents=True)
            css.write_bytes(b'body{color:navy}')
            page = root / 'index.html'
            original = ('<link rel="stylesheet" href="/portfolio/assets/css/main.css?mode=one&amp;v=__SITE_CSS_SHA256__#theme">'
                        '<link href="https://cdn.example.test/style.css" rel="stylesheet" integrity="sha384-unchanged">')
            page.write_text(original)
            result = self.run_hook(root, '/portfolio')
            self.assertEqual(result.returncode, 0, result.stderr)
            digest = hashlib.sha256(css.read_bytes()).hexdigest()
            expected = original.replace('__SITE_CSS_SHA256__', digest)
            self.assertEqual(page.read_text(), expected)
            self.assertEqual(self.run_hook(root, '/portfolio').returncode, 0)
            self.assertEqual(page.read_text(), expected)
            css.write_bytes(b'body{color:blue}')
            # A watch render may rewrite the original marker or leave an old digest.
            self.assertEqual(self.run_hook(root, '/portfolio').returncode, 0)
            self.assertNotIn(digest, page.read_text())
            page.write_text(original)
            self.assertEqual(self.run_hook(root, '/portfolio').returncode, 0)
            self.assertIn(hashlib.sha256(css.read_bytes()).hexdigest(), page.read_text())

    def test_relative_static_stylesheets_are_fingerprinted(self):
        with tempfile.TemporaryDirectory() as temp:
            root = Path(temp)
            (root / 'nested').mkdir()
            (root / 'plain.css').write_bytes(b'p{}')
            page = root / 'nested/index.html'
            page.write_text("<link href='../plain.css' media='print' rel='stylesheet'>")
            result = self.run_hook(root)
            self.assertEqual(result.returncode, 0, result.stderr)
            self.assertIn('../plain.css?v=' + hashlib.sha256(b'p{}').hexdigest(), page.read_text())

    def test_missing_escaping_and_unresolved_references_fail(self):
        for markup in ('<link rel="stylesheet" href="/missing.css?v=__SITE_CSS_SHA256__">',
                       '<link rel="stylesheet" href="../../outside.css">',
                       '<p>__SITE_CSS_SHA256__</p>'):
            with self.subTest(markup=markup), tempfile.TemporaryDirectory() as temp:
                root = Path(temp)
                (root / 'index.html').write_text(markup)
                result = self.run_hook(root)
                self.assertNotEqual(result.returncode, 0)
                self.assertRegex(result.stderr, 'Missing|Unsafe|Unresolved')
