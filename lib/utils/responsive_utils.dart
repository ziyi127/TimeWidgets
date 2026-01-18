

/// 屏幕尺寸类型枚举
enum ScreenSize {
  compact,    // < 600dp
  medium,     // 600dp - 839dp
  expanded,   // >= 840dp
}

/// 响应式设计工具类
class ResponsiveUtils {
  // 私有构造函数，防止实例化
  ResponsiveUtils._();

  /// UI缩放比例
  static double _scaleFactor = 1;
  
  /// 设置缩放比例
  static void setScaleFactor(double factor) {
    _scaleFactor = factor;
  }
  
  /// 获取当前缩放比例
  static double get scaleFactor => _scaleFactor;
  
  /// 缩放数值
  static double value(double val) {
    return val * _scaleFactor;
  }

  /// Material Design 3 断点定义
  static const double compactBreakpoint = 600;
  static const double mediumBreakpoint = 840;
  static const double expandedBreakpoint = 1200;

  /// 获取当前屏幕尺寸类型
  static ScreenSize getScreenSize(double width) {
    if (width < compactBreakpoint) {
      return ScreenSize.compact;
    } else if (width < mediumBreakpoint) {
      return ScreenSize.medium;
    } else {
      return ScreenSize.expanded;
    }
  }

  /// 判断是否为紧凑布局
  static bool isCompact(double width) {
    return width < compactBreakpoint;
  }

  /// 判断是否为中等布局
  static bool isMedium(double width) {
    return width >= compactBreakpoint && width < mediumBreakpoint;
  }

  /// 判断是否为扩展布局
  static bool isExpanded(double width) {
    return width >= mediumBreakpoint;
  }

  /// 获取响应式水平内边距
  static double getHorizontalPadding(double width) {
    final screenSize = getScreenSize(width);
    switch (screenSize) {
      case ScreenSize.compact:
        return 16.0 * _scaleFactor;
      case ScreenSize.medium:
        return 24.0 * _scaleFactor;
      case ScreenSize.expanded:
        return 32.0 * _scaleFactor;
    }
  }

  /// 获取响应式垂直内边距
  static double getVerticalPadding(double width) {
    final screenSize = getScreenSize(width);
    switch (screenSize) {
      case ScreenSize.compact:
        return 16.0 * _scaleFactor;
      case ScreenSize.medium:
      case ScreenSize.expanded:
        return 24.0 * _scaleFactor;
    }
  }

  /// 获取响应式卡片间距
  static double getCardSpacing(double width) {
    final screenSize = getScreenSize(width);
    switch (screenSize) {
      case ScreenSize.compact:
        return 12.0 * _scaleFactor;
      case ScreenSize.medium:
        return 16.0 * _scaleFactor;
      case ScreenSize.expanded:
        return 20.0 * _scaleFactor;
    }
  }

  /// 获取响应式字体大小倍数
  static double getFontSizeMultiplier(double width) {
    final screenSize = getScreenSize(width);
    double baseMultiplier;
    switch (screenSize) {
      case ScreenSize.compact:
        baseMultiplier = 0.9;
        break;
      case ScreenSize.medium:
        baseMultiplier = 1.0;
        break;
      case ScreenSize.expanded:
        baseMultiplier = 1.1;
        break;
    }
    return baseMultiplier * _scaleFactor;
  }

  /// 获取响应式图标大小
  static double getIconSize(double width, {double baseSize = 24.0}) {
    return baseSize * _scaleFactor;
  }

  /// 获取响应式边框圆角
  static double getBorderRadius(double width, {double baseRadius = 16.0}) {
    final screenSize = getScreenSize(width);
    double multiplier;
    switch (screenSize) {
      case ScreenSize.compact:
        multiplier = 0.75;
        break;
      case ScreenSize.medium:
        multiplier = 1.0;
        break;
      case ScreenSize.expanded:
        multiplier = 1.25;
        break;
    }
    return baseRadius * multiplier * _scaleFactor;
  }

  /// 获取响应式列数
  static int getColumnCount(double width) {
    final screenSize = getScreenSize(width);
    switch (screenSize) {
      case ScreenSize.compact:
        return 1;
      case ScreenSize.medium:
        return 2;
      case ScreenSize.expanded:
        return 3;
    }
  }

  /// 获取响应式网格交叉轴数量
  static int getCrossAxisCount(double width, {int? compactCount, int? mediumCount, int? expandedCount}) {
    final screenSize = getScreenSize(width);
    switch (screenSize) {
      case ScreenSize.compact:
        return compactCount ?? 2;
      case ScreenSize.medium:
        return mediumCount ?? 3;
      case ScreenSize.expanded:
        return expandedCount ?? 4;
    }
  }
}
