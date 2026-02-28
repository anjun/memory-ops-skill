---
name: memory-ops
description: "Unified memory operation skill for OpenClaw: organize MEMORY.md vs daily/project notes, compress long conversations into reusable conclusions, enforce memory write gate (classification + security), and run regression checks before/after memory changes. Use when user asks to remember things, optimize memory quality, sink details from MEMORY.md, build memory workflows, validate memory retrieval reliability, or when conversation is long/noisy and near context compaction."
---

# Memory Ops

Use this skill to keep memory useful, short, and safe.

## Execute this workflow

1. Classify memory intent before writing:
   - `long_term` → `MEMORY.md`
   - `project_detail` → `memory/projects/<topic>.md`
   - `daily_log` → `memory/YYYY-MM-DD.md`
2. Write only the minimal reusable signal.
3. Keep sensitive data out of memory files.
4. Run verification checks.

## Read these references as needed

- Layout and placement rules: `references/memory-layout.md`
- Hard write gate and safety rules: `references/write-gate.md`
- Compression + regression checklist: `references/regression-checklist.md`
- Context compression mode (output contract): `references/context-compression-mode.md`
- Evaluation mode (test design + acceptance): `references/evaluation-mode.md`
- OpenClaw memory_search bootstrap/fix: `references/openclaw-memory-search-fix.md`

## Required output contract (for memory update tasks)

Always return:

1. Classification decision (`long_term` / `project_detail` / `daily_log`)
2. Target file path
3. What was added/removed (short bullets)
4. Verification result (`memory-lint` / retrieval check)

### If the task is context compression, also return

1. **3-7 reusable conclusions**
2. **3-10 event summaries**
3. **actionable todos/risks** (if any)

## Non-negotiables

- Never store token/cookie/password/API key/Bearer values in memory files.
- Prefer “index + link” in `MEMORY.md`; move procedures to `memory/projects/*`.
- If confidence is low, read more context first instead of writing vague memory.
