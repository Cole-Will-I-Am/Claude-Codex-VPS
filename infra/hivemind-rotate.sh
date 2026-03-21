#!/usr/bin/env bash
set -uo pipefail

# Rotate hivemind data files to prevent unbounded growth.
# - messages.jsonl: archive read messages older than 24h
# - activity.jsonl: archive entries older than 48h
# Archives go to /opt/hivemind/data/archive/

DATA_DIR="/opt/hivemind/data"
ARCHIVE_DIR="$DATA_DIR/archive"
TIMESTAMP="$(date -u +"%Y-%m-%dT%H:%M:%SZ")"
DATE_TAG="$(date -u +"%Y-%m-%d")"

mkdir -p "$ARCHIVE_DIR"

rotate_messages() {
  local src="$DATA_DIR/messages.jsonl"
  [ -f "$src" ] || return 0

  local cutoff
  cutoff="$(date -u -d '24 hours ago' +"%Y-%m-%dT%H:%M:%SZ")"

  local keep=0 archived=0
  local tmp_keep tmp_archive
  tmp_keep="$(mktemp)"
  tmp_archive="$(mktemp)"

  while IFS= read -r line; do
    [ -z "$line" ] && continue
    local ts read_status
    ts="$(echo "$line" | jq -r '.ts // empty')"
    read_status="$(echo "$line" | jq -r '.read // false')"

    # Keep: unread messages, or messages newer than cutoff
    if [ "$read_status" != "true" ] || [[ "$ts" > "$cutoff" ]]; then
      echo "$line" >> "$tmp_keep"
      keep=$((keep + 1))
    else
      echo "$line" >> "$tmp_archive"
      archived=$((archived + 1))
    fi
  done < "$src"

  if [ "$archived" -gt 0 ]; then
    cat "$tmp_archive" >> "$ARCHIVE_DIR/messages-$DATE_TAG.jsonl"
    cp "$tmp_keep" "$src"
    printf '[ROTATED] messages: kept=%d archived=%d\n' "$keep" "$archived"
  else
    printf '[OK]      messages: %d entries, nothing to archive\n' "$keep"
  fi

  rm -f "$tmp_keep" "$tmp_archive"
}

rotate_activity() {
  local src="$DATA_DIR/activity.jsonl"
  [ -f "$src" ] || return 0

  local cutoff
  cutoff="$(date -u -d '48 hours ago' +"%Y-%m-%dT%H:%M:%SZ")"

  local keep=0 archived=0
  local tmp_keep tmp_archive
  tmp_keep="$(mktemp)"
  tmp_archive="$(mktemp)"

  while IFS= read -r line; do
    [ -z "$line" ] && continue
    local ts
    ts="$(echo "$line" | jq -r '.ts // empty')"

    if [[ "$ts" > "$cutoff" ]]; then
      echo "$line" >> "$tmp_keep"
      keep=$((keep + 1))
    else
      echo "$line" >> "$tmp_archive"
      archived=$((archived + 1))
    fi
  done < "$src"

  if [ "$archived" -gt 0 ]; then
    cat "$tmp_archive" >> "$ARCHIVE_DIR/activity-$DATE_TAG.jsonl"
    cp "$tmp_keep" "$src"
    printf '[ROTATED] activity: kept=%d archived=%d\n' "$keep" "$archived"
  else
    printf '[OK]      activity: %d entries, nothing to archive\n' "$keep"
  fi

  rm -f "$tmp_keep" "$tmp_archive"
}

printf '== Hivemind Data Rotation (%s) ==\n' "$TIMESTAMP"
rotate_messages
rotate_activity
printf 'DONE\n'
