import 'package:flutter_test/flutter_test.dart';
import 'package:time_widgets/services/desktop_widget_service.dart';
import 'package:flutter/material.dart';

void main() {
  group('DesktopWidgetService', () {
    test('should provide default positions for all widget types', () {
      const screenSize = Size(1920, 1080);
      final defaultPositions = DesktopWidgetService.getDefaultPositions(screenSize);
      
      // 验证所有小组件类型都有默认位置
      for (final type in WidgetType.values) {
        expect(defaultPositions.containsKey(type), true, 
               reason: 'Missing default position for $type');
        
        final position = defaultPositions[type]!;
        expect(position.type, equals(type));
        expect(position.x, greaterThanOrEqualTo(0));
        expect(position.y, greaterThanOrEqualTo(0));
        expect(position.width, greaterThan(0));
        expect(position.height, greaterThan(0));
        expect(position.isVisible, true);
        
        // 验证位置在窗口区域内（现在直接使用窗口宽度）
        expect(position.x + position.width, lessThanOrEqualTo(screenSize.width));
        expect(position.y + position.height, lessThanOrEqualTo(screenSize.height));
      }
    });

    test('should get correct default sizes', () {
      const screenSize = Size(1920, 1080);
      for (final type in WidgetType.values) {
        final size = DesktopWidgetService.getDefaultSize(type);
        expect(size.width, greaterThan(0));
        expect(size.height, greaterThan(0));
        
        // 验证尺寸合理（不超过窗口宽度）
        expect(size.width, lessThanOrEqualTo(screenSize.width));
      }
    });

    test('should validate positions correctly', () {
      const screenSize = Size(1920, 1080);
      
      // 有效位置
      expect(DesktopWidgetService.isPositionValid(0, 0, 100, 100, screenSize), true);
      expect(DesktopWidgetService.isPositionValid(100, 100, 200, 200, screenSize), true);
      
      // 无效位置 - 超出边界
      expect(DesktopWidgetService.isPositionValid(-10, 0, 100, 100, screenSize), false);
      expect(DesktopWidgetService.isPositionValid(0, -10, 100, 100, screenSize), false);
      expect(DesktopWidgetService.isPositionValid(1900, 0, 100, 100, screenSize), false);
      expect(DesktopWidgetService.isPositionValid(0, 1000, 100, 100, screenSize), false);
    });

    test('should adjust positions to screen bounds', () {
      const screenSize = Size(1920, 1080);
      
      // 测试调整到左上角
      var adjusted = DesktopWidgetService.adjustPositionToScreen(-10, -10, 100, 100, screenSize);
      expect(adjusted.dx, equals(0));
      expect(adjusted.dy, equals(0));
      
      // 测试调整到右下角
      adjusted = DesktopWidgetService.adjustPositionToScreen(2000, 1200, 100, 100, screenSize);
      expect(adjusted.dx, equals(1820)); // 1920 - 100
      expect(adjusted.dy, equals(980));  // 1080 - 100
      
      // 测试有效位置不变
      adjusted = DesktopWidgetService.adjustPositionToScreen(100, 100, 100, 100, screenSize);
      expect(adjusted.dx, equals(100));
      expect(adjusted.dy, equals(100));
    });

    test('WidgetPosition should serialize and deserialize correctly', () {
      final original = WidgetPosition(
        type: WidgetType.weather,
        x: 100.5,
        y: 200.7,
        width: 300.0,
        height: 150.0,
        isVisible: false,
      );
      
      final json = original.toJson();
      final deserialized = WidgetPosition.fromJson(json);
      
      expect(deserialized.type, equals(original.type));
      expect(deserialized.x, equals(original.x));
      expect(deserialized.y, equals(original.y));
      expect(deserialized.width, equals(original.width));
      expect(deserialized.height, equals(original.height));
      expect(deserialized.isVisible, equals(original.isVisible));
    });

    test('WidgetPosition should handle invalid JSON gracefully', () {
      final invalidJson = {
        'type': 'invalid_type',
        'x': 'not_a_number',
        'y': null,
        'width': -100,
        'height': 'invalid',
        'isVisible': 'not_a_bool',
      };
      
      final position = WidgetPosition.fromJson(invalidJson);
      
      // 应该使用默认值或限制在合理范围内
      expect(position.type, equals(WidgetType.time));
      expect(position.x, equals(0.0));
      expect(position.y, equals(0.0));
      expect(position.width, equals(50.0)); // -100 被限制为最小值50
      expect(position.height, equals(120.0)); // 无效值使用默认值120.0
      expect(position.isVisible, equals(true));
    });
  });
}