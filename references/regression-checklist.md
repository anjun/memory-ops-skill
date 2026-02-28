# Compression + Regression Checklist

## Compression checklist

- [ ] Extract 3-7 reusable conclusions
- [ ] Keep procedures in project docs
- [ ] Keep MEMORY.md concise
- [ ] Include risks/todos only if actionable

## Retrieval/regression checklist

Run representative checks after major memory changes:

```bash
bash scripts/memory-lint.sh
bash scripts/regression-memory-search.sh
```

Expected:

- `memory-lint: PASSED`
- regression script prints `ALL PASSED`

If failure occurs:

1. Roll back noisy edits in `MEMORY.md`
2. Sink details to `memory/projects/*`
3. Re-run checks
