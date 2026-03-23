# Agent Setup — Claude Code + Codex

## Agents on This VPS

| | Claude Code | Codex |
|---|---|---|
| **Model** | claude-opus-4-6 | gpt-5.4 |
| **Boot prompt** | `~/CLAUDE.md` | `~/.codex/instructions.md` |
| **Config** | `~/.claude/settings.json` | `~/.codex/config.toml` |
| **Memory** | `~/.claude/projects/-root/memory/` | `~/.codex/memories/` |
| **MCP** | `settings.json` → mcpServers | `config.toml` → [mcp_servers] |

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
