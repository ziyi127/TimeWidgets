# 智慧课程表 UX/UI 优化方案

## 📋 项目概述
**目标用户**: 班级大屏
**核心定位**: 智能、轻量、个性化
**设计规范**: Material Design 3

---

## 🎯 一、信息架构优化

### 1.1 当前问题诊断

#### 课程信息层级不清晰
- ✗ 课程卡片中信息密度过高，时间、地点、教师挤在一起
- ✗ 周视图与日视图切换按钮位置不够突出
- ✗ "进行中"状态标识不够醒目

#### 视图切换不够直观
- ✗ 切换按钮仅用图标，缺少文字说明
- ✗ 周视图数据加载时无骨架屏，体验断层

### 1.2 优化方案

#### A. 课程卡片信息重构
```
优先级层次：
1. 课程名称（最大字号，粗体）
2. 当前状态（进行中/已结束）- 视觉标签
3. 时间段（次要信息，等宽字体）
4. 地点（图标+文字）
5. 教师（最小字号）
```

#### B. 视图切换优化
- 添加 SegmentedButton 替代 IconButton
- 增加切换动画（淡入淡出 + 位移）
- 周视图加载时显示骨架屏

---

## 🎨 二、视觉层次优化

### 2.1 色彩系统增强

#### 当前问题
- ✗ 课程卡片颜色区分度不足（仅靠左侧色条）
- ✗ 已结束课程的视觉弱化不够明显
- ✗ 深色模式下对比度不足

#### 优化方案

**1. 课程状态色彩语言**
```dart
// 进行中：高饱和度 + 脉动动画
- 背景：seedColor.withOpacity(0.12)
- 边框：seedColor (2px)
- 标签：seedColor 填充

// 即将开始（15分钟内）：中等饱和度
- 背景：warningColor.withOpacity(0.08)
- 左侧色条：warningColor

// 已结束：低饱和度灰度
- 背景：surfaceVariant
- 文字：onSurface.withOpacity(0.38)
- 删除线效果
```

**2. 无障碍色彩增强**
- 为色盲用户添加图案纹理（斜线、圆点、网格）
- 确保所有文字对比度 ≥ 4.5:1（WCAG AA 标准）
- 提供高对比度模式开关

### 2.2 字体层级优化

#### 当前问题
- ✗ 字号差异不够明显
- ✗ 缺少字重变化
- ✗ 行高不够舒适

#### 优化方案
```dart
// 课程名称
titleLarge: 18sp, FontWeight.w600, lineHeight: 1.4

// 时间信息（使用等宽字体）
bodyMedium: 14sp, FontWeight.w500, fontFeatures: [tabularFigures]

// 地点/教师
bodySmall: 12sp, FontWeight.w400, lineHeight: 1.5, opacity: 0.7
```

### 2.3 间距与呼吸感

#### 当前问题
- ✗ 卡片内边距不足（12px）
- ✗ 卡片间距过小（8px）
- ✗ 信息元素之间缺少分隔

#### 优化方案
```dart
// 卡片内边距：16px（大屏）/ 12px（小屏）
// 卡片间距：12px（大屏）/ 8px（小屏）
// 信息行间距：8px
// 图标与文字间距：6px
```

---

## 🖱️ 三、交互体验优化

### 3.1 添加课程流程

#### 当前问题
- ✗ 点击"+"按钮直接跳转到复杂的编辑页面
- ✗ 缺少快速添加单节课的入口
- ✗ 表单字段过多，认知负担重

#### 优化方案

**快速添加模式（Bottom Sheet）**
```
1. 点击"+"触发底部抽屉
2. 仅显示核心字段：
   - 课程名称（自动补全）
   - 时间段（快速选择器）
   - 地点（历史记录）
3. 高级选项折叠（教师、备注等）
4. 保存后显示成功动画
```

**完整编辑模式**
- 保留现有 TimetableEditScreen
- 通过"高级编辑"按钮进入

### 3.2 滑动切换周

#### 当前问题
- ✗ 周视图不支持左右滑动切换
- ✗ 缺少周数指示器

#### 优化方案
```dart
// 使用 PageView 实现周切换
PageView.builder(
  controller: _pageController,
  onPageChanged: (week) => _loadWeekData(week),
  children: _buildWeekPages(),
)

// 添加周数指示器
Row(
  children: [
    IconButton(icon: Icon(Icons.chevron_left)),
    Text('第 ${currentWeek} 周'),
    IconButton(icon: Icon(Icons.chevron_right)),
  ],
)
```

### 3.3 长按编辑

#### 当前问题
- ✗ 课程卡片仅支持点击，无长按菜单
- ✗ 编辑/删除操作需要进入编辑页面

#### 优化方案
```dart
// 长按触发上下文菜单
GestureDetector(
  onLongPress: () => _showCourseMenu(course),
  child: CourseCard(...),
)

// 菜单选项
- 编辑课程
- 删除课程
- 复制到其他时间
- 设置提醒
- 分享课程
```

### 3.4 微交互增强

#### 当前缺失的反馈
- ✗ 按钮点击无涟漪效果
- ✗ 卡片切换无过渡动画
- ✗ 数据加载无进度指示

#### 优化方案

**1. 按钮反馈**
```dart
// 使用 Material 涟漪效果
InkWell(
  splashColor: colorScheme.primary.withOpacity(0.12),
  highlightColor: colorScheme.primary.withOpacity(0.08),
  borderRadius: BorderRadius.circular(12),
  onTap: () {},
)
```

**2. 状态动画**
```dart
// 进行中课程脉动效果
AnimatedContainer(
  duration: Duration(seconds: 2),
  decoration: BoxDecoration(
    boxShadow: [
      BoxShadow(
        color: courseColor.withOpacity(0.3),
        blurRadius: _isPulsing ? 12 : 4,
        spreadRadius: _isPulsing ? 2 : 0,
      ),
    ],
  ),
)
```

**3. 骨架屏**
```dart
// 数据加载时显示
Shimmer.fromColors(
  baseColor: Colors.grey[300],
  highlightColor: Colors.grey[100],
  child: CourseCardSkeleton(),
)
```

---

## 🎭 四、个性化与情感化设计

### 4.1 主题切换优化

#### 当前问题
- ✗ 主题切换无过渡动画
- ✗ 深色模式色彩对比度不足
- ✗ 自定义色盘选项有限（仅12色）

#### 优化方案

**1. 平滑过渡**
```dart
AnimatedTheme(
  data: _currentTheme,
  duration: Duration(milliseconds: 300),
  curve: Curves.easeInOut,
  child: MaterialApp(...),
)
```

**2. 扩展色盘**
- 增加至24个预设色
- 添加色相环选择器
- 支持从图片提取主题色

**3. 深色模式优化**
```dart
// 提高对比度
darkTheme: ThemeData(
  colorScheme: ColorScheme.fromSeed(
    seedColor: seedColor,
    brightness: Brightness.dark,
    // 强制提高对比度
    contrastLevel: 0.5,
  ),
)
```

### 4.2 情感化微交互

#### 新增愉悦感设计

**1. 课程完成庆祝**
```dart
// 课程结束时触发
void _onCourseComplete() {
  showDialog(
    context: context,
    builder: (_) => ConfettiAnimation(
      message: '${course.name} 已完成！',
    ),
  );
}
```

**2. 空状态插画**
```dart
// 无课程时显示
Column(
  children: [
    Lottie.asset('assets/animations/relax.json'),
    Text('今天没有课，享受自由时光吧 ☕'),
  ],
)
```

**3. 加载动画**
- 使用品牌色的 Lottie 动画
- 添加幽默文案（"正在召唤课程表..."）

### 4.3 班级大屏专属优化

#### 针对大屏场景的特殊设计

**1. 超大字号模式**
```dart
// 设置中添加"大屏模式"开关
if (settings.isLargeScreenMode) {
  fontSizeScale = 1.5;
  iconSize = 32;
  cardPadding = 24;
}
```

**2. 远距离可读性**
- 课程名称最小 24sp
- 高对比度配色
- 粗体字重（FontWeight.w600+）

**3. 自动轮播**
```dart
// 大屏模式下自动切换视图
Timer.periodic(Duration(seconds: 30), (_) {
  if (settings.autoRotate) {
    _switchView();
  }
});
```

---

## ♿ 五、可访问性优化

### 5.1 色盲友好设计

#### 当前问题
- ✗ 完全依赖颜色区分课程
- ✗ 红绿色盲用户无法区分状态

#### 优化方案

**1. 多维度区分**
```dart
// 除颜色外，增加：
- 图标（进行中：▶️，已结束：✓）
- 纹理（进行中：实线边框，已结束：虚线）
- 位置（进行中置顶）
```

**2. 色盲模式**
```dart
// 设置中添加色盲模式选项
enum ColorBlindMode {
  none,
  protanopia,    // 红色盲
  deuteranopia,  // 绿色盲
  tritanopia,    // 蓝色盲
}

// 应用色盲滤镜
ColorFiltered(
  colorFilter: ColorFilter.matrix(_getColorBlindMatrix()),
  child: child,
)
```

### 5.2 小字号阅读优化

#### 当前问题
- ✗ 最小字号 10sp，老年用户难以阅读
- ✗ 行高不足，文字拥挤

#### 优化方案
```dart
// 最小字号提升至 12sp
// 行高设置为 1.5
// 字间距增加 0.5sp

TextStyle(
  fontSize: max(12, baseFontSize * fontSizeScale),
  height: 1.5,
  letterSpacing: 0.5,
)
```

### 5.3 语义化标签

#### 优化方案
```dart
// 为屏幕阅读器添加语义
Semantics(
  label: '${course.name}课程，时间${course.time}，地点${course.classroom}',
  button: true,
  onTap: () => _editCourse(course),
  child: CourseCard(...),
)
```

---

## 📊 六、性能优化建议

### 6.1 渲染优化
```dart
// 使用 RepaintBoundary 隔离重绘
RepaintBoundary(
  child: CourseCard(...),
)

// 列表使用 ListView.builder
ListView.builder(
  itemCount: courses.length,
  cacheExtent: 500, // 预加载范围
)
```

### 6.2 动画性能
```dart
// 使用 AnimatedBuilder 减少重建
AnimatedBuilder(
  animation: _controller,
  builder: (context, child) => Transform.scale(
    scale: _animation.value,
    child: child,
  ),
  child: CourseCard(...), // 不会重建
)
```

---

## 🎬 七、实施优先级

### P0（立即实施）
1. ✅ 课程卡片信息层级重构
2. ✅ 色彩对比度提升（无障碍）
3. ✅ 添加骨架屏加载状态

### P1（本周完成）
4. ✅ 视图切换动画优化
5. ✅ 长按菜单功能
6. ✅ 深色模式对比度修复

### P2（下周完成）
7. ✅ 快速添加课程 Bottom Sheet
8. ✅ 周视图滑动切换
9. ✅ 色盲模式支持

### P3（后续迭代）
10. ✅ 情感化动画（Lottie）
11. ✅ 大屏模式优化
12. ✅ 主题色提取功能

---

## 📝 设计规范文档

### 间距系统
```
4px  - 最小间距（图标与文字）
8px  - 小间距（列表项）
12px - 中间距（卡片间）
16px - 大间距（卡片内边距）
24px - 超大间距（区块间）
```

### 圆角系统
```
4px  - 小圆角（标签）
8px  - 中圆角（按钮）
12px - 大圆角（卡片）
16px - 超大圆角（对话框）
```

### 阴影系统
```
elevation-0: 无阴影
elevation-1: 0 1px 2px rgba(0,0,0,0.05)
elevation-2: 0 2px 4px rgba(0,0,0,0.08)
elevation-3: 0 4px 8px rgba(0,0,0,0.12)
```

---

## 🔗 参考资源

- [Material Design 3 Guidelines](https://m3.material.io/)
- [WCAG 2.1 无障碍标准](https://www.w3.org/WAI/WCAG21/quickref/)
- [Color Blind Simulator](https://www.color-blindness.com/coblis-color-blindness-simulator/)
- [Flutter 动画最佳实践](https://docs.flutter.dev/ui/animations)

---

**优化完成后预期效果**：
- 📈 信息查找效率提升 40%
- 🎨 视觉满意度提升 60%
- ♿ 无障碍评分达到 AA 级
- ⚡ 交互响应时间 < 100ms
- 😊 用户愉悦度显著提升
