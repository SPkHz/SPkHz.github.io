"""Exercise the configured Deno publication lane on isolated offline inputs."""
import os
from pathlib import Path
import shutil
import subprocess
import tempfile
import unittest

ROOT = Path(__file__).resolve().parents[1]
INPUT = 'assets'


@unittest.skipUnless(shutil.which('deno'), 'BLOCKED: Deno is unavailable; no installation authorized')
class DenoPublicationTest(unittest.TestCase):
    def test_build_accepts_public_payload_and_rejects_guidance(self):
        with tempfile.TemporaryDirectory() as name:
            fixture = Path(name)
            for rel in ('deno.json', 'deno.lock', 'package.json', 'site/build.ts', 'scripts/validate_public_artifacts.py'):
                if not (ROOT / rel).exists():
                    continue
                target = fixture / rel
                target.parent.mkdir(parents=True, exist_ok=True)
                shutil.copyfile(ROOT / rel, target)
            (fixture / INPUT).mkdir()
            (fixture / INPUT / 'index.html').write_text('<h1>Public</h1>')
            env = dict(os.environ, DENO_NO_UPDATE_CHECK='1')
            command = [shutil.which('deno'), 'task', 'build']
            good = subprocess.run(command, cwd=fixture, env=env, capture_output=True, text=True, timeout=60)
            self.assertEqual(good.returncode, 0, good.stderr)
            self.assertTrue((fixture / '_site_deno/index.html').is_file())
            (fixture / INPUT / 'README.md').write_text('SYNTHETIC PRIVATE')
            bad = subprocess.run(command, cwd=fixture, env=env, capture_output=True, text=True, timeout=60)
            self.assertNotEqual(bad.returncode, 0)
            self.assertIn('README.md', bad.stderr)
            self.assertNotIn('SYNTHETIC PRIVATE', bad.stdout + bad.stderr)
            (fixture / INPUT / 'README.md').unlink()
            (fixture / INPUT / '.env').write_text('SYNTHETIC PRIVATE')
            (fixture / INPUT / 'innocent.html').symlink_to('.env')
            alias = subprocess.run(command, cwd=fixture, env=env, capture_output=True, text=True, timeout=60)
            self.assertNotEqual(alias.returncode, 0, 'Input aliases must not launder hidden development files')
            self.assertNotIn('SYNTHETIC PRIVATE', alias.stdout + alias.stderr)


if __name__ == '__main__':
    unittest.main()
