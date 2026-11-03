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

    def test_backlog_variants_are_forbidden_everywhere(self):
        for name in ('NEXT_PLAN.md', 'NEXT_PLAN.html', 'NEXT_PLAN.txt',
                     'next_plan.MARKDOWN', 'notes/NEXT_PLAN.md',
                     'notes/NEXT_PLAN.html', 'assets/archive/next_plan.txt',
                     'assets/NEXT_PLAN/index.html'):
            with self.subTest(name=name):
                self.assertTrue(self.validator.forbidden(Path(name)))
                path = self.root / name
                path.parent.mkdir(parents=True, exist_ok=True)
                path.write_text('Unfinished development work')
                self.assertIn(f'forbidden development material: {name}',
                              self.validator.validate(self.root))
                path.unlink()

    def test_security_contact_remains_publishable(self):
        contact = self.root / '.well-known/security.txt'
        contact.parent.mkdir()
        contact.write_text('Contact: mailto:security@example.test\n')
        self.assertFalse(self.validator.forbidden(Path('.well-known/security.txt')))
        self.assertEqual(self.validator.validate(self.root), [])

    def test_retired_samples_cannot_be_republished(self):
        for name in ('assets/plotly/demo.html', 'assets/video/tutorial_al_folio.mp4'):
            with self.subTest(name=name):
                path = self.root / name
                path.parent.mkdir(parents=True, exist_ok=True)
                path.write_bytes(b'retired upstream sample')
                self.assertTrue(self.validator.validate(self.root))
                path.unlink()

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
