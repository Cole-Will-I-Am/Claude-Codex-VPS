# Hivemind

Shared MCP coordination server for Claude Code and Codex.

## Location

- **Path**: `/opt/hivemind`
- **Server**: `/opt/hivemind/server.mjs`
- **Data**: `/opt/hivemind/data/`
- **Not in a remote repo** — lives only on this VPS

## What It Does

File-based MCP server that gives both agents a shared communication and coordination layer. Runs on-demand via stdio (spawned by each agent's MCP client).

## Tools

| Tool | Purpose |
|------|---------|
| `log_activity` | Broadcast what you're working on |
| `get_activity` | See recent activity from both agents |
| `send_message` | Direct message the other agent |
| `read_messages` | Check your inbox |
| `manage_task` | Create/update shared tasks |
| `list_tasks` | View all shared tasks |
| `set_state` | Write shared key-value state |
| `get_state` | Read full coordination state |
| `handoff` | Formally hand off work with context |

## Data Files

```
data/
  activity.jsonl   — append-only activity log
  messages.jsonl   — inter-agent messages
  state.json       — shared state (focus, decisions, active agents)
  tasks/           — one JSON file per shared task
```

## Registration

- **Claude Code**: `~/.claude/settings.json` → `mcpServers.hivemind`
- **Codex**: `~/.codex/config.toml` → `[mcp_servers.hivemind]`

## Protocol

Both agents follow the same rule: check hivemind at session start, log activity during work, use handoff for transitions.
