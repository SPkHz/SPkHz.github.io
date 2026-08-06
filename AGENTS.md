# AGENTS.md — SPkHz.github.io agent-configuration scope

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
application source and its own agent-configuration harness. No parent or
sibling repository configures this project, and this project configures
none of them.

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
and maintains no local workflow catalog. Any future workflow, command,
subagent, hook, plugin, or MCP declaration requires separate, explicit
operator authorization naming the exact component and its owner.

## Application versus harness work

Application (site) development and agent-harness governance are distinct
lines of work. Harness changes in this repository do not imply that any
site build, dependency, or deployment configuration has been reviewed,
exercised, or endorsed.
