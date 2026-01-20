---
name: alex-mcp
description: OpenAlex MCP server for author disambiguation, affiliations, and works retrieval optimized for AI agents.
---

# OpenAlex MCP — Author & Works

Use this server to disambiguate authors, resolve affiliations, and retrieve peer‑reviewed works from OpenAlex.

## Codex CLI Notes
- Configured for stdio via `$HOME/mcp/mcp-zotero-matlab-tools/bin/alex-mcp-stdio.sh` (see dotfiles Codex config). Required env: `OPENALEX_MAILTO="you@example.com"`; optional `OPENALEX_USER_AGENT`.
- Call tools by exact name with JSON args (examples below).

## Tools and When to Call
- `search_authors(name, institution?, topic?, country_code?, limit?)`
  - Use to find candidate authors; filter by institution/topic/country.
- `autocomplete_authors(name, context?, limit?)`
  - Use for quick candidates by name with lightweight output.
- `retrieve_author_works(author_id, limit?, order_by?, publication_year?, type?, journal_only?, min_citations?, peer_reviewed_only?)`
  - Use to get an author’s peer‑reviewed journal articles (default). Set `order_by="citations"` for impact.
- `search_works(query, search_type?, author?, institution?, publication_year?, type?, limit?, peer_reviewed_only?)`
  - Use for free‑text work search across titles/abstracts.
- `search_pubmed(query, search_type?, max_results?)` and `pubmed_author_sample(author_name, sample_size?)`
  - Convenience PubMed helpers bundled here for cross‑checks.
- `search_orcid_authors(name, affiliation?, max_results?)`, `get_orcid_publications(orcid_id, max_works?)`
  - Use ORCID to validate identity and fetch works.

## Examples (codex-cli)
- Disambiguate then fetch: call `search_authors {"name":"Ivan Matic","institution":"Francis Crick"}` → pick candidate.id → `retrieve_author_works {"author_id":"https://openalex.org/A...","limit":20,"order_by":"citations"}`
- Year filter: `retrieve_author_works {"author_id":"...","publication_year":2023}`

## Tips
- Prefer `peer_reviewed_only=true` and `journal_only=true` for clean corpora.
- Include affiliations to separate common names.

## Security & Limits
- Do not store secrets in prompts. Required: `OPENALEX_MAILTO` only.
- Respect OpenAlex rate limits; set `OPENALEX_USER_AGENT` when available.
- Avoid sending PII; author queries should be public academic info only.
