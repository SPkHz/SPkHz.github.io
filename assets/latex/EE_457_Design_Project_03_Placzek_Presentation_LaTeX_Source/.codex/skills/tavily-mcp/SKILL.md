---
name: tavily-mcp
description: MCP server for Tavily real-time web search, site mapping, extraction, and targeted crawling.
---

# Tavily MCP — Web Search + Extraction

Search the web, map site URLs, extract structured content, or crawl with breadth/depth controls. Use when you need current information plus reliable page text extraction.

## Codex CLI Notes
- Stdio transport via `$HOME/mcp/mcp-zotero-matlab-tools/bin/tavily-mcp.sh` (sets Volta/XDG caches under `$HOME/mcp/mcp-zotero-matlab-tools`). Call tools by name; prefer search first, then extract/crawl selectively.

## Tools and When to Call
- `tavily_search(query, max_results?, topic?, search_depth?)` — Web/news search with recency options.
- `tavily_map(url, max_depth?, max_breadth?)` — Discover URLs on a site.
- `tavily_extract(urls, format?, extract_depth?)` — Extract clean page content (markdown/text).
- `tavily_crawl(url, max_depth?, limit?, select_paths?, exclude_paths?)` — Multi‑page crawl (summaries per page).

## Examples (codex-cli)
- `tavily_search {"query":"OpenAI o3 mini system prompt", "max_results":5}`
- `tavily_map {"url":"https://example.com/docs"}` → pick URLs → `tavily_extract` for full content

## Guidelines
- Start with `tavily_search`; keep extraction targeted to avoid noise.
- Use `select_paths`/`exclude_paths` and low depth to focus crawls.

## Security
- Keep API keys in environment (e.g., `TAVILY_API_KEY`). Respect robots.txt and site ToS.
