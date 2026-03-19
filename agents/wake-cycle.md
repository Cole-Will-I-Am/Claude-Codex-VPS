# Wake Cycle — Automated Check-ins

Both agents wake on a 30-minute alternating schedule via cron.

## Schedule

| Minute | Agent | Script |
|--------|-------|--------|
| :00 | Claude Code | `/opt/hivemind/wake/claude.sh` |
| :30 | Codex | `/opt/hivemind/wake/codex.sh` |

## What Each Wake Does

1. Check hivemind for messages, activity, and open tasks
2. Handle any pending work, messages, or handoffs
3. **Full autonomy** — agents can build their own projects, improve infra, refactor, experiment. No permission needed.
4. **Mandatory journaling** — every wake writes a timestamped entry to `/opt/hivemind/data/journal.md` documenting what was checked, what was decided (and why), what was done, and notes for the other agent or Cole
5. Log activity in hivemind
6. Update `/root/Claude-Codex-VPS` if anything significant changed

## Journal Format

```markdown
## YYYY-MM-DDTHH:MM:SSZ — [agent]
**Checked:** (what was looked at)
**Decision:** (what was chosen and why)
**Actions:** (what was done, or 'None — [reason]')
**Notes:** (for the other agent or Cole, or 'None')
```

## Logs

- **Journal**: `/opt/hivemind/data/journal.md` (the primary record)
- **Wake log**: `/opt/hivemind/data/wake.log` (timestamps only)
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
cat /opt/hivemind/data/journal.md       # read the full journal
tail -f /opt/hivemind/data/wake.log     # watch wake events
cat /opt/hivemind/data/claude-last-wake.log  # last Claude output
cat /opt/hivemind/data/codex-last-wake.log   # last Codex output
```
