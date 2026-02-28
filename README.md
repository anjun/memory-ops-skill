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

## 2.1) Does this depend on AGENTS.md?

No. This package is designed to be **self-contained**:

- Routing/writing rules are in `SKILL.md` + `references/write-gate.md`
- Verification is in scripts (`memory-lint`, `regression-memory-search`)

If a workspace has extra AGENTS.md conventions, they are additive.

## 3) What this skill enforces

- Memory write classification: `long_term` / `project_detail` / `daily_log`
- Keep `MEMORY.md` concise; sink procedures to `memory/projects/*`
- Security hard stop: no token/cookie/password/API key values in memory files
- Regression checks: `memory-lint` + retrieval regression checklist
- Context-compression parity: 3-7 conclusions + 3-10 event summaries + risk/todo output contract
- Evaluation parity: 3-10 case design + explicit acceptance signals + rollback-aware checks

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

## 5) Runtime compatibility + test matrix

> Important: this project does **not** claim full forward/backward compatibility across all runtime versions.
> Use the matrix below as the source of truth.

| Runtime | Version / Scope | Status | What was tested |
|---|---|---|---|
| OpenClaw | `2026.2.26` | ✅ Verified | Install, SKILL parse, `memory-lint`, `regression-memory-search`, `setup-memory-search-local` (safe mode) |
| Codex CLI | path installer only | ⚠️ Partial | `scripts/install.sh --target codex` installs files to target path |
| Claude Code | path installer only | ⚠️ Partial | `scripts/install.sh --target claude` installs files to target path |
| OpenCode | path installer only | ⚠️ Partial | `scripts/install.sh --target opencode` installs files to target path |

### Notes

- Non-OpenClaw runtimes are currently **installation-verified only**, not full end-to-end behavior verified.
- If you need strict compatibility in Codex/Claude Code/OpenCode, run local acceptance tests in that runtime before production use.

## 6) How to use after install

### OpenClaw (recommended)

1. Install to OpenClaw skills path:

```bash
bash <(curl -fsSL https://raw.githubusercontent.com/anjun/memory-ops-skill/master/scripts/install.sh) --target openclaw
```

2. Start using in chat (auto-trigger by intent). Example prompts:

- "Remember this as long-term rule: ..."
- "Sink these debugging details to project memory"
- "Compress today into 3-7 conclusions + 3-10 events"
- "Run memory quality checks"

3. Optional explicit checks:

```bash
bash ~/.openclaw/workspace/skills/memory-ops/scripts/memory-lint.sh
bash ~/.openclaw/workspace/skills/memory-ops/scripts/regression-memory-search.sh
```

### Codex / Claude Code / OpenCode

- Install with `--target codex|claude|opencode`
- This package is currently **install-verified** on those runtimes.
- Triggering behavior depends on each runtime's own skill loader/rules.

## 7) Local test

```bash
# clone and install locally

git clone https://github.com/anjun/memory-ops-skill.git
cd memory-ops-skill
bash scripts/install.sh --target openclaw
```

## License

MIT
