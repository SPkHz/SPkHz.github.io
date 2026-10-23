#!/usr/bin/env python3
"""Render portable source evidence from a closed list; no local-state discovery."""
import argparse
import hashlib
import os
from pathlib import Path

REPO_ROOT = Path(__file__).resolve().parents[2]
PROJECT_ID = 'spkhz-github-io'
RETAINED_SKILLS = ()
COMPONENTS = tuple((name, path, PROJECT_ID, "EXPLICIT_ONLY" if path.startswith(".agents/") else "INSTRUCTIONS", "network_default=OFF", "FORBIDDEN") for name, path in (
    ("canonical-instructions", "README.md"),
    ("agents-alias", "AGENTS.md"),
    ("claude-alias", "CLAUDE.md"),
    *(("skill-" + name, ".agents/skills/" + name + "/skill.md") for name in RETAINED_SKILLS),
))


def render_manifest_text():
    lines = [
        "# Agent components lock", "", "Evidence-Tier: REGISTERED",
        "Qualifier: EFFECTIVE_STATE_NOT_PROBED", "", f"project_id={PROJECT_ID}",
        "canonical_source=README.md", "core_instruction_files=1", "instruction_aliases=2",
        f"portable_skills={len(RETAINED_SKILLS)}", "local_session_skills=7",
        "local_registration_state=NOT_INSPECTED_BY_PORTABLE_RENDERER",
        "commands=0", "subagents=0", "hooks=0", "plugins=0", "MCP_routes=0",
        "network_default=OFF", "personal_data_access=FORBIDDEN", "machine_specific_paths=0", "",
        "Local session registrations are ignored and do not travel with clones or new worktrees.",
        "Validate them separately through the resolved skill-source binding. This manifest grants no write authority.", "",
        "| component_id | path | link_payload | resolved_content_sha256 | invocation_policy |",
        "| --- | --- | --- | --- | --- |",
    ]
    for component, rel, owner, invocation, network, personal_data in COMPONENTS:
        path = REPO_ROOT / rel
        payload = os.readlink(path) if path.is_symlink() else "(regular file)"
        if rel in {"AGENTS.md", "CLAUDE.md"} and payload != "README.md":
            raise ValueError("Instruction alias must point exactly to README.md")
        if rel == "README.md" and path.is_symlink():
            raise ValueError("Canonical README must be a regular file")
        digest = hashlib.sha256(path.read_bytes()).hexdigest()
        lines.append(f"| {component} | {rel} | {payload} | {digest} | {invocation} |")
    return "\n".join(lines) + "\n"


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--output", required=True, help="Explicit destination; private manifests belong outside the application repository")
    parser.add_argument("--emit-pass", action="store_true")
    args = parser.parse_args()
    Path(args.output).write_text(render_manifest_text(), encoding="utf-8")
    if args.emit_pass:
        print("PASS")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
