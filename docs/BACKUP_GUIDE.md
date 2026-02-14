# OpenClaw 配置备份指南

## 📦 当前备份状态

✅ **已配置并推送到 GitHub**：
- 仓库：https://github.com/bobo522487/openclaw-config
- 分支：master
- 可见性：Public

### 已备份的内容
- `openclaw.json` - 主配置文件（包含初始配置）
- `.gitignore` - 忽略规则
- `setup-gh.sh` - GitHub CLI 安装脚本
- `docs/GITHUB_CLI_SETUP.md` - CLI 使用文档

## ⚠️ 安全注意事项

### 敏感数据处理

当前 `openclaw.json` 文件包含以下敏感信息：

1. **API Keys** - 智谱 GLM API key
2. **Bot Tokens** - Telegram bot tokens
3. **User IDs** - Telegram 用户 ID
4. **Auth Tokens** - Gateway auth token

### 建议的备份策略

#### 选项 A：使用私人仓库（推荐）

```bash
# 将仓库设置为私有
gh repo edit bobo522487/openclaw-config --visibility private
```

#### 选项 B：模板化配置

创建不包含敏感信息的模板：

```bash
# 创建模板文件
cp openclaw.json openclaw.json.example

# 编辑 openclaw.json.example，移除所有敏感信息
# - API keys → 替换为 "YOUR_API_KEY_HERE"
# - Bot tokens → 替换为 "YOUR_BOT_TOKEN_HERE"
# - User IDs → 替换为 "YOUR_USER_ID_HERE"
```

#### 选项 C：环境变量分离

将敏感信息移到环境变量，并在 `.env` 文件中管理：

```bash
# 创建 .env 文件（添加到 .gitignore）
ZAI_API_KEY="your_key_here"
TELEGRAM_BOT_TOKEN="your_token_here"
```

## 🔄 备份工作流

### 日常备份配置更改

```bash
# 1. 检查更改
cd /home/node/.openclaw
git status

# 2. 查看具体更改
git diff openclaw.json

# 3. 添加更改（注意不要包含敏感信息）
git add openclaw.json

# 4. 提交
git commit -m "Update config - $(date -u +%Y-%m-%d)"

# 5. 推送到 GitHub
git push
```

### 备份 Workspace 配置

Workspace 目录包含：
- `AGENTS.md` - 代理定义
- `SOUL.md` - 助手个性
- `USER.md` - 用户信息
- `MEMORY.md` - 长期记忆
- `memory/YYYY-MM-DD.md` - 每日日志

**注意**：Workspace 目录有自己的 Git 仓库，需要单独管理：

```bash
cd /home/node/.openclaw/workspace

# 提交 workspace 更改
git add .
git commit -m "Update workspace - $(date -u +%Y-%m-%d)"

# 如果需要，可以推送到单独的仓库
# git remote add origin https://github.com/bobo522487/openclaw-workspace.git
# git push -u origin master
```

## 🚀 自动化备份建议

### 使用 Cron 定期备份

```bash
# 编辑 crontab
crontab -e

# 添加每日凌晨 3 点自动备份
0 3 * * * cd /home/node/.openclaw && git add . && git commit -m "Auto backup $(date +\%Y-\%m-\%d)" && git push
```

### 使用 OpenClaw Cron（推荐）

```bash
# 创建每日备份任务
openclaw cron add << 'EOF'
{
  "name": "Daily Config Backup",
  "schedule": {
    "kind": "cron",
    "expr": "0 3 * * *",
    "tz": "Asia/Shanghai"
  },
  "payload": {
    "kind": "systemEvent",
    "text": "[BACKUP_CONFIG] Please backup OpenClaw configuration to GitHub"
  },
  "sessionTarget": "main"
}
EOF
```

## 📋 备份检查清单

在推送配置到 GitHub 之前，确认：

- [ ] 仓库可见性设置正确（private 更安全）
- [ ] 没有硬编码的密码、API keys 或 tokens
- [ ] 或已使用环境变量管理敏感信息
- [ ] .gitignore 正确配置
- [ ] 测试了恢复流程（克隆仓库并重新配置）

## 🔐 敏感信息检查命令

```bash
# 检查是否有 API keys
grep -r "api.*key" openclaw.json | grep -v "apiKey"

# 检查是否有 tokens
grep -r "token" openclaw.json | grep -v "auth.*token"

# 检查是否有密码
grep -r "password" openclaw.json

# 检查是否有密钥文件
git ls-files | grep -E "\.(key|pem|secret)$"
```

## 📚 相关文档

- GitHub CLI 设置：[docs/GITHUB_CLI_SETUP.md](./GITHUB_CLI_SETUP.md)
- OpenClaw 文档：https://docs.openclaw.ai
- Git 最佳实践：https://git-scm.com/book/en/v2

---

**最后更新**：2026-02-14
**维护者**：bobo522487
