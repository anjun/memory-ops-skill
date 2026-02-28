---
name: memory-ops
description: Unified memory operation skill for OpenClaw: organize MEMORY.md vs daily/project notes, compress long conversations into reusable conclusions, enforce memory write gate (classification + security), and run regression checks before/after memory changes. Use when user asks to remember things, optimize memory quality, sink details from MEMORY.md, build memory workflows, or validate memory retrieval reliability.
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

## Required output contract (for memory update tasks)

Always return:

1. Classification decision (`long_term` / `project_detail` / `daily_log`)
2. Target file path
3. What was added/removed (short bullets)
4. Verification result (`memory-lint` / retrieval check)

## Non-negotiables

- Never store token/cookie/password/API key/Bearer values in memory files.
- Prefer “index + link” in `MEMORY.md`; move procedures to `memory/projects/*`.
- If confidence is low, read more context first instead of writing vague memory.
