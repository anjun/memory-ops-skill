# Evaluation Mode (parity with original evaluation skill)

## Goal

Turn "looks fine" into "verifiable": define minimal test set and explicit acceptance signals.

## Procedure

1. Define 3-10 representative cases.
2. For each case, document input → operation → expected output signal.
3. Prefer automated checks/scripts first; manual check second.
4. Record failure modes and rollback path.

## Memory-specific examples

- Lint: `bash scripts/memory-lint.sh` should pass.
- Retrieval: `bash scripts/regression-memory-search.sh` should print `ALL PASSED`.
- Optional strict assert:
  - `MEMORY_EXPECT_PATH="memory/2026-02-28.md" bash scripts/regression-memory-search.sh "memory-ops"`
