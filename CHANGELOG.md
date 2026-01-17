# 更新日志

所有重要的项目变更都会记录在此文件中。

格式基于 [Keep a Changelog](https://keepachangelog.com/zh-CN/1.0.0/)，
版本号遵循 [语义化版本](https://semver.org/lang/zh-CN/)。

## [未发布]

### 计划中
- 添加 Linux 和 macOS 支持
- 云同步功能
- 更多天气数据源
- 课程提醒通知

## [0.1.0] - 2025-01-17

### 新增
- ✨ 课程表管理功能
- ✨ 实时时间和日期显示
- ✨ 天气信息显示（Open-Meteo API）
- ✨ 倒计时管理
- ✨ 周次显示和单双周支持
- ✨ JSON 格式数据导入导出
- ✨ ClassIsland 格式兼容
- ✨ Material Design 3 主题
- ✨ 浅色/深色主题切换
- ✨ 桌面小组件模式
- ✨ 透明背景和可拖拽布局
- ✨ 系统托盘集成
- ✨ 完整中文本地化
- ✨ 本地数据存储

### 优化
- ⚡ 内存使用优化（~80-90MB）
- ⚡ CPU 占用优化（空闲时 3-5%）
- ⚡ 渲染性能优化
- ⚡ 启动速度优化

### 修复
- 🐛 修复文本截断问题
- 🐛 修复小组件位置保存
- 🐛 修复天气组件布局
- 🐛 修复内存泄漏
- 🐛 修复编码错误

### 技术栈
- Flutter 3.24.0
- Dart 3.0+
- Material Design 3
- Windows 桌面支持

---

## 版本号说明

- **0.1.x** - 早期测试版本（Alpha/Beta）
  - 核心功能实现
  - 已知问题修复
  - 性能优化

- **0.2.x** - 功能增强版本
  - 新功能添加
  - 用户体验改进
  - 稳定性提升

- **0.9.x** - 预发布版本（RC）
  - 功能冻结
  - 最终测试
  - 文档完善

- **1.0.0** - 正式稳定版本
  - 所有核心功能完整
  - 经过充分测试
  - 生产环境可用

---

## 贡献指南

如果你想为项目做出贡献，请：

1. Fork 本仓库
2. 创建特性分支 (`git checkout -b feature/AmazingFeature`)
3. 提交更改 (`git commit -m 'Add some AmazingFeature'`)
4. 推送到分支 (`git push origin feature/AmazingFeature`)
5. 开启 Pull Request

---

[未发布]: https://github.com/your-username/time_widgets/compare/v0.1.0...HEAD
[0.1.0]: https://github.com/your-username/time_widgets/releases/tag/v0.1.0
