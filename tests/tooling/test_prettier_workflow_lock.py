"""Require Prettier workflows to consume the repository-owned npm lock."""

import json
from pathlib import Path
import unittest


ROOT = Path(__file__).resolve().parents[2]
LOCKED_INSTALL = "npm ci --ignore-scripts --no-audit --no-fund"


class PrettierWorkflowLockTest(unittest.TestCase):
    def workflow(self, name):
        return (ROOT / ".github" / "workflows" / name).read_text()

    def assert_locked_prettier_commands(self, workflow):
        commands = [
            line.strip().removeprefix("run: ").strip()
            for line in workflow.splitlines()
            if "npx" in line and "prettier" in line
        ]
        self.assertTrue(commands)
        self.assertTrue(
            all(command.startswith("npx --no-install prettier") for command in commands),
            commands,
        )

    def test_lock_and_manifest_bind_prettier_dependencies(self):
        manifest = json.loads((ROOT / "package.json").read_text())
        lock = json.loads((ROOT / "package-lock.json").read_text())
        dependencies = manifest["devDependencies"]

        self.assertEqual(dependencies, lock["packages"][""]["devDependencies"])
        for dependency in dependencies:
            package = lock["packages"][f"node_modules/{dependency}"]
            self.assertTrue(package["integrity"].startswith("sha512-"))

    def test_default_branch_check_uses_immutable_locked_install(self):
        workflow = self.workflow("prettier.yml")

        self.assertIn(LOCKED_INSTALL, workflow)
        self.assertNotIn("npm install --save-dev", workflow)
        self.assert_locked_prettier_commands(workflow)

    def test_gh_pages_writer_uses_root_lock_and_nested_checkout(self):
        workflow = self.workflow("prettier-html.yml")
        checkout = "uses: actions/checkout@"
        first_checkout = workflow.index(checkout)
        second_checkout = workflow.index(checkout, first_checkout + 1)
        first_block = workflow[first_checkout:second_checkout]
        second_block = workflow[second_checkout:]

        self.assertIn("persist-credentials: false", first_block)
        self.assertIn(LOCKED_INSTALL, first_block)
        self.assertIn("ref: gh-pages", second_block)
        self.assertIn("path: gh-pages", second_block)
        self.assertIn("persist-credentials: true", second_block)
        self.assertNotIn("npm install -g prettier", workflow)
        self.assert_locked_prettier_commands(workflow)
        self.assertIn(
            "npx --no-install prettier --write 'gh-pages/**/*.html'", workflow
        )
        self.assertGreaterEqual(workflow.count("working-directory: gh-pages"), 2)


if __name__ == "__main__":
    unittest.main()
