import 'package:flutter/material.dart';

/// 课程状态枚举
enum CourseStatus {
  upcoming,   // 即将开始
  current,    // 正在进行
  completed,  // 已结束
}

/// 事件类型枚举
enum EventType {
  exam,       // 考试
  assignment, // 作业
  meeting,    // 会议
  other,      // 其他
}

/// 天气状态枚举
enum WeatherCondition {
  sunny,      // 晴天
  cloudy,     // 多云
  rainy,      // 雨天
  snowy,      // 雪天
  foggy,      // 雾天
  stormy,     // 暴风雨
  unknown,    // 未知
}

/// 主题模式枚举
enum AppThemeMode {
  system,     // 跟随系统
  light,      // 浅色主题
  dark,       // 深色主题
}

/// 语言设置枚举
enum AppLanguage {
  system,     // 跟随系统
  chinese,    // 中文
  english,    // 英文
}

/// 应用常量定义
class AppConstants {
  // 私有构造函数，防止实例化
  AppConstants._();

  /// 应用信息
  static const String appName = 'TimeWidgets';
  static const String appVersion = '1.0.0';

  /// Material Design 3 种子颜色
  static const Color seedColor = Color(0xFF6750A4);

  /// 动画持续时间
  static const Duration shortAnimationDuration = Duration(milliseconds: 200);
  static const Duration mediumAnimationDuration = Duration(milliseconds: 300);
  static const Duration longAnimationDuration = Duration(milliseconds: 500);

  /// 边框圆角
  static const double smallBorderRadius = 8.0;
  static const double mediumBorderRadius = 16.0;
  static const double largeBorderRadius = 24.0;

  /// 间距
  static const double smallSpacing = 8.0;
  static const double mediumSpacing = 16.0;
  static const double largeSpacing = 24.0;
  static const double extraLargeSpacing = 32.0;

  /// 图标大小
  static const double smallIconSize = 16.0;
  static const double mediumIconSize = 24.0;
  static const double largeIconSize = 32.0;
  static const double extraLargeIconSize = 48.0;

  /// 字体大小倍数
  static const double smallFontMultiplier = 0.8;
  static const double mediumFontMultiplier = 1.0;
  static const double largeFontMultiplier = 1.2;

  /// 透明度
  static const double lowOpacity = 0.3;
  static const double mediumOpacity = 0.6;
  static const double highOpacity = 0.8;

  /// 阴影
  static const double lowElevation = 2.0;
  static const double mediumElevation = 4.0;
  static const double highElevation = 8.0;

  /// 时间格式
  static const String timeFormat = 'HH:mm:ss';
  static const String dateFormat = 'yyyy-MM-dd';
  static const String fullDateFormat = 'yyyy年MM月dd日 EEEE';

  /// 网络请求超时
  static const Duration networkTimeout = Duration(seconds: 30);

  /// 缓存键
  static const String weatherCacheKey = 'weather_data';
  static const String timetableCacheKey = 'timetable_data';
  static const String settingsCacheKey = 'app_settings';

  /// 默认值
  static const String defaultCity = '北京';
  static const String defaultWeatherApiKey = 'your_api_key_here';

  /// 课程状态颜色映射
  static const Map<CourseStatus, Color> courseStatusColors = {
    CourseStatus.upcoming: Colors.blue,
    CourseStatus.current: Colors.green,
    CourseStatus.completed: Colors.grey,
  };

  /// 事件类型颜色映射
  static const Map<EventType, Color> eventTypeColors = {
    EventType.exam: Colors.red,
    EventType.assignment: Colors.orange,
    EventType.meeting: Colors.blue,
    EventType.other: Colors.purple,
  };

  /// 天气状态图标映射
  static const Map<WeatherCondition, IconData> weatherIcons = {
    WeatherCondition.sunny: Icons.wb_sunny,
    WeatherCondition.cloudy: Icons.cloud,
    WeatherCondition.rainy: Icons.grain,
    WeatherCondition.snowy: Icons.ac_unit,
    WeatherCondition.foggy: Icons.foggy,
    WeatherCondition.stormy: Icons.thunderstorm,
    WeatherCondition.unknown: Icons.help_outline,
  };

  /// 课程状态图标映射
  static const Map<CourseStatus, IconData> courseStatusIcons = {
    CourseStatus.upcoming: Icons.schedule,
    CourseStatus.current: Icons.play_circle_filled,
    CourseStatus.completed: Icons.check_circle,
  };

  /// 事件类型图标映射
  static const Map<EventType, IconData> eventTypeIcons = {
    EventType.exam: Icons.quiz,
    EventType.assignment: Icons.assignment,
    EventType.meeting: Icons.meeting_room,
    EventType.other: Icons.event,
  };

  /// 获取课程状态文本
  static String getCourseStatusText(CourseStatus status) {
    switch (status) {
      case CourseStatus.upcoming:
        return '即将开始';
      case CourseStatus.current:
        return '正在进行';
      case CourseStatus.completed:
        return '已结束';
    }
  }

  /// 获取事件类型文本
  static String getEventTypeText(EventType type) {
    switch (type) {
      case EventType.exam:
        return '考试';
      case EventType.assignment:
        return '作业';
      case EventType.meeting:
        return '会议';
      case EventType.other:
        return '其他';
    }
  }

  /// 获取天气状态文本
  static String getWeatherConditionText(WeatherCondition condition) {
    switch (condition) {
      case WeatherCondition.sunny:
        return '晴天';
      case WeatherCondition.cloudy:
        return '多云';
      case WeatherCondition.rainy:
        return '雨天';
      case WeatherCondition.snowy:
        return '雪天';
      case WeatherCondition.foggy:
        return '雾天';
      case WeatherCondition.stormy:
        return '暴风雨';
      case WeatherCondition.unknown:
        return '未知';
    }
  }

  /// 验证API密钥格式
  static bool isValidApiKey(String apiKey) {
    return apiKey.isNotEmpty && apiKey.length >= 16;
  }

  /// 验证城市名称
  static bool isValidCityName(String cityName) {
    return cityName.isNotEmpty && cityName.trim().length >= 2;
  }
}
