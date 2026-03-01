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

## 2.1）这个技能是否依赖 AGENTS.md？

不依赖。这个技能包按“**自包含**”设计：

- 分流/写入规则写在 `SKILL.md` + `references/write-gate.md`
- 校验逻辑在脚本里（`memory-lint`、`regression-memory-search`）

如果工作区还有额外 AGENTS.md 约束，只是叠加，不是前提。

## 3）这个技能做什么

- 强制记忆写入分类：`long_term` / `project_detail` / `daily_log`
- `MEMORY.md` 保持精简，过程细节下沉到 `memory/projects/*`
- 安全硬规则：禁止把 token/cookie/password/API key 值写入记忆文件
- 回归校验：`memory-lint` + 检索回归检查
- 压缩总结能力对齐：3-7 条结论 + 3-10 条事件摘要 + 风险/待办输出约束
- 评估能力对齐：3-10 用例设计 + 验收信号 + 回滚意识

## 4）包结构

- `SKILL.md`：统一入口
- `references/memory-layout.md`
- `references/write-gate.md`
- `references/regression-checklist.md`
- `references/openclaw-memory-search-fix.md`（OpenClaw 记忆检索修复说明）
- `scripts/install.sh`：跨运行时安装脚本
- `scripts/setup-memory-search-local.sh`：OpenClaw memory_search 初始化/修复
- `scripts/regression-memory-search.sh`：检索回归检查
- `scripts/memory-lint.sh`：记忆质量与安全校验

## 4.1）OpenClaw memory_search 修复（已内置说明）

如果初始化后检索为空，可执行：

```bash
bash scripts/setup-memory-search-local.sh
```

支持注入自定义配置路径（多 profile / 非默认路径）：

```bash
OPENCLAW_CONFIG_PATH=~/.openclaw-prod/openclaw.json bash scripts/setup-memory-search-local.sh
# 或
bash scripts/setup-memory-search-local.sh --config ~/.openclaw-prod/openclaw.json
```

然后验证：

```bash
openclaw memory status --json
openclaw memory search --query "飞书 发图片"
```

## 5）兼容性与测试矩阵

> 重要：本项目**不承诺**对所有版本做前向/后向完全兼容；请以测试矩阵为准。

| 运行时 | 版本/范围 | 状态 | 已验证内容 |
|---|---|---|---|
| OpenClaw | `2026.2.26` | ✅ 已验证 | 安装、SKILL 解析、`memory-lint`、`regression-memory-search`、`setup-memory-search-local`（安全模式） |
| Codex CLI | 仅安装路径验证 | ⚠️ 部分验证 | `scripts/install.sh --target codex` 能正确落盘 |
| Claude Code | 仅安装路径验证 | ⚠️ 部分验证 | `scripts/install.sh --target claude` 能正确落盘 |
| OpenCode | 仅安装路径验证 | ⚠️ 部分验证 | `scripts/install.sh --target opencode` 能正确落盘 |

### 说明

- 除 OpenClaw 外，当前是“**安装层面已验证**”，不是“端到端行为已验证”。
- 如果要在 Codex / Claude Code / OpenCode 上生产使用，请先在对应运行时做验收测试。

## 6）安装后怎么用

### OpenClaw（推荐）

1. 先安装到 OpenClaw skills 目录：

```bash
bash <(curl -fsSL https://raw.githubusercontent.com/anjun/memory-ops-skill/master/scripts/install.sh) --target openclaw
```

2. 在聊天里直接用（按意图自动触发），例如：

- “把这条记成长期规则：...”
- “把这段排障细节下沉到项目记忆”
- “把今天压缩成 3-7 条结论 + 3-10 条事件”
- “跑一下记忆质量检查”

3. 可选手工校验：

```bash
bash ~/.openclaw/workspace/skills/memory-ops/scripts/memory-lint.sh
bash ~/.openclaw/workspace/skills/memory-ops/scripts/regression-memory-search.sh
```

### Codex / Claude Code / OpenCode

- 用 `--target codex|claude|opencode` 安装
- 当前在这些运行时是“**安装层面已验证**”
- 触发行为取决于各运行时自己的技能加载机制

## 7）本地测试

```bash
git clone https://github.com/anjun/memory-ops-skill.git
cd memory-ops-skill
bash scripts/install.sh --target openclaw
```

## License

MIT
