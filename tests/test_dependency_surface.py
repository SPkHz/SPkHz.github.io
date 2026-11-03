import json
from pathlib import Path
import re
import subprocess
import unittest

ROOT = Path(__file__).resolve().parents[1]


class DependencySurface(unittest.TestCase):
    def test_vendored_automation_removed(self):
        for name in ('.github/actions/setup-python', '.github/python-wheels',
                     '.github/ci-tools', 'tests/tooling', 'requirements.txt',
                     'requirements.lock', 'bin/update_scholar_citations.py', '_data/citations.yml'):
            with self.subTest(name=name):
                self.assertFalse((ROOT / name).exists())

    def test_ruby_direct_versions_match_frozen_lock_without_execjs(self):
        manifest = (ROOT / 'Gemfile').read_text()
        direct = dict(re.findall(r"^\s*gem '([^']+)', '([0-9]+\.[0-9]+\.[0-9]+)'", manifest, re.M))
        self.assertEqual(set(direct), {'jekyll', 'jekyll-archives-v2', 'jekyll-email-protect',
                                      'jekyll-feed', 'jekyll-get-json', 'jekyll-imagemagick',
                                      'jekyll-link-attributes', 'jekyll-paginate-v2', 'jekyll-regex-replace',
                                      'jekyll-scholar', 'jekyll-sitemap', 'jekyll-tabs', 'jekyll-toc',
                                      'jemoji', 'classifier-reborn', 'observer'})
        self.assertEqual(len(direct), len(re.findall(r'^\s*gem ', manifest, re.M)))
        result = subprocess.run(['ruby', '-rbundler', '-rjson', '-e',
                                 'lock = Bundler::LockfileParser.new(File.read(ARGV[0])); '
                                 'puts JSON.generate(lock.specs.to_h { |s| [s.name, s.version.to_s] })',
                                 str(ROOT / 'Gemfile.lock')], check=True, capture_output=True, text=True)
        resolved = json.loads(result.stdout)
        checksums = (ROOT / 'Gemfile.lock').read_text().split('CHECKSUMS\n', 1)[1]
        for name, version in resolved.items():
            self.assertRegex(checksums, r'(?m)^  ' + re.escape(name) + r' \(' + re.escape(version) + r'(?:-[^)]+)?\) sha256=[0-9a-f]{64}$')
        for name, version in direct.items():
            self.assertEqual(resolved[name], version)
        for name in ('execjs', 'terser', 'jekyll-terser', 'jekyll-minifier', 'htmlcompressor', 'cssminify2'):
            self.assertNotIn(name, resolved)
        self.assertTrue((ROOT / 'assets/jupyter/blog.ipynb').is_file())

    def test_quality_only_node_dependencies_and_integrity(self):
        package = json.loads((ROOT / 'package.json').read_text())
        lock = json.loads((ROOT / 'package-lock.json').read_text())
        self.assertEqual(set(package['devDependencies']), {'prettier', '@shopify/prettier-plugin-liquid'})
        self.assertFalse(package.get('dependencies'))
        self.assertEqual(lock['packages']['']['devDependencies'], package['devDependencies'])
        for name, version in package['devDependencies'].items():
            with self.subTest(dependency=name):
                self.assertRegex(version, r'^\d+\.\d+\.\d+$')
                self.assertEqual(lock['packages'][f'node_modules/{name}']['version'], version)
        for name, entry in lock['packages'].items():
            if not name:
                continue
            with self.subTest(package=name):
                self.assertRegex(entry['integrity'], r'^sha512-[A-Za-z0-9+/]+=*$')
                self.assertTrue(entry['resolved'].startswith('https://registry.npmjs.org/'))
        for version in package['engines'].values():
            self.assertRegex(version, r'^\d+\.\d+\.\d+$')
        self.assertEqual(package['packageManager'], 'npm@' + package['engines']['npm'])
        self.assertEqual(lock['packages']['']['engines'], package['engines'])
        self.assertEqual(set(package['scripts']), {'format:check', 'js:check'})
        config = json.loads((ROOT / '.devcontainer/devcontainer.json').read_text())
        self.assertEqual(config['features']['ghcr.io/devcontainers/features/node:2']['version'], package['engines']['node'])
        self.assertNotRegex(config['postCreateCommand'], r'\b(npm|npx)\b')
