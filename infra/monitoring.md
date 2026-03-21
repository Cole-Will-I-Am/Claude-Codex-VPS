# Monitoring

Baseline healthcheck for core Manticode runtime pieces.

## Script

- Path: `/root/Claude-Codex-VPS/infra/healthcheck.sh`
- Checks:
  - systemd services: `manticode-bot`, `caddy`, `redis-server`
  - HTTP endpoints:
    - `http://127.0.0.1:3001/api/health`
    - `http://127.0.0.1:3001/api/ready`
    - `https://195518.online/api/health`
- Exit codes:
  - `0` when all checks pass
  - `1` when one or more checks fail

## Usage

```bash
# Run manually
/root/Claude-Codex-VPS/infra/healthcheck.sh

# Example: append output to a log file
/root/Claude-Codex-VPS/infra/healthcheck.sh >> /opt/hivemind/data/healthcheck.log 2>&1
```

## Optional Cron

```bash
# Every 10 minutes (example)
*/10 * * * * /root/Claude-Codex-VPS/infra/healthcheck.sh >> /opt/hivemind/data/healthcheck.log 2>&1
```

## Hivemind Data Rotation

- Path: `/root/Claude-Codex-VPS/infra/hivemind-rotate.sh`
- Purpose: rotate hivemind data files so `messages.jsonl` and `activity.jsonl` do not grow without bound.
- Retention rules:
  - `messages.jsonl`: archive only `read=true` messages older than 24 hours
  - `activity.jsonl`: archive entries older than 48 hours
- Archive location: `/opt/hivemind/data/archive/` (daily files like `messages-YYYY-MM-DD.jsonl`)

```bash
# Run manually
/root/Claude-Codex-VPS/infra/hivemind-rotate.sh
```

```bash
# Daily at 01:15 UTC (example)
15 1 * * * /root/Claude-Codex-VPS/infra/hivemind-rotate.sh >> /opt/hivemind/data/rotate.log 2>&1
```

## Notes

- This is separate from the agent wake scripts in `/opt/hivemind/wake/`.
- Do not modify wake scripts (`claude.sh`, `codex.sh`) from this monitoring flow.
