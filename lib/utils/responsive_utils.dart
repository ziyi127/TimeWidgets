import 'package:flutter/material.dart';
import 'package:time_widgets/utils/platform_utils.dart';

/// 屏幕尺寸类型枚举
enum ScreenSize {
  compact, // < 600dp
  medium, // 600dp - 839dp
  expanded, // >= 840dp
}

/// 响应式设计工具类
class ResponsiveUtils {
  // 私有构造函数，防止实例化
  ResponsiveUtils._();

  /// UI缩放比例
  static double scaleFactor = 1;

  /// 缩放数值
  static double value(double val) {
    return val * scaleFactor;
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
        return 16.0 * scaleFactor;
      case ScreenSize.medium:
        return 24.0 * scaleFactor;
      case ScreenSize.expanded:
        return 32.0 * scaleFactor;
    }
  }

  /// 获取响应式垂直内边距
  static double getVerticalPadding(double width) {
    final screenSize = getScreenSize(width);
    switch (screenSize) {
      case ScreenSize.compact:
        return 16.0 * scaleFactor;
      case ScreenSize.medium:
      case ScreenSize.expanded:
        return 24.0 * scaleFactor;
    }
  }

  /// 获取响应式卡片间距
  static double getCardSpacing(double width) {
    final screenSize = getScreenSize(width);
    switch (screenSize) {
      case ScreenSize.compact:
        return 12.0 * scaleFactor;
      case ScreenSize.medium:
        return 16.0 * scaleFactor;
      case ScreenSize.expanded:
        return 20.0 * scaleFactor;
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
    return baseMultiplier * scaleFactor;
  }

  /// 获取响应式图标大小
  static double getIconSize(double width, {double baseSize = 24.0}) {
    return baseSize * scaleFactor;
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
    return baseRadius * multiplier * scaleFactor;
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
  static int getCrossAxisCount(
    double width, {
    int? compactCount,
    int? mediumCount,
    int? expandedCount,
  }) {
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

  /// 获取平台特定的缩放因子
  static double getPlatformScaleFactor() {
    if (PlatformUtils.isLinux) {
      return 0.95; // Linux 稍微缩小以适应不同的 DPI 设置
    }
    if (PlatformUtils.isMacOS) {
      return 1; // macOS 通常有正确的 DPI
    }
    return 1;
  }

  /// 获取考虑平台的最终缩放因子
  static double getEffectiveScaleFactor() {
    return scaleFactor * getPlatformScaleFactor();
  }

  /// 获取响应式动画持续时间
  static Duration getAnimationDuration(double width) {
    final screenSize = getScreenSize(width);
    switch (screenSize) {
      case ScreenSize.compact:
        return const Duration(milliseconds: 200);
      case ScreenSize.medium:
        return const Duration(milliseconds: 250);
      case ScreenSize.expanded:
        return const Duration(milliseconds: 300);
    }
  }

  /// 获取响应式阴影
  static List<BoxShadow> getShadows(double width, {bool elevated = false}) {
    final screenSize = getScreenSize(width);
    final baseAlpha = elevated ? 0.15 : 0.05;
    final baseBlur = elevated ? 20 : 4;
    final baseOffset = elevated ? 10 : 2;

    double multiplier;
    switch (screenSize) {
      case ScreenSize.compact:
        multiplier = 0.8;
        break;
      case ScreenSize.medium:
        multiplier = 1.0;
        break;
      case ScreenSize.expanded:
        multiplier = 1.2;
        break;
    }

    return [
      BoxShadow(
        color: Colors.black.withValues(alpha: baseAlpha * multiplier),
        blurRadius: baseBlur * multiplier,
        offset: Offset(0, baseOffset * multiplier),
      ),
    ];
  }

  /// 获取响应式列表项高度
  static double getListItemHeight(double width) {
    final screenSize = getScreenSize(width);
    switch (screenSize) {
      case ScreenSize.compact:
        return 56.0 * scaleFactor;
      case ScreenSize.medium:
        return 64.0 * scaleFactor;
      case ScreenSize.expanded:
        return 72.0 * scaleFactor;
    }
  }

  /// 获取响应式按钮高度
  static double getButtonHeight(double width) {
    final screenSize = getScreenSize(width);
    switch (screenSize) {
      case ScreenSize.compact:
        return 40.0 * scaleFactor;
      case ScreenSize.medium:
        return 44.0 * scaleFactor;
      case ScreenSize.expanded:
        return 48.0 * scaleFactor;
    }
  }

  /// 获取响应式输入框高度
  static double getInputHeight(double width) {
    final screenSize = getScreenSize(width);
    switch (screenSize) {
      case ScreenSize.compact:
        return 48.0 * scaleFactor;
      case ScreenSize.medium:
        return 52.0 * scaleFactor;
      case ScreenSize.expanded:
        return 56.0 * scaleFactor;
    }
  }

  /// 获取响应式对话/dialog 宽度
  static double getDialogWidth(double width) {
    final screenSize = getScreenSize(width);
    switch (screenSize) {
      case ScreenSize.compact:
        return width * 0.92;
      case ScreenSize.medium:
        return 600.0 * scaleFactor;
      case ScreenSize.expanded:
        return 800.0 * scaleFactor;
    }
  }

  /// 获取响应式底部动作表最大高度
  static double getBottomSheetMaxHeight(double screenHeight) {
    return screenHeight * 0.9;
  }

  /// 检查是否为触摸设备
  static bool isTouchDevice(double width) {
    return getScreenSize(width) == ScreenSize.compact;
  }

  /// 获取触摸友好的最小点击区域
  static double getMinTouchTarget() {
    return 48.0 * scaleFactor;
  }
}
