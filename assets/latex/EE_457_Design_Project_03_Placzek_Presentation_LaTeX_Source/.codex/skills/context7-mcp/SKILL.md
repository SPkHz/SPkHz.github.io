---
name: context7-mcp
description: MCP server that resolves libraries and fetches up-to-date docs/examples from Context7.
---

# Context7 MCP — Fresh Library Docs

Use Context7 to resolve library IDs and pull current, version-aware docs and snippets. Great when you need authoritative API references beyond the model's training window.

## Codex CLI Notes
- Supports remote HTTP (`https://mcp.context7.com/mcp`) or local stdio (`npx -y @upstash/context7-mcp --api-key <key>`).
- API key optional but recommended for higher rate limits/private repos (`CONTEXT7_API_KEY`).
- Call tools directly; typical flow: `resolve-library-id` → `get-library-docs` (with topic/page to focus).

## Tools and When to Call
- `resolve-library-id(libraryName)` — Normalize a package/framework name to a Context7-compatible ID.
- `get-library-docs(context7CompatibleLibraryID, topic?, page?)` — Fetch docs/snippets for a specific ID; paginate with `page` if more context is needed.

## Examples (codex-cli)
- `resolve-library-id {"libraryName":"nextjs"}` → then `get-library-docs {"context7CompatibleLibraryID":"/vercel/next.js","topic":"routing"}`
- `get-library-docs {"context7CompatibleLibraryID":"/supabase/supabase","topic":"auth","page":2}` (skip resolve when you already know the ID)

## Guidelines
- Prefer providing the exact Context7 ID when known to skip disambiguation.
- Use `topic` and paginate (`page` 2, 3…) instead of asking for broader results in one call.
- Add a client rule like “always use context7 for code/setup questions” to auto-invoke the server.

## Security
- Keep API keys in env (`CONTEXT7_API_KEY`); avoid embedding secrets in requests.
- Remote endpoints use HTTPS; for local runs, ensure `npx`/`bunx` is available and not aliased insecurely.
