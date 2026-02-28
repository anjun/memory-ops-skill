#!/usr/bin/env bash
set -euo pipefail

# Setup OpenClaw memory_search to use LOCAL embeddings (no external API key).
# Safer version: creates config backup before modifying.

CFG="$HOME/.openclaw/openclaw.json"
MODEL_PATH="hf:ggml-org/embeddinggemma-300m-qat-q8_0-GGUF/embeddinggemma-300m-qat-Q8_0.gguf"
ASSUME_YES=0
SKIP_REBUILD=0
SKIP_RESTART=0

say() { echo "[setup-memory-search-local] $*"; }
die() { echo "[setup-memory-search-local][ERROR] $*" >&2; exit 1; }

usage() {
  cat <<EOF
Usage: $0 [--yes] [--skip-rebuild] [--skip-restart]

Options:
  --yes           Non-interactive confirm
  --skip-rebuild  Skip npm rebuild node-llama-cpp
  --skip-restart  Skip openclaw gateway restart
EOF
}

while [[ $# -gt 0 ]]; do
  case "$1" in
    --yes) ASSUME_YES=1; shift ;;
    --skip-rebuild) SKIP_REBUILD=1; shift ;;
    --skip-restart) SKIP_RESTART=1; shift ;;
    -h|--help) usage; exit 0 ;;
    *) die "unknown argument: $1" ;;
  esac
done

command -v openclaw >/dev/null 2>&1 || die "openclaw not found in PATH"
[[ -f "$CFG" ]] || die "config not found: $CFG"

say "Plan:"
say "  1) backup $CFG"
say "  2) set memorySearch provider=local"
if [[ "$SKIP_REBUILD" -eq 0 ]]; then say "  3) rebuild node-llama-cpp"; else say "  3) skip rebuild"; fi
if [[ "$SKIP_RESTART" -eq 0 ]]; then say "  4) restart gateway"; else say "  4) skip restart"; fi
say "  5) force reindex + status"

if [[ "$ASSUME_YES" -ne 1 ]]; then
  read -r -p "Continue? [y/N] " ans
  [[ "${ans:-}" =~ ^[Yy]$ ]] || die "aborted"
fi

backup="$CFG.bak.$(date +%Y%m%d-%H%M%S)"
cp "$CFG" "$backup"
say "backup created: $backup"

say "updating config..."
python3 - <<PY
import json
p=r'''$CFG'''
with open(p,'r',encoding='utf-8') as f:
    cfg=json.load(f)
agents=cfg.setdefault('agents',{})
defaults=agents.setdefault('defaults',{})
ms=defaults.setdefault('memorySearch',{})
ms['provider']='local'
ms['fallback']='none'
local=ms.setdefault('local',{})
local['modelPath']=r'''$MODEL_PATH'''
cache=ms.setdefault('cache',{})
cache.setdefault('enabled', True)
with open(p,'w',encoding='utf-8') as f:
    json.dump(cfg,f,ensure_ascii=False,indent=2)
print('ok')
PY

if [[ "$SKIP_REBUILD" -eq 0 ]]; then
  OPENCLAW_DIR="$(npm root -g 2>/dev/null)/openclaw"
  if [[ ! -d "$OPENCLAW_DIR" ]]; then
    OPENCLAW_DIR="/usr/lib/node_modules/openclaw"
  fi
  [[ -d "$OPENCLAW_DIR" ]] || die "OpenClaw install dir not found"
  say "rebuilding node-llama-cpp in $OPENCLAW_DIR"
  (cd "$OPENCLAW_DIR" && npm rebuild node-llama-cpp) >/dev/null 2>&1 || die "npm rebuild node-llama-cpp failed"
fi

if [[ "$SKIP_RESTART" -eq 0 ]]; then
  say "restarting gateway"
  openclaw gateway restart >/dev/null 2>&1 || die "gateway restart failed"
fi

say "reindex memory"
openclaw memory index --force || die "memory index failed"

say "status"
openclaw memory status --json | sed -n '1,200p'

say "Done"
say "Rollback: cp '$backup' '$CFG' && openclaw gateway restart"
