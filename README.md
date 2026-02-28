# memory-ops-skill

Unified memory operation skill package for OpenClaw.

## What it does

- Enforces memory write classification (`long_term` / `project_detail` / `daily_log`)
- Keeps `MEMORY.md` concise and pushes procedures into `memory/projects/*`
- Applies security rules (never store token/cookie/password/API key values)
- Provides regression checklist (`memory-lint` + retrieval checks)

## Structure

- `SKILL.md` — entrypoint instructions
- `references/memory-layout.md`
- `references/write-gate.md`
- `references/regression-checklist.md`

## Runtime compatibility

### OpenClaw (native)

This package is natively compatible as an AgentSkill folder.

### Codex / Claude Code / OpenCode (portable with adapter)

Core methodology is portable (classification + sinking + lint workflow), but trigger/loading mechanism is OpenClaw-style.

To use in other runtimes, adapt:

1. Skill metadata/trigger format
2. Tool command names (`openclaw ...` → equivalent commands)
3. Memory file paths if your workspace layout differs

## Notes

This repo is intended for isolated testing before publishing to ClawHub.
