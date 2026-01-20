---
name: exa-mcp
description: MCP server for Exa AI web search and code context retrieval, enabling fresh web results and API/library context for coding tasks.
---

# Exa MCP — Web + Code Context

Use Exa to perform high‑quality web searches and retrieve focused API/library/code context. Ideal when you need up‑to‑date information, library usage examples, or authoritative docs.

## Codex CLI Notes
- Configured via `npx -y mcp-remote https://mcp.exa.ai/mcp --header 'x-api-key: $EXA_API_KEY'` (stdio bridge). Make sure `$EXA_API_KEY` is set; dotfiles config wires PATH/cache roots under `$HOME/mcp/mcp-zotero-matlab-tools`, while the default `~/.codex/config.toml` keeps caches under `$HOME/mcp`.
- Typical flow: search → select URLs → extract/code‑context as needed.

## Tools and When to Call
- `web_search_exa(query, numResults?)` — General web search for fresh, relevant sources.
- `get_code_context_exa(query, tokensNum?)` — Retrieve API/library/code context blocks optimized for coding tasks.

## Examples (codex-cli)
- `web_search_exa {"query":"FastAPI background tasks", "numResults":5}`
- `get_code_context_exa {"query":"Zod schema transform examples", "tokensNum":3000}`

## Guidelines
- Prefer `web_search_exa` for discovery; follow with per‑site extraction or code context retrieval depending on need.
- Cross‑check critical facts across multiple sources; cite canonical documentation when available.

## Security
- Keep API keys in environment (e.g., `EXA_API_KEY`).
- Respect provider rate limits; avoid submitting secrets in queries.
