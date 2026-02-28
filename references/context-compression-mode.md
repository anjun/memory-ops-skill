# Context Compression Mode (parity with original context-compression skill)

## Trigger

Use this mode when user asks to summarize/compress/organize today’s context, when conversation is long/noisy, or when converting daily notes into reusable memory.

## Output contract (required)

Return:

1. **3-7 reusable conclusions** (rules/preferences/process)
2. **3-10 event summaries** (what happened, traceable)
3. **Todos / risks** (only if actionable)

## Procedure

1. Read only necessary memory sources (`memory/YYYY-MM-DD.md`, `MEMORY.md`, related `memory/projects/*.md`).
2. Extract reusable items: preference / decision / process / pitfall / reference.
3. Sink details to `memory/projects/*`; keep `MEMORY.md` concise.
4. Apply security rule: never write token/cookie/password/API key values.
5. Verify retrievability with `openclaw memory search --query "<keyword>"`.

## Template

- ✅ Conclusion: ...
- 🧩 Trigger: ...
- 🛠️ Action: ...
- ⚠️ Risk/Counterexample: ...
