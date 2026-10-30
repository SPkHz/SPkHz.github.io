"""Exercise Chrome-for-Testing verification with synthetic archive bytes."""

import hashlib
import json
from pathlib import Path
import stat
import subprocess
import sys
import tempfile
import unittest
import zipfile


ROOT = Path(__file__).resolve().parents[2]
HELPER = ROOT / ".github" / "ci-tools" / "cft_artifacts.py"
VERSION = "156.0.8078.73"


class CftArtifactsTest(unittest.TestCase):
    def make_archive(self, path, member, output):
        info = zipfile.ZipInfo(member)
        info.external_attr = (stat.S_IFREG | 0o755) << 16
        with zipfile.ZipFile(path, "w") as archive:
            archive.writestr(info, f"#!/bin/sh\nprintf '%s\\n' '{output}'\n")

    def make_fixture(self, root, *, driver_version=VERSION, traversal=False):
        cache = root / "cache"
        cache.mkdir()
        chrome = cache / "chrome-linux64.zip"
        driver = cache / "chromedriver-linux64.zip"
        self.make_archive(
            chrome,
            "../escape" if traversal else "chrome-linux64/chrome",
            f"Google Chrome for Testing {VERSION}",
        )
        self.make_archive(
            driver,
            "chromedriver-linux64/chromedriver",
            f"ChromeDriver {driver_version}",
        )
        artifacts = {}
        for name, archive, executable in (
            ("chrome", chrome, "chrome-linux64/chrome"),
            ("chromedriver", driver, "chromedriver-linux64/chromedriver"),
        ):
            payload = archive.read_bytes()
            artifacts[name] = {
                "url": (
                    f"https://storage.googleapis.com/chrome-for-testing-public/"
                    f"{VERSION}/linux64/{archive.name}"
                ),
                "filename": archive.name,
                "size_bytes": len(payload),
                "sha256": hashlib.sha256(payload).hexdigest(),
                "executable": executable,
                "publisher_checksum_available": False,
            }
        manifest = root / "manifest.json"
        manifest.write_text(
            json.dumps(
                {
                    "schema_version": 1,
                    "version": VERSION,
                    "platform": "linux64",
                    "artifacts": artifacts,
                }
            )
        )
        return manifest, cache

    def run_helper(self, root, manifest, cache):
        output = root / "result.json"
        result = subprocess.run(
            [
                sys.executable,
                str(HELPER),
                "prepare",
                "--manifest",
                str(manifest),
                "--cache-dir",
                str(cache),
                "--install-dir",
                str(root / "install"),
                "--output-json",
                str(output),
                "--offline",
            ],
            capture_output=True,
            text=True,
            timeout=10,
        )
        return result, output

    def test_verified_archives_extract_and_report_exact_executables(self):
        self.assertTrue(HELPER.is_file(), "Chrome-for-Testing helper is missing")
        with tempfile.TemporaryDirectory() as directory:
            root = Path(directory)
            manifest, cache = self.make_fixture(root)
            result, output = self.run_helper(root, manifest, cache)

            self.assertEqual(result.returncode, 0, result.stderr)
            report = json.loads(output.read_text())
            self.assertEqual(report["version"], VERSION)
            self.assertEqual(report["platform"], "linux64")
            self.assertEqual(report["chrome_version"], VERSION)
            self.assertEqual(report["chromedriver_version"], VERSION)
            self.assertTrue(Path(report["chrome_path"]).is_file())
            self.assertTrue(Path(report["chromedriver_path"]).is_file())

    def test_archive_digest_mismatch_fails_before_extraction(self):
        self.assertTrue(HELPER.is_file(), "Chrome-for-Testing helper is missing")
        with tempfile.TemporaryDirectory() as directory:
            root = Path(directory)
            manifest, cache = self.make_fixture(root)
            data = json.loads(manifest.read_text())
            data["artifacts"]["chrome"]["sha256"] = "0" * 64
            manifest.write_text(json.dumps(data))
            result, output = self.run_helper(root, manifest, cache)

            self.assertNotEqual(result.returncode, 0)
            self.assertIn("SHA-256 mismatch", result.stderr)
            self.assertFalse(output.exists())
            self.assertFalse((root / "install").exists())

    def test_unsafe_archive_member_is_rejected(self):
        self.assertTrue(HELPER.is_file(), "Chrome-for-Testing helper is missing")
        with tempfile.TemporaryDirectory() as directory:
            root = Path(directory)
            manifest, cache = self.make_fixture(root, traversal=True)
            result, _ = self.run_helper(root, manifest, cache)

            self.assertNotEqual(result.returncode, 0)
            self.assertIn("unsafe ZIP member", result.stderr)
            self.assertFalse((root / "escape").exists())

    def test_executable_full_version_mismatch_is_rejected(self):
        self.assertTrue(HELPER.is_file(), "Chrome-for-Testing helper is missing")
        with tempfile.TemporaryDirectory() as directory:
            root = Path(directory)
            manifest, cache = self.make_fixture(root, driver_version="156.0.8078.72")
            result, _ = self.run_helper(root, manifest, cache)

            self.assertNotEqual(result.returncode, 0)
            self.assertIn("ChromeDriver version mismatch", result.stderr)


if __name__ == "__main__":
    unittest.main()
