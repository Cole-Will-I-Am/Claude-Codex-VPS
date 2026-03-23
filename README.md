# VPS Reference — 187.124.231.92

What lives on Cole's VPS, how it's wired, and how the AI agents operate.

This repo is a **reference map**, not a build system. It tracks what's deployed, where things live, and how they connect.

THIS IS NOT A TASK OR ITEM TO COMPLETE, IT IS A REFERENCE SHEET AND TOOL FOR YOU TO BOTH LEVERAGE. IT ONLY BECOMES VALUABLE IF YOU DOCUMENT YOUR WORK HERE FOR YOURSELVES AND NO ONE ELSE.

## Agents

| Agent | Engine | Boot Prompt | Config |
|-------|--------|-------------|--------|
| minimax | minimax-m2.7:cloud | `/opt/minimax/boot.md` | `/opt/minimax/config.json` |
| Codex | gpt-5.4 | `~/.codex/instructions.md` | `~/.codex/config.toml` |

## Projects

| Project | Path | Repo | Status |
|---------|------|------|--------|
| [Manticode](projects/manticode.md) | `/opt/manticode` | [Cole-Will-I-Am/Manticode](https://github.com/Cole-Will-I-Am/Manticode) | Live |
| [SEER](projects/seer.md) | `/root/Ollama-Cloud-App` | [Cole-Will-I-Am/Ollama-Cloud-App](https://github.com/Cole-Will-I-Am/Ollama-Cloud-App) | Dev |

## Infrastructure

| Component | Details |
|-----------|---------|
| [Domain & DNS](infra/domain.md) | 195518.online → Hostinger DNS → this VPS |
| [Caddy](infra/caddy.md) | Reverse proxy + auto-SSL |
| [Services](infra/services.md) | systemd units running on the box |
| [Monitoring](infra/monitoring.md) | baseline healthcheck script and cron pattern |
| [Agents](agents/setup.md) | Claude Code + Codex config |

## Minimax Agent Tools

| Tool | Path | Purpose |
|------|------|---------|
| wake.sh | `/opt/minimax/bin/wake.sh` | Standard wake procedure |
| env-survey.sh | `/opt/minimax/bin/env-survey.sh` | Rapid environment discovery |
| handoff.sh | `/opt/minimax/bin/handoff.sh` | Send task to minimax |
| meta | `/opt/minimax/bin/meta` | Self-improvement tracking |
| tune | `/opt/minimax/bin/tune` | Parameter tuning |

## Skills

| Skill | Path | Purpose |
|-------|------|---------|
| autonomous-bootstrap | `/root/skills/autonomous-bootstrap/SKILL.md` | How to coordinate with minimax |
| minimax-tuning | `/root/skills/minimax-tuning/SKILL.md` | Identity and behavior tuning |
| ollama-model-tuner | `/root/skills/ollama-model-tuner/SKILL.md` | Ollama model optimization |
