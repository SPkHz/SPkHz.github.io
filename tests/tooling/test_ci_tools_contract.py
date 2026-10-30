"""Contract tests for the repository-owned CI tools and their consumers."""

import json
from pathlib import Path
import re
import unittest


ROOT = Path(__file__).resolve().parents[2]
CI_TOOLS = ROOT / ".github" / "ci-tools"
LOCKED_INSTALL = (
    "npm ci --prefix .github/ci-tools --ignore-scripts --no-audit --no-fund"
)
SETUP_NODE = "actions/setup-node@249970729cb0ef3589644e2896645e5dc5ba9c38"
EXPECTED_TOOLS = {
    "@axe-core/cli": "4.14.0",
    "diff2html-cli": "5.2.15",
    "http-server": "14.1.1",
    "purgecss": "8.0.0",
}
EXPECTED_RELEASE_DATES = {
    "@axe-core/cli": "2026-10-15",
    "diff2html-cli": "2024-01-12",
    "http-server": "2022-05-31",
    "purgecss": "2026-01-24",
}


class CiToolsContractTest(unittest.TestCase):
    def read_workflow(self, name):
        return (ROOT / ".github" / "workflows" / name).read_text()

    def test_manifest_and_lock_bind_the_exact_reviewed_graph(self):
        manifest = json.loads((CI_TOOLS / "package.json").read_text())
        lock = json.loads((CI_TOOLS / "package-lock.json").read_text())

        self.assertTrue(manifest["private"])
        self.assertEqual(manifest["packageManager"], "npm@11.19.1")
        self.assertEqual(manifest["engines"], {"node": "24.22.1", "npm": "11.19.1"})
        self.assertEqual(manifest["devDependencies"], EXPECTED_TOOLS)
        self.assertEqual(
            manifest["overrides"], {"get-uri": {"basic-ftp": "6.2.3"}}
        )
        self.assertEqual(lock["lockfileVersion"], 3)
        self.assertEqual(
            lock["packages"][""]["devDependencies"], manifest["devDependencies"]
        )
        self.assertIn("node_modules/axe-core", lock["packages"])
        self.assertEqual(lock["packages"]["node_modules/basic-ftp"]["version"], "6.2.3")
        for path, package in lock["packages"].items():
            if not path or package.get("link"):
                continue
            self.assertRegex(package.get("integrity", ""), r"^sha512-")

    def test_selection_record_preserves_release_and_compatibility_evidence(self):
        selection = json.loads((CI_TOOLS / "tool-selection.json").read_text())

        self.assertEqual(selection["runtime"], {"node": "24.22.1", "npm": "11.19.1"})
        actual = {
            name: entry["released"] for name, entry in selection["direct_tools"].items()
        }
        self.assertEqual(actual, EXPECTED_RELEASE_DATES)
        self.assertEqual(selection["direct_tools"]["@axe-core/cli"]["node_engine"], ">=22.12.0")
        self.assertEqual(selection["install"]["lifecycle_scripts"], "disabled")

    def test_every_affected_workflow_selects_and_asserts_the_exact_runtime(self):
        for name in ("axe.yml", "broken-links-site.yml", "deploy.yml", "prettier.yml"):
            with self.subTest(workflow=name):
                workflow = self.read_workflow(name)
                self.assertIn(SETUP_NODE, workflow)
                self.assertIn('node-version: "24.22.1"', workflow)
                self.assertIn('test "$(node --version)" = "v24.22.1"', workflow)
                self.assertIn('test "$(npm --version)" = "11.19.1"', workflow)
                self.assertNotIn("npm install -g", workflow)

    def test_consumers_use_only_the_dedicated_locked_installation(self):
        axe = self.read_workflow("axe.yml")
        links = self.read_workflow("broken-links-site.yml")
        deploy = self.read_workflow("deploy.yml")
        prettier = self.read_workflow("prettier.yml")

        for workflow in (axe, links, deploy, prettier):
            self.assertIn(LOCKED_INSTALL, workflow)
        for workflow in (axe, links, deploy):
            self.assertIn(".github/ci-tools/node_modules/.bin/purgecss", workflow)
        self.assertIn(".github/ci-tools/node_modules/.bin/diff2html", prettier)
        self.assertIn(".github/ci-tools/run-axe.py", axe)
        self.assertIn('axe-ci-diagnostics/axe-run.json', axe)
        self.assertIn("node_modules/axe-core/axe.js", axe)
        self.assertNotIn("node_modules/axe-core/axe.min.js", axe)
        self.assertIn(
            "CFT_CHROME_PATH: ${{ steps.cft.outputs.chrome-path }}", axe
        )
        self.assertIn(
            "CFT_CHROMEDRIVER_PATH: ${{ steps.cft.outputs.chromedriver-path }}",
            axe,
        )
        self.assertNotIn('--chrome "${{ steps.cft.outputs.chrome-path }}"', axe)
        self.assertNotIn(
            '--chromedriver "${{ steps.cft.outputs.chromedriver-path }}"', axe
        )
        self.assertNotIn("LATEST_RELEASE_STABLE", axe)
        self.assertNotIn("browser-actions/setup-chrome", axe)
        self.assertNotIn("chromedriver@", axe)

    def test_browser_manifest_binds_the_approved_linux64_pair(self):
        manifest = json.loads((CI_TOOLS / "chrome-for-testing.json").read_text())

        self.assertEqual(manifest["version"], "156.0.8078.73")
        self.assertEqual(manifest["platform"], "linux64")
        self.assertEqual(
            manifest["artifacts"]["chrome"]["url"],
            "https://storage.googleapis.com/chrome-for-testing-public/156.0.8078.73/linux64/chrome-linux64.zip",
        )
        self.assertEqual(
            manifest["artifacts"]["chromedriver"]["url"],
            "https://storage.googleapis.com/chrome-for-testing-public/156.0.8078.73/linux64/chromedriver-linux64.zip",
        )
        for artifact in manifest["artifacts"].values():
            self.assertGreater(artifact["size_bytes"], 0)
            self.assertTrue(re.fullmatch(r"[0-9a-f]{64}", artifact["sha256"]))
            self.assertFalse(artifact["publisher_checksum_available"])

    def test_dependabot_tracks_the_ci_tools_lock_weekly(self):
        dependabot = (ROOT / ".github" / "dependabot.yml").read_text()

        self.assertIn('directory: "/.github/ci-tools"', dependabot)
        block = dependabot[dependabot.index('directory: "/.github/ci-tools"') :]
        self.assertIn('interval: "weekly"', block)
        self.assertNotRegex(block, r"(?i)auto.?merge")


if __name__ == "__main__":
    unittest.main()
