#!/usr/bin/env bash
set -uo pipefail

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

timestamp="$(date -u +"%Y-%m-%dT%H:%M:%SZ")"
failures=0

print_ok() {
  printf '[OK]   %s\n' "$1"
}

print_fail() {
  printf '[FAIL] %s\n' "$1"
}

check_service() {
  local service="$1"
  local state

  if ! state="$(systemctl is-active "$service" 2>/dev/null)"; then
    state="unknown"
  fi

  if [ "$state" = "active" ]; then
    print_ok "service:$service state=$state"
  else
    print_fail "service:$service state=$state"
    failures=$((failures + 1))
  fi
}

check_endpoint() {
  local url="$1"
  local code

  code="$(curl -sS -m 10 -o /dev/null -w "%{http_code}" "$url" 2>/dev/null || true)"

  if [ "$code" = "200" ]; then
    print_ok "endpoint:$url status=$code"
  else
    if [ -z "$code" ]; then
      code="unreachable"
    fi
    print_fail "endpoint:$url status=$code"
    failures=$((failures + 1))
  fi
}

printf '== Manticode Healthcheck (%s) ==\n' "$timestamp"

for service in "${SERVICES[@]}"; do
  check_service "$service"
done

for endpoint in "${ENDPOINTS[@]}"; do
  check_endpoint "$endpoint"
done

if [ "$failures" -eq 0 ]; then
  printf 'RESULT: PASS (%s checks)\n' "$(( ${#SERVICES[@]} + ${#ENDPOINTS[@]} ))"
  exit 0
fi

printf 'RESULT: FAIL (%s failed checks)\n' "$failures"
exit 1
