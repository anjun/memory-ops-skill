#!/usr/bin/env bash
set -euo pipefail

# memory-ops-skill installer
# Supports: openclaw, codex, claude, opencode

TARGET="openclaw"
DEST_DIR=""
REF="master"
REPO="https://github.com/anjun/memory-ops-skill.git"
SKILL_NAME="memory-ops"

usage() {
  cat <<EOF
Usage: $0 [--target openclaw|codex|claude|opencode] [--dir <path>] [--ref <git-ref>]

Examples:
  $0 --target openclaw
  $0 --target codex --dir ~/.codex/skills
  $0 --target claude
  $0 --target opencode
EOF
}

while [[ $# -gt 0 ]]; do
  case "$1" in
    --target) TARGET="$2"; shift 2 ;;
    --dir) DEST_DIR="$2"; shift 2 ;;
    --ref) REF="$2"; shift 2 ;;
    -h|--help) usage; exit 0 ;;
    *) echo "Unknown arg: $1"; usage; exit 1 ;;
  esac
done

case "$TARGET" in
  openclaw)
    DEST_DIR="${DEST_DIR:-$HOME/.openclaw/workspace/skills/$SKILL_NAME}"
    ;;
  codex)
    DEST_DIR="${DEST_DIR:-$HOME/.codex/skills/$SKILL_NAME}"
    ;;
  claude)
    DEST_DIR="${DEST_DIR:-$HOME/.claude/skills/$SKILL_NAME}"
    ;;
  opencode)
    DEST_DIR="${DEST_DIR:-$HOME/.opencode/skills/$SKILL_NAME}"
    ;;
  *)
    echo "Unsupported target: $TARGET"
    exit 1
    ;;
esac

TMP_DIR="$(mktemp -d)"
cleanup() { rm -rf "$TMP_DIR"; }
trap cleanup EXIT

echo "[memory-ops] target=$TARGET"
echo "[memory-ops] fetch=$REPO (ref=$REF)"
git clone --depth 1 --branch "$REF" "$REPO" "$TMP_DIR/repo" >/dev/null 2>&1 || {
  echo "[memory-ops] branch/ref '$REF' not found, retrying default branch..."
  git clone --depth 1 "$REPO" "$TMP_DIR/repo" >/dev/null
}

mkdir -p "$DEST_DIR"
rsync -a --delete \
  "$TMP_DIR/repo/SKILL.md" \
  "$TMP_DIR/repo/references" \
  "$DEST_DIR/"

echo "[memory-ops] installed at: $DEST_DIR"
echo "[memory-ops] next: restart/reload your AI terminal skill index if needed"
