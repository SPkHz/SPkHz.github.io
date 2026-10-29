"""Rebuild frozen bundles and qualify the owned repair in an existing Node24 environment.

This explicitly installs lock-bound build tools with lifecycle scripts disabled.
Run only in a task-owned copy. No Action entrypoint or downloaded Python executes.
"""
import os
from pathlib import Path
import subprocess

root = Path(__file__).resolve().parent
commands = [
    ["npm", "ci", "--ignore-scripts", "--no-audit", "--no-fund"],
    ["npm", "ls", "--all"],
    ["npm", "audit", "--ignore-scripts"],
    ["node", "qualification-deepmerge.cjs", str(root / "vendor/deepmerge/index.cjs")],
    ["npm", "run", "build"],
]
for command in commands:
    subprocess.run(command, cwd=root, check=True)
env = os.environ.copy()
env["NODE_OPTIONS"] = "--require=" + str(root / "qualification-deny-side-effects.cjs")
subprocess.run(["node", "--experimental-vm-modules", "node_modules/jest/bin/jest.js",
                "--runInBand", "--coverage=false"], cwd=root, env=env, check=True)
