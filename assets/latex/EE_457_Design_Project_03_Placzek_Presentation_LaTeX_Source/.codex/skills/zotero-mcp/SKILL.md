---
name: zotero-mcp
description: Zotero MCP server to search your library, access items/notes/annotations, and perform semantic search.
---

# Zotero MCP — Your Library

Access Zotero libraries (local or web API), retrieve items/notes/attachments, and run semantic search.

## Codex CLI Notes
- Stdio transport (codex-cli via dotter) via `$HOME/mcp/mcp-zotero-matlab-tools/bin/zotero-mcp serve --transport stdio` (exposed as `zotero-mcp` in PATH).
- Local: `ZOTERO_LOCAL=true` with Zotero desktop running.
- Web API: set `ZOTERO_API_KEY`, `ZOTERO_LIBRARY_ID`, `ZOTERO_LIBRARY_TYPE`.
- Semantic (optional): `OPENAI_API_KEY` or `GEMINI_API_KEY`.

## Tools and When to Call (selection)
- Search: `zotero_search_items(query, qmode?, item_type?, limit?, tag?)`, `zotero_search_by_tag(tag[], item_type?, limit?)`, `zotero_semantic_search(query, filters?, limit?)`
- Items: `zotero_get_item_metadata(item_key, include_abstract?, format?)`, `zotero_get_item_fulltext(item_key)`
- Collections: `zotero_get_collections(limit?)`, `zotero_get_collection_items(collection_key, limit?)`
- Children/Notes/Annotations: `zotero_get_item_children(item_key)`, `zotero_get_notes(item_key?)`, `zotero_search_notes(query)`, `zotero_get_annotations(item_key?)`
- Batch/Recent/Tags: `zotero_batch_update_tags(add_tags?, remove_tags?, query, limit?)`, `zotero_get_recent(limit?)`, `zotero_get_tags(limit?)`
- Advanced: `zotero_advanced_search(conditions[], join_mode?, sort_by?, sort_direction?, limit?)`, DB status: `zotero_get_search_database_status`, update: `zotero_update_search_database(force_rebuild?, limit?)`

## Examples (codex-cli)
- Items by tag: `zotero_search_by_tag {"tag":["RAG||Retrieval","-draft"],"limit":20}`
- Full text: `zotero_get_item_fulltext {"item_key":"ABCD1234"}`

## Security
- Local mode accesses your local Zotero; avoid exposing library content unintentionally.
- Web API mode requires `ZOTERO_API_KEY`; keep it in environment variables.
- Semantic search may call external embedding providers; set keys (`OPENAI_API_KEY`/`GEMINI_API_KEY`) securely.
