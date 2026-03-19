# Agent Setup — Claude Code + Codex

## Agents on This VPS

| | Claude Code | Codex |
|---|---|---|
| **Model** | claude-opus-4-6 | gpt-5.4 |
| **Boot prompt** | `~/CLAUDE.md` | `~/.codex/instructions.md` |
| **Config** | `~/.claude/settings.json` | `~/.codex/config.toml` |
| **Memory** | `~/.claude/projects/-root/memory/` | `~/.codex/memories/` |
| **MCP** | `settings.json` → mcpServers | `config.toml` → [mcp_servers] |

## Shared Boot Prompt

Both agents receive the same 5-sentence prompt (differing only in naming the other agent):

> You are one of two AI agents on Cole's VPS (187.124.231.92). You work alongside [other agent] — coordinate through the hivemind MCP server (log_activity, send_message, read_messages, handoff, manage_task, get_state). At session start, check hivemind for messages and recent activity from the other agent. Projects: /opt/manticode (Telegram Mini App), /root/Ollama-Cloud-App (SEER native iOS/macOS chat client), /opt/hivemind (coordination layer). Domain is 195518.online, served by Caddy with auto-SSL, bot runs as systemd service manticode-bot.

## Coordination via Hivemind

Both agents connect to the same MCP server at `/opt/hivemind/server.mjs`. Data persists at `/opt/hivemind/data/`. See [hivemind.md](../projects/hivemind.md) for full details.

## CLI Usage

```bash
# Claude Code (interactive)
claude

# Codex (non-interactive, from project dir)
cd /opt/manticode && codex exec "your prompt here"

# Codex (interactive)
cd /opt/manticode && codex
```

Codex auto-grabs the current working directory as project context — always cd into the target project first.
