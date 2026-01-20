+++
id = "alex-mcp"
name = "OpenAlex MCP"
summary = "Author disambiguation, affiliations, and works retrieval with agent-optimized outputs."
tags = ["mcp", "openalex", "research", "authors", "works"]
+++

## Capabilities
- Author search and autocomplete; institution/topic filters
- Retrieve peer‑reviewed works; ordering and citation filters
- ORCID helpers; PubMed convenience tools

## Workflow
1) `search_authors {"name":"Ada Yonath"}` → pick `author_id`
2) `retrieve_author_works {"author_id":"https://openalex.org/A...","limit":20,"order_by":"citations"}`

## Security
- Set `OPENALEX_MAILTO` via environment (dotfiles config wraps `$HOME/mcp/mcp-zotero-matlab-tools/bin/alex-mcp-stdio.sh`).
- Respect API rate limits; avoid PII in queries; set `OPENALEX_USER_AGENT` when available.
