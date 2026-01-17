# 版本发布检查清单

在发布新版本之前，请确保完成以下所有检查项。

## 📋 发布前检查

### 代码质量
- [ ] 所有测试通过 (`flutter test`)
- [ ] 代码分析无错误 (`flutter analyze`)
- [ ] 代码格式化完成 (`flutter format .`)
- [ ] 无未提交的更改 (`git status`)

### 版本信息
- [ ] 更新 `pubspec.yaml` 中的版本号
- [ ] 更新 `CHANGELOG.md` 添加新版本说明
- [ ] 检查版本号遵循语义化版本规范

### 文档更新
- [ ] 更新 README.md（如有新功能）
- [ ] 更新 API 文档（如有接口变更）
- [ ] 检查所有文档链接有效

### 功能测试
- [ ] 在 Windows 上测试所有核心功能
- [ ] 测试桌面小组件模式
- [ ] 测试数据导入导出
- [ ] 测试主题切换
- [ ] 测试系统托盘功能

### 性能检查
- [ ] 内存使用正常（< 100MB）
- [ ] CPU 占用正常（空闲 < 5%）
- [ ] 启动速度正常（< 3秒）
- [ ] 无内存泄漏

## 🚀 发布流程

### 1. 准备发布
```bash
# 确保在 main 分支
git checkout main
git pull origin main

# 运行测试
flutter test
flutter analyze
```

### 2. 更新版本
```bash
# 使用脚本（推荐）
.\scripts\release.ps1 -Version "0.1.0"

# 或手动更新
# 1. 编辑 pubspec.yaml
# 2. 编辑 CHANGELOG.md
# 3. git commit -m "chore: bump version to v0.1.0"
# 4. git tag -a v0.1.0 -m "Release v0.1.0"
```

### 3. 推送发布
```bash
git push origin main
git push origin v0.1.0
```

### 4. 等待构建
- 访问 GitHub Actions 页面
- 等待构建完成（约 5-10 分钟）
- 检查构建日志无错误

### 5. 编辑 Release
- 访问 GitHub Releases 页面
- 编辑自动创建的 Release
- 使用 `.github/RELEASE_TEMPLATE.md` 模板
- 添加详细的更新说明
- 上传额外的文档或资源（可选）

### 6. 发布后验证
- [ ] 下载发布的 ZIP 文件
- [ ] 解压并测试运行
- [ ] 验证所有功能正常
- [ ] 检查版本号显示正确

## 📝 版本号规范

### 语义化版本 (SemVer)

格式: `主版本号.次版本号.修订号+构建号`

- **主版本号**: 不兼容的 API 修改
- **次版本号**: 向下兼容的功能性新增
- **修订号**: 向下兼容的问题修正
- **构建号**: 构建次数（可选）

### 示例

- `0.1.0+1` - 第一个测试版本
- `0.1.1+2` - 修复 bug
- `0.2.0+1` - 添加新功能
- `1.0.0+1` - 正式发布

### 预发布版本

- `0.1.0-alpha.1` - Alpha 测试版
- `0.1.0-beta.1` - Beta 测试版
- `0.1.0-rc.1` - Release Candidate

## ⚠️ 常见问题

### 构建失败
1. 检查 Actions 日志
2. 本地测试构建: `flutter build windows --release`
3. 检查依赖版本兼容性

### Tag 已存在
```bash
# 删除本地 tag
git tag -d v0.1.0

# 删除远程 tag
git push origin :refs/tags/v0.1.0

# 重新创建
git tag -a v0.1.0 -m "Release v0.1.0"
git push origin v0.1.0
```

### Release 未自动创建
1. 确保 tag 以 `v` 开头
2. 检查 GitHub Actions 权限
3. 手动创建 Release

## 🔄 回滚版本

如果发现严重问题需要回滚：

```bash
# 1. 删除 tag
git tag -d v0.1.0
git push origin :refs/tags/v0.1.0

# 2. 在 GitHub 删除 Release

# 3. 修复问题后重新发布
```

## 📞 联系方式

如有问题，请：
- 提交 Issue
- 查看文档
- 联系维护者
