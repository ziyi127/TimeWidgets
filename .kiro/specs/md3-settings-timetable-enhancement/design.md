# Design Document

## Overview

本设计文档描述了完善 Flutter 课表应用设置界面和课表编辑界面的技术方案，遵循 Material Design 3 (MD3) 设计规范，并参考 ClassIsland 的课表编辑逻辑。

主要改进包括：
1. **设置界面 MD3 规范化** - 统一使用 MD3 组件样式
2. **课表编辑重构** - 采用 ClassIsland 风格的三标签结构（课表、时间表、科目）
3. **时间表编辑器** - 时间轴视图，支持拖拽调整
4. **科目管理** - 主从布局，颜色自定义
5. **课表管理** - 触发规则，网格编辑

## Architecture

```mermaid
graph TB
    subgraph UI Layer
        SS[SettingsScreen]
        TES[TimetableEditScreen]
        subgraph Timetable Tabs
            ST[ScheduleTab - 课表]
            TLT[TimeLayoutTab - 时间表]
            SJT[SubjectTab - 科目]
        end
    end
    
    subgraph Services
        TS[TimetableEditService]
        TSS[TimetableStorageService]
        CIS[ClassIslandImportService]
        THS[ThemeService]
    end
    
    subgraph Models
        TD[TimetableData]
        CI[CourseInfo/Subject]
        TSL[TimeSlot/TimeLayout]
        DC[DailyCourse/ClassPlan]
    end
    
    subgraph Utils
        MD3C[MD3CardStyles]
        MD3B[MD3ButtonStyles]
        MD3T[MD3TypographyStyles]
        MD3N[MD3NavigationStyles]
        MD3D[MD3DialogStyles - NEW]
        MD3F[MD3FormStyles - NEW]
    end
    
    TES --> ST
    TES --> TLT
    TES --> SJT
    
    ST --> TS
    TLT --> TS
    SJT --> TS
    
    TS --> TSS
    TS --> TD
    
    SS --> THS
    
    UI Layer --> Utils
```

## Components and Interfaces

### 1. MD3DialogStyles (新增工具类)

```dart
/// Material Design 3 Dialog 样式工具类
class MD3DialogStyles {
  /// 标准 MD3 对话框
  static Widget dialog({
    required BuildContext context,
    required String title,
    required Widget content,
    required List<Widget> actions,
    bool isDestructive = false,
  });
  
  /// 全屏对话框 (用于复杂编辑)
  static Widget fullScreenDialog({
    required BuildContext context,
    required String title,
    required Widget content,
    VoidCallback? onSave,
    VoidCallback? onCancel,
  });
  
  /// 确认对话框
  static Future<bool?> showConfirmDialog({
    required BuildContext context,
    required String title,
    required String message,
    String confirmText = '确定',
    String cancelText = '取消',
    bool isDestructive = false,
  });
}
```

### 2. MD3FormStyles (新增工具类)

```dart
/// Material Design 3 Form 样式工具类
class MD3FormStyles {
  /// MD3 Outlined TextField
  static Widget outlinedTextField({
    required BuildContext context,
    required TextEditingController controller,
    required String label,
    String? hint,
    String? errorText,
    Widget? prefixIcon,
    Widget? suffixIcon,
    int maxLines = 1,
    TextInputType? keyboardType,
    FormFieldValidator<String>? validator,
  });
  
  /// MD3 Filled TextField
  static Widget filledTextField({...});
  
  /// MD3 Dropdown
  static Widget dropdown<T>({
    required BuildContext context,
    required T? value,
    required List<DropdownMenuItem<T>> items,
    required ValueChanged<T?> onChanged,
    required String label,
  });
  
  /// MD3 Time Picker Button
  static Widget timePickerButton({
    required BuildContext context,
    required TimeOfDay? time,
    required ValueChanged<TimeOfDay> onChanged,
    required String label,
  });
  
  /// MD3 Color Picker Button
  static Widget colorPickerButton({
    required BuildContext context,
    required Color color,
    required ValueChanged<Color> onChanged,
    required String label,
  });
}
```

### 3. 重构后的课表编辑界面结构

```dart
/// 课表编辑主界面 - 三标签结构
class TimetableEditScreen extends StatefulWidget {
  // 标签: 课表(Schedule), 时间表(TimeLayout), 科目(Subject)
}

/// 科目编辑标签页 - 主从布局
class SubjectEditTab extends StatefulWidget {
  // 左侧: 科目列表 (可选中)
  // 右侧: 科目详情编辑面板
}

/// 时间表编辑标签页 - 时间轴视图
class TimeLayoutEditTab extends StatefulWidget {
  // 左侧: 时间表列表
  // 右侧: 时间轴编辑器 (可拖拽调整时间点)
}

/// 课表编辑标签页 - 网格视图
class ScheduleEditTab extends StatefulWidget {
  // 左侧: 课表列表 (带触发规则)
  // 右侧: 课程网格编辑器
}
```

### 4. 时间轴编辑器组件

```dart
/// 时间轴视图组件
class TimelineEditor extends StatefulWidget {
  final List<TimeSlot> timeSlots;
  final ValueChanged<List<TimeSlot>> onChanged;
  final TimeSlot? selectedSlot;
  final ValueChanged<TimeSlot?> onSelectionChanged;
}

/// 时间点类型
enum TimePointType {
  classTime,    // 上课
  breakTime,    // 课间休息
  divider,      // 分割线
}

/// 扩展的时间点模型
class TimePoint {
  final String id;
  final String name;
  final TimeOfDay startTime;
  final TimeOfDay endTime;
  final TimePointType type;
  final String? defaultSubjectId;
  final bool isHiddenByDefault;
}
```

### 5. 课程网格编辑器组件

```dart
/// 课程网格编辑器
class ScheduleGridEditor extends StatefulWidget {
  final List<TimeSlot> timeSlots;
  final List<CourseInfo> subjects;
  final List<DailyCourse> assignments;
  final ValueChanged<List<DailyCourse>> onChanged;
}

/// 网格单元格
class ScheduleGridCell extends StatelessWidget {
  final TimeSlot timeSlot;
  final CourseInfo? subject;
  final WeekType weekType;
  final VoidCallback onTap;
}
```

## Data Models

### 扩展的数据模型

```dart
/// 时间点类型枚举
enum TimePointType { classTime, breakTime, divider }

/// 扩展的时间段模型 (兼容 ClassIsland TimeLayout)
class TimeSlot {
  final String id;
  final String name;
  final String startTime;  // "HH:MM"
  final String endTime;    // "HH:MM"
  final TimePointType type;  // 新增: 时间点类型
  final String? defaultSubjectId;  // 新增: 默认科目
  final bool isHiddenByDefault;  // 新增: 默认隐藏
  
  // JSON 序列化需要更新以支持新字段
}

/// 扩展的科目模型 (兼容 ClassIsland Subject)
class CourseInfo {
  final String id;
  final String name;
  final String abbreviation;  // 新增: 简称
  final String teacher;
  final String classroom;
  final String color;  // 已有
  final bool isOutdoor;  // 新增: 是否户外课
}

/// 课表触发规则
class ScheduleTriggerRule {
  final int weekDay;  // 0-6, 0=周日
  final WeekType weekType;  // 单周/双周/每周
  final bool isEnabled;
}

/// 课表模型 (兼容 ClassIsland ClassPlan)
class Schedule {
  final String id;
  final String name;
  final String timeLayoutId;  // 关联的时间表
  final ScheduleTriggerRule triggerRule;
  final List<DailyCourse> courses;
  final bool isAutoEnabled;
}
```



## UI Component Specifications

### 设置界面 MD3 规范

```dart
// 设置分组卡片
MD3CardStyles.surfaceContainer(
  context: context,
  child: Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text('分组标题', style: MD3TypographyStyles.titleMedium(context)),
      const SizedBox(height: 16),
      // ListTile 设置项...
    ],
  ),
)

// MD3 Switch 样式
SwitchListTile(
  secondary: Icon(Icons.xxx, color: colorScheme.onSurfaceVariant),
  title: Text('设置项', style: MD3TypographyStyles.bodyLarge(context)),
  subtitle: Text('描述', style: MD3TypographyStyles.bodyMedium(context)
      .copyWith(color: colorScheme.onSurfaceVariant)),
  value: value,
  onChanged: onChanged,
)

// MD3 Dropdown 样式
DropdownButtonFormField<T>(
  decoration: InputDecoration(
    labelText: '标签',
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(4),
    ),
    filled: true,
    fillColor: colorScheme.surfaceContainerHighest,
  ),
  value: value,
  items: items,
  onChanged: onChanged,
)
```

### 主从布局 (Master-Detail)

```dart
class MasterDetailLayout extends StatelessWidget {
  final Widget masterPane;   // 左侧列表
  final Widget detailPane;   // 右侧详情
  final double masterWidth;  // 左侧宽度 (默认 300)
  
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        // 左侧列表面板
        SizedBox(
          width: masterWidth,
          child: MD3CardStyles.surfaceContainer(
            context: context,
            padding: EdgeInsets.zero,
            child: masterPane,
          ),
        ),
        const VerticalDivider(width: 1),
        // 右侧详情面板
        Expanded(
          child: detailPane,
        ),
      ],
    );
  }
}
```

### 时间轴编辑器视觉规范

```dart
// 时间轴容器
Container(
  decoration: BoxDecoration(
    color: colorScheme.surfaceContainerLow,
    borderRadius: BorderRadius.circular(12),
  ),
  child: Column(
    children: [
      // 时间刻度标尺
      TimeRuler(startHour: 6, endHour: 22),
      // 时间点列表
      ...timePoints.map((tp) => TimePointWidget(
        timePoint: tp,
        isSelected: tp.id == selectedId,
        onTap: () => onSelect(tp),
        onDragStart: (details) => onDragStart(tp, details),
        onDragUpdate: (details) => onDragUpdate(tp, details),
        onDragEnd: (details) => onDragEnd(tp, details),
      )),
    ],
  ),
)

// 时间点样式
Container(
  margin: EdgeInsets.symmetric(horizontal: 8, vertical: 2),
  decoration: BoxDecoration(
    color: _getTimePointColor(type, colorScheme),
    borderRadius: BorderRadius.circular(8),
    border: isSelected ? Border.all(
      color: colorScheme.primary,
      width: 2,
    ) : null,
  ),
  child: Row(
    children: [
      // 开始时间把手
      GestureDetector(
        onHorizontalDragUpdate: onStartDrag,
        child: Container(
          width: 8,
          color: colorScheme.primary.withOpacity(0.3),
        ),
      ),
      // 时间点内容
      Expanded(
        child: Padding(
          padding: EdgeInsets.all(12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(name, style: MD3TypographyStyles.titleSmall(context)),
              Text('$startTime - $endTime', 
                   style: MD3TypographyStyles.bodySmall(context)),
            ],
          ),
        ),
      ),
      // 结束时间把手
      GestureDetector(
        onHorizontalDragUpdate: onEndDrag,
        child: Container(
          width: 8,
          color: colorScheme.primary.withOpacity(0.3),
        ),
      ),
    ],
  ),
)

Color _getTimePointColor(TimePointType type, ColorScheme colorScheme) {
  switch (type) {
    case TimePointType.classTime:
      return colorScheme.primaryContainer;
    case TimePointType.breakTime:
      return colorScheme.surfaceContainerHighest;
    case TimePointType.divider:
      return colorScheme.outlineVariant;
  }
}
```

### 课程网格编辑器视觉规范

```dart
// 网格布局
Table(
  border: TableBorder.all(
    color: colorScheme.outlineVariant,
    width: 1,
  ),
  children: [
    // 表头行 (时间段名称)
    TableRow(
      decoration: BoxDecoration(
        color: colorScheme.surfaceContainerHighest,
      ),
      children: [
        TableCell(child: Text('时间')),
        ...timeSlots.map((ts) => TableCell(
          child: Text(ts.name, textAlign: TextAlign.center),
        )),
      ],
    ),
    // 数据行 (每个时间段的课程)
    ...buildCourseRows(),
  ],
)

// 课程单元格
InkWell(
  onTap: () => showSubjectPicker(timeSlot),
  borderRadius: BorderRadius.circular(4),
  child: Container(
    padding: EdgeInsets.all(8),
    decoration: BoxDecoration(
      color: subject?.color != null 
          ? Color(int.parse(subject!.color.replaceFirst('#', '0xFF')))
          : colorScheme.surface,
      borderRadius: BorderRadius.circular(4),
    ),
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          subject?.abbreviation ?? subject?.name ?? '无课程',
          style: MD3TypographyStyles.labelMedium(context).copyWith(
            color: _getContrastColor(subject?.color),
          ),
          textAlign: TextAlign.center,
        ),
        if (weekType != WeekType.both)
          Container(
            margin: EdgeInsets.only(top: 4),
            padding: EdgeInsets.symmetric(horizontal: 4, vertical: 2),
            decoration: BoxDecoration(
              color: colorScheme.tertiaryContainer,
              borderRadius: BorderRadius.circular(4),
            ),
            child: Text(
              weekType == WeekType.single ? '单' : '双',
              style: MD3TypographyStyles.labelSmall(context),
            ),
          ),
      ],
    ),
  ),
)
```

### 对话框规范

```dart
// MD3 标准对话框
AlertDialog(
  shape: RoundedRectangleBorder(
    borderRadius: BorderRadius.circular(28),
  ),
  backgroundColor: colorScheme.surfaceContainerHigh,
  surfaceTintColor: colorScheme.surfaceTint,
  title: Text(
    '对话框标题',
    style: MD3TypographyStyles.headlineSmall(context),
  ),
  content: Padding(
    padding: EdgeInsets.symmetric(vertical: 8),
    child: content,
  ),
  actionsPadding: EdgeInsets.fromLTRB(24, 0, 24, 24),
  actions: [
    MD3ButtonStyles.text(
      onPressed: onCancel,
      child: Text('取消'),
    ),
    SizedBox(width: 8),
    MD3ButtonStyles.filled(
      onPressed: onConfirm,
      child: Text('确定'),
    ),
  ],
)

// 删除确认对话框 (危险操作)
AlertDialog(
  // ... 同上
  actions: [
    MD3ButtonStyles.text(
      onPressed: onCancel,
      child: Text('取消'),
    ),
    SizedBox(width: 8),
    FilledButton(
      onPressed: onDelete,
      style: FilledButton.styleFrom(
        backgroundColor: colorScheme.error,
        foregroundColor: colorScheme.onError,
      ),
      child: Text('删除'),
    ),
  ],
)
```



## Correctness Properties

*A property is a characteristic or behavior that should hold true across all valid executions of a system-essentially, a formal statement about what the system should do. Properties serve as the bridge between human-readable specifications and machine-verifiable correctness guarantees.*

Based on the acceptance criteria analysis, the following correctness properties have been identified:

### Property 1: Time points chronological ordering
*For any* list of time points in a time layout, when displayed in the timeline view, the time points SHALL be ordered by start time in ascending order.
**Validates: Requirements 10.1**

### Property 2: Schedule auto-activation based on trigger rules
*For any* date and set of schedules with trigger rules, the system SHALL activate the schedule whose trigger rule matches the current weekday and week type.
**Validates: Requirements 11.3**

### Property 3: Schedule priority ordering
*For any* set of schedules where multiple schedules match the current conditions, the system SHALL activate the schedule with the highest priority (lowest priority number).
**Validates: Requirements 11.4**

### Property 4: Subject deletion prevention when in use
*For any* subject that is referenced by one or more course assignments, attempting to delete that subject SHALL fail and the subject SHALL remain in the subject list.
**Validates: Requirements 12.4**

### Property 5: Color contrast for text readability
*For any* subject with a custom color, when displayed in the schedule grid, the text color SHALL provide a contrast ratio of at least 4.5:1 against the background color.
**Validates: Requirements 14.2**

### Property 6: Deterministic color generation from name
*For any* subject name, the generated color based on the name hash SHALL always produce the same color value for the same input name.
**Validates: Requirements 14.3**

### Property 7: Timetable data serialization round-trip
*For any* valid TimetableData object containing subjects, time layouts, and course assignments, serializing to JSON and then deserializing SHALL produce an equivalent TimetableData object.
**Validates: Requirements 15.1, 15.2**

### Property 8: Icon button touch target minimum size
*For any* icon button in the application, the touch target size SHALL be at least 48x48 density-independent pixels.
**Validates: Requirements 6.4**

## Error Handling

### Import/Export Errors

```dart
/// 导入错误类型
enum ImportErrorType {
  fileNotFound,
  invalidFormat,
  parseError,
  incompatibleVersion,
}

/// 导入结果
class ImportResult {
  final bool success;
  final ImportErrorType? errorType;
  final String? errorMessage;
  final int subjectsImported;
  final int timeLayoutsImported;
  final int schedulesImported;
}

/// 错误处理示例
void handleImportError(ImportResult result, BuildContext context) {
  if (!result.success) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(result.errorMessage ?? '导入失败'),
        backgroundColor: Theme.of(context).colorScheme.error,
        action: SnackBarAction(
          label: '详情',
          textColor: Theme.of(context).colorScheme.onError,
          onPressed: () => showErrorDetails(context, result),
        ),
      ),
    );
  }
}
```

### Validation Errors

```dart
/// 表单验证
String? validateSubjectName(String? value) {
  if (value == null || value.trim().isEmpty) {
    return '科目名称不能为空';
  }
  if (value.length > 50) {
    return '科目名称不能超过50个字符';
  }
  return null;
}

String? validateTimeRange(TimeOfDay start, TimeOfDay end) {
  final startMinutes = start.hour * 60 + start.minute;
  final endMinutes = end.hour * 60 + end.minute;
  if (endMinutes <= startMinutes) {
    return '结束时间必须晚于开始时间';
  }
  return null;
}
```

### Data Integrity Errors

```dart
/// 删除科目前检查引用
Future<DeleteResult> checkSubjectDeletion(String subjectId) async {
  final usages = await findSubjectUsages(subjectId);
  if (usages.isNotEmpty) {
    return DeleteResult(
      canDelete: false,
      reason: '该科目正在被 ${usages.length} 个课程安排使用',
      usages: usages,
    );
  }
  return DeleteResult(canDelete: true);
}
```

## Testing Strategy

### Dual Testing Approach

本项目采用单元测试和属性测试相结合的测试策略：

1. **单元测试** - 验证具体示例和边界情况
2. **属性测试** - 验证在所有有效输入上都应成立的通用属性

### Property-Based Testing Framework

使用 `glados` 包进行 Dart/Flutter 属性测试：

```yaml
# pubspec.yaml
dev_dependencies:
  glados: ^0.5.0
  test: ^1.24.0
```

### Test Structure

```dart
// test/property_tests/timetable_properties_test.dart

import 'package:glados/glados.dart';
import 'package:test/test.dart';

void main() {
  group('Timetable Properties', () {
    // **Feature: md3-settings-timetable-enhancement, Property 1: Time points chronological ordering**
    Glados<List<TimeSlot>>().test(
      'time points should be sorted by start time',
      (timeSlots) {
        final sorted = sortTimeSlots(timeSlots);
        for (var i = 0; i < sorted.length - 1; i++) {
          expect(
            parseTime(sorted[i].startTime).isBefore(parseTime(sorted[i + 1].startTime)) ||
            parseTime(sorted[i].startTime) == parseTime(sorted[i + 1].startTime),
            isTrue,
          );
        }
      },
    );

    // **Feature: md3-settings-timetable-enhancement, Property 6: Deterministic color generation**
    Glados<String>().test(
      'same subject name should always generate same color',
      (name) {
        final color1 = generateColorFromName(name);
        final color2 = generateColorFromName(name);
        expect(color1, equals(color2));
      },
    );

    // **Feature: md3-settings-timetable-enhancement, Property 7: Serialization round-trip**
    Glados<TimetableData>().test(
      'serialization round-trip should preserve data',
      (data) {
        final json = data.toJson();
        final restored = TimetableData.fromJson(json);
        expect(restored.courses.length, equals(data.courses.length));
        expect(restored.timeSlots.length, equals(data.timeSlots.length));
        expect(restored.dailyCourses.length, equals(data.dailyCourses.length));
      },
    );
  });
}
```

### Unit Test Examples

```dart
// test/services/timetable_edit_service_test.dart

void main() {
  group('TimetableEditService', () {
    test('should prevent deletion of subject in use', () async {
      final service = TimetableEditService();
      
      // Add a subject
      final subject = CourseInfo(id: '1', name: 'Math', teacher: 'Teacher');
      service.addCourse(subject);
      
      // Add a course assignment using this subject
      final assignment = DailyCourse(
        id: '1',
        dayOfWeek: DayOfWeek.monday,
        timeSlotId: '1',
        courseId: '1',
      );
      service.addDailyCourse(assignment);
      
      // Attempt to delete should fail or show warning
      final canDelete = service.canDeleteCourse('1');
      expect(canDelete, isFalse);
    });

    test('should auto-activate schedule matching current date', () {
      final service = TimetableEditService();
      final monday = DateTime(2024, 1, 1); // A Monday
      
      final schedule = Schedule(
        id: '1',
        name: 'Monday Schedule',
        triggerRule: ScheduleTriggerRule(
          weekDay: 1, // Monday
          weekType: WeekType.both,
          isEnabled: true,
        ),
      );
      
      final shouldActivate = service.shouldActivateSchedule(schedule, monday);
      expect(shouldActivate, isTrue);
    });
  });
}
```

### Widget Test Examples

```dart
// test/widgets/settings_screen_test.dart

void main() {
  testWidgets('Settings screen displays MD3 cards', (tester) async {
    await tester.pumpWidget(MaterialApp(
      theme: ThemeData(useMaterial3: true),
      home: const SettingsScreen(),
    ));
    
    // Verify MD3 cards are present
    expect(find.byType(Card), findsWidgets);
    
    // Verify section headers use correct typography
    expect(find.text('外观设置'), findsOneWidget);
  });

  testWidgets('Empty state shows guidance button', (tester) async {
    await tester.pumpWidget(MaterialApp(
      theme: ThemeData(useMaterial3: true),
      home: const SubjectEditTab(),
    ));
    
    // With no subjects, should show empty state
    expect(find.text('暂无科目，请添加科目'), findsOneWidget);
    expect(find.byType(FilledButton), findsOneWidget);
  });
}
```

### Test Configuration

```dart
// test/test_generators.dart

/// Custom generators for property-based testing
extension TimetableGenerators on Any {
  Generator<TimeSlot> get timeSlot => any.combine3(
    any.stringOf(any.letterOrDigit, minLength: 1, maxLength: 20),
    any.intInRange(0, 23),
    any.intInRange(0, 59),
    (name, hour, minute) => TimeSlot(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      name: name,
      startTime: '${hour.toString().padLeft(2, '0')}:${minute.toString().padLeft(2, '0')}',
      endTime: '${((hour + 1) % 24).toString().padLeft(2, '0')}:${minute.toString().padLeft(2, '0')}',
    ),
  );

  Generator<CourseInfo> get courseInfo => any.combine4(
    any.stringOf(any.letterOrDigit, minLength: 1, maxLength: 30),
    any.stringOf(any.letterOrDigit, minLength: 0, maxLength: 20),
    any.stringOf(any.letterOrDigit, minLength: 0, maxLength: 20),
    any.stringOf(any.hexDigit, minLength: 6, maxLength: 6),
    (name, teacher, classroom, colorHex) => CourseInfo(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      name: name,
      teacher: teacher,
      classroom: classroom,
      color: '#$colorHex',
    ),
  );
}
```
