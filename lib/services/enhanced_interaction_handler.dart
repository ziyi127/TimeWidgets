import 'package:flutter/material.dart';
import 'package:time_widgets/services/desktop_widget_service.dart';
import 'dart:math' as math;

/// 增强的交互处理器
/// 提供流畅的拖拽、点击和编辑模式交互
class EnhancedInteractionHandler {
  /// 拖拽状态管理
  static final Map<WidgetType, DragState> _dragStates = {};
  
  /// 处理拖拽开始
  static void handleDragStart(WidgetType type, Offset startPosition) {
    _dragStates[type] = DragState(
      startPosition: startPosition,
      currentPosition: startPosition,
      isDragging: true,
      startTime: DateTime.now(),
    );
    
    print('Drag started for $type at $startPosition');
  }

  /// 处理拖拽更新
  static void handleDragUpdate(WidgetType type, Offset currentPosition) {
    final state = _dragStates[type];
    if (state != null) {
      _dragStates[type] = state.copyWith(currentPosition: currentPosition);
    }
  }

  /// 处理拖拽结束
  static DragResult handleDragEnd({
    required WidgetType type,
    required Offset endPosition,
    required Size widgetSize,
    required Size containerSize,
    required Map<WidgetType, WidgetPosition> currentLayout,
  }) {
    final state = _dragStates[type];
    if (state == null) {
      return DragResult(
        finalPosition: endPosition,
        wasSuccessful: false,
        message: '拖拽状态无效',
      );
    }

    try {
      // 计算拖拽距离和时间
      final dragDistance = _calculateDistance(state.startPosition, endPosition);
      final dragDuration = DateTime.now().difference(state.startTime);
      
      // 如果拖拽距离很小且时间很短，可能是点击而不是拖拽
      if (dragDistance < 10 && dragDuration.inMilliseconds < 200) {
        _dragStates.remove(type);
        return DragResult(
          finalPosition: state.startPosition,
          wasSuccessful: false,
          message: '检测到点击而非拖拽',
        );
      }

      // 调整位置到容器边界内
      final adjustedPosition = _adjustToContainerBounds(
        endPosition, 
        widgetSize, 
        containerSize
      );

      // 检测碰撞并寻找最佳位置
      final optimalPosition = _findOptimalPosition(
        type: type,
        desiredPosition: adjustedPosition,
        widgetSize: widgetSize,
        containerSize: containerSize,
        currentLayout: currentLayout,
      );

      // 清理拖拽状态
      _dragStates.remove(type);

      return DragResult(
        finalPosition: optimalPosition.position,
        wasSuccessful: true,
        message: optimalPosition.message,
        hadCollision: optimalPosition.hadCollision,
      );

    } catch (e) {
      _dragStates.remove(type);
      return DragResult(
        finalPosition: endPosition,
        wasSuccessful: false,
        message: '拖拽处理失败: $e',
      );
    }
  }

  /// 处理小组件点击
  static ClickResult handleWidgetClick({
    required WidgetType type,
    required Offset position,
    required BuildContext context,
  }) {
    try {
      // 根据小组件类型执行相应操作
      switch (type) {
        case WidgetType.settings:
          return ClickResult(
            wasHandled: true,
            action: ClickAction.navigate,
            message: '打开设置页面',
          );
        
        case WidgetType.weather:
          return ClickResult(
            wasHandled: true,
            action: ClickAction.refresh,
            message: '刷新天气信息',
          );
        
        case WidgetType.countdown:
          return ClickResult(
            wasHandled: true,
            action: ClickAction.expand,
            message: '展开倒计时详情',
          );
        
        case WidgetType.timetable:
          return ClickResult(
            wasHandled: true,
            action: ClickAction.navigate,
            message: '打开课程表编辑',
          );
        
        default:
          return ClickResult(
            wasHandled: false,
            action: ClickAction.none,
            message: '无可用操作',
          );
      }
    } catch (e) {
      return ClickResult(
        wasHandled: false,
        action: ClickAction.none,
        message: '点击处理失败: $e',
      );
    }
  }

  /// 处理编辑模式切换
  static EditModeResult handleEditModeToggle({
    required bool currentEditMode,
    required Map<WidgetType, WidgetPosition> currentLayout,
    required Size containerSize,
  }) {
    try {
      final newEditMode = !currentEditMode;
      
      if (newEditMode) {
        // 进入编辑模式 - 验证当前布局
        final validationResult = _validateLayoutForEditing(currentLayout, containerSize);
        
        return EditModeResult(
          newEditMode: newEditMode,
          wasSuccessful: true,
          message: validationResult.isValid 
              ? '已进入编辑模式' 
              : '已进入编辑模式，检测到布局问题: ${validationResult.issues.join(", ")}',
          layoutIssues: validationResult.issues,
        );
      } else {
        // 退出编辑模式 - 保存并验证最终布局
        final finalValidation = _validateFinalLayout(currentLayout, containerSize);
        
        return EditModeResult(
          newEditMode: newEditMode,
          wasSuccessful: finalValidation.isValid,
          message: finalValidation.isValid 
              ? '已退出编辑模式，布局已保存' 
              : '退出编辑模式时发现问题: ${finalValidation.issues.join(", ")}',
          layoutIssues: finalValidation.issues,
        );
      }
    } catch (e) {
      return EditModeResult(
        newEditMode: currentEditMode, // 保持原状态
        wasSuccessful: false,
        message: '编辑模式切换失败: $e',
        layoutIssues: ['系统错误'],
      );
    }
  }

  /// 获取拖拽状态
  static DragState? getDragState(WidgetType type) {
    return _dragStates[type];
  }

  /// 清理所有拖拽状态
  static void clearAllDragStates() {
    _dragStates.clear();
  }

  /// 计算两点间距离
  static double _calculateDistance(Offset point1, Offset point2) {
    final dx = point1.dx - point2.dx;
    final dy = point1.dy - point2.dy;
    return math.sqrt(dx * dx + dy * dy);
  }

  /// 调整位置到容器边界内
  static Offset _adjustToContainerBounds(
    Offset position, 
    Size widgetSize, 
    Size containerSize
  ) {
    final adjustedX = position.dx.clamp(0.0, containerSize.width - widgetSize.width);
    final adjustedY = position.dy.clamp(0.0, containerSize.height - widgetSize.height);
    return Offset(adjustedX, adjustedY);
  }

  /// 寻找最佳位置（避免碰撞）
  static OptimalPositionResult _findOptimalPosition({
    required WidgetType type,
    required Offset desiredPosition,
    required Size widgetSize,
    required Size containerSize,
    required Map<WidgetType, WidgetPosition> currentLayout,
  }) {
    // 创建测试布局
    final testLayout = Map<WidgetType, WidgetPosition>.from(currentLayout);
    testLayout[type] = WidgetPosition(
      type: type,
      x: desiredPosition.dx,
      y: desiredPosition.dy,
      width: widgetSize.width,
      height: widgetSize.height,
      isVisible: true,
    );

    // 检测碰撞
    final collisions = DesktopWidgetService.detectCollisions(testLayout);
    
    if (!collisions.contains(type)) {
      // 无碰撞，使用期望位置
      return OptimalPositionResult(
        position: desiredPosition,
        hadCollision: false,
        message: '位置已更新',
      );
    }

    // 有碰撞，寻找最近的有效位置
    final nearestValidPosition = _findNearestValidPosition(
      type: type,
      desiredPosition: desiredPosition,
      widgetSize: widgetSize,
      containerSize: containerSize,
      currentLayout: currentLayout,
    );

    return OptimalPositionResult(
      position: nearestValidPosition ?? desiredPosition,
      hadCollision: true,
      message: nearestValidPosition != null 
          ? '已调整到最近的有效位置' 
          : '无法找到有效位置，保持原位置',
    );
  }

  /// 寻找最近的有效位置
  static Offset? _findNearestValidPosition({
    required WidgetType type,
    required Offset desiredPosition,
    required Size widgetSize,
    required Size containerSize,
    required Map<WidgetType, WidgetPosition> currentLayout,
  }) {
    const searchRadius = 50.0;
    const step = 10.0;
    
    for (double radius = step; radius <= searchRadius; radius += step) {
      // 在圆周上搜索
      for (double angle = 0; angle < 2 * math.pi; angle += math.pi / 8) {
        final testX = desiredPosition.dx + radius * math.cos(angle);
        final testY = desiredPosition.dy + radius * math.sin(angle);
        
        final testPosition = _adjustToContainerBounds(
          Offset(testX, testY),
          widgetSize,
          containerSize,
        );
        
        // 测试这个位置是否有效
        final testLayout = Map<WidgetType, WidgetPosition>.from(currentLayout);
        testLayout[type] = WidgetPosition(
          type: type,
          x: testPosition.dx,
          y: testPosition.dy,
          width: widgetSize.width,
          height: widgetSize.height,
          isVisible: true,
        );
        
        final collisions = DesktopWidgetService.detectCollisions(testLayout);
        if (!collisions.contains(type)) {
          return testPosition;
        }
      }
    }
    
    return null; // 找不到有效位置
  }

  /// 验证布局是否适合编辑
  static ValidationResult _validateLayoutForEditing(
    Map<WidgetType, WidgetPosition> layout,
    Size containerSize,
  ) {
    final issues = <String>[];
    
    // 检查边界
    for (final entry in layout.entries) {
      final position = entry.value;
      if (position.x + position.width > containerSize.width ||
          position.y + position.height > containerSize.height) {
        issues.add('${entry.key.name}超出边界');
      }
    }
    
    // 检查碰撞
    final collisions = DesktopWidgetService.detectCollisions(layout);
    if (collisions.isNotEmpty) {
      issues.add('检测到${collisions.length}个组件重叠');
    }
    
    return ValidationResult(
      isValid: issues.isEmpty,
      issues: issues,
    );
  }

  /// 验证最终布局
  static ValidationResult _validateFinalLayout(
    Map<WidgetType, WidgetPosition> layout,
    Size containerSize,
  ) {
    // 使用相同的验证逻辑
    return _validateLayoutForEditing(layout, containerSize);
  }
}

/// 拖拽状态
class DragState {
  final Offset startPosition;
  final Offset currentPosition;
  final bool isDragging;
  final DateTime startTime;

  DragState({
    required this.startPosition,
    required this.currentPosition,
    required this.isDragging,
    required this.startTime,
  });

  DragState copyWith({
    Offset? startPosition,
    Offset? currentPosition,
    bool? isDragging,
    DateTime? startTime,
  }) {
    return DragState(
      startPosition: startPosition ?? this.startPosition,
      currentPosition: currentPosition ?? this.currentPosition,
      isDragging: isDragging ?? this.isDragging,
      startTime: startTime ?? this.startTime,
    );
  }
}

/// 拖拽结果
class DragResult {
  final Offset finalPosition;
  final bool wasSuccessful;
  final String message;
  final bool hadCollision;

  DragResult({
    required this.finalPosition,
    required this.wasSuccessful,
    required this.message,
    this.hadCollision = false,
  });
}

/// 点击结果
class ClickResult {
  final bool wasHandled;
  final ClickAction action;
  final String message;

  ClickResult({
    required this.wasHandled,
    required this.action,
    required this.message,
  });
}

/// 点击动作类型
enum ClickAction {
  none,
  navigate,
  refresh,
  expand,
  edit,
}

/// 编辑模式结果
class EditModeResult {
  final bool newEditMode;
  final bool wasSuccessful;
  final String message;
  final List<String> layoutIssues;

  EditModeResult({
    required this.newEditMode,
    required this.wasSuccessful,
    required this.message,
    required this.layoutIssues,
  });
}

/// 最佳位置结果
class OptimalPositionResult {
  final Offset position;
  final bool hadCollision;
  final String message;

  OptimalPositionResult({
    required this.position,
    required this.hadCollision,
    required this.message,
  });
}

/// 验证结果
class ValidationResult {
  final bool isValid;
  final List<String> issues;

  ValidationResult({
    required this.isValid,
    required this.issues,
  });
}