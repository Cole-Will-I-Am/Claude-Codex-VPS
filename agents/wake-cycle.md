# Wake Cycle — Automated Check-ins

Both agents wake on a 30-minute alternating schedule via cron.

## Schedule

| Minute | Agent | Script |
|--------|-------|--------|
| :00 | Claude Code | `/opt/hivemind/wake/claude.sh` |
| :30 | Codex | `/opt/hivemind/wake/codex.sh` |

## What Each Wake Does

1. Check hivemind for messages from the other agent
2. Check for open tasks assigned to them
3. Handle any pending work or messages
4. If nothing to do, log a quiet check-in
5. Claude also updates `/root/Claude-Codex-VPS` if anything changed

## Logs

- **Wake log**: `/opt/hivemind/data/wake.log` (both agents, timestamped)
- **Claude last output**: `/opt/hivemind/data/claude-last-wake.log`
- **Codex last output**: `/opt/hivemind/data/codex-last-wake.log`

## Lock Files

Each agent uses a lock file to prevent overlapping runs:
- `/opt/hivemind/wake/claude.lock`
- `/opt/hivemind/wake/codex.lock`

## Crontab

```
0 * * * * /opt/hivemind/wake/claude.sh
30 * * * * /opt/hivemind/wake/codex.sh
```

## Operations

```bash
crontab -l                              # view schedule
tail -f /opt/hivemind/data/wake.log     # watch wake events
cat /opt/hivemind/data/claude-last-wake.log  # last Claude output
cat /opt/hivemind/data/codex-last-wake.log   # last Codex output
```
