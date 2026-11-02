import importlib.util
import os
from pathlib import Path
import tempfile
import unittest

ROOT = Path(__file__).resolve().parents[1]


class PublicArtifacts(unittest.TestCase):
    def setUp(self):
        source = ROOT / 'scripts/validate_public_artifacts.py'
        self.assertTrue(source.is_file(), 'publication validator must exist')
        spec = importlib.util.spec_from_file_location('public_artifacts', source)
        self.validator = importlib.util.module_from_spec(spec)
        spec.loader.exec_module(self.validator)
        self.temp = tempfile.TemporaryDirectory()
        self.addCleanup(self.temp.cleanup)
        self.root = Path(self.temp.name) / 'site'
        self.root.mkdir()
        (self.root / 'index.html').write_text('<html>Public page</html>')

    def test_clean_output(self):
        self.assertEqual(self.validator.validate(self.root), [])

    def test_empty_output(self):
        (self.root / 'index.html').unlink()
        self.assertTrue(self.validator.validate(self.root))

    def test_forbidden_material(self):
        for name in ('docs/plan.md', '_scripts/search.liquid.js', '.git/config',
                     'assets/.env', 'assets/img/prof_pic.jpg', 'node_modules/x.js',
                     'Gemfile.lock', 'tests/a.py', 'SECURITY.md'):
            with self.subTest(name=name):
                self.assertTrue(self.validator.forbidden(Path(name)))
        self.assertFalse(self.validator.forbidden(Path('.well-known/security.txt')))

    def test_symlinks(self):
        outside = Path(self.temp.name) / 'private.txt'
        outside.write_text('private')
        for target in (outside, self.root / 'missing', self.root):
            link = self.root / 'link'
            link.symlink_to(target)
            self.assertTrue(self.validator.validate(self.root))
            link.unlink()

    def test_special_file(self):
        os.mkfifo(self.root / 'pipe')
        self.assertTrue(self.validator.validate(self.root))

    def test_portrait_text_and_deterministic_diagnostics(self):
        (self.root / 'index.html').write_text('<img src="/assets/img/prof_pic.jpg">')
        (self.root / '.env').write_text('fixture')
        failures = self.validator.validate(self.root)
        self.assertGreaterEqual(len(failures), 2)
        self.assertEqual(failures, sorted(set(failures)))


if __name__ == '__main__':
    unittest.main()
