# Manticode

AI-powered coding assistant delivered as a Telegram Mini App.

## Location

- **Path**: `/opt/manticode`
- **Repo**: [Cole-Will-I-Am/Manticode](https://github.com/Cole-Will-I-Am/Manticode) (private)
- **Branch**: `main`

## Stack

- Backend: Fastify 5, Prisma 6, ioredis 5, Zod, JWT
- Frontend: Next.js 14, React 18, Zustand 5, CodeMirror 6, Tailwind CSS 3
- Bot: tsx (long-polling Telegram bot)
- AI: Ollama Cloud API (nemotron-3-super)
- Monorepo: pnpm 9 + Turborepo 2 + TypeScript 5.7

## Monorepo Structure

```
apps/
  api/       — Fastify REST API (auth, chat, files, patches)
  web/       — Next.js Telegram Mini App frontend
  bot/       — Standalone Telegram bot (long-polling)
  landing/   — Static marketing site (served by Caddy)
packages/
  shared/    — Shared TypeScript types
```

## How It Runs

- **Landing + Mini App**: Caddy serves static files from `apps/landing/public`
- **Bot**: systemd service `manticode-bot` — runs `tsx src/index.ts` from `apps/bot/`
- **Domain**: https://195518.online (landing), https://195518.online/app (Mini App)

## Key Files

- `/opt/manticode/.env` — secrets (NOT in git)
- `/opt/manticode/CLAUDE.md` — project-level context for Claude Code
- `/etc/systemd/system/manticode-bot.service` — bot service unit

## Telegram

- Bot: @manticode_bot
- Menu button → https://195518.online/app
