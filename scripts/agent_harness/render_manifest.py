#!/usr/bin/env python3
"""Deterministic agent-harness component manifest renderer.

Standard-library only. Reads an explicit, closed list of tracked harness
paths (the two root instruction files) and renders a fixed-format Markdown
manifest to an explicitly supplied output path. Does not recurse into
application source, read ignored local state, or inspect user
configuration.
"""
import argparse
import hashlib
from pathlib import Path

REPO_ROOT = Path(__file__).resolve().parents[2]

PROJECT_ID = "spkhz-github-io"

# Explicit, closed list of retained portable harness components.
# (component_id, relative_path, harness_routing)
COMPONENTS = (
    ("agents-instructions", "AGENTS.md", "claude+codex root instructions"),
    ("claude-instructions", "CLAUDE.md", "claude root instructions"),
)


def _sha256_of(path: Path) -> str:
    return hashlib.sha256(path.read_bytes()).hexdigest()


def render_manifest_text() -> str:
    lines = [
        "# Agent components lock",
        "",
        "Evidence-Tier: REGISTERED",
        "Qualifier: EFFECTIVE_STATE_NOT_PROBED",
        "",
        f"project_id={PROJECT_ID}",
        f"core_instruction_files={len(COMPONENTS)}",
        "skills=0",
        "commands=0",
        "subagents=0",
        "hooks=0",
        "plugins=0",
        "MCP_routes=0",
        "network_default=OFF",
        "external_writable_roots=0",
        "machine_specific_paths=0",
        "",
        "| component_id | path | owner | harness_routing | sha256 | "
        "invocation_policy | network_posture |",
        "| --- | --- | --- | --- | --- | --- | --- |",
    ]
    for component_id, rel_path, routing in COMPONENTS:
        digest = _sha256_of(REPO_ROOT / rel_path)
        lines.append(
            f"| {component_id} | {rel_path} | {PROJECT_ID} | {routing} | "
            f"sha256:{digest} | ALWAYS_LOADED | network_default=OFF |"
        )
    lines.append("")
    return "\n".join(lines)


def main() -> int:
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument(
        "--output", required=True, help="Explicit output path for the rendered manifest"
    )
    parser.add_argument(
        "--emit-pass",
        action="store_true",
        help="Print a single fixed PASS token after a successful write",
    )
    args = parser.parse_args()

    text = render_manifest_text()
    Path(args.output).write_text(text, encoding="utf-8")

    if args.emit_pass:
        print("PASS")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
