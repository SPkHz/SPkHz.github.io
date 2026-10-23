"""Publication regression tests; standard library only, synthetic artifacts."""
from pathlib import Path
import subprocess
import sys
import tempfile
import unittest

ROOT = Path(__file__).resolve().parents[1]
VALIDATOR = ROOT / "scripts/validate_public_artifacts.py"


class PublicArtifactTest(unittest.TestCase):
    def setUp(self):
        self.assertTrue(VALIDATOR.is_file(), "Publication guard is missing")
        self.temp = tempfile.TemporaryDirectory()
        self.addCleanup(self.temp.cleanup)
        self.base = Path(self.temp.name)
        self.output = self.base / "public"
        self.output.mkdir()
        (self.output / "index.html").write_text("<h1>Public page</h1>")

    def validate(self, path=None):
        return subprocess.run([sys.executable, str(VALIDATOR), str(path or self.output)], capture_output=True, text=True)

    def test_validator_is_versionable(self):
        result = subprocess.run(['git', '-C', str(ROOT), 'check-ignore', '--no-index',
                                 'scripts/validate_public_artifacts.py'], capture_output=True)
        self.assertEqual(result.returncode, 1, 'Required publication guard must not be ignored')

    def test_public_assets_pass(self):
        assets = self.output / "assets"
        assets.mkdir()
        (assets / "site.js").write_text("console.log('public');")
        (self.output / ".well-known").mkdir()
        (self.output / ".well-known/security.txt").write_text("Contact: public@example.invalid")
        self.assertEqual(self.validate().returncode, 0)

    def test_academic_downloads_and_runtime_library_output_pass(self):
        for name in ('assets/course/docs/lab.pdf', 'assets/course/generate_plots.py',
                     'assets/libs/mathjax/output/chtml.js'):
            path = self.output / name
            path.parent.mkdir(parents=True, exist_ok=True)
            path.write_text('public course material or library asset')
        self.assertEqual(self.validate().returncode, 0)

    def test_guidance_tools_and_development_files_fail(self):
        for name in ("README.md", "HUMAN_README.md", "AGENTS.md", "CLAUDE.md", "FAQ.md", "README.html", "FAQ.html",
                     ".agents/skills/demo/SKILL.md", ".codex/config.toml", ".claude/settings.json", ".vscode/settings.json",
                     "_scripts/tool.js", "scripts/check.py", "tests/test.py", "docs/notes.md", "plans/work.md",
                     ".env.local", "sendgrid.env", "deno.json", "package-lock.json", "Procfile", "config/nginx.conf.erb",
                     "nested/.git/config", "nested/AGENTS.md", "private-system-notes.md", "session-management.md"):
            with self.subTest(name=name):
                path = self.output / name
                path.parent.mkdir(parents=True, exist_ok=True)
                path.write_text("SYNTHETIC PRIVATE CONTENT")
                result = self.validate()
                self.assertNotEqual(result.returncode, 0, name)
                self.assertNotIn("SYNTHETIC PRIVATE CONTENT", result.stdout + result.stderr)
                path.unlink()
                parent = path.parent
                while parent != self.output:
                    parent.rmdir()
                    parent = parent.parent

    def test_symlink_escape_dangling_cycle_and_root_symlink_fail(self):
        outside = self.base / "outside"
        outside.write_text("PRIVATE")
        link = self.output / "innocent.html"
        for target in (outside, self.base / "missing", link, self.output):
            with self.subTest(target=target.name):
                link.symlink_to(target)
                result = self.validate()
                link.unlink()
                self.assertNotEqual(result.returncode, 0)
                self.assertNotIn("Traceback", result.stderr)
        link.symlink_to(self.base, target_is_directory=True)
        self.assertNotEqual(self.validate().returncode, 0)
        link.unlink()
        root_link = self.base / "root-link"
        root_link.symlink_to(self.output, target_is_directory=True)
        self.assertNotEqual(self.validate(root_link).returncode, 0)

    def test_internal_public_symlink_passes(self):
        (self.output / "alias.html").symlink_to("index.html")
        self.assertEqual(self.validate().returncode, 0)

    def test_missing_and_empty_output_fail(self):
        self.assertNotEqual(self.validate(self.base / "missing").returncode, 0)
        (self.output / "index.html").unlink()
        self.assertNotEqual(self.validate().returncode, 0)


if __name__ == "__main__":
    unittest.main()
