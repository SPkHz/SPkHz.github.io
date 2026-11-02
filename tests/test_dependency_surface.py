import json
from pathlib import Path
import unittest

ROOT = Path(__file__).resolve().parents[1]


class DependencySurface(unittest.TestCase):
    def test_vendored_automation_removed(self):
        for name in ('.github/actions/setup-python', '.github/python-wheels',
                     '.github/ci-tools', 'tests/tooling', 'requirements.txt',
                     'requirements.lock', 'bin/update_scholar_citations.py', '_data/citations.yml'):
            with self.subTest(name=name):
                self.assertFalse((ROOT / name).exists())

    def test_unused_ruby_dependencies_removed(self):
        gemfile = (ROOT / 'Gemfile').read_text()
        for name in ('jekyll-jupyter-notebook', 'jekyll-twitter-plugin', 'ostruct',
                     'feedjira', 'httparty', 'css_parser'):
            with self.subTest(name=name):
                self.assertNotIn(name, gemfile)
        self.assertTrue((ROOT / 'assets/jupyter/blog.ipynb').is_file())

    def test_exact_node_dependencies(self):
        package = json.loads((ROOT / 'package.json').read_text())
        lock = json.loads((ROOT / 'package-lock.json').read_text())
        self.assertEqual(package['devDependencies'], {
            'prettier': '3.9.10', '@shopify/prettier-plugin-liquid': '1.11.3', 'purgecss': '8.0.0'})
        self.assertEqual(lock['packages']['']['devDependencies'], package['devDependencies'])
        for name, version in package['devDependencies'].items():
            with self.subTest(dependency=name):
                self.assertEqual(lock['packages'][f'node_modules/{name}']['version'], version)
        self.assertEqual(package.get('packageManager'), 'npm@11.19.1')
        self.assertEqual(package.get('engines'), {'node': '24.22.1', 'npm': '11.19.1'})
        self.assertEqual(lock['packages']['']['engines'], package['engines'])
        self.assertIn('format:check', package.get('scripts', {}))
        self.assertIn('css:purge', package.get('scripts', {}))
