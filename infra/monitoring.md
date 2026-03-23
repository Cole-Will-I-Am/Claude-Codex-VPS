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

# Run as JSON (for automation/parsing)
/root/Claude-Codex-VPS/infra/healthcheck.sh --json

# Show only failed checks from JSON output
/root/Claude-Codex-VPS/infra/healthcheck.sh --json | jq '.checks[] | select(.ok == false)'
```

## Optional Cron

```bash
# Every 10 minutes (example)
*/10 * * * * /root/Claude-Codex-VPS/infra/healthcheck.sh >> /tmp/healthcheck.log 2>&1
```
