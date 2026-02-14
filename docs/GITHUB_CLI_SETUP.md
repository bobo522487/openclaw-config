# GitHub CLI 持久化安装指南 - Docker 环境

## 📦 安装状态

✅ GitHub CLI 已安装到：`/home/node/.local/bin/gh`
- 版本：v2.50.0
- 持久化目录：`/home/node/.openclaw/`

## 🚀 使用方法

### 方式 1：直接调用

```bash
/home/node/.local/bin/gh --version
```

### 方式 2：添加到临时 PATH

```bash
export PATH="/home/node/.local/bin:$PATH"
gh --version
```

### 方式 3：运行启动脚本

```bash
/home/node/.openclaw/setup-gh.sh
```

## 🔑 认证设置

### 选项 A：交互式登录（适合首次设置）

```bash
export PATH="/home/node/.local/bin:$PATH"
gh auth login
```

按提示选择：
1. GitHub.com
2. HTTPS
3. Login with a web browser（推荐）或 paste token

### 选项 B：使用 Token（推荐用于自动化）

1. 在 GitHub 创建 Personal Access Token (classic)
   - Settings → Developer settings → Personal access tokens → Tokens (classic)
   - 勾选所需权限：`repo`, `workflow`, `read:org`

2. 设置环境变量

**方式 1 - 临时（当前会话）：**
```bash
export GH_TOKEN="your_token_here"
```

**方式 2 - 持久化（容器重启后有效）：**
在 Docker 启动命令中添加：
```bash
docker run ... -e GH_TOKEN="your_token_here" ...
```

## 🐳 Docker 配置优化

### 修改 Docker 启动命令

```bash
docker run -d \
  --name openclaw \
  -v /path/to/openclaw:/home/node/.openclaw \
  -e PATH="/home/node/.local/bin:$PATH" \
  -e GH_TOKEN="your_token_here" \
  ...其他参数...
  your-openclaw-image
```

### 使用 Docker Compose

```yaml
services:
  openclaw:
    image: your-openclaw-image
    volumes:
      - ./openclaw:/home/node/.openclaw
    environment:
      - PATH=/home/node/.local/bin:$$PATH
      - GH_TOKEN=${GH_TOKEN}
    restart: unless-stopped
```

## 📝 使用示例

### 推送配置到 GitHub

```bash
export PATH="/home/node/.local/bin:$PATH"

# 创建新仓库
gh repo create openclaw-config --private --description "OpenClaw configuration backup"

# 添加远程仓库
cd /home/node/.openclaw
git remote add origin git@github.com:yourusername/openclaw-config.git

# 推送代码
git push -u origin master
```

### 备份当前配置

```bash
export PATH="/home/node/.local/bin:$PATH"

cd /home/node/.openclaw
git add openclaw.json
git commit -m "Backup config - $(date -u +%Y-%m-%d)"
git push
```

## 🔍 故障排除

### gh 命令找不到

```bash
export PATH="/home/node/.local/bin:$PATH"
```

### 认证失败

```bash
gh auth logout
gh auth login
```

### 检查认证状态

```bash
export PATH="/home/node/.local/bin:$PATH"
gh auth status
```

## 📚 参考资料

- GitHub CLI 官方文档：https://cli.github.com/
- 创建 Personal Access Token：https://github.com/settings/tokens
- OpenClaw 文档：https://docs.openclaw.ai
