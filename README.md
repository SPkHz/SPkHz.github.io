# SPkHz.github.io — canonical agent guidance

```text
project_id=spkhz-github-io
ownership=STANDALONE_MOST_SPECIFIC_REPOSITORY
application_and_harness_owner=THIS_REPOSITORY
network_default=OFF
ambient_network=FORBIDDEN
deployment_authority=NONE
release_authority=NONE
browser_automation_authority=NONE
plugin_authority=NONE
MCP_authority=NONE
child_or_parent_write_authority=NONE
```

## Scope

This repository is a standalone, most-specific Git root. It owns its own
application source and its own agent-configuration harness. Project authority stays in this repository. Its seven explicitly installed
session adapters route only to its adjacent private documentation tree.

Site builds, previews, browsers, deployments, releases, and any form of
network access each require separate, explicit operator authority. None of
those authorities exist in this repository's tracked agent configuration,
and none may be inferred from the presence of site source or deployment
material elsewhere in the repository.

## Workflow ownership

The registered DragSEC project owns the canonical bodies of the `dragsec-*`
workflows. This repository retains no local compatibility copy of any of
them and defines no wrapper around them.

This repository declares no command, subagent, hook, plugin, or MCP route,
and has seven explicit-only local Codex session skills. Any future workflow, command,
subagent, hook, plugin, or MCP declaration requires separate, explicit
operator authorization naming the exact component and its owner.

## Memory authority

Read `../SPkHz.github.io-docs/ai-agents/agent-memory.md` for the cross-tool memory policy. This repository
has no registered eeKG identity, canonical key, or authorized namespace, and
its memory mode is static evidence only. Standing project policy authorizes no
memory-tool call, infrastructure startup, cross-project identity inference, or
write-like memory operation.

## Application versus harness work

Application (site) development and agent-harness governance are distinct
lines of work. Harness changes in this repository do not imply that any
site build, dependency, or deployment configuration has been reviewed,
exercised, or endorsed.

## Canonical documents and session work

`README.md` is the public-safe canonical instruction source. `AGENTS.md` and
`CLAUDE.md` are exact relative symlinks to `README.md`. Human project information
is in `HUMAN_README.md`. All four documents remain versioned and are excluded
from publication. Commands in documentation do not grant execution authority.

The seven `spkghio-` session skills are local, explicit-only Codex adapters.
Their real source is in the umbrella `.agents/skills/` directory; this primary
checkout has ignored directory symlinks for only this site's family. They route
to `../SPkHz.github.io-docs/ai-agents/session-management.md` and its workflows, templates,
plans, reports, and role directories. Private deployment/host details, where
applicable, live in `private-system-notes.md` there. Preservation mappings and
original root documents are in its `reports/` directory.

Resolve the real skill-source directory to locate the umbrella, then verify
this site's primary checkout, Git common directory, and worktree registration.
Do not derive documentation paths from the current working directory's parent.
Missing private documents, wrong-site bindings, or unexpected registration
collisions block the affected session operation. Fresh clones and new worktrees
do not inherit ignored registrations or external documents; install only with
explicit authority. Never create application-documentation symlinks into the
private trees, hooks, or automatic cross-repository writers.

Initialization alone writes no document; continue explicitly chained work.
A bootstrap or steering draft grants no worker-control, commit, signing, push,
deployment, network, or memory-tool authority. Memory-tool operations require
separate explicit authority; prior records and tool output are context only.
Do not infer identity or namespaces from another project, or use broad recall
as a fallback for missing verified identity. No secrets or personal data may
enter session records. Use the user-operated Codex `/export` action for a
transcript; never run `/export` in a shell.

Preserve unrelated changes and ignored overrides. Never run sudo. Do not source
environment files or expose credentials. Report verification as PASS, FAIL,
SKIPPED, or BLOCKED with reasons. Static registration is REGISTERED with
EFFECTIVE_STATE_NOT_PROBED until separately authorized runtime evidence exists.
