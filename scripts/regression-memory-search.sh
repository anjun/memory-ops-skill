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

parsed=$(python3 -c '
import json,sys
raw=sys.stdin.read()
clean="\n".join([ln for ln in raw.splitlines() if not ln.startswith("[proxychains]")]).strip()
if not clean:
    print("-1 -1"); raise SystemExit
start=min([x for x in [clean.find("["), clean.find("{")] if x!=-1], default=-1)
if start==-1:
    print("-1 -1"); raise SystemExit
clean=clean[start:]
try:
    j=json.loads(clean)
except Exception:
    print("-1 -1"); raise SystemExit
if isinstance(j, list) and j:
    j=j[0].get("status", {})
elif isinstance(j, dict) and "status" in j:
    j=j.get("status", {})
elif not isinstance(j, dict):
    print("-1 -1"); raise SystemExit
print("{} {}".format(j.get("files", -1), j.get("chunks", -1)))
' <<< "$status_json")
files=$(echo "$parsed" | awk '{print $1}')
chunks=$(echo "$parsed" | awk '{print $2}')

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
