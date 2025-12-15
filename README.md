# 智慧课程表 (Time Widgets)

一款基于 Flutter 的智能课程表桌面应用，为学生提供课程管理、天气信息、倒计时等功能。

## ✨ 功能特性

- 📅 **课程表管理** - 创建、编辑和管理每日课程安排
- ⏰ **时间显示** - 实时显示当前时间和日期
- 🌤️ **天气信息** - 显示当前天气状况和温度（小米天气API）
- ⏳ **倒计时管理** - 支持多个倒计时事件（考试、截止日期等）
- 📊 **周次显示** - 显示当前周次和单双周信息
- 🔄 **数据导入导出** - 支持 JSON 格式导入导出，兼容 ClassIsland
- 🎨 **Material Design 3** - 现代化 UI 设计，支持浅色/深色主题
- 💾 **本地存储** - 数据自动保存到本地
- 🖥️ **桌面小组件模式** - 每个卡片作为独立的桌面组件，透明背景，可拖拽调整位置
- 🌐 **中文本地化** - 完整的中文界面和错误提示
- 🔧 **系统托盘集成** - 最小化到系统托盘，支持右键菜单操作

## 📸 截图

*应用界面截图*

## 🚀 快速开始

### 环境要求

- Flutter SDK >= 3.10.0
- Dart SDK >= 3.0.0
- Windows 10/11 (桌面应用)

### 安装步骤

1. **克隆仓库**
   ```bash
   git clone https://github.com/your-username/time_widgets.git
   cd time_widgets
   ```

2. **安装依赖**
   ```bash
   flutter pub get
   ```

3. **运行应用**
   ```bash
   flutter run -d windows
   ```

### 构建发布版本

```bash
flutter build windows --release
```

构建产物位于 `build/windows/runner/Release/` 目录。

## 📖 使用指南

### 桌面小组件模式

应用以桌面小组件模式运行，每个功能卡片作为独立的桌面组件：

**小组件包括：**
- 时间显示 - 实时时钟和秒数
- 日期显示 - 当前日期和星期
- 周次显示 - 学期周次信息
- 天气信息 - 实时天气数据（温度、湿度、风速、气压）
- 当前课程 - 正在进行的课程信息
- 倒计时事件 - 重要事件倒计时
- 课程表 - 今日课程安排
- 设置按钮 - 快速访问设置

**特性：**
- 透明背景，不遮挡其他应用
- 可拖拽调整位置（编辑模式）
- 可单独显示/隐藏每个小组件
- 位置自动保存
- 支持用户交互（非指针穿透）

### 课程表编辑

1. 点击设置图标进入设置页面
2. 在课程表编辑界面可以：
   - 添加/编辑/删除课程
   - 设置时间段
   - 配置每日课程安排
   - 设置单双周课程

### 倒计时管理

1. 在主界面点击倒计时卡片的"查看全部"
2. 可以添加、编辑、删除倒计时事件
3. 支持的事件类型：考试、截止日期、事件、任务

### 数据导入导出

**导出课表数据：**
1. 进入课程表编辑界面
2. 点击菜单 → 导出课表
3. 选择保存位置

**导入课表数据：**
1. 进入课程表编辑界面
2. 点击菜单 → 导入课表
3. 选择 JSON 文件

**从 ClassIsland 导入：**
1. 进入课程表编辑界面
2. 点击菜单 → 从 ClassIsland 导入
3. 选择 ClassIsland 导出的 JSON 文件

### 桌面小组件配置

**编辑布局：**
1. 点击右上角的编辑按钮进入编辑模式
2. 拖拽任意小组件到新位置
3. 点击完成按钮保存布局

**管理小组件：**
1. 进入设置页面
2. 点击"桌面小组件" → "小组件配置"
3. 可以显示/隐藏任意小组件
4. 查看每个小组件的位置和尺寸信息
5. 点击"重置位置"恢复默认布局

### 设置

在设置页面可以配置：
- **桌面小组件**
  - 小组件配置 - 管理显示和位置
- **主题设置**
  - 主题模式（跟随系统/浅色/深色）
  - 种子颜色自定义（Material You 动态取色）
  - 动态颜色开关
- 语言（中文/English）
- 学期开始日期（用于计算周次）
- 通知开关
- 数据刷新间隔

### 主题自定义

应用支持 Material Design 3 的动态颜色系统（Material You）：

**更改种子颜色：**
1. 进入设置页面
2. 在"主题设置"部分找到"种子颜色"
3. 点击颜色选择器，从 18 种预设颜色中选择
4. 或点击"自定义颜色"选择任意颜色
5. 应用会实时预览新的配色方案

**主题模式选项：**
- **跟随系统**：根据系统设置自动切换浅色/深色主题
- **浅色模式**：始终使用浅色主题
- **深色模式**：始终使用深色主题

**动态颜色功能：**
- 开启后，应用会根据种子颜色生成完整的配色方案
- 关闭后，使用系统默认颜色
- 所有 UI 组件都会自动适配新的配色方案

## 🏗️ 项目结构

```
lib/
├── main.dart              # 应用入口
├── models/                # 数据模型
│   ├── course_model.dart
│   ├── countdown_model.dart
│   ├── settings_model.dart
│   ├── timetable_edit_model.dart
│   └── weather_model.dart
├── screens/               # 页面
│   ├── home_screen.dart
│   ├── settings_screen.dart
│   ├── countdown_list_screen.dart
│   └── timetable_edit_screen.dart
├── services/              # 服务层
│   ├── api_service.dart
│   ├── cache_service.dart
│   ├── settings_service.dart
│   ├── countdown_storage_service.dart
│   ├── timetable_export_service.dart
│   └── week_service.dart
├── utils/                 # 工具类
│   ├── error_handler.dart
│   └── time_slot_utils.dart
└── widgets/               # 组件
    ├── countdown_widget.dart
    ├── timetable_widget.dart
    ├── weather_widget.dart
    └── ...
```

## 🧪 测试

运行所有测试：
```bash
flutter test
```

运行特定测试文件：
```bash
flutter test test/property_tests/
```

## 📝 数据格式

### 课表 JSON 格式

```json
{
  "courses": [
    {
      "id": "1",
      "name": "语文",
      "teacher": "张老师",
      "classroom": "101",
      "color": "#2196F3"
    }
  ],
  "timeSlots": [
    {
      "id": "1",
      "startTime": "08:00",
      "endTime": "08:45",
      "name": "第一节课"
    }
  ],
  "dailyCourses": [
    {
      "id": "1",
      "dayOfWeek": 0,
      "timeSlotId": "1",
      "courseId": "1",
      "weekType": 2
    }
  ]
}
```

### 字段说明

- `dayOfWeek`: 0-6 分别表示周一到周日
- `weekType`: 0=单周, 1=双周, 2=每周

## 🤝 贡献指南

1. Fork 本仓库
2. 创建特性分支 (`git checkout -b feature/AmazingFeature`)
3. 提交更改 (`git commit -m 'Add some AmazingFeature'`)
4. 推送到分支 (`git push origin feature/AmazingFeature`)
5. 创建 Pull Request

## 📄 许可证

本项目采用 MIT 许可证 - 查看 [LICENSE](LICENSE) 文件了解详情。

## 🙏 致谢

- [Flutter](https://flutter.dev/) - UI 框架
- [Material Design 3](https://m3.material.io/) - 设计规范
- [ClassIsland](https://github.com/ClassIsland/ClassIsland) - 数据格式兼容
