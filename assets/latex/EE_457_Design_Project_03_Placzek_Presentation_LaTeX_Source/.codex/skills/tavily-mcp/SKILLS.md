++
id = "tavily-mcp"
name = "Tavily MCP"
summary = "Real-time web search, site mapping, precise content extraction, and controlled crawling."
tags = ["mcp","web","search","extract","crawl","tavily"]
++

## Capabilities
- Web/news search; site URL discovery; clean content extraction; scoped crawling

## Workflow
Search → map key sections → extract full text for analysis → crawl selectively when needed

## Security
- Use `TAVILY_API_KEY` in env; follow robots.txt and site ToS; throttle bulk extraction.
- Dotfiles config (server key `tavily`) launches via `$HOME/mcp/mcp-zotero-matlab-tools/bin/tavily-mcp.sh` with Volta/XDG dirs inside `$HOME/mcp/mcp-zotero-matlab-tools`; ensure PATH/env align.
