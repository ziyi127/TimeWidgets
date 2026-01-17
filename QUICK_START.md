# 快速开始 - 上传到 GitHub

## 📝 前提条件

1. 已安装 Git
2. 拥有 GitHub 账号
3. 已在 GitHub 创建新仓库（或准备创建）

## 🚀 三步上传到 GitHub

### 步骤 1: 初始化仓库

在 GitHub 上创建新仓库后，复制仓库地址，然后运行：

```powershell
.\scripts\init-github.ps1 -RepoUrl "https://github.com/你的用户名/time_widgets.git"
```

或手动操作：

```bash
git init
git remote add origin https://github.com/你的用户名/time_widgets.git
git add .
git commit -m "Initial commit"
git branch -M main
git push -u origin main
```

### 步骤 2: 推送代码

每次修改代码后：

```powershell
.\scripts\push-to-github.ps1 -Message "你的提交信息"
```

或手动操作：

```bash
git add .
git commit -m "你的提交信息"
git push origin main
```

### 步骤 3: 创建发布版本

准备发布新版本时：

```powershell
.\scripts\release.ps1 -Version "1.0.0"
```

这会自动：
- ✅ 更新版本号
- ✅ 创建 Git tag
- ✅ 推送到 GitHub
- ✅ 触发自动构建
- ✅ 创建 Release

## 🤖 自动化构建

推送 tag 后，GitHub Actions 会自动：

1. ⚙️ 编译 Windows 版本
2. 📦 打包为 ZIP 文件
3. 🚀 创建 GitHub Release
4. 📤 上传构建产物

查看构建进度：访问你的 GitHub 仓库 → Actions 页面

## 📋 常用命令

```powershell
# 查看当前状态
git status

# 查看提交历史
git log --oneline

# 查看所有 tag
git tag

# 查看远程仓库
git remote -v

# 拉取最新代码
git pull origin main
```

## 🔗 下一步

- 📖 阅读完整文档: [docs/github_workflow_guide.md](docs/github_workflow_guide.md)
- 🐛 遇到问题: 查看故障排除部分
- 💡 自定义工作流: 编辑 `.github/workflows/*.yml`

## ⚡ 快速参考

| 操作 | 命令 |
|------|------|
| 初始化仓库 | `.\scripts\init-github.ps1 -RepoUrl "仓库地址"` |
| 推送代码 | `.\scripts\push-to-github.ps1 -Message "信息"` |
| 创建版本 | `.\scripts\release.ps1 -Version "1.0.0"` |
| 查看状态 | `git status` |
| 查看日志 | `git log --oneline` |

---

**提示**: 首次推送可能需要输入 GitHub 用户名和密码（或 Personal Access Token）
