import html
import json
from pathlib import Path
import re
import subprocess
import unittest

ROOT = Path(__file__).resolve().parents[1]


class SearchSerialization(unittest.TestCase):
    def test_untrusted_quoted_unicode_strings_remain_inert_and_readable(self):
        title = 'Quoted "O\'Neill" \\ Ω <img src=x onerror=alert(1)>'
        description = 'A "quote", a backslash \\, Unicode λ and <script>alert(1)</script>'
        destination = '/projects/quote"and\\unicode-λ/'
        fixture = {'pages': [{'permalink': '/', 'title': title},
                             {'nav': True, 'title': title, 'description': description, 'url': destination}],
                   'posts_in_search': True, 'posts': [{'title': title, 'description': description, 'url': destination}],
                   'collections': [{'label': 'projects', 'docs': [{'title': title, 'description': description, 'url': destination}]}],
                   'socials_in_search': False, 'enable_darkmode': False}
        script = r'''
require 'jekyll'
require 'json'
site = Jekyll::Site.new(Jekyll.configuration('quiet' => true))
source = File.read('_scripts/search-data.liquid').sub(/\A---.*?---/m, '')
puts Liquid::Template.parse(source).render!({'site' => JSON.parse(STDIN.read)}, registers: {site: site})
'''
        result = subprocess.run(['bundle', '_4.0.15_', 'exec', 'ruby', '-e', script],
                                input=json.dumps(fixture), cwd=ROOT, capture_output=True, text=True, check=True)
        titles = re.findall(r'^\s*title:\s*(.+?),\s*$', result.stdout, re.M)
        self.assertEqual(len(titles), 4, result.stdout)
        for value in titles:
            decoded = json.loads(value)
            self.assertEqual(html.unescape(decoded).split(' <img')[0], title.split(' <img')[0])
            self.assertNotIn('<img', decoded)
        ids = re.findall(r'\bid:\s*(.+?),', result.stdout, re.M)
        self.assertEqual(len(ids), 4)
        for value in ids:
            self.assertIsInstance(json.loads(value), str)
        urls = re.findall(r'window.location.href\s*=\s*(.+?);', result.stdout)
        self.assertEqual([json.loads(value) for value in urls], ['/', '/projects/quote%22and%5Cunicode-%CE%BB/', '/projects/quote%22and%5Cunicode-%CE%BB/', '/projects/quote%22and%5Cunicode-%CE%BB/'])
        for value in re.findall(r'^\s*description:\s*(.+?),\s*$', result.stdout, re.M):
            decoded = json.loads(value)
            self.assertIn('a backslash \\', html.unescape(decoded))
            self.assertNotIn('<script', decoded)
