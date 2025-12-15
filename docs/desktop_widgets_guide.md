# 桌面小组件功能指南

## 概述

智慧课程表现在支持桌面小组件模式，将每个功能卡片作为独立的桌面组件显示。这种模式提供了更灵活的桌面体验，用户可以自由安排小组件的位置，同时保持与其他应用程序的良好兼容性。

## 主要特性

### 🖥️ 透明背景
- 应用窗口具有完全透明的背景
- 不会遮挡桌面壁纸或其他应用程序
- 只有小组件卡片本身可见

### 🎯 桌面层级
- 窗口置于桌面层级，不会覆盖其他应用程序
- 使用 `window_manager` 实现窗口透明和层级控制
- 支持用户交互，非指针穿透

### 📱 独立小组件
应用包含以下8个独立小组件：

1. **时间显示** - 实时时钟和秒数显示
2. **日期显示** - 当前日期、星期和年份
3. **周次显示** - 学期周次信息（单周/双周）
4. **天气信息** - 实时天气数据（小米天气API）
5. **当前课程** - 正在进行的课程信息和进度
6. **倒计时事件** - 重要事件倒计时
7. **课程表** - 今日完整课程安排
8. **设置按钮** - 快速访问应用设置

### 🔧 可拖拽布局
- 点击编辑按钮进入编辑模式
- 拖拽任意小组件到新位置
- 实时预览拖拽效果
- 自动保存位置到本地存储

### ⚙️ 灵活配置
- 单独控制每个小组件的显示/隐藏
- 查看小组件位置和尺寸信息
- 一键重置到默认布局
- 位置验证和边界检查

## 技术实现

### 窗口管理
```dart
// 使用 window_manager 实现透明窗口
WindowOptions windowOptions = const WindowOptions(
  size: Size(1200, 800),
  center: true,
  backgroundColor: Colors.transparent,
  skipTaskbar: false,
  titleBarStyle: TitleBarStyle.hidden,
  windowButtonVisibility: false,
);

await windowManager.setAsFrameless();
await windowManager.setBackgroundColor(Colors.transparent);
await windowManager.setHasShadow(false);
await windowManager.setAlwaysOnBottom(true);
```

### 小组件位置管理
```dart
// 小组件位置数据结构
class WidgetPosition {
  final WidgetType type;
  final double x, y, width, height;
  final bool isVisible;
}

// 位置持久化
static Future<void> saveWidgetPositions(Map<WidgetType, WidgetPosition> positions);
static Future<Map<WidgetType, WidgetPosition>> loadWidgetPositions();
```

### 拖拽交互
```dart
// 可拖拽小组件实现
Draggable<WidgetType>(
  data: type,
  feedback: // 拖拽时的视觉反馈
  childWhenDragging: // 拖拽时原位置的占位符
  onDragEnd: (details) => _updateWidgetPosition(type, details.offset),
  child: // 实际的小组件内容
)
```

## 使用指南

### 启动应用
1. 运行应用后，将以桌面小组件模式启动
2. 所有小组件按默认布局显示在桌面上
3. 应用窗口具有透明背景，不会遮挡其他内容

### 编辑布局
1. 点击右上角的编辑按钮（铅笔图标）
2. 进入编辑模式，小组件周围显示边框
3. 拖拽任意小组件到新位置
4. 点击完成按钮（勾选图标）保存布局

### 管理小组件
1. 点击设置按钮进入设置页面
2. 选择"桌面小组件" → "小组件配置"
3. 使用开关控制小组件的显示/隐藏
4. 查看每个小组件的位置和尺寸信息
5. 点击"重置位置"恢复默认布局

### 系统托盘集成
- 应用最小化到系统托盘
- 右键托盘图标访问菜单：
  - 设置 - 打开设置页面
  - 课表编辑 - 打开课表编辑
  - 显示/隐藏 - 切换窗口可见性
  - 退出 - 完全退出应用

## 配置文件

小组件位置信息保存在本地存储中：
- 键名：`desktop_widget_positions`
- 格式：JSON
- 包含每个小组件的类型、位置、尺寸和可见性

## 兼容性

### 支持的平台
- Windows 10/11
- 需要 Flutter 3.10.0+
- 需要 Dart 3.0.0+

### 依赖项
- `window_manager: ^0.3.7` - 窗口管理
- `bitsdojo_window: ^0.1.6` - 窗口控制
- `shared_preferences: ^2.2.2` - 本地存储
- `system_tray: ^2.0.3` - 系统托盘

## 故障排除

### 窗口不透明
- 确保 `window_manager` 依赖正确安装
- 检查系统是否支持窗口透明效果
- 重启应用程序

### 小组件位置丢失
- 检查本地存储权限
- 尝试重置位置到默认值
- 清除应用数据后重新配置

### 拖拽不响应
- 确保处于编辑模式
- 检查小组件是否可见
- 重启应用程序

## 开发说明

### 添加新小组件
1. 在 `WidgetType` 枚举中添加新类型
2. 在 `getDefaultPositions()` 中定义默认位置
3. 在 `DesktopWidgetScreen` 中添加小组件实例
4. 在配置屏幕中添加名称和图标映射

### 自定义小组件样式
- 所有小组件使用 Material Design 3 样式
- 支持浅色/深色主题自动切换
- 使用 `MD3CardStyles` 保持一致的卡片样式

### 测试
```bash
# 运行桌面小组件服务测试
flutter test test/services/desktop_widget_service_test.dart

# 运行所有测试
flutter test
```

## 更新日志

### v1.0.0
- ✅ 实现桌面小组件模式
- ✅ 透明窗口和桌面层级
- ✅ 可拖拽布局编辑
- ✅ 小组件显示/隐藏控制
- ✅ 位置持久化存储
- ✅ 系统托盘集成
- ✅ 中文本地化
- ✅ 小米天气API集成