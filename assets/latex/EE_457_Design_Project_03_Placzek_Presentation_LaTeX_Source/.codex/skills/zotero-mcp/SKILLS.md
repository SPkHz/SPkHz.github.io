+++
id = "zotero-mcp"
name = "Zotero MCP"
summary = "Search library, metadata/fulltext, collections, tags, notes, and semantic search."
tags = ["mcp","zotero","references","pdf","notes"]
+++

## Capabilities (selection)
- Search: `zotero_search_items`, `zotero_search_by_tag`, `zotero_semantic_search`
- Items: `zotero_get_item_metadata`, `zotero_get_item_fulltext`
- Collections/Notes/Tags: getters and batch updates

## Workflow
Tag search → item metadata → full text/annotations as needed.

## Security
- Local vs Web API modes; store API keys in env; semantic providers require their own keys.
- Server key `zotero`; command exposed as `zotero-mcp` from `$HOME/mcp/mcp-zotero-matlab-tools/bin`; ensure PATH includes that wrapper (per dotfiles Codex config).
