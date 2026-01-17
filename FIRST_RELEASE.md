# 🎉 首次发布指南

欢迎使用 TimeWidgets！这是将项目首次发布到 GitHub 的完整指南。

## 📦 当前版本

**v0.1.0** - 早期测试版本 (Alpha/Beta)

这是第一个公开测试版本，包含所有核心功能。

## 🚀 发布步骤

### 1️⃣ 在 GitHub 创建仓库

1. 访问 https://github.com/new
2. 仓库名称: `time_widgets`
3. 描述: `智慧课程表 - 基于 Flutter 的智能课程管理桌面应用`
4. 选择 **Public** 或 **Private**
5. **不要**勾选 "Initialize this repository with"
6. 点击 **Create repository**

### 2️⃣ 初始化并推送代码

**使用脚本（推荐）：**

```powershell
# 替换为你的仓库地址
.\scripts\init-github.ps1 -RepoUrl "https://github.com/你的用户名/time_widgets.git"
```

**手动操作：**

```bash
git init
git add .
git commit -m "Initial commit: TimeWidgets v0.1.0"
git branch -M main
git remote add origin https://github.com/你的用户名/time_widgets.git
git push -u origin main
```

### 3️⃣ 创建首个发布版本

**使用脚本（推荐）：**

```powershell
.\scripts\release.ps1 -Version "0.1.0"
```

**手动操作：**

```bash
git tag -a v0.1.0 -m "Release v0.1.0 - 首个测试版本"
git push origin v0.1.0
```

### 4️⃣ 等待自动构建

1. 访问 `https://github.com/你的用户名/time_widgets/actions`
2. 查看 "Build and Release" 工作流
3. 等待构建完成（约 5-10 分钟）
4. 构建成功后会自动创建 Release

### 5️⃣ 编辑 Release 说明

1. 访问 `https://github.com/你的用户名/time_widgets/releases`
2. 找到 `v0.1.0` Release
3. 点击 **Edit release**
4. 使用以下模板：

```markdown
## 🎉 TimeWidgets v0.1.0 - 首个测试版本

这是 TimeWidgets 的第一个公开测试版本！感谢你的关注和支持。

### ✨ 主要功能

- 📅 **课程表管理** - 创建和管理每日课程安排
- ⏰ **时间显示** - 实时显示当前时间和日期
- 🌤️ **天气信息** - 显示当前天气状况
- ⏳ **倒计时** - 管理重要事件倒计时
- 📊 **周次显示** - 显示当前周次和单双周
- 🖥️ **桌面小组件** - 透明背景，可拖拽布局
- 🎨 **Material Design 3** - 现代化 UI，支持主题切换
- 💾 **数据管理** - 本地存储，支持导入导出

### 📥 下载

- **Windows x64**: [TimeWidgets-Windows-x64.zip](下载链接)

### 💡 使用说明

1. 下载 ZIP 文件
2. 解压到任意目录
3. 运行 `time_widgets.exe`
4. 首次运行会创建默认配置

### ⚠️ 注意事项

- 这是早期测试版本，可能存在 bug
- 目前仅支持 Windows 10/11 (x64)
- 建议在测试环境中使用
- 欢迎反馈问题和建议

### 🐛 已知问题

- 仅支持 Windows 平台
- 天气数据源有限
- 部分功能待优化

### 📝 下一步计划

- v0.1.x - Bug 修复和性能优化
- v0.2.0 - 添加新功能
- v0.9.0 - 预发布版本
- v1.0.0 - 正式稳定版本

### 🙏 反馈

如果你遇到问题或有建议，请：
- 提交 [Issue](https://github.com/你的用户名/time_widgets/issues)
- 查看 [文档](https://github.com/你的用户名/time_widgets)

感谢使用 TimeWidgets！
```

5. 点击 **Update release**

## ✅ 发布完成检查清单

- [ ] GitHub 仓库已创建
- [ ] 代码已推送到 main 分支
- [ ] v0.1.0 tag 已创建
- [ ] GitHub Actions 构建成功
- [ ] Release 已创建并包含 ZIP 文件
- [ ] Release 说明已编辑完善
- [ ] README.md 中的链接已更新
- [ ] 项目可以正常下载和运行

## 📢 宣传你的项目

发布后，你可以：

1. **添加 README 徽章**
   - 构建状态
   - 版本号
   - 下载量
   - License

2. **分享到社交媒体**
   - Twitter
   - Reddit
   - 开发者社区

3. **添加到项目列表**
   - Awesome Flutter
   - Flutter Gems
   - 相关论坛

4. **撰写博客文章**
   - 介绍项目特点
   - 开发经验分享
   - 技术细节讲解

## 🔄 后续更新

每次发布新版本：

```powershell
# 1. 更新代码
git add .
git commit -m "feat: 添加新功能"
git push origin main

# 2. 创建新版本
.\scripts\release.ps1 -Version "0.1.1"

# 3. 编辑 Release 说明
# 访问 GitHub Releases 页面编辑
```

## 📚 相关文档

- [完整工作流指南](docs/github_workflow_guide.md)
- [发布检查清单](.github/RELEASE_CHECKLIST.md)
- [更新日志](CHANGELOG.md)
- [快速开始](QUICK_START.md)

## 🎊 恭喜！

你已经成功发布了 TimeWidgets 的第一个版本！

接下来：
- 收集用户反馈
- 修复发现的问题
- 规划新功能
- 准备下一个版本

祝你的项目越来越好！🚀
