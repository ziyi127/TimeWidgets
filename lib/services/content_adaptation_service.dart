import 'package:flutter/material.dart';
import 'dart:math' as math;

/// 内容适配服务
/// 提供智能内容裁剪、响应式布局和溢出处�?
class ContentAdaptationService {
  /// 创建响应式文�?
  static Widget createResponsiveText({
    required String text,
    required TextStyle baseStyle,
    required Size containerSize,
    int? maxLines,
    TextOverflow? overflow,
    TextAlign? textAlign,
    double? minFontSize,
    double? maxFontSize,
  }) {
    // 计算响应式字体大�?
    final responsiveFontSize = _calculateResponsiveFontSize(
      baseStyle.fontSize ?? 14.0,
      containerSize,
      minFontSize ?? 10.0,
      maxFontSize ?? 24.0,
    );
    
    final responsiveStyle = baseStyle.copyWith(fontSize: responsiveFontSize);
    
    return LayoutBuilder(
      builder: (context, constraints) {
        // 检查文本是否会溢出
        final textPainter = TextPainter(
          text: TextSpan(text: text, style: responsiveStyle),
          textDirection: TextDirection.ltr,
          maxLines: maxLines,
        );
        
        textPainter.layout(maxWidth: constraints.maxWidth);
        
        // 如果文本溢出，应用智能裁�?
        if (textPainter.didExceedMaxLines || 
            textPainter.size.height > constraints.maxHeight) {
          return _createAdaptiveText(
            text: text,
            style: responsiveStyle,
            constraints: constraints,
            maxLines: maxLines,
            overflow: overflow ?? TextOverflow.ellipsis,
            textAlign: textAlign,
          );
        }
        
        return Text(
          text,
          style: responsiveStyle,
          maxLines: maxLines,
          overflow: overflow,
          textAlign: textAlign,
        );
      },
    );
  }

  /// 创建响应式容�?
  static Widget createResponsiveContainer({
    required Widget child,
    required Size containerSize,
    EdgeInsets? basePadding,
    double? baseSpacing,
    bool enableScrolling = false,
  }) {
    final responsivePadding = _calculateResponsivePadding(
      basePadding ?? const EdgeInsets.all(16.0),
      containerSize,
    );
    
    Widget content = Container(
      padding: responsivePadding,
      child: child,
    );
    
    if (enableScrolling) {
      content = SingleChildScrollView(
        child: content,
        physics: const BouncingScrollPhysics(),
      );
    }
    
    return ConstrainedBox(
      constraints: BoxConstraints(
        maxWidth: containerSize.width,
        maxHeight: containerSize.height,
      ),
      child: content,
    );
  }

  /// 创建响应式列�?
  static Widget createResponsiveList({
    required List<Widget> children,
    required Size containerSize,
    double? baseSpacing,
    bool shrinkWrap = true,
    ScrollPhysics? physics,
  }) {
    final responsiveSpacing = _calculateResponsiveSpacing(
      baseSpacing ?? 8.0,
      containerSize,
    );
    
    return ListView.separated(
      shrinkWrap: shrinkWrap,
      physics: physics ?? const BouncingScrollPhysics(),
      itemCount: children.length,
      itemBuilder: (context, index) => children[index],
      separatorBuilder: (context, index) => SizedBox(height: responsiveSpacing),
    );
  }

  /// 创建响应式网�?
  static Widget createResponsiveGrid({
    required List<Widget> children,
    required Size containerSize,
    int? baseColumns,
    double? baseSpacing,
    double? childAspectRatio,
  }) {
    final responsiveColumns = _calculateResponsiveColumns(
      baseColumns ?? 2,
      containerSize,
    );
    
    final responsiveSpacing = _calculateResponsiveSpacing(
      baseSpacing ?? 8.0,
      containerSize,
    );
    
    return GridView.count(
      crossAxisCount: responsiveColumns,
      crossAxisSpacing: responsiveSpacing,
      mainAxisSpacing: responsiveSpacing,
      childAspectRatio: childAspectRatio ?? 1.0,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      children: children,
    );
  }

  /// 创建自适应图标
  static Widget createResponsiveIcon({
    required IconData icon,
    required Size containerSize,
    double? baseSize,
    Color? color,
    double? minSize,
    double? maxSize,
  }) {
    final responsiveSize = _calculateResponsiveIconSize(
      baseSize ?? 24.0,
      containerSize,
      minSize ?? 16.0,
      maxSize ?? 48.0,
    );
    
    return Icon(
      icon,
      size: responsiveSize,
      color: color,
    );
  }

  /// 处理长文本内�?
  static Widget handleLongContent({
    required String content,
    required Size containerSize,
    required TextStyle style,
    int? maxLines,
    bool enableExpansion = false,
  }) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final textPainter = TextPainter(
          text: TextSpan(text: content, style: style),
          textDirection: TextDirection.ltr,
          maxLines: maxLines,
        );
        
        textPainter.layout(maxWidth: constraints.maxWidth);
        
        final isOverflowing = textPainter.didExceedMaxLines ||
            textPainter.size.height > constraints.maxHeight;
        
        if (!isOverflowing) {
          return Text(content, style: style, maxLines: maxLines);
        }
        
        if (enableExpansion) {
          return _createExpandableText(
            content: content,
            style: style,
            maxLines: maxLines ?? 3,
            constraints: constraints,
          );
        } else {
          return _createTruncatedText(
            content: content,
            style: style,
            maxLines: maxLines ?? 3,
            constraints: constraints,
          );
        }
      },
    );
  }

  /// 创建自适应布局
  static Widget createAdaptiveLayout({
    required List<Widget> children,
    required Size containerSize,
    Axis direction = Axis.vertical,
    MainAxisAlignment mainAxisAlignment = MainAxisAlignment.start,
    CrossAxisAlignment crossAxisAlignment = CrossAxisAlignment.start,
    double? spacing,
  }) {
    final responsiveSpacing = _calculateResponsiveSpacing(
      spacing ?? 8.0,
      containerSize,
    );
    
    if (direction == Axis.vertical) {
      return Column(
        mainAxisAlignment: mainAxisAlignment,
        crossAxisAlignment: crossAxisAlignment,
        children: _addSpacing(children, responsiveSpacing, Axis.vertical),
      );
    } else {
      return Row(
        mainAxisAlignment: mainAxisAlignment,
        crossAxisAlignment: crossAxisAlignment,
        children: _addSpacing(children, responsiveSpacing, Axis.horizontal),
      );
    }
  }

  /// 计算响应式字体大�?
  static double _calculateResponsiveFontSize(
    double baseFontSize,
    Size containerSize,
    double minSize,
    double maxSize,
  ) {
    // 基于容器宽度的缩放因�?
    double scaleFactor = 1.0;
    
    if (containerSize.width < 250) {
      scaleFactor = 0.8;
    } else if (containerSize.width < 300) {
      scaleFactor = 0.9;
    } else if (containerSize.width > 400) {
      scaleFactor = 1.1;
    } else if (containerSize.width > 500) {
      scaleFactor = 1.2;
    }
    
    // 基于容器高度的额外调�?
    if (containerSize.height < 100) {
      scaleFactor *= 0.9;
    } else if (containerSize.height > 200) {
      scaleFactor *= 1.05;
    }
    
    final adjustedSize = baseFontSize * scaleFactor;
    return adjustedSize.clamp(minSize, maxSize);
  }

  /// 计算响应式内边距
  static EdgeInsets _calculateResponsivePadding(
    EdgeInsets basePadding,
    Size containerSize,
  ) {
    double scaleFactor = 1.0;
    
    if (containerSize.width < 250) {
      scaleFactor = 0.7;
    } else if (containerSize.width < 300) {
      scaleFactor = 0.85;
    } else if (containerSize.width > 400) {
      scaleFactor = 1.15;
    }
    
    return EdgeInsets.only(
      left: (basePadding.left * scaleFactor).clamp(4.0, 32.0),
      top: (basePadding.top * scaleFactor).clamp(4.0, 32.0),
      right: (basePadding.right * scaleFactor).clamp(4.0, 32.0),
      bottom: (basePadding.bottom * scaleFactor).clamp(4.0, 32.0),
    );
  }

  /// 计算响应式间�?
  static double _calculateResponsiveSpacing(
    double baseSpacing,
    Size containerSize,
  ) {
    double scaleFactor = 1.0;
    
    if (containerSize.width < 250) {
      scaleFactor = 0.6;
    } else if (containerSize.width < 300) {
      scaleFactor = 0.8;
    } else if (containerSize.width > 400) {
      scaleFactor = 1.2;
    }
    
    return (baseSpacing * scaleFactor).clamp(2.0, 24.0);
  }

  /// 计算响应式图标大�?
  static double _calculateResponsiveIconSize(
    double baseSize,
    Size containerSize,
    double minSize,
    double maxSize,
  ) {
    double scaleFactor = 1.0;
    
    if (containerSize.width < 250) {
      scaleFactor = 0.75;
    } else if (containerSize.width < 300) {
      scaleFactor = 0.9;
    } else if (containerSize.width > 400) {
      scaleFactor = 1.2;
    }
    
    final adjustedSize = baseSize * scaleFactor;
    return adjustedSize.clamp(minSize, maxSize);
  }

  /// 计算响应式列�?
  static int _calculateResponsiveColumns(
    int baseColumns,
    Size containerSize,
  ) {
    if (containerSize.width < 200) {
      return math.max(1, baseColumns - 1);
    } else if (containerSize.width > 400) {
      return baseColumns + 1;
    }
    return baseColumns;
  }

  /// 创建自适应文本
  static Widget _createAdaptiveText({
    required String text,
    required TextStyle style,
    required BoxConstraints constraints,
    int? maxLines,
    TextOverflow overflow = TextOverflow.ellipsis,
    TextAlign? textAlign,
  }) {
    // 尝试不同的字体大小直到文本适合
    double fontSize = style.fontSize ?? 14.0;
    const minFontSize = 8.0;
    const step = 0.5;
    
    while (fontSize >= minFontSize) {
      final testStyle = style.copyWith(fontSize: fontSize);
      final textPainter = TextPainter(
        text: TextSpan(text: text, style: testStyle),
        textDirection: TextDirection.ltr,
        maxLines: maxLines,
      );
      
      textPainter.layout(maxWidth: constraints.maxWidth);
      
      if (textPainter.size.height <= constraints.maxHeight &&
          (!textPainter.didExceedMaxLines || maxLines == null)) {
        return Text(
          text,
          style: testStyle,
          maxLines: maxLines,
          overflow: overflow,
          textAlign: textAlign,
        );
      }
      
      fontSize -= step;
    }
    
    // 如果无法适配，使用最小字体大�?
    return Text(
      text,
      style: style.copyWith(fontSize: minFontSize),
      maxLines: maxLines,
      overflow: overflow,
      textAlign: textAlign,
    );
  }

  /// 创建可展开文本
  static Widget _createExpandableText({
    required String content,
    required TextStyle style,
    required int maxLines,
    required BoxConstraints constraints,
  }) {
    // Simplified version without expand/collapse functionality
    return Text(
      content,
      style: style,
      maxLines: maxLines,
      overflow: TextOverflow.ellipsis,
    );
  }

  /// 创建截断文本
  static Widget _createTruncatedText({
    required String content,
    required TextStyle style,
    required int maxLines,
    required BoxConstraints constraints,
  }) {
    return Text(
      content,
      style: style,
      maxLines: maxLines,
      overflow: TextOverflow.ellipsis,
    );
  }

  /// 在子组件之间添加间距
  static List<Widget> _addSpacing(
    List<Widget> children,
    double spacing,
    Axis direction,
  ) {
    if (children.isEmpty) return children;
    
    final spacedChildren = <Widget>[];
    
    for (int i = 0; i < children.length; i++) {
      spacedChildren.add(children[i]);
      
      if (i < children.length - 1) {
        if (direction == Axis.vertical) {
          spacedChildren.add(SizedBox(height: spacing));
        } else {
          spacedChildren.add(SizedBox(width: spacing));
        }
      }
    }
    
    return spacedChildren;
  }

  /// 检查内容是否会溢出
  static bool willContentOverflow({
    required String text,
    required TextStyle style,
    required Size containerSize,
    int? maxLines,
  }) {
    final textPainter = TextPainter(
      text: TextSpan(text: text, style: style),
      textDirection: TextDirection.ltr,
      maxLines: maxLines,
    );
    
    textPainter.layout(maxWidth: containerSize.width);
    
    return textPainter.didExceedMaxLines ||
           textPainter.size.height > containerSize.height;
  }

  /// 计算文本所需的最小尺�?
  static Size calculateTextSize({
    required String text,
    required TextStyle style,
    int? maxLines,
    double? maxWidth,
  }) {
    final textPainter = TextPainter(
      text: TextSpan(text: text, style: style),
      textDirection: TextDirection.ltr,
      maxLines: maxLines,
    );
    
    textPainter.layout(maxWidth: maxWidth ?? double.infinity);
    
    return textPainter.size;
  }

  /// 创建响应式内边距（公共方法）
  static EdgeInsets createResponsivePadding({
    required Size containerSize,
    EdgeInsets basePadding = const EdgeInsets.all(16.0),
  }) {
    return _calculateResponsivePadding(basePadding, containerSize);
  }
}
