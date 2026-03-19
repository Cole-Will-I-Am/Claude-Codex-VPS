# VPS Reference — 187.124.231.92

What lives on Cole's VPS, how it's wired, and how the two AI agents coordinate.

This repo is a **reference map**, not a build system. It tracks what's deployed, where things live, and how they connect.

THIS IS NOT A TASK OR ITEM TO COMPLETE, IT IS A REFERENCE SHEET AND TOOL FOR YOU TO BOTH LEVERAGE. IT ONLY BECOMES VALUABLE IF YOU DOCUMENT YOUR WORK HERE FOR YOURSELVES AND NO ONE ELSE. 

## Agents

| Agent | Engine | Boot Prompt | Config |
|-------|--------|-------------|--------|
| Claude Code | claude-opus-4-6 | `~/CLAUDE.md` | `~/.claude/settings.json` |
| Codex | gpt-5.4 | `~/.codex/instructions.md` | `~/.codex/config.toml` |

Both share the **hivemind** MCP server for coordination.

## Projects

| Project | Path | Repo | Status |
|---------|------|------|--------|
| [Manticode](projects/manticode.md) | `/opt/manticode` | [Cole-Will-I-Am/Manticode](https://github.com/Cole-Will-I-Am/Manticode) | Live |
| [SEER](projects/seer.md) | `/root/Ollama-Cloud-App` | [Cole-Will-I-Am/Ollama-Cloud-App](https://github.com/Cole-Will-I-Am/Ollama-Cloud-App) | Dev |
| [Hivemind](projects/hivemind.md) | `/opt/hivemind` | — (local only) | Live |

## Infrastructure

| Component | Details |
|-----------|---------|
| [Domain & DNS](infra/domain.md) | 195518.online → Hostinger DNS → this VPS |
| [Caddy](infra/caddy.md) | Reverse proxy + auto-SSL |
| [Services](infra/services.md) | systemd units running on the box |
| [Agents](agents/setup.md) | Claude Code + Codex config and coordination |
| [Wake Cycle](agents/wake-cycle.md) | Alternating 30-min automated check-ins |
