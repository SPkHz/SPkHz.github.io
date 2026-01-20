+++
id = "matlab-mcp"
name = "MATLAB MCP"
summary = "Single MATLAB MCP server providing execution, sections, workspace, and figure capture."
tags = ["mcp","matlab","workspace","plots","sections"]
+++

## Capabilities
- Execute code/files; run sections; capture figures; snapshot workspace; discover sections; create scripts in the server’s configured MATLAB scripts directory.

## Workflow
1) `create_matlab_script` → author `.m` file
2) `get_script_sections` → pick a range
3) `execute_script_section` or `execute_script` with `capture_plots`
4) `get_workspace` to validate state

## Security / Config
- Local code execution; avoid untrusted inputs and secrets in prompts.
- Server binary: `$HOME/mcp/mcp-zotero-matlab-tools/modules/matlab-r2025b-mcp-tools/.venv/bin/matlab-mcp-server`; ensure `MATLAB_PATH` and `LD_LIBRARY_PATH` (R2025b runtime) are set.
