++
id = "exa-mcp"
name = "Exa MCP"
summary = "Up-to-date web search and code context retrieval for APIs, libraries, and docs."
tags = ["mcp","web","search","code","context","exa"]
++

## Capabilities
- General web search with fresh, high‑quality results
- Code/API context retrieval for libraries, SDKs, and frameworks

## Workflow
1) `web_search_exa {"query":"<topic>"}` to discover authoritative sources
2) `get_code_context_exa {"query":"<library/API>"}` for focused coding context
 - get_code_context_exa: Search and get relevant code snippets, examples, and documentation from open source libraries, GitHub repositories, and programming frameworks.
 - Perfect for finding up-to-date code documentation, implementation examples, API usage patterns, and best practices from real codebases.

## Available Tools
    web_search_exa: Performs real-time web searches with optimized results and content extraction.
    company_research: Comprehensive company research tool that crawls company websites to gather detailed information about businesses.
    crawling: Extracts content from specific URLs, useful for reading articles, PDFs, or any web page when you have the exact URL.
    linkedin_search: Search LinkedIn for companies and people using Exa AI. Simply include company names, person names, or specific LinkedIn URLs in your query.
    deep_researcher_start: Start a smart AI researcher for complex questions. The AI will search the web, read many sources, and think deeply about your question to create a detailed research report.
    deep_researcher_check: Check if your research is ready and get the results. Use this after starting a research task to see if it's done and get your comprehensive report.

## Security / Config
- Server key `exa`. Requires `EXA_API_KEY` (passed as `x-api-key` header). Dotfiles config runs via `npx -y mcp-remote https://mcp.exa.ai/mcp` with caches under `$HOME/mcp/mcp-zotero-matlab-tools`; the `~/.codex/config.toml` variant keeps caches under `$HOME/mcp`. Ensure PATH/env match the active layout.
