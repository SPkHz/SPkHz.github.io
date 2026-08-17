# Agent components lock

Evidence-Tier: REGISTERED
Qualifier: EFFECTIVE_STATE_NOT_PROBED

project_id=spkhz-github-io
core_instruction_files=2
skills=0
commands=0
subagents=0
hooks=0
plugins=0
MCP_routes=0
network_default=OFF
external_writable_roots=0
machine_specific_paths=0

| component_id | path | owner | harness_routing | sha256 | invocation_policy | network_posture |
| --- | --- | --- | --- | --- | --- | --- |
| agents-instructions | AGENTS.md | spkhz-github-io | claude+codex root instructions | sha256:c252d6dcf49dca7c8ec1f4739a5dfd2d740d136ec42031dadb2e459974ebc839 | ALWAYS_LOADED | network_default=OFF |
| claude-instructions | CLAUDE.md | spkhz-github-io | claude root instructions | sha256:503fa0f23957f1d007013810b72c782fb8b2c0c751ef697e503c9890f88e9c77 | ALWAYS_LOADED | network_default=OFF |
