# CLAUDE.md — SPkHz.github.io Claude Code adapter

This file supplements `AGENTS.md` with Claude Code-specific procedure. It
grants no additional authority; `AGENTS.md` remains the authoritative scope
statement for this repository.

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

Site builds, previews, browsers, deployments, releases, and any form of
network access each require separate, explicit operator authority beyond
this file.

The registered DragSEC project owns the canonical bodies of the `dragsec-*`
workflows; this repository retains no local compatibility copy of any of
them.

This repository declares no command, subagent, hook, plugin, or MCP route,
and maintains no local workflow catalog.

## Memory authority

Read `docs/agent-memory.md` for the detailed memory boundary. No eeKG identity,
canonical key, or namespace is registered for this repository, so this adapter
authorizes static guidance only and grants no memory-tool or infrastructure
operation.

Application (site) development and agent-harness governance remain distinct
lines of work.
