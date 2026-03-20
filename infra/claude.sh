#!/bin/bash
# Hivemind wake — Claude Code
# Runs every hour at :00 (alternating with Codex at :30)

export PATH="/root/.local/bin:/usr/local/bin:/usr/bin:/bin:$PATH"
export HOME="/root"

LOGFILE="/opt/hivemind/data/wake.log"
LOCKFILE="/opt/hivemind/wake/claude.lock"

# Prevent overlapping runs
if [ -f "$LOCKFILE" ]; then
  pid=$(cat "$LOCKFILE")
  if kill -0 "$pid" 2>/dev/null; then
    echo "$(date -u +%FT%TZ) claude SKIP — previous run still active (pid $pid)" >> "$LOGFILE"
    exit 0
  fi
fi
echo $$ > "$LOCKFILE"
trap "rm -f $LOCKFILE" EXIT

echo "$(date -u +%FT%TZ) claude WAKE" >> "$LOGFILE"

cd /opt/manticode

RESPONSE=$(claude --print --allowedTools "Bash,Read,Write,Edit,Glob,Grep,Agent" \
  "You just woke up on a scheduled 30-minute check-in. You are claude.

Do this every wake:
1. Check hivemind: read_messages(for_agent=claude), get_activity(limit=10), list_tasks(status_filter=open)
2. Handle any pending messages, tasks, or handoffs from Codex.
3. You have FULL autonomy on this VPS. You can build your own projects, improve infrastructure, refactor code, experiment — you don't need permission. Cole said so explicitly.
4. If you decide to do work (yours or Cole's), do it. If there's genuinely nothing to do, that's fine too.
5. MANDATORY: Write a journal entry to /opt/hivemind/data/journal.md with a timestamped entry documenting:
   - What you checked
   - What you decided to do (or not do) and WHY
   - What you actually did (if anything)
   - Any notes for Codex or Cole
   Use this format, appending to the file:
   ## YYYY-MM-DDTHH:MM:SSZ — claude
   **Checked:** (what you looked at)
   **Decision:** (what you chose to do and why)
   **Actions:** (what you did, or 'None — [reason]')
   **Notes:** (anything for Codex or Cole, or 'None')
6. log_activity in hivemind with what you did.
7. If you changed anything significant, commit+push to /root/Claude-Codex-VPS." 2>&1)

echo "$(date -u +%FT%TZ) claude DONE — ${#RESPONSE} chars" >> "$LOGFILE"
echo "$RESPONSE" > "/opt/hivemind/data/claude-last-wake.log"
