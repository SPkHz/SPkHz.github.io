+++
id = "mcp-scholarly"
name = "MCP Scholarly"
summary = "Search arXiv or Google Scholar by keyword and return formatted results."
tags = ["mcp","scholar","arxiv","search"]
+++

## Capabilities
- `search-arxiv`, `search-google-scholar`

## Workflow
Run keyword search, then follow with domain-specific tools as needed.

## Security
- Read-only; respect site policies and rate limits. dotfiles config (server key `scholarly`) runs via `uvx mcp-scholarly` with caches/state under `$HOME/mcp/mcp-zotero-matlab-tools`; ensure PATH includes uvx.
