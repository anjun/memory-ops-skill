#!/usr/bin/env bash
set -euo pipefail

# Setup OpenClaw memory_search to use LOCAL embeddings (no external API key).
# Idempotent: safe to run after OpenClaw upgrades.

WORKSPACE="/home/ubuntu/.openclaw/workspace"
CFG="$HOME/.openclaw/openclaw.json"
OPENCLAW_DIR="/usr/lib/node_modules/openclaw"
MODEL_PATH="hf:ggml-org/embeddinggemma-300m-qat-q8_0-GGUF/embeddinggemma-300m-qat-Q8_0.gguf"

say() { echo "[setup-memory-search-local] $*"; }

die() { echo "[setup-memory-search-local][ERROR] $*" >&2; exit 1; }

command -v openclaw >/dev/null 2>&1 || die "openclaw not found in PATH"

say "1) Updating config: $CFG"
python3 - <<'PY'
import json, os
p=os.path.expanduser('~/.openclaw/openclaw.json')
with open(p) as f:
    cfg=json.load(f)
agents=cfg.setdefault('agents',{})
defaults=agents.setdefault('defaults',{})
ms=defaults.setdefault('memorySearch',{})
ms['provider']='local'
ms['fallback']='none'
ms.setdefault('local',{})
ms['local']['modelPath']='hf:ggml-org/embeddinggemma-300m-qat-q8_0-GGUF/embeddinggemma-300m-qat-Q8_0.gguf'
ms.setdefault('cache',{})
ms['cache'].setdefault('enabled', True)
with open(p,'w') as f:
    json.dump(cfg,f,ensure_ascii=False,indent=2)
print('ok')
PY

say "2) Rebuilding native dependency: node-llama-cpp (needed for local embeddings)"
if [ -d "$OPENCLAW_DIR" ]; then
  (cd "$OPENCLAW_DIR" && npm rebuild node-llama-cpp) >/dev/null 2>&1 || die "npm rebuild node-llama-cpp failed"
else
  die "OpenClaw install dir not found: $OPENCLAW_DIR"
fi

say "3) Restarting gateway (so config takes effect)"
openclaw gateway restart >/dev/null 2>&1 || die "gateway restart failed"

say "4) Reindexing memory (may download the model on first run)"
openclaw memory index --force || die "memory index failed"

say "5) Showing status"
openclaw memory status --json | head -200

say "Done. You can now use: memory_search / openclaw memory search --query '...'"
