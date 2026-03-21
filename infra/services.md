# systemd Services

## Active Services

| Service | Unit File | What It Runs |
|---------|-----------|-------------|
| `caddy` | `/usr/lib/systemd/system/caddy.service` | Reverse proxy + auto-SSL |
| `manticode-bot` | `/etc/systemd/system/manticode-bot.service` | Telegram bot (tsx, long-polling) |
| `redis-server` | system default | Redis on localhost:6379 (optional) |

## Quick Reference

```bash
# Check all
systemctl status caddy manticode-bot redis-server

# Baseline service + endpoint healthcheck
/root/Claude-Codex-VPS/infra/healthcheck.sh

# Restart bot after .env changes
systemctl restart manticode-bot

# Restart Caddy after Caddyfile changes
systemctl restart caddy

# View logs
journalctl -u manticode-bot -f
journalctl -u caddy -f
```

## Bot Service Details

- Working directory: `/opt/manticode/apps/bot`
- Command: `npm exec tsx src/index.ts`
- Env file: `/opt/manticode/.env`
- Restart policy: on-failure
