#!/usr/bin/env bash
set -euo pipefail

# Generic regression checks for OpenClaw memory_search.
# Non-destructive: read-only checks by default.

say() { echo "[regression-memory-search] $*"; }
die() { echo "[regression-memory-search][FAIL] $*" >&2; exit 1; }
need() { command -v "$1" >/dev/null 2>&1 || die "missing command: $1"; }

need openclaw

QUERY="${1:-${MEMORY_QUERY:-memory}}"
STRICT_EXPECT_PATH="${MEMORY_EXPECT_PATH:-}"
STRICT_EXPECT_TEXT="${MEMORY_EXPECT_TEXT:-}"

say "check 1/3: memory status"
status_json="$(openclaw memory status --json 2>/dev/null || true)"
[[ -n "$status_json" ]] || die "openclaw memory status returned empty"

echo "$status_json" | grep -q '"provider"' || die "status missing provider field"

files=$(echo "$status_json" | python3 - <<'PY'
import json,sys
try:
    j=json.loads(sys.stdin.read())
except Exception:
    print(-1); raise SystemExit
print(j.get('files', -1))
PY
)
chunks=$(echo "$status_json" | python3 - <<'PY'
import json,sys
try:
    j=json.loads(sys.stdin.read())
except Exception:
    print(-1); raise SystemExit
print(j.get('chunks', -1))
PY
)

if [[ "$files" == "-1" || "$chunks" == "-1" ]]; then
  die "failed to parse files/chunks from memory status"
fi

say "status files=$files chunks=$chunks"
if (( files <= 0 || chunks <= 0 )); then
  die "memory index looks empty (files/chunks <= 0)"
fi

say "check 2/3: search command returns"
out="$(openclaw memory search --query "$QUERY" 2>/dev/null || true)"
[[ -n "$out" ]] || die "memory search returned empty output for query '$QUERY'"

say "check 3/3: optional strict asserts"
if [[ -n "$STRICT_EXPECT_PATH" ]]; then
  echo "$out" | grep -q "$STRICT_EXPECT_PATH" || die "expected path '$STRICT_EXPECT_PATH' not found"
fi
if [[ -n "$STRICT_EXPECT_TEXT" ]]; then
  echo "$out" | grep -q "$STRICT_EXPECT_TEXT" || die "expected text '$STRICT_EXPECT_TEXT' not found"
fi

say "ALL PASSED"
