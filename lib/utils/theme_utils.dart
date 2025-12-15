import 'package:flutter/material.dart';

/// Material Design 3 主题工具�?class ThemeUtils {
  // 私有构造函数，防止实例�?  ThemeUtils._();

  /// MD3 种子颜色
  static const Color _seedColor = Color(0xFF6750A4);

  /// 构建浅色主题
  static ThemeData buildLightTheme() {
    final colorScheme = ColorScheme.fromSeed(
      seedColor: _seedColor,
      brightness: Brightness.light,
    );

    return _buildTheme(colorScheme);
  }

  /// 构建深色主题
  static ThemeData buildDarkTheme() {
    final colorScheme = ColorScheme.fromSeed(
      seedColor: _seedColor,
      brightness: Brightness.dark,
    );

    return _buildTheme(colorScheme);
  }

  /// 构建通用主题配置
  static ThemeData _buildTheme(ColorScheme colorScheme) {
    return ThemeData(
      useMaterial3: true,
      colorScheme: colorScheme,
      
      // 应用栏主�?      appBarTheme: AppBarTheme(
        backgroundColor: Colors.transparent,
        elevation: 0,
        scrolledUnderElevation: 0,
        centerTitle: false,
        titleTextStyle: TextStyle(
          color: colorScheme.onSurface,
          fontSize: 22,
          fontWeight: FontWeight.w600,
        ),
      ),

      // 卡片主题
      cardTheme: CardThemeData(
        elevation: 0,
        color: colorScheme.surfaceContainer,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: BorderSide(
            color: colorScheme.outline.withValues(alpha: 0.2),
            width: 1,
          ),
        ),
      ),

      // 按钮主题
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
        ),
      ),

      // 文本按钮主题
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        ),
      ),

      // 输入框主�?      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: colorScheme.surfaceContainerHighest,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(
            color: colorScheme.outline.withValues(alpha: 0.5),
          ),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(
            color: colorScheme.outline.withValues(alpha: 0.5),
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(
            color: colorScheme.primary,
            width: 2,
          ),
        ),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      ),

      // 进度指示器主�?      progressIndicatorTheme: ProgressIndicatorThemeData(
        color: colorScheme.primary,
        linearTrackColor: colorScheme.surfaceContainerHighest,
      ),

      // 分割线主�?      dividerTheme: DividerThemeData(
        color: colorScheme.outline.withValues(alpha: 0.2),
        thickness: 1,
        space: 1,
      ),

      // 图标主题
      iconTheme: IconThemeData(
        color: colorScheme.onSurfaceVariant,
        size: 24,
      ),

      // 文本主题
      textTheme: _buildTextTheme(colorScheme),
    );
  }

  /// 构建文本主题
  static TextTheme _buildTextTheme(ColorScheme colorScheme) {
    return TextTheme(
      // 显示文本
      displayLarge: TextStyle(
        color: colorScheme.onSurface,
        fontSize: 57,
        fontWeight: FontWeight.w400,
        letterSpacing: -0.25,
      ),
      displayMedium: TextStyle(
        color: colorScheme.onSurface,
        fontSize: 45,
        fontWeight: FontWeight.w400,
      ),
      displaySmall: TextStyle(
        color: colorScheme.onSurface,
        fontSize: 36,
        fontWeight: FontWeight.w400,
      ),

      // 标题文本
      headlineLarge: TextStyle(
        color: colorScheme.onSurface,
        fontSize: 32,
        fontWeight: FontWeight.w400,
      ),
      headlineMedium: TextStyle(
        color: colorScheme.onSurface,
        fontSize: 28,
        fontWeight: FontWeight.w400,
      ),
      headlineSmall: TextStyle(
        color: colorScheme.onSurface,
        fontSize: 24,
        fontWeight: FontWeight.w400,
      ),

      // 标题文本
      titleLarge: TextStyle(
        color: colorScheme.onSurface,
        fontSize: 22,
        fontWeight: FontWeight.w400,
      ),
      titleMedium: TextStyle(
        color: colorScheme.onSurface,
        fontSize: 16,
        fontWeight: FontWeight.w500,
        letterSpacing: 0.15,
      ),
      titleSmall: TextStyle(
        color: colorScheme.onSurface,
        fontSize: 14,
        fontWeight: FontWeight.w500,
        letterSpacing: 0.1,
      ),

      // 标签文本
      labelLarge: TextStyle(
        color: colorScheme.onSurface,
        fontSize: 14,
        fontWeight: FontWeight.w500,
        letterSpacing: 0.1,
      ),
      labelMedium: TextStyle(
        color: colorScheme.onSurface,
        fontSize: 12,
        fontWeight: FontWeight.w500,
        letterSpacing: 0.5,
      ),
      labelSmall: TextStyle(
        color: colorScheme.onSurface,
        fontSize: 11,
        fontWeight: FontWeight.w500,
        letterSpacing: 0.5,
      ),

      // 正文文本
      bodyLarge: TextStyle(
        color: colorScheme.onSurface,
        fontSize: 16,
        fontWeight: FontWeight.w400,
        letterSpacing: 0.5,
      ),
      bodyMedium: TextStyle(
        color: colorScheme.onSurface,
        fontSize: 14,
        fontWeight: FontWeight.w400,
        letterSpacing: 0.25,
      ),
      bodySmall: TextStyle(
        color: colorScheme.onSurface,
        fontSize: 12,
        fontWeight: FontWeight.w400,
        letterSpacing: 0.4,
      ),
    );
  }

  /// 获取状态颜�?  static Color getStatusColor(ColorScheme colorScheme, String status) {
    switch (status.toLowerCase()) {
      case 'success':
      case 'completed':
        return colorScheme.tertiary;
      case 'warning':
      case 'pending':
        return colorScheme.secondary;
      case 'error':
      case 'failed':
        return colorScheme.error;
      case 'info':
      case 'current':
      case 'active':
        return colorScheme.primary;
      default:
        return colorScheme.onSurfaceVariant;
    }
  }

  /// 获取事件类型颜色
  static Color getEventTypeColor(ColorScheme colorScheme, String eventType) {
    switch (eventType.toLowerCase()) {
      case 'exam':
        return colorScheme.error;
      case 'assignment':
        return colorScheme.tertiary;
      case 'project':
        return colorScheme.secondary;
      case 'holiday':
      case 'vacation':
        return colorScheme.primary;
      case 'meeting':
        return colorScheme.secondary;
      default:
        return colorScheme.primary;
    }
  }

  /// 获取事件类型图标
  static IconData getEventTypeIcon(String eventType) {
    switch (eventType.toLowerCase()) {
      case 'exam':
        return Icons.quiz_rounded;
      case 'assignment':
        return Icons.assignment_rounded;
      case 'project':
        return Icons.work_rounded;
      case 'holiday':
      case 'vacation':
        return Icons.celebration_rounded;
      case 'meeting':
        return Icons.meeting_room_rounded;
      default:
        return Icons.event_rounded;
    }
  }

  /// 获取课程状态图�?  static IconData getCourseStatusIcon(String status) {
    switch (status.toLowerCase()) {
      case 'current':
      case 'active':
        return Icons.play_circle_filled_rounded;
      case 'completed':
      case 'finished':
        return Icons.check_circle_rounded;
      case 'upcoming':
      case 'pending':
        return Icons.schedule_rounded;
      case 'cancelled':
        return Icons.cancel_rounded;
      default:
        return Icons.circle_outlined;
    }
  }
}
