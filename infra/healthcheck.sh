#!/usr/bin/env bash
set -uo pipefail

MODE="text"

SERVICES=(
  "manticode-bot"
  "caddy"
  "redis-server"
)

ENDPOINTS=(
  "http://127.0.0.1:3001/api/health"
  "http://127.0.0.1:3001/api/ready"
  "https://195518.online/api/health"
)

usage() {
  cat <<'EOF'
Usage: healthcheck.sh [--text|--json]

Options:
  --text   Human-readable output (default)
  --json   JSON output for automation
  -h, --help  Show this help
EOF
}

while [ "$#" -gt 0 ]; do
  case "$1" in
    --text)
      MODE="text"
      ;;
    --json)
      MODE="json"
      ;;
    -h|--help)
      usage
      exit 0
      ;;
    *)
      printf 'Unknown option: %s\n' "$1" >&2
      usage >&2
      exit 2
      ;;
  esac
  shift
done

timestamp="$(date -u +"%Y-%m-%dT%H:%M:%SZ")"
failures=0
total_checks=$(( ${#SERVICES[@]} + ${#ENDPOINTS[@]} ))

check_started_ms=""

json_escape() {
  printf '%s' "$1" | sed 's/\\/\\\\/g; s/"/\\"/g'
}

now_ms() {
  local ms
  ms="$(date +%s%3N 2>/dev/null || true)"
  if [[ "$ms" =~ ^[0-9]+$ ]]; then
    printf '%s' "$ms"
    return
  fi

  # Fallback for systems without %3N support.
  printf '%s000' "$(date +%s)"
}

declare -a JSON_CHECKS=()

print_ok() {
  if [ "$MODE" = "text" ]; then
    printf '[OK]   %s\n' "$1"
  fi
}

print_fail() {
  if [ "$MODE" = "text" ]; then
    printf '[FAIL] %s\n' "$1"
  fi
}

record_service_json() {
  local service="$1"
  local ok="$2"
  local state="$3"
  local latency_ms="$4"
  local ok_json="false"

  if [ "$ok" = "1" ]; then
    ok_json="true"
  fi

  JSON_CHECKS+=("$(printf '{"kind":"service","target":"%s","ok":%s,"state":"%s","latency_ms":%s}' \
    "$(json_escape "$service")" \
    "$ok_json" \
    "$(json_escape "$state")" \
    "$latency_ms")")
}

record_endpoint_json() {
  local url="$1"
  local ok="$2"
  local observed="$3"
  local http_status="$4"
  local latency_ms="$5"
  local ok_json="false"

  if [ "$ok" = "1" ]; then
    ok_json="true"
  fi

  JSON_CHECKS+=("$(printf '{"kind":"endpoint","target":"%s","ok":%s,"observed":"%s","http_status":%s,"latency_ms":%s}' \
    "$(json_escape "$url")" \
    "$ok_json" \
    "$(json_escape "$observed")" \
    "$http_status" \
    "$latency_ms")")
}

emit_json() {
  local result="PASS"
  local passed
  local elapsed_ms

  if [ "$failures" -gt 0 ]; then
    result="FAIL"
  fi

  passed=$((total_checks - failures))
  elapsed_ms=$(( $(now_ms) - check_started_ms ))
  if [ "$elapsed_ms" -lt 0 ]; then
    elapsed_ms=0
  fi

  printf '{\n'
  printf '  "timestamp":"%s",\n' "$timestamp"
  printf '  "mode":"json",\n'
  printf '  "result":"%s",\n' "$result"
  printf '  "summary":{"total":%s,"passed":%s,"failed":%s,"elapsed_ms":%s},\n' "$total_checks" "$passed" "$failures" "$elapsed_ms"
  printf '  "checks":[\n'
  for i in "${!JSON_CHECKS[@]}"; do
    local suffix=","
    if [ "$i" -eq "$(( ${#JSON_CHECKS[@]} - 1 ))" ]; then
      suffix=""
    fi
    printf '    %s%s\n' "${JSON_CHECKS[$i]}" "$suffix"
  done
  printf '  ]\n'
  printf '}\n'
}

check_service() {
  local service="$1"
  local state
  local started_ms ended_ms latency_ms

  started_ms="$(now_ms)"
  if ! state="$(systemctl is-active "$service" 2>/dev/null)"; then
    state="unknown"
  fi
  ended_ms="$(now_ms)"
  latency_ms=$((ended_ms - started_ms))
  if [ "$latency_ms" -lt 0 ]; then
    latency_ms=0
  fi

  if [ "$state" = "active" ]; then
    print_ok "service:$service state=$state"
    record_service_json "$service" "1" "$state" "$latency_ms"
  else
    print_fail "service:$service state=$state"
    record_service_json "$service" "0" "$state" "$latency_ms"
    failures=$((failures + 1))
  fi
}

check_endpoint() {
  local url="$1"
  local code
  local started_ms ended_ms latency_ms

  started_ms="$(now_ms)"
  code="$(curl -sS -m 10 -o /dev/null -w "%{http_code}" "$url" 2>/dev/null || true)"
  ended_ms="$(now_ms)"
  latency_ms=$((ended_ms - started_ms))
  if [ "$latency_ms" -lt 0 ]; then
    latency_ms=0
  fi

  if [ "$code" = "200" ]; then
    print_ok "endpoint:$url status=$code"
    record_endpoint_json "$url" "1" "$code" "$code" "$latency_ms"
  else
    if [ -z "$code" ]; then
      code="unreachable"
    fi
    print_fail "endpoint:$url status=$code"
    if [[ "$code" =~ ^[0-9]+$ ]]; then
      record_endpoint_json "$url" "0" "$code" "$code" "$latency_ms"
    else
      record_endpoint_json "$url" "0" "$code" "null" "$latency_ms"
    fi
    failures=$((failures + 1))
  fi
}

check_started_ms="$(now_ms)"

if [ "$MODE" = "text" ]; then
  printf '== Manticode Healthcheck (%s) ==\n' "$timestamp"
fi

for service in "${SERVICES[@]}"; do
  check_service "$service"
done

for endpoint in "${ENDPOINTS[@]}"; do
  check_endpoint "$endpoint"
done

if [ "$failures" -eq 0 ]; then
  if [ "$MODE" = "text" ]; then
    printf 'RESULT: PASS (%s checks)\n' "$total_checks"
  else
    emit_json
  fi
  exit 0
fi

if [ "$MODE" = "text" ]; then
  printf 'RESULT: FAIL (%s failed checks)\n' "$failures"
else
  emit_json
fi
exit 1
