import 'package:flutter/material.dart';
import 'package:time_widgets/services/desktop_widget_service.dart';
import 'dart:math' as math;

/// 增强的布局引擎
/// 提供智能位置计算、碰撞检测和自适应布局功能
class EnhancedLayoutEngine {
  static const double _minSpacing = 8.0;
  static const double _defaultSpacing = 12.0;
  static const double _minWidgetSize = 50.0;
  static const double _maxWidgetSize = 500.0;
  
  /// 位置计算器
  final PositionCalculator _positionCalculator = PositionCalculator();
  
  /// 碰撞检测器
  final CollisionDetector _collisionDetector = CollisionDetector();
  
  /// 布局验证器
  final LayoutValidator _layoutValidator = LayoutValidator();

  /// 计算最优布局
  Map<WidgetType, WidgetPosition> calculateOptimalLayout(
    Size screenSize, 
    Map<WidgetType, WidgetPosition>? currentLayout
  ) {
    try {
      // 1. 计算容器尺寸（屏幕右侧1/4）
      final containerSize = Size(screenSize.width / 4, screenSize.height);
      
      // 2. 生成默认位置
      var layout = _positionCalculator.calculateDefaultPositions(containerSize);
      
      // 3. 如果有现有布局，尝试保留有效位置
      if (currentLayout != null) {
        layout = _mergeWithExistingLayout(layout, currentLayout, containerSize);
      }
      
      // 4. 解决碰撞问题
      layout = _collisionDetector.resolveCollisions(layout, containerSize);
      
      // 5. 验证布局有效性
      if (!_layoutValidator.validateLayout(layout, containerSize)) {
        // 如果验证失败，使用安全的默认布局
        layout = _positionCalculator.calculateSafeDefaultLayout(containerSize);
      }
      
      return layout;
    } catch (e) {
      print('Layout calculation failed: $e');
      // 返回安全的默认布局
      return _positionCalculator.calculateSafeDefaultLayout(
        Size(screenSize.width / 4, screenSize.height)
      );
    }
  }

  /// 检测布局中的碰撞
  List<WidgetType> detectCollisions(Map<WidgetType, WidgetPosition> layout) {
    return _collisionDetector.detectCollisions(layout);
  }

  /// 调整布局以适应新的屏幕尺寸
  Map<WidgetType, WidgetPosition> adjustForScreenSize(
    Map<WidgetType, WidgetPosition> currentLayout,
    Size oldSize,
    Size newSize
  ) {
    final newContainerSize = Size(newSize.width / 4, newSize.height);
    final oldContainerSize = Size(oldSize.width / 4, oldSize.height);
    
    // 计算缩放比例
    final scaleX = newContainerSize.width / oldContainerSize.width;
    final scaleY = newContainerSize.height / oldContainerSize.height;
    
    final adjustedLayout = <WidgetType, WidgetPosition>{};
    
    for (final entry in currentLayout.entries) {
      final position = entry.value;
      
      // 按比例调整位置和尺寸
      final newX = (position.x * scaleX).clamp(0.0, (newContainerSize.width - position.width).toDouble());
      final newY = (position.y * scaleY).clamp(0.0, (newContainerSize.height - position.height).toDouble());
      final newWidth = (position.width * scaleX).clamp(_minWidgetSize, _maxWidgetSize);
      final newHeight = (position.height * scaleY).clamp(_minWidgetSize, _maxWidgetSize);
      
      adjustedLayout[entry.key] = WidgetPosition(
        type: position.type,
        x: newX,
        y: newY,
        width: newWidth,
        height: newHeight,
        isVisible: position.isVisible,
      );
    }
    
    // 解决调整后可能出现的碰撞
    return _collisionDetector.resolveCollisions(adjustedLayout, newContainerSize);
  }

  /// 验证布局有效性
  bool validateLayout(Map<WidgetType, WidgetPosition> layout, Size containerSize) {
    return _layoutValidator.validateLayout(layout, containerSize);
  }

  /// 合并现有布局和默认布局
  Map<WidgetType, WidgetPosition> _mergeWithExistingLayout(
    Map<WidgetType, WidgetPosition> defaultLayout,
    Map<WidgetType, WidgetPosition> existingLayout,
    Size containerSize
  ) {
    final mergedLayout = <WidgetType, WidgetPosition>{};
    
    for (final type in WidgetType.values) {
      final existing = existingLayout[type];
      final defaultPos = defaultLayout[type]!;
      
      if (existing != null && _layoutValidator.isPositionValid(existing, containerSize)) {
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
  static const double _padding = 16.0;
  static const double _spacing = 12.0;

  /// 计算默认位置
  Map<WidgetType, WidgetPosition> calculateDefaultPositions(Size containerSize) {
    final positions = <WidgetType, WidgetPosition>{};
    final cardWidth = (containerSize.width - 2 * _padding).clamp(240.0, 400.0);
    
    double currentY = _padding;
    
    // 按优先级排列组件
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
      
      positions[type] = WidgetPosition(
        type: type,
        x: _padding,
        y: currentY,
        width: cardWidth,
        height: height,
        isVisible: true,
      );
      
      currentY += height + _spacing;
    }
    
    // 设置按钮单独处理
    positions[WidgetType.settings] = WidgetPosition(
      type: WidgetType.settings,
      x: containerSize.width - _padding - 48,
      y: _padding,
      width: 48,
      height: 48,
      isVisible: true,
    );
    
    return positions;
  }

  /// 计算安全的默认布局（用于错误恢复）
  Map<WidgetType, WidgetPosition> calculateSafeDefaultLayout(Size containerSize) {
    final positions = <WidgetType, WidgetPosition>{};
    final safeWidth = math.min(280.0, containerSize.width - 32);
    final safeHeight = 80.0;
    
    double currentY = 16.0;
    
    for (final type in WidgetType.values) {
      if (type == WidgetType.settings) {
        positions[type] = WidgetPosition(
          type: type,
          x: containerSize.width - 64,
          y: 16,
          width: 48,
          height: 48,
          isVisible: true,
        );
      } else {
        positions[type] = WidgetPosition(
          type: type,
          x: 16,
          y: currentY,
          width: safeWidth,
          height: safeHeight,
          isVisible: true,
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
    Size containerSize
  ) {
    final adjustedX = x.clamp(0.0, math.max(0.0, containerSize.width - width).toDouble());
    final adjustedY = y.clamp(0.0, math.max(0.0, containerSize.height - height).toDouble());
    return Offset(adjustedX, adjustedY);
  }

  /// 获取组件默认高度
  double _getDefaultHeight(WidgetType type) {
    switch (type) {
      case WidgetType.time:
        return 100.0;
      case WidgetType.date:
        return 80.0;
      case WidgetType.week:
        return 60.0;
      case WidgetType.weather:
        return 140.0;
      case WidgetType.currentClass:
      case WidgetType.countdown:
        return 120.0;
      case WidgetType.timetable:
        return 200.0;
      case WidgetType.settings:
        return 48.0;
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
    Size containerSize
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

  /// 应用流式布局解决重叠
  Map<WidgetType, WidgetPosition> _applyFlowLayout(
    Map<WidgetType, WidgetPosition> layout,
    Size containerSize
  ) {
    final flowLayout = <WidgetType, WidgetPosition>{};
    const padding = 16.0;
    const spacing = 12.0;
    
    // 按Y坐标排序
    final sortedEntries = layout.entries.toList()
      ..sort((a, b) => a.value.y.compareTo(b.value.y));
    
    double currentY = padding;
    
    for (final entry in sortedEntries) {
      if (!entry.value.isVisible) {
        flowLayout[entry.key] = entry.value;
        continue;
      }
      
      final position = entry.value;
      
      // 特殊处理设置按钮
      if (entry.key == WidgetType.settings) {
        flowLayout[entry.key] = WidgetPosition(
          type: position.type,
          x: containerSize.width - padding - position.width,
          y: padding,
          width: position.width,
          height: position.height,
          isVisible: position.isVisible,
        );
        continue;
      }
      
      // 确保组件在容器内
      final adjustedWidth = math.min(position.width, containerSize.width - 2 * padding);
      final adjustedHeight = math.min(position.height, containerSize.height - currentY - padding);
      
      if (adjustedHeight < 50) {
        // 如果剩余空间不足，隐藏组件
        flowLayout[entry.key] = WidgetPosition(
          type: position.type,
          x: position.x,
          y: position.y,
          width: position.width,
          height: position.height,
          isVisible: false,
        );
        continue;
      }
      
      flowLayout[entry.key] = WidgetPosition(
        type: position.type,
        x: padding,
        y: currentY,
        width: adjustedWidth,
        height: adjustedHeight,
        isVisible: true,
      );
      
      currentY += adjustedHeight + spacing;
    }
    
    return flowLayout;
  }
}

/// 布局验证器
class LayoutValidator {
  /// 验证整个布局的有效性
  bool validateLayout(Map<WidgetType, WidgetPosition> layout, Size containerSize) {
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
    if (position.width > containerSize.width || position.height > containerSize.height) return false;
    
    return true;
  }

  /// 验证布局配置
  bool validateLayoutConfiguration(Size containerSize) {
    return containerSize.width >= 200 && containerSize.height >= 400;
  }
}