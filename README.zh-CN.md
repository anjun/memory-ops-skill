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

## 6）本地测试

```bash
git clone https://github.com/anjun/memory-ops-skill.git
cd memory-ops-skill
bash scripts/install.sh --target openclaw
```

## License

MIT
