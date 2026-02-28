# Memory Write Gate (Hard Rules)

## Mandatory classification

Before any write, choose one:

1. `long_term`
2. `project_detail`
3. `daily_log`

No classification → do not write.

## Default smart routing (when user only says "remember this")

- Operation steps / commands / errors / debugging process → `project_detail`
- Same-day events / progress / temporary context → `daily_log`
- Stable preferences / durable rules / final conclusions → `long_term`

Do **not** default long procedures to `MEMORY.md`.

## Strict limits for MEMORY.md

- Max 5 bullets per update
- Each bullet is a conclusion, not a procedure
- No long command blocks
- Prefer links to `memory/projects/*`

## Security hard stop

Never write secrets:

- token, cookie, password, API key
- Bearer/auth headers

Store only location/method, never secret values.

## Post-write check

If `MEMORY.md` changed, run:

```bash
bash scripts/memory-lint.sh
```
