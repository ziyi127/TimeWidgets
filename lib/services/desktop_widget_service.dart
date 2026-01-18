import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:time_widgets/services/enhanced_layout_engine.dart';
import 'package:time_widgets/utils/logger.dart';

/// 小组件类型枚举
enum WidgetType {
  time,
  date,
  week,
  weather,
  currentClass,
  countdown,
  timetable,
  settings,
}

/// 小组件位置信息
class WidgetPosition {
  WidgetPosition({
    required this.type,
    required this.x,
    required this.y,
    required this.width,
    required this.height,
    this.isVisible = true,
  });

  factory WidgetPosition.fromJson(Map<String, dynamic> json) {
    return WidgetPosition(
      type: WidgetType.values.firstWhere(
        (e) => e.name == json['type'],
        orElse: () => WidgetType.time,
      ),
      x: _parseDouble(json['x']) ?? 0.0,
      y: _parseDouble(json['y']) ?? 0.0,
      width: (_parseDouble(json['width']) ?? 280.0).clamp(50.0, 2000.0),
      height: (_parseDouble(json['height']) ?? 120.0).clamp(50.0, 1500.0),
      isVisible: json['isVisible'] is bool ? (json['isVisible'] as bool) : true,
    );
  }
  final WidgetType type;
  final double x;
  final double y;
  final double width;
  final double height;
  final bool isVisible;

  WidgetPosition copyWith({
    WidgetType? type,
    double? x,
    double? y,
    double? width,
    double? height,
    bool? isVisible,
  }) {
    return WidgetPosition(
      type: type ?? this.type,
      x: x ?? this.x,
      y: y ?? this.y,
      width: width ?? this.width,
      height: height ?? this.height,
      isVisible: isVisible ?? this.isVisible,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'type': type.name,
      'x': x,
      'y': y,
      'width': width,
      'height': height,
      'isVisible': isVisible,
    };
  }

  static double? _parseDouble(dynamic value) {
    if (value == null) return null;
    if (value is double) return value;
    if (value is int) return value.toDouble();
    if (value is String) {
      return double.tryParse(value);
    }
    return null;
  }
}

/// 桌面小组件服务
/// 管理桌面小组件的位置、可见性和配置
class DesktopWidgetService {
  static const String _positionsKey = 'desktop_widget_positions';

  // 使用增强的布局引擎
  static final EnhancedLayoutEngine _layoutEngine = EnhancedLayoutEngine();

  /// 默认小组件位置配置（使用增强布局引擎）
  static Map<WidgetType, WidgetPosition> getDefaultPositions(
      [Size? screenSize]) {
    final containerSize = screenSize != null
        ? Size(screenSize.width / 4, screenSize.height)
        : const Size(480, 1080);

    return _layoutEngine.calculateOptimalLayout(containerSize, null);
  }

  /// 保存小组件位置
  static Future<void> saveWidgetPositions(
      Map<WidgetType, WidgetPosition> positions) async {
    final prefs = await SharedPreferences.getInstance();
    final positionsJson = positions.map(
      (key, value) => MapEntry(key.name, value.toJson()),
    );
    await prefs.setString(_positionsKey, json.encode(positionsJson));
  }

  /// 加载小组件位置（使用增强布局引擎）
  static Future<Map<WidgetType, WidgetPosition>> loadWidgetPositions(
      [Size? screenSize]) async {
    final prefs = await SharedPreferences.getInstance();
    final positionsString = prefs.getString(_positionsKey);

    final containerSize = screenSize != null
        ? Size(screenSize.width / 4, screenSize.height)
        : const Size(480, 1080);

    if (positionsString == null) {
      return _layoutEngine.calculateOptimalLayout(containerSize, null);
    }

    try {
      final positionsJson =
          json.decode(positionsString) as Map<String, dynamic>;
      final savedPositions = <WidgetType, WidgetPosition>{};

      for (final entry in positionsJson.entries) {
        final type = WidgetType.values.firstWhere(
          (e) => e.name == entry.key,
          orElse: () => WidgetType.time,
        );
        savedPositions[type] =
            WidgetPosition.fromJson(entry.value as Map<String, dynamic>);
      }

      // 使用布局引擎计算最优布局，考虑已保存的位置
      final optimizedLayout =
          _layoutEngine.calculateOptimalLayout(containerSize, savedPositions);

      // 验证布局有效性
      if (_layoutEngine.validateLayout(optimizedLayout, containerSize)) {
        return optimizedLayout;
      } else {
        Logger.w('Saved layout is invalid, using default layout');
        return _layoutEngine.calculateOptimalLayout(containerSize, null);
      }
    } catch (e) {
      Logger.e('Error loading widget positions: $e');
      return _layoutEngine.calculateOptimalLayout(containerSize, null);
    }
  }

  /// 更新单个小组件位置
  static Future<void> updateWidgetPosition(
    WidgetType type,
    double x,
    double y, {
    double? width,
    double? height,
  }) async {
    final positions = await loadWidgetPositions();
    final currentPosition = positions[type];

    if (currentPosition != null) {
      positions[type] = WidgetPosition(
        type: type,
        x: x,
        y: y,
        width: width ?? currentPosition.width,
        height: height ?? currentPosition.height,
        isVisible: currentPosition.isVisible,
      );

      await saveWidgetPositions(positions);
    }
  }

  /// 切换小组件可见性
  static Future<void> toggleWidgetVisibility(WidgetType type) async {
    final positions = await loadWidgetPositions();
    final currentPosition = positions[type];

    if (currentPosition != null) {
      positions[type] = WidgetPosition(
        type: type,
        x: currentPosition.x,
        y: currentPosition.y,
        width: currentPosition.width,
        height: currentPosition.height,
        isVisible: !currentPosition.isVisible,
      );

      await saveWidgetPositions(positions);
    }
  }

  /// 重置所有小组件位置
  static Future<void> resetWidgetPositions() async {
    await saveWidgetPositions(getDefaultPositions());
  }

  /// 获取小组件的默认尺寸
  static Size getDefaultSize(WidgetType type) {
    final defaultPositions = getDefaultPositions();
    final position = defaultPositions[type];
    return position != null
        ? Size(position.width, position.height)
        : const Size(280, 80); // 默认尺寸
  }

  /// 检查位置是否在屏幕边界内
  static bool isPositionValid(
      double x, double y, double width, double height, Size screenSize) {
    return x >= 0 &&
        y >= 0 &&
        x + width <= screenSize.width &&
        y + height <= screenSize.height;
  }

  /// 调整位置到屏幕边界内（使用增强布局引擎）
  static Offset adjustPositionToScreen(
      double x, double y, double width, double height, Size screenSize) {
    final containerSize = Size(screenSize.width / 4, screenSize.height);
    final positionCalculator = PositionCalculator();
    return positionCalculator.adjustPositionToScreen(
        x, y, width, height, containerSize);
  }

  /// 检测布局碰撞
  static List<WidgetType> detectCollisions(
      Map<WidgetType, WidgetPosition> layout) {
    return _layoutEngine.detectCollisions(layout);
  }

  /// 调整布局以适应新屏幕尺寸
  static Map<WidgetType, WidgetPosition> adjustLayoutForScreenSize(
    Map<WidgetType, WidgetPosition> currentLayout,
    Size oldSize,
    Size newSize,
  ) {
    return _layoutEngine.adjustForScreenSize(currentLayout, oldSize, newSize);
  }
}
