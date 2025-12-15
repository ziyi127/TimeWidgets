# Design Document: Project Enhancement

## Overview

本设计文档描述了智慧课程表（Time Widgets）项目的完善方案。该项目是一个基于 Flutter 的桌面应用程序，主要功能包括课程表管理、天气信息展示、倒计时功能等。本次完善将增强应用的功能完整性、用户体验和代码质量。

### 设计目标

1. 完善项目文档，提供清晰的使用指南
2. 实现多倒计时事件管理功能
3. 添加应用设置功能
4. 完善数据导入导出功能
5. 优化错误处理机制
6. 实现周次显示和课程过滤功能
7. 添加快速导航功能
8. 完善单元测试覆盖
9. 全面实施 Material Design 3 规范
10. 实现 Monet 动态取色系统
11. 实现系统托盘功能，提供快速访问设置和课表编辑
12. 实现完整的中文本地化界面

## Architecture

### 现有架构

```
┌─────────────────────────────────────────────────────────────┐
│                        Presentation Layer                    │
│  ┌─────────────┐  ┌─────────────┐  ┌─────────────────────┐  │
│  │   Screens   │  │   Widgets   │  │      Dialogs        │  │
│  └─────────────┘  └─────────────┘  └─────────────────────┘  │
└─────────────────────────────────────────────────────────────┘
                              │
                              ▼
┌─────────────────────────────────────────────────────────────┐
│                        Service Layer                         │
│  ┌─────────────┐  ┌─────────────┐  ┌─────────────────────┐  │
│  │ ApiService  │  │CacheService │  │TimetableStorageServ │  │
│  └─────────────┘  └─────────────┘  └─────────────────────┘  │
└─────────────────────────────────────────────────────────────┘
                              │
                              ▼
┌─────────────────────────────────────────────────────────────┐
│                         Data Layer                           │
│  ┌─────────────┐  ┌─────────────┐  ┌─────────────────────┐  │
│  │   Models    │  │SharedPrefs  │  │    File System      │  │
│  └─────────────┘  └─────────────┘  └─────────────────────┘  │
└─────────────────────────────────────────────────────────────┘
```

### 增强后架构

```
┌─────────────────────────────────────────────────────────────┐
│                        Presentation Layer                    │
│  ┌─────────────┐  ┌─────────────┐  ┌─────────────────────┐  │
│  │   Screens   │  │   Widgets   │  │      Dialogs        │  │
│  │ + Settings  │  │ + Enhanced  │  │ + CountdownEdit     │  │
│  │ + Chinese   │  │ + Chinese   │  │ + Chinese UI        │  │
│  └─────────────┘  └─────────────┘  └─────────────────────┘  │
└─────────────────────────────────────────────────────────────┘
                              │
                              ▼
┌─────────────────────────────────────────────────────────────┐
│                        Service Layer                         │
│  ┌─────────────┐  ┌─────────────┐  ┌─────────────────────┐  │
│  │ ApiService  │  │CacheService │  │TimetableStorageServ │  │
│  ├─────────────┤  ├─────────────┤  ├─────────────────────┤  │
│  │ + Settings  │  │ + Countdown │  │ + Export/Import     │  │
│  │   Service   │  │   Storage   │  │   Enhancement       │  │
│  └─────────────┘  └─────────────┘  └─────────────────────┘  │
│  ┌─────────────┐  ┌─────────────┐  ┌─────────────────────┐  │
│  │ WeekService │  │ErrorHandler │  │ SystemTrayService   │  │
│  └─────────────┘  └─────────────┘  └─────────────────────┘  │
└─────────────────────────────────────────────────────────────┘
                              │
                              ▼
┌─────────────────────────────────────────────────────────────┐
│                         Data Layer                           │
│  ┌─────────────┐  ┌─────────────┐  ┌─────────────────────┐  │
│  │   Models    │  │SharedPrefs  │  │    File System      │  │
│  │ + Settings  │  │ + Countdown │  │ + JSON Export       │  │
│  │   Model     │  │   List      │  │ + Localization      │  │
│  └─────────────┘  └─────────────┘  └─────────────────────┘  │
└─────────────────────────────────────────────────────────────┘
```

## Components and Interfaces

### 1. Settings Module

#### SettingsModel (`lib/models/settings_model.dart`)

```dart
class AppSettings {
  final ThemeMode themeMode;
  final String apiBaseUrl;
  final bool enableNotifications;
  final DateTime? semesterStartDate;
  final String language;
  
  // JSON serialization methods
  Map<String, dynamic> toJson();
  factory AppSettings.fromJson(Map<String, dynamic> json);
  factory AppSettings.defaultSettings();
}
```

#### SettingsService (`lib/services/settings_service.dart`)

```dart
class SettingsService {
  Future<AppSettings> loadSettings();
  Future<void> saveSettings(AppSettings settings);
  Future<void> resetToDefaults();
  Stream<AppSettings> get settingsStream;
}
```

### 2. Countdown Management Module

#### CountdownStorageService (`lib/services/countdown_storage_service.dart`)

```dart
class CountdownStorageService {
  Future<List<CountdownData>> loadAllCountdowns();
  Future<void> saveCountdown(CountdownData countdown);
  Future<void> updateCountdown(CountdownData countdown);
  Future<void> deleteCountdown(String id);
  Future<void> saveAllCountdowns(List<CountdownData> countdowns);
}
```

### 3. Week Calculation Module

#### WeekService (`lib/services/week_service.dart`)

```dart
class WeekService {
  int calculateWeekNumber(DateTime semesterStart, DateTime currentDate);
  bool isOddWeek(int weekNumber);
  List<DailyCourse> filterCoursesByWeekType(
    List<DailyCourse> courses, 
    int weekNumber
  );
}
```

### 4. Export/Import Enhancement

#### TimetableExportService (`lib/services/timetable_export_service.dart`)

```dart
class TimetableExportService {
  Future<String> exportToJson(TimetableData data);
  Future<TimetableData?> importFromJson(String jsonString);
  Future<void> exportToFile(TimetableData data, String filePath);
  Future<TimetableData?> importFromFile(String filePath);
  ValidationResult validateJson(String jsonString);
}

class ValidationResult {
  final bool isValid;
  final String? errorMessage;
  final List<String> warnings;
}
```

### 5. Error Handling Module

#### ErrorHandler (`lib/utils/error_handler.dart`)

```dart
class AppError {
  final String code;
  final String message;
  final String? userMessage;
  final String? resolution;
  final dynamic originalError;
}

class ErrorHandler {
  static AppError handleNetworkError(dynamic error);
  static AppError handleStorageError(dynamic error);
  static AppError handleValidationError(String message);
  static void logError(AppError error);
}
```

### 6. Material Design 3 Theme Module

#### ThemeService (`lib/services/theme_service.dart`)

```dart
class ThemeService {
  Future<Color> getSeedColor();
  Future<void> setSeedColor(Color color);
  ThemeData generateLightTheme(Color seedColor);
  ThemeData generateDarkTheme(Color seedColor);
  ColorScheme generateColorScheme(Color seedColor, Brightness brightness);
  Stream<Color> get seedColorStream;
}
```

#### DynamicColorBuilder (`lib/widgets/dynamic_color_builder.dart`)

```dart
class DynamicColorBuilder extends StatelessWidget {
  final Widget Function(ThemeData lightTheme, ThemeData darkTheme) builder;
  final Color? defaultSeedColor;
  
  // Builds themes based on current seed color
  // Supports dynamic color updates
}
```

### 7. System Tray Module

#### SystemTrayService (`lib/services/system_tray_service.dart`)

```dart
class SystemTrayService {
  Future<void> initializeSystemTray();
  Future<void> updateTrayIcon(String iconPath);
  Future<void> showTrayMenu();
  Future<void> setTrayTooltip(String tooltip);
  void onTrayMenuItemSelected(String itemId);
  Future<void> showMainWindow();
  Future<void> hideMainWindow();
  Future<void> toggleMainWindow();
  Future<void> exitApplication();
}

enum TrayMenuItem {
  settings,      // 设置
  timetableEdit, // 课表编辑
  toggleWindow,  // 显示/隐藏
  exit          // 退出
}
```

### 8. Localization Module

#### LocalizationService (`lib/services/localization_service.dart`)

```dart
class LocalizationService {
  static const Map<String, String> chineseStrings = {
    // UI Labels
    'app_title': '智慧课程表',
    'settings': '设置',
    'timetable_edit': '课表编辑',
    'show_hide': '显示/隐藏',
    'exit': '退出',
    
    // Settings Screen
    'theme_settings': '主题设置',
    'api_settings': 'API设置',
    'notification_settings': '通知设置',
    
    // Error Messages
    'network_error': '网络连接失败',
    'file_not_found': '文件未找到',
    'invalid_format': '文件格式无效',
    
    // Date/Time Formats
    'week_format': '第{week}周',
    'odd_week': '单周',
    'even_week': '双周',
  };
  
  static String getString(String key, {Map<String, dynamic>? params});
  static String formatDate(DateTime date);
  static String formatTime(DateTime time);
}
```

## Data Models

### AppSettings Model

```dart
class AppSettings {
  final ThemeMode themeMode;           // system, light, dark
  final String apiBaseUrl;             // API base URL
  final bool enableNotifications;      // Enable notifications
  final DateTime? semesterStartDate;   // Semester start date for week calculation
  final String language;               // App language (zh, en)
  final int weatherRefreshInterval;    // Weather refresh interval in minutes
  final int countdownRefreshInterval;  // Countdown refresh interval in minutes
}
```

### Enhanced CountdownData Model

现有的 `CountdownData` 模型已经包含了必要的字段，无需修改。

### ValidationResult Model

```dart
class ValidationResult {
  final bool isValid;
  final String? errorMessage;
  final List<String> warnings;
  
  factory ValidationResult.valid();
  factory ValidationResult.invalid(String message);
}
```

### ThemeSettings Model

```dart
class ThemeSettings {
  final Color seedColor;              // Seed color for Monet theming
  final ThemeMode themeMode;          // light, dark, system
  final bool useDynamicColor;         // Enable/disable dynamic color
  final bool useSystemColor;          // Use system accent color (Android 12+)
  
  Map<String, dynamic> toJson();
  factory ThemeSettings.fromJson(Map<String, dynamic> json);
  factory ThemeSettings.defaultSettings();
}
```

## Correctness Properties

*A property is a characteristic or behavior that should hold true across all valid executions of a system-essentially, a formal statement about what the system should do. Properties serve as the bridge between human-readable specifications and machine-verifiable correctness guarantees.*

Based on the prework analysis, the following correctness properties have been identified:

### Property 1: Countdown Event Persistence Round Trip
*For any* valid CountdownData object, saving it to storage and then loading it back SHALL produce a CountdownData object equivalent to the original.
**Validates: Requirements 2.1, 2.3**

### Property 2: Countdown List Sorting
*For any* list of CountdownData objects, when sorted by target date, each element's target date SHALL be less than or equal to the next element's target date.
**Validates: Requirements 2.2**

### Property 3: Countdown Deletion Removes Event
*For any* CountdownData object that has been saved and then deleted, attempting to load that event by ID SHALL return null or not include it in the list.
**Validates: Requirements 2.4**

### Property 4: Settings Persistence Round Trip
*For any* valid AppSettings object, saving it and then loading it back SHALL produce an AppSettings object equivalent to the original.
**Validates: Requirements 3.2**

### Property 5: Settings Reset Restores Defaults
*For any* modified AppSettings, after calling reset, loading settings SHALL return values equivalent to AppSettings.defaultSettings().
**Validates: Requirements 3.3**

### Property 6: Timetable JSON Round Trip
*For any* valid TimetableData object, serializing to JSON and deserializing back SHALL produce a TimetableData object equivalent to the original.
**Validates: Requirements 4.1, 4.2, 4.5**

### Property 7: Invalid JSON Validation
*For any* malformed or incomplete JSON string, the validation function SHALL return isValid=false with a non-empty errorMessage.
**Validates: Requirements 4.3**

### Property 8: Cache Fallback on Error
*For any* cached data that exists, when a network request fails, the system SHALL return the cached data instead of throwing an error.
**Validates: Requirements 5.2**

### Property 9: Week Number Calculation
*For any* semester start date and current date where current date is after start date, the week number SHALL be calculated as ceil((currentDate - startDate).inDays / 7) + 1.
**Validates: Requirements 6.1, 6.3**

### Property 10: Odd/Even Week Classification
*For any* week number, isOddWeek SHALL return true if weekNumber % 2 == 1, and false otherwise.
**Validates: Requirements 6.2**

### Property 11: Course Filtering by Week Type
*For any* list of DailyCourse objects and a week number, filtering SHALL return only courses where weekType is 'both' OR weekType matches the current week's odd/even status.
**Validates: Requirements 6.4**

### Property 12: Current Time Slot Highlighting
*For any* list of TimeSlot objects and a current time, at most one time slot SHALL be identified as current (where startTime <= currentTime <= endTime).
**Validates: Requirements 7.2**

### Property 13: Theme Settings Persistence Round Trip
*For any* valid ThemeSettings object, saving it and then loading it back SHALL produce a ThemeSettings object equivalent to the original.
**Validates: Requirements 9.5**

### Property 14: Color Scheme Generation Consistency
*For any* seed color and brightness mode, generating a color scheme multiple times SHALL produce identical color values.
**Validates: Requirements 9.2**

### Property 15: Theme Mode Application
*For any* theme mode setting (light/dark/system), the application SHALL apply the corresponding theme and all UI components SHALL use colors from that theme's color scheme.
**Validates: Requirements 9.1, 9.3, 9.4**

### Property 16: Window Visibility Toggle
*For any* current window visibility state (visible/hidden), selecting the toggle menu item SHALL result in the opposite visibility state.
**Validates: Requirements 10.5**

### Property 17: Chinese UI Text Display
*For any* UI component that displays text, all displayed strings SHALL match entries in the Chinese localization string map.
**Validates: Requirements 11.1**

### Property 18: Chinese Error Messages
*For any* error condition that generates a user-facing message, the displayed error message SHALL be in Chinese and match the localized error string format.
**Validates: Requirements 11.2**

### Property 19: Chinese Date Time Formatting
*For any* date or time value displayed to the user, the formatted string SHALL follow Chinese date/time conventions and patterns.
**Validates: Requirements 11.3**

### Property 20: Chinese Dialog Content
*For any* dialog box or notification displayed to the user, all text content SHALL use Chinese strings from the localization service.
**Validates: Requirements 11.5**

## Error Handling

### Error Categories

1. **Network Errors**: API 请求失败、超时、无网络连接
2. **Storage Errors**: 文件读写失败、权限问题、存储空间不足
3. **Validation Errors**: JSON 格式错误、数据验证失败
4. **Runtime Errors**: 意外异常、空指针等

### Error Handling Strategy

```dart
// 统一错误处理流程
try {
  // 执行操作
} on NetworkException catch (e) {
  // 1. 尝试使用缓存数据
  // 2. 显示友好错误信息
  // 3. 提供重试选项
} on StorageException catch (e) {
  // 1. 记录错误日志
  // 2. 显示错误信息
  // 3. 提供解决建议
} on ValidationException catch (e) {
  // 1. 显示具体验证错误
  // 2. 高亮错误位置
} catch (e) {
  // 1. 记录未知错误
  // 2. 显示通用错误信息
  // 3. 不崩溃应用
}
```

### User-Facing Error Messages

| Error Type | User Message | Resolution |
|------------|--------------|------------|
| Network Timeout | 网络连接超时 | 请检查网络连接后重试 |
| No Internet | 无法连接到网络 | 请检查网络设置 |
| Invalid JSON | 文件格式无效 | 请确保文件是有效的 JSON 格式 |
| Storage Full | 存储空间不足 | 请清理存储空间后重试 |
| Permission Denied | 没有文件访问权限 | 请授予应用文件访问权限 |
| Tray Init Failed | 系统托盘初始化失败 | 请重启应用程序 |
| Window Show Failed | 窗口显示失败 | 请检查窗口管理器设置 |
| Localization Error | 本地化资源加载失败 | 请重新安装应用程序 |

### System Tray Menu Items (Chinese)

| Menu Item ID | Chinese Label | Function |
|--------------|---------------|----------|
| settings | 设置 | Open settings screen |
| timetable_edit | 课表编辑 | Open timetable editing screen |
| toggle_window | 显示/隐藏 | Toggle main window visibility |
| exit | 退出 | Exit application |

## Testing Strategy

### Dual Testing Approach

本项目采用单元测试和属性测试相结合的测试策略：

1. **单元测试**: 验证特定示例和边界情况
2. **属性测试**: 验证在所有有效输入上都应成立的通用属性

### Property-Based Testing Framework

使用 `dart_quickcheck` 或 `glados` 作为属性测试框架。

```yaml
dev_dependencies:
  glados: ^0.0.5
```

### Test Categories

#### 1. Model Serialization Tests

- CountdownData JSON round trip
- AppSettings JSON round trip
- TimetableData JSON round trip
- CourseInfo JSON round trip
- TimeSlot JSON round trip
- DailyCourse JSON round trip

#### 2. Service Logic Tests

- WeekService week number calculation
- WeekService odd/even week classification
- WeekService course filtering
- CountdownStorageService CRUD operations
- SettingsService persistence
- TimetableExportService validation

#### 3. Error Handling Tests

- Network error fallback to cache
- Invalid JSON validation
- Storage error handling

#### 4. System Tray Tests

- Tray icon initialization
- Tray menu display and item selection
- Window visibility toggle functionality
- Application exit from tray

#### 5. Localization Tests

- Chinese text display verification
- Chinese error message formatting
- Chinese date/time formatting
- Dialog and notification text localization

### Test File Structure

```
test/
├── models/
│   ├── countdown_model_test.dart
│   ├── settings_model_test.dart
│   └── timetable_model_test.dart
├── services/
│   ├── week_service_test.dart
│   ├── countdown_storage_service_test.dart
│   ├── settings_service_test.dart
│   ├── timetable_export_service_test.dart
│   ├── system_tray_service_test.dart
│   └── localization_service_test.dart
├── property_tests/
│   ├── serialization_properties_test.dart
│   ├── week_calculation_properties_test.dart
│   ├── countdown_properties_test.dart
│   ├── system_tray_properties_test.dart
│   └── localization_properties_test.dart
└── widget_test.dart
```

### Property Test Annotations

每个属性测试必须使用以下格式注释：

```dart
// **Feature: project-enhancement, Property 1: Countdown Event Persistence Round Trip**
// **Validates: Requirements 2.1, 2.3**
test('countdown persistence round trip', () {
  // Property-based test implementation
});
```

### Minimum Test Requirements

- 每个属性测试运行至少 100 次迭代
- 核心模块代码覆盖率达到 70%
- 所有属性测试必须引用设计文档中的属性编号
