# OpenClaw memory_search bootstrap/fix (important)

Use this when semantic retrieval returns empty/noisy results after initialization.

## Symptoms

- `memory_search` has poor/empty recall
- `openclaw memory status` shows `files=0` / `chunks=0`
- provider unavailable due to external embeddings key mismatch

## Root cause (common)

Default `provider=auto` may rely on external embedding providers.
If the runtime has no valid embedding API key, indexing/search degrades.

## Recommended fix (OpenClaw-native)

Prefer **local embeddings**:

- provider: `local`
- fallback: `none`
- model: embeddinggemma gguf

If your workspace has the helper script, run:

```bash
bash scripts/setup-memory-search-local.sh
```

This usually performs:

1. write memorySearch config to openclaw.json
2. rebuild `node-llama-cpp`
3. restart OpenClaw gateway
4. force reindex memory

## Verification

```bash
openclaw memory status --json
openclaw memory search --query "飞书 发图片"
```

Expected:

- provider = local
- files/chunks > 0
- query hits known memory docs
