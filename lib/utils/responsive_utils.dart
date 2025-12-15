import 'package:flutter/material.dart';

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
        return 16.0;
      case ScreenSize.medium:
        return 24.0;
      case ScreenSize.expanded:
        return 32.0;
    }
  }

  /// 获取响应式垂直内边距
  static double getVerticalPadding(double width) {
    final screenSize = getScreenSize(width);
    switch (screenSize) {
      case ScreenSize.compact:
        return 16.0;
      case ScreenSize.medium:
      case ScreenSize.expanded:
        return 24.0;
    }
  }

  /// 获取响应式卡片间距
  static double getCardSpacing(double width) {
    final screenSize = getScreenSize(width);
    switch (screenSize) {
      case ScreenSize.compact:
        return 12.0;
      case ScreenSize.medium:
        return 16.0;
      case ScreenSize.expanded:
        return 20.0;
    }
  }

  /// 获取响应式字体大小倍数
  static double getFontSizeMultiplier(double width) {
    final screenSize = getScreenSize(width);
    switch (screenSize) {
      case ScreenSize.compact:
        return 0.9;
      case ScreenSize.medium:
        return 1.0;
      case ScreenSize.expanded:
        return 1.1;
    }
  }

  /// 获取响应式图标大小
  static double getIconSize(double width, {double baseSize = 24.0}) {
    final multiplier = getFontSizeMultiplier(width);
    return baseSize * multiplier;
  }

  /// 获取响应式边框圆角
  static double getBorderRadius(double width, {double baseRadius = 16.0}) {
    final screenSize = getScreenSize(width);
    switch (screenSize) {
      case ScreenSize.compact:
        return baseRadius * 0.75;
      case ScreenSize.medium:
        return baseRadius;
      case ScreenSize.expanded:
        return baseRadius * 1.25;
    }
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
        return compactCount ?? 1;
      case ScreenSize.medium:
        return mediumCount ?? 2;
      case ScreenSize.expanded:
        return expandedCount ?? 3;
    }
  }

  /// 获取响应式最大宽度
  static double getMaxWidth(double width) {
    final screenSize = getScreenSize(width);
    switch (screenSize) {
      case ScreenSize.compact:
        return width;
      case ScreenSize.medium:
        return 800.0;
      case ScreenSize.expanded:
        return 1200.0;
    }
  }

  /// 构建响应式布局
  static Widget buildResponsiveLayout({
    required double width,
    required Widget compactLayout,
    Widget? mediumLayout,
    Widget? expandedLayout,
  }) {
    final screenSize = getScreenSize(width);
    
    switch (screenSize) {
      case ScreenSize.compact:
        return compactLayout;
      case ScreenSize.medium:
        return mediumLayout ?? compactLayout;
      case ScreenSize.expanded:
        return expandedLayout ?? mediumLayout ?? compactLayout;
    }
  }

  /// 构建响应式网格
  static Widget buildResponsiveGrid({
    required double width,
    required List<Widget> children,
    int? compactColumns,
    int? mediumColumns,
    int? expandedColumns,
    double? spacing,
  }) {
    final columnCount = getCrossAxisCount(
      width,
      compactCount: compactColumns ?? 1,
      mediumCount: mediumColumns ?? 2,
      expandedCount: expandedColumns ?? 3,
    );
    
    final effectiveSpacing = spacing ?? getCardSpacing(width);
    
    return GridView.count(
      crossAxisCount: columnCount,
      crossAxisSpacing: effectiveSpacing,
      mainAxisSpacing: effectiveSpacing,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      children: children,
    );
  }

  /// 构建响应式行布局
  static Widget buildResponsiveRow({
    required double width,
    required List<Widget> children,
    MainAxisAlignment mainAxisAlignment = MainAxisAlignment.start,
    CrossAxisAlignment crossAxisAlignment = CrossAxisAlignment.center,
    bool forceColumn = false,
  }) {
    final spacing = getCardSpacing(width);
    final isCompactScreen = isCompact(width);
    
    if (forceColumn || isCompactScreen) {
      return Column(
        mainAxisAlignment: mainAxisAlignment,
        crossAxisAlignment: crossAxisAlignment,
        children: children
            .expand((child) => [child, SizedBox(height: spacing)])
            .take(children.length * 2 - 1)
            .toList(),
      );
    } else {
      return Row(
        mainAxisAlignment: mainAxisAlignment,
        crossAxisAlignment: crossAxisAlignment,
        children: children
            .expand((child) => [Expanded(child: child), SizedBox(width: spacing)])
            .take(children.length * 2 - 1)
            .toList(),
      );
    }
  }

  /// 构建响应式容器
  static Widget buildResponsiveContainer({
    required double width,
    required Widget child,
    EdgeInsets? padding,
    EdgeInsets? margin,
    double? borderRadius,
  }) {
    return Container(
      width: getMaxWidth(width),
      padding: padding ?? EdgeInsets.all(getHorizontalPadding(width)),
      margin: margin,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(
          borderRadius ?? getBorderRadius(width),
        ),
      ),
      child: child,
    );
  }
}