---
name: mcp-scholarly
description: MCP server for scholarly search/metadata across academic sources (e.g., Google Scholar-like flows).
---

# Scholarly MCP — Academic Search

Search academic literature via arXiv or Google Scholar flows and return formatted results.

## Codex CLI Notes
- Stdio transport via `uvx mcp-scholarly` (dotfiles config) with XDG cache/state under `$HOME/mcp/mcp-zotero-matlab-tools`. Call tools by exact name.

## Tools and When to Call
- `search-arxiv(keyword)` — Use for arXiv keyword search and reference formatting.
- `search-google-scholar(keyword)` — Use for Google Scholar keyword search summaries.

## Examples (codex-cli)
- `search-arxiv {"keyword":"self-supervised learning survey"}`
- `search-google-scholar {"keyword":"""Attention Is All You Need"" citations"}`

## Security
- Read-only search; no credentials needed. Be mindful of rate limits and scraping policies.
