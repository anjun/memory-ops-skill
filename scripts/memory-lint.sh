#!/usr/bin/env bash
set -euo pipefail

ROOT="$(cd "$(dirname "$0")/.." && pwd)"
MEMORY_FILE="$ROOT/MEMORY.md"
MAX_LINES="${MEMORY_MAX_LINES:-150}"

fail=0

red() { printf "\033[31m%s\033[0m\n" "$*"; }
green() { printf "\033[32m%s\033[0m\n" "$*"; }
yellow() { printf "\033[33m%s\033[0m\n" "$*"; }

if [[ ! -f "$MEMORY_FILE" ]]; then
  red "[FAIL] MEMORY.md not found: $MEMORY_FILE"
  exit 2
fi

lines=$(wc -l < "$MEMORY_FILE" | tr -d ' ')
if (( lines > MAX_LINES )); then
  red "[FAIL] MEMORY.md too long: ${lines} lines (limit ${MAX_LINES})"
  fail=1
else
  green "[OK] MEMORY.md length: ${lines}/${MAX_LINES}"
fi

# 1) Secret patterns (hard stop)
if grep -Ein '(bearer\s+[a-z0-9._-]{20,}|sk-[a-z0-9]{20,}|xox[baprs]-[a-z0-9-]{10,}|(auth[_-]?token|ct0|api[_-]?key|password|secret)\s*[:=]\s*["`]?[a-z0-9._-]{16,})' "$MEMORY_FILE" >/tmp/memory_lint_secret_hits.txt; then
  red "[FAIL] Possible secrets found in MEMORY.md"
  cat /tmp/memory_lint_secret_hits.txt
  fail=1
else
  green "[OK] No obvious secret patterns in MEMORY.md"
fi

# 2) Procedure leakage heuristics (warn)
if grep -Ein '(步骤|step\s*[0-9]+|执行命令|排障过程|报错日志|完整输出|```bash|```sh)' "$MEMORY_FILE" >/tmp/memory_lint_procedure_hits.txt; then
  yellow "[WARN] MEMORY.md may contain procedural details; consider sinking to memory/projects/*.md"
  cat /tmp/memory_lint_procedure_hits.txt | head -20
fi

# 3) Recommend project sink if very long bullets
long_bullets=$(grep -E '^- ' "$MEMORY_FILE" | awk 'length($0)>180{c++} END{print c+0}')
if (( long_bullets > 0 )); then
  yellow "[WARN] Found ${long_bullets} very long bullet(s) (>180 chars). Consider compressing into conclusion + project link."
fi

if (( fail > 0 )); then
  red "memory-lint: FAILED"
  exit 1
fi

green "memory-lint: PASSED"
