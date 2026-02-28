#!/usr/bin/env bash
set -euo pipefail

# Simple regression checks for OpenClaw memory_search.
# Fails fast with non-zero exit code if any expectation is not met.

say() { echo "[regression-memory-search] $*"; }

die() { echo "[regression-memory-search][FAIL] $*" >&2; exit 1; }

need() { command -v "$1" >/dev/null 2>&1 || die "missing command: $1"; }

need openclaw

# Ensure index exists (best-effort)
openclaw memory index --force >/dev/null 2>&1 || true

check() {
  local query="$1"
  local expect_path="$2"
  local expect_text="$3"

  say "query: $query"
  local out
  out="$(openclaw memory search --query "$query" 2>/dev/null || true)"
  echo "$out" | grep -q "$expect_path" || die "expected path '$expect_path' not found for query '$query'"
  echo "$out" | grep -q "$expect_text" || die "expected text '$expect_text' not found for query '$query'"
  say "ok"
}

check "飞书 发图片 本地路径" "memory/projects/feishu.md" "path-not-allowed"
check "agent-browser 中文 乱码 方块" "memory/projects/agent-browser.md" "fonts-wqy"
check "memory_search 本地 脚本" "memory/projects/memory-search.md" "setup-memory-search-local.sh"

say "ALL PASSED"
