"""Exercise the real entrypoint with synthetic commands and no site server."""

from pathlib import Path
import signal
import subprocess
import sys
import tempfile
import unittest


ROOT = Path(__file__).resolve().parents[2]


class EntrypointLockTest(unittest.TestCase):
    def run_entrypoint(self, with_lock):
        with tempfile.TemporaryDirectory() as directory:
            root = Path(directory)
            tools = root / "bin"
            tools.mkdir()
            original = "BUNDLED WITH\n  4.0.15\n"
            if with_lock:
                (root / "Gemfile.lock").write_text(original)
            (root / "_config.yml").write_text("title: synthetic\n")
            # The watcher terminates only its owned entrypoint parent after
            # startup. Nothing listens on a port or accesses a real repository.
            stub = f"#!{sys.executable}\n" + '''
import os
from pathlib import Path
import signal
import sys
name = Path(sys.argv[0]).name
with Path("calls").open("a") as output:
    output.write(name + " " + " ".join(sys.argv[1:]) + "\\n")
if name == "git" and "ls-files" in sys.argv:
    sys.exit(1)
if name == "bundle" and os.environ.get("BUNDLE_FROZEN") != "true":
    Path("Gemfile.lock").write_text("unreviewed resolution\\n")
if name == "inotifywait":
    os.kill(os.getppid(), signal.SIGTERM)
'''
            for name in ("git", "bundle", "sleep", "inotifywait"):
                executable = tools / name
                executable.write_text(stub)
                executable.chmod(0o755)
            (tools / "rm").symlink_to("/bin/rm")
            result = subprocess.run(
                ["/bin/bash", str(ROOT / "bin/entry_point.sh")],
                cwd=root,
                env={"PATH": str(tools), "LANG": "C.UTF-8"},
                capture_output=True,
                text=True,
                timeout=5,
            )
            self.assertIn(result.returncode, (1, -signal.SIGTERM), result.stderr)
            lock = root / "Gemfile.lock"
            calls = root / "calls"
            return (lock.read_text() if lock.exists() else None), original, (
                calls.read_text() if calls.exists() else ""
            )

    def test_existing_lock_is_preserved_and_git_state_is_untouched(self):
        actual, original, calls = self.run_entrypoint(True)
        self.assertEqual(actual, original)
        self.assertIn("bundle ", calls)
        self.assertNotIn("git ", calls)

    def test_missing_lock_refuses_package_manager_and_site_start(self):
        actual, _, calls = self.run_entrypoint(False)
        self.assertIsNone(actual)
        self.assertNotIn("bundle ", calls)


if __name__ == "__main__":
    unittest.main()
