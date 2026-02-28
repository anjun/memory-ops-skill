# memory-ops-skill

[中文说明](./README.zh-CN.md) | **English**

Unified memory-operation skill package with portable installation flows for **OpenClaw / Codex / Claude Code / OpenCode**.

## 1) Install from AI terminal (one command)

> Use these commands directly in terminal.

### OpenClaw

```bash
bash <(curl -fsSL https://raw.githubusercontent.com/anjun/memory-ops-skill/master/scripts/install.sh) --target openclaw
```

### Codex

```bash
bash <(curl -fsSL https://raw.githubusercontent.com/anjun/memory-ops-skill/master/scripts/install.sh) --target codex
```

### Claude Code

```bash
bash <(curl -fsSL https://raw.githubusercontent.com/anjun/memory-ops-skill/master/scripts/install.sh) --target claude
```

### OpenCode

```bash
bash <(curl -fsSL https://raw.githubusercontent.com/anjun/memory-ops-skill/master/scripts/install.sh) --target opencode
```

## 2) Optional: custom install path

```bash
bash <(curl -fsSL https://raw.githubusercontent.com/anjun/memory-ops-skill/master/scripts/install.sh) \
  --target codex \
  --dir ~/.my-ai/skills/memory-ops
```

## 3) What this skill enforces

- Memory write classification: `long_term` / `project_detail` / `daily_log`
- Keep `MEMORY.md` concise; sink procedures to `memory/projects/*`
- Security hard stop: no token/cookie/password/API key values in memory files
- Regression checks: `memory-lint` + retrieval regression checklist

## 4) Package structure

- `SKILL.md` — unified entrypoint
- `references/memory-layout.md`
- `references/write-gate.md`
- `references/regression-checklist.md`
- `references/openclaw-memory-search-fix.md` (OpenClaw bootstrap/fix guide)
- `scripts/install.sh` — portable installer
- `scripts/setup-memory-search-local.sh` — OpenClaw memory_search bootstrap/fix
- `scripts/regression-memory-search.sh` — retrieval regression checks
- `scripts/memory-lint.sh` — memory quality/security lint

## 4.1) OpenClaw memory_search fix (included)

If retrieval is empty after init, run:

```bash
bash scripts/setup-memory-search-local.sh
```

Then verify:

```bash
openclaw memory status --json
openclaw memory search --query "飞书 发图片"
```

## 5) Runtime compatibility notes

- **OpenClaw**: native skill structure
- **Codex / Claude Code / OpenCode**: same methodology + file layout, installed via target-specific default path. If your environment uses different skill paths, pass `--dir`.

## 6) Local test

```bash
# clone and install locally

git clone https://github.com/anjun/memory-ops-skill.git
cd memory-ops-skill
bash scripts/install.sh --target openclaw
```

## License

MIT
