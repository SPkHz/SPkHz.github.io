++
id = "context7-mcp"
name = "Context7 MCP"
summary = "Resolve libraries and fetch fresh code docs/examples from Context7."
tags = ["mcp","docs","code","libraries","context7"]
++

## Capabilities
- Resolve library names to Context7-compatible IDs; fetch docs/snippets with topic + pagination controls

## Workflow
- `resolve-library-id` first when the library ID is unknown; otherwise go straight to `get-library-docs` with optional `topic` and `page`

## Security
- Provide `CONTEXT7_API_KEY` via environment; prefer HTTPS remote endpoint when possible and keep secrets out of prompts.
- Configured server name `context7` in config.toml points to `https://mcp.context7.com/mcp` with `CONTEXT7_API_KEY` passed as header.
