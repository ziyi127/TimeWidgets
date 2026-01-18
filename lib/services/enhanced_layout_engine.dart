import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:time_widgets/services/desktop_widget_service.dart';
import 'package:time_widgets/utils/logger.dart';

/// 增强的布局引擎
/// 提供智能位置计算、碰撞检测和自适应布局功能
class EnhancedLayoutEngine {
  static const double _minWidgetSize = 50;
  static const double _maxWidgetSize = 500;
  static const double _padding = 16;

  /// 位置计算器
  final PositionCalculator _positionCalculator = PositionCalculator();

  /// 碰撞检测器
  final CollisionDetector _collisionDetector = CollisionDetector();

  /// 布局验证器
  final LayoutValidator _layoutValidator = LayoutValidator();

  /// 计算最优布局
  Map<WidgetType, WidgetPosition> calculateOptimalLayout(
    Size screenSize,
    Map<WidgetType, WidgetPosition>? currentLayout,
  ) {
    try {
      // 1. 计算自适应容器大小，根据屏幕尺寸动态调整
      final containerSize = _calculateAdaptiveContainerSize(screenSize);

      // 2. 生成默认位置
      var layout = _positionCalculator.calculateDefaultPositions(containerSize);

      // 3. 如果有现有布局，尝试保留有效位置
      if (currentLayout != null) {
        layout = _mergeWithExistingLayout(layout, currentLayout, containerSize);
      }

      // 4. 解决碰撞问题
      layout = _collisionDetector.resolveCollisions(layout, containerSize);

      // 5. 特殊处理settings按钮，确保不会与其他组件重叠
      final settingsPosition = layout[WidgetType.settings];
      if (settingsPosition != null) {
        final settingsRect = Rect.fromLTWH(
          settingsPosition.x,
          settingsPosition.y,
          settingsPosition.width,
          settingsPosition.height,
        );

        bool hasOverlap = false;

        // 检查是否与其他组件重叠
        for (final entry in layout.entries) {
          if (entry.key == WidgetType.settings) continue;

          final position = entry.value;
          final rect = Rect.fromLTWH(
            position.x,
            position.y,
            position.width,
            position.height,
          );

          if (settingsRect.overlaps(rect)) {
            hasOverlap = true;
            break;
          }
        }

        // 如果有重叠，将settings按钮重新放置在右下角
        if (hasOverlap) {
          layout[WidgetType.settings] = WidgetPosition(
            type: WidgetType.settings,
            x: containerSize.width - _padding - settingsPosition.width,
            y: containerSize.height - _padding - settingsPosition.height,
            width: settingsPosition.width,
            height: settingsPosition.height,
            isVisible: settingsPosition.isVisible,
          );
        }
      }

      // 6. 再次检查并解决碰撞问题
      layout = _collisionDetector.resolveCollisions(layout, containerSize);

      // 7. 验证布局有效性
      if (!_layoutValidator.validateLayout(layout, containerSize)) {
        // 如果验证失败，使用安全的默认布局
        layout = _positionCalculator.calculateSafeDefaultLayout(containerSize);
      }

      return layout;
    } catch (e) {
      Logger.e('Layout calculation failed: $e');
      // 返回安全的默认布局
      return _positionCalculator.calculateSafeDefaultLayout(
        _calculateAdaptiveContainerSize(screenSize),
      );
    }
  }

  /// 计算自适应容器大小
  Size _calculateAdaptiveContainerSize(Size screenSize) {
    // 根据屏幕尺寸动态调整容器大小
    // 大屏幕使用更宽的容器，小屏幕使用相对宽度
    double containerWidth;
    if (screenSize.width > 1920) {
      containerWidth = screenSize.width / 3;
    } else if (screenSize.width > 1440) {
      containerWidth = screenSize.width / 3.5;
    } else if (screenSize.width > 1024) {
      containerWidth = screenSize.width / 4;
    } else if (screenSize.width > 768) {
      containerWidth = screenSize.width / 3;
    } else {
      containerWidth = screenSize.width / 2;
    }

    // 确保容器宽度不小于最小安全宽度
    containerWidth = math.max(containerWidth, 280);
    return Size(containerWidth, screenSize.height);
  }

  /// 检测布局中的碰撞
  List<WidgetType> detectCollisions(Map<WidgetType, WidgetPosition> layout) {
    return _collisionDetector.detectCollisions(layout);
  }

  /// 调整布局以适应新的屏幕尺寸
  Map<WidgetType, WidgetPosition> adjustForScreenSize(
    Map<WidgetType, WidgetPosition> currentLayout,
    Size oldSize,
    Size newSize,
  ) {
    final newContainerSize = _calculateAdaptiveContainerSize(newSize);
    final oldContainerSize = _calculateAdaptiveContainerSize(oldSize);

    // 计算缩放比例
    final scaleX = newContainerSize.width / oldContainerSize.width;
    final scaleY = newContainerSize.height / oldContainerSize.height;

    final adjustedLayout = <WidgetType, WidgetPosition>{};

    for (final entry in currentLayout.entries) {
      final position = entry.value;

      // 按比例调整位置和尺寸
      final scaledWidth =
          (position.width * scaleX).clamp(_minWidgetSize, _maxWidgetSize);
      final scaledHeight =
          (position.height * scaleY).clamp(_minWidgetSize, _maxWidgetSize);

      // 确保组件不会超出容器边界
      final maxX = newContainerSize.width - scaledWidth;
      final maxY = newContainerSize.height - scaledHeight;

      final newX = (position.x * scaleX).clamp(0.0, maxX);
      final newY = (position.y * scaleY).clamp(0.0, maxY);

      adjustedLayout[entry.key] = WidgetPosition(
        type: position.type,
        x: newX,
        y: newY,
        width: scaledWidth,
        height: scaledHeight,
        isVisible: position.isVisible,
      );
    }

    // 解决调整后可能出现的碰撞
    return _collisionDetector.resolveCollisions(
      adjustedLayout,
      newContainerSize,
    );
  }

  /// 获取自适应容器大小
  Size getAdaptiveContainerSize(Size screenSize) {
    return _calculateAdaptiveContainerSize(screenSize);
  }

  /// 验证布局有效性
  bool validateLayout(
    Map<WidgetType, WidgetPosition> layout,
    Size containerSize,
  ) {
    return _layoutValidator.validateLayout(layout, containerSize);
  }

  /// 合并现有布局和默认布局
  Map<WidgetType, WidgetPosition> _mergeWithExistingLayout(
    Map<WidgetType, WidgetPosition> defaultLayout,
    Map<WidgetType, WidgetPosition> existingLayout,
    Size containerSize,
  ) {
    final mergedLayout = <WidgetType, WidgetPosition>{};

    for (final type in WidgetType.values) {
      final existing = existingLayout[type];
      // 获取默认布局中对应的位置
      final defaultPos = defaultLayout[type];
      if (defaultPos == null) continue;

      if (existing != null &&
          _layoutValidator.isPositionValid(existing, containerSize)) {
        mergedLayout[type] = existing;
      } else {
        mergedLayout[type] = defaultPos;
      }
    }

    return mergedLayout;
  }
}

/// 位置计算器
class PositionCalculator {
  static const double _padding = 16;
  static const double _spacing = 16; // 增加间距

  /// 计算默认位置 - 垂直单列布局，确保所有组件可见
  Map<WidgetType, WidgetPosition> calculateDefaultPositions(
    Size containerSize,
  ) {
    final positions = <WidgetType, WidgetPosition>{};

    // 使用更小的卡片宽度，让组件更紧凑
    final cardWidth = math.min(containerSize.width - 2 * _padding, 300);

    double currentY = _padding;

    // 按优先级排列组件 - 先不包括settings
    final orderedTypes = [
      WidgetType.time,
      WidgetType.date,
      WidgetType.week,
      WidgetType.weather,
      WidgetType.currentClass,
      WidgetType.countdown,
      WidgetType.timetable,
    ];

    for (final type in orderedTypes) {
      final height = _getDefaultHeight(type);

      // 检查是否还有足够的空间
      final remainingHeight = containerSize.height - currentY - _padding;
      final adjustedHeight =
          remainingHeight > height ? height : math.max(50, remainingHeight);

      positions[type] = WidgetPosition(
        type: type,
        x: _padding,
        y: currentY,
        width: cardWidth.toDouble(),
        height: adjustedHeight.toDouble(),
        isVisible: remainingHeight >= 50, // 只有在有足够空间时才显示
      );

      // 更新Y坐标
      currentY += adjustedHeight + _spacing;
    }

    // 设置按钮单独处理 - 放置在右下角，确保不会与其他组件重叠
    // 计算右下角位置，避免与其他组件重叠
    const settingsWidth = 48.0;
    const settingsHeight = 48.0;
    final settingsX = containerSize.width - _padding - settingsWidth;
    final settingsY = containerSize.height - _padding - settingsHeight;

    positions[WidgetType.settings] = WidgetPosition(
      type: WidgetType.settings,
      x: settingsX,
      y: settingsY,
      width: settingsWidth,
      height: settingsHeight,
    );

    return positions;
  }

  /// 计算安全的默认布局（用于错误恢复）
  Map<WidgetType, WidgetPosition> calculateSafeDefaultLayout(
    Size containerSize,
  ) {
    final positions = <WidgetType, WidgetPosition>{};
    final safeWidth = math.min(280, containerSize.width - 32);
    const safeHeight = 80.0;

    double currentY = 16;

    for (final type in WidgetType.values) {
      if (type == WidgetType.settings) {
        positions[type] = WidgetPosition(
          type: type,
          x: containerSize.width - 64,
          y: 16,
          width: 48,
          height: 48,
        );
      } else {
        positions[type] = WidgetPosition(
          type: type,
          x: 16,
          y: currentY,
          width: safeWidth.toDouble(),
          height: safeHeight,
        );
        currentY += safeHeight + 8;
      }
    }

    return positions;
  }

  /// 调整位置到屏幕边界内
  Offset adjustPositionToScreen(
    double x,
    double y,
    double width,
    double height,
    Size containerSize,
  ) {
    final adjustedX =
        x.clamp(0.0, math.max(0.0, containerSize.width - width)).toDouble();
    final adjustedY =
        y.clamp(0.0, math.max(0.0, containerSize.height - height)).toDouble();
    return Offset(adjustedX, adjustedY);
  }

  /// 获取组件默认高度
  double _getDefaultHeight(WidgetType type) {
    switch (type) {
      case WidgetType.time:
        return 50;
      case WidgetType.date:
        return 50;
      case WidgetType.week:
        return 45;
      case WidgetType.weather:
        return 130; // 增加高度
      case WidgetType.currentClass:
        return 90;
      case WidgetType.countdown:
        return 90;
      case WidgetType.timetable:
        return 140; // 减小高度
      case WidgetType.settings:
        return 48;
    }
  }
}

/// 碰撞检测器
class CollisionDetector {
  /// 检测布局中的碰撞
  List<WidgetType> detectCollisions(Map<WidgetType, WidgetPosition> layout) {
    final collisions = <WidgetType>[];
    final positions = layout.values.where((p) => p.isVisible).toList();

    for (int i = 0; i < positions.length; i++) {
      for (int j = i + 1; j < positions.length; j++) {
        if (_isOverlapping(positions[i], positions[j])) {
          collisions.add(positions[i].type);
          collisions.add(positions[j].type);
        }
      }
    }

    return collisions.toSet().toList();
  }

  /// 解决碰撞问题
  Map<WidgetType, WidgetPosition> resolveCollisions(
    Map<WidgetType, WidgetPosition> layout,
    Size containerSize,
  ) {
    final resolvedLayout = Map<WidgetType, WidgetPosition>.from(layout);
    final collisions = detectCollisions(resolvedLayout);

    if (collisions.isEmpty) return resolvedLayout;

    // 使用流式布局解决碰撞
    return _applyFlowLayout(resolvedLayout, containerSize);
  }

  /// 检查两个组件是否重叠
  bool _isOverlapping(WidgetPosition a, WidgetPosition b) {
    return !(a.x + a.width <= b.x ||
        b.x + b.width <= a.x ||
        a.y + a.height <= b.y ||
        b.y + b.height <= a.y);
  }

  /// 获取组件默认高度
  double _getDefaultHeight(WidgetType type) {
    switch (type) {
      case WidgetType.time:
        return 50;
      case WidgetType.date:
        return 50;
      case WidgetType.week:
        return 45;
      case WidgetType.weather:
        return 130; // 增加高度
      case WidgetType.currentClass:
        return 90;
      case WidgetType.countdown:
        return 90;
      case WidgetType.timetable:
        return 140; // 减小高度
      case WidgetType.settings:
        return 48;
    }
  }

  /// 应用流式布局解决重叠 - 使用单列垂直布局
  Map<WidgetType, WidgetPosition> _applyFlowLayout(
    Map<WidgetType, WidgetPosition> layout,
    Size containerSize,
  ) {
    final flowLayout = <WidgetType, WidgetPosition>{};
    const padding = 16.0;
    const spacing = 16.0; // 增加间距

    // 使用更小的卡片宽度，让组件更紧凑
    final cardWidth = math.min(containerSize.width - 2 * padding, 300);

    // 按Y坐标排序
    final sortedEntries = layout.entries.toList()
      ..sort((a, b) => a.value.y.compareTo(b.value.y));

    double currentY = padding;

    // 保存settings按钮，最后处理
    WidgetType? settingsKey;
    WidgetPosition? settingsPosition;

    for (final entry in sortedEntries) {
      if (!entry.value.isVisible) {
        flowLayout[entry.key] = entry.value;
        continue;
      }

      // 保存settings按钮，最后处理
      if (entry.key == WidgetType.settings) {
        settingsKey = entry.key;
        settingsPosition = entry.value;
        continue;
      }

      final position = entry.value;

      // 确保组件高度合理
      final preferredHeight = _getDefaultHeight(position.type);
      final remainingHeight = containerSize.height - currentY - padding;

      // 如果剩余高度不足，使用剩余空间或最小高度
      final adjustedHeight = remainingHeight > preferredHeight
          ? preferredHeight
          : math.max(50, remainingHeight);

      // 只有在完全没有空间时才隐藏组件
      final isVisible = remainingHeight >= 50;

      flowLayout[entry.key] = WidgetPosition(
        type: position.type,
        x: padding,
        y: currentY,
        width: cardWidth.toDouble(),
        height: adjustedHeight.toDouble(),
        isVisible: isVisible,
      );

      // 只有可见的组件才更新Y坐标
      if (isVisible) {
        currentY += adjustedHeight + spacing;
      }
    }

    // 最后处理settings按钮，确保不会与其他组件重叠
    if (settingsKey != null && settingsPosition != null) {
      // 将settings按钮放置在右下角，确保不会溢出
      final settingsX =
          math.max(0, containerSize.width - padding - settingsPosition.width);
      final settingsY =
          math.max(0, containerSize.height - padding - settingsPosition.height);

      flowLayout[settingsKey] = WidgetPosition(
        type: settingsPosition.type,
        x: settingsX.toDouble(),
        y: settingsY.toDouble(),
        width: settingsPosition.width,
        height: settingsPosition.height,
        isVisible: settingsPosition.isVisible,
      );
    }

    return flowLayout;
  }
}

/// 布局验证器
class LayoutValidator {
  /// 验证整个布局的有效性
  bool validateLayout(
    Map<WidgetType, WidgetPosition> layout,
    Size containerSize,
  ) {
    // 检查所有组件是否在边界内
    for (final position in layout.values) {
      if (!isPositionValid(position, containerSize)) {
        return false;
      }
    }

    // 检查是否有重叠
    final collisionDetector = CollisionDetector();
    final collisions = collisionDetector.detectCollisions(layout);

    return collisions.isEmpty;
  }

  /// 验证单个位置是否有效
  bool isPositionValid(WidgetPosition position, Size containerSize) {
    // 检查边界
    if (position.x < 0 || position.y < 0) return false;
    if (position.x + position.width > containerSize.width) return false;
    if (position.y + position.height > containerSize.height) return false;

    // 检查尺寸
    if (position.width < 50 || position.height < 50) return false;
    if (position.width > containerSize.width ||
        position.height > containerSize.height) {
      return false;
    }

    return true;
  }

  /// 验证布局配置
  bool validateLayoutConfiguration(Size containerSize) {
    return containerSize.width >= 200 && containerSize.height >= 400;
  }
}
