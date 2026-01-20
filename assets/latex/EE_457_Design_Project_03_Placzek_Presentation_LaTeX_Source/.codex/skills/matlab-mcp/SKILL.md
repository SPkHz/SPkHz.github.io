---
name: matlab-mcp
description: MATLAB MCP server + tools (single server) for executing code, sections, capturing figures, and inspecting workspace.
---

# MATLAB MCP — Server + Tools

Single MATLAB MCP server providing both execution and helper tools (sections, workspace, figures).

## Codex CLI Notes
- Stdio transport (codex-cli via dotter). Server binary: `$HOME/mcp/mcp-zotero-matlab-tools/modules/matlab-r2025b-mcp-tools/.venv/bin/matlab-mcp-server`; set `MATLAB_PATH`/`LD_LIBRARY_PATH` (e.g., R2025b) accordingly. Ensure MATLAB/Runtime is available.
- Tools: `execute_script`, `execute_script_section`, `get_workspace`, `get_script_sections`, `create_matlab_script`.

## Examples (codex-cli)
- Run section then capture figs: `get_script_sections {"script_name":"analysis.m"}` → `execute_script_section {"script_name":"analysis.m","section_range":[1,50],"capture_plots":true}`
- Inspect workspace: `get_workspace {}`

## Security
- Same security posture as server/tools: treat inputs as code and avoid secrets in prompts. Ensure env paths point to the R2025b runtime.
