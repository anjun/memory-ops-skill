# Memory Write Gate (Hard Rules)

## Mandatory classification

Before any write, choose one:

1. `long_term`
2. `project_detail`
3. `daily_log`

No classification → do not write.

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
