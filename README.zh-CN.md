# memory-ops-skill

**中文** | [English](./README.md)

统一的记忆优化技能包，支持在 **OpenClaw / Codex / Claude Code / OpenCode** 的 AI 终端中直接安装。

## 1）AI 终端一键安装

> 下面命令可直接复制到终端执行。

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

## 2）自定义安装目录（可选）

```bash
bash <(curl -fsSL https://raw.githubusercontent.com/anjun/memory-ops-skill/master/scripts/install.sh) \
  --target codex \
  --dir ~/.my-ai/skills/memory-ops
```

## 3）这个技能做什么

- 强制记忆写入分类：`long_term` / `project_detail` / `daily_log`
- `MEMORY.md` 保持精简，过程细节下沉到 `memory/projects/*`
- 安全硬规则：禁止把 token/cookie/password/API key 值写入记忆文件
- 回归校验：`memory-lint` + 检索回归检查

## 4）包结构

- `SKILL.md`：统一入口
- `references/memory-layout.md`
- `references/write-gate.md`
- `references/regression-checklist.md`
- `references/openclaw-memory-search-fix.md`（OpenClaw 记忆检索修复说明）
- `scripts/install.sh`：跨运行时安装脚本

## 4.1）OpenClaw memory_search 修复（已内置说明）

如果初始化后检索为空，可执行：

```bash
bash scripts/setup-memory-search-local.sh
```

然后验证：

```bash
openclaw memory status --json
openclaw memory search --query "飞书 发图片"
```

## 5）兼容性说明

- **OpenClaw**：原生兼容
- **Codex / Claude Code / OpenCode**：同一套方法论和文件结构可直接复用；默认安装到各自常见技能目录。如你的环境目录不同，使用 `--dir` 指定。

## 6）本地测试

```bash
git clone https://github.com/anjun/memory-ops-skill.git
cd memory-ops-skill
bash scripts/install.sh --target openclaw
```

## License

MIT
