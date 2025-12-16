import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:glados/glados.dart' hide group, expect, test;
import 'package:time_widgets/services/enhanced_layout_engine.dart';


/// **Feature: desktop-widget-layout-fix**
/// **Property 1: No Overlap Layout Guarantee**
/// **Property 2: Screen Adaptation Consistency**
/// **Validates: Requirements 1.2, 1.4, 2.4, 5.3**
void main() {
  final engine = EnhancedLayoutEngine();

  group('EnhancedLayoutEngine Properties', () {
    // Property 1: No Overlap Layout Guarantee
    Glados(any.combine2(
      any.doubleInRange(1000, 4000), // Screen width
      any.doubleInRange(600, 2000), // Screen height
      (width, height) => [width, height],
    )).test(
      'calculateOptimalLayout should produce non-overlapping widgets',
      (screenDims) {
        final screenSize = Size(screenDims[0], screenDims[1]);
        final layout = engine.calculateOptimalLayout(screenSize, null);

        // Check for overlaps
        final positions = layout.values.toList();
        for (var i = 0; i < positions.length; i++) {
          for (var j = i + 1; j < positions.length; j++) {
            final rect1 = Rect.fromLTWH(
              positions[i].x,
              positions[i].y,
              positions[i].width,
              positions[i].height,
            );
            final rect2 = Rect.fromLTWH(
              positions[j].x,
              positions[j].y,
              positions[j].width,
              positions[j].height,
            );

            // Using a small epsilon for floating point comparisons if needed,
            // but Rect.overlaps handles it. However, touching edges usually don't count as overlap.
            // Let's assume strict non-overlap (intersection should be empty or zero area).
            // Actually, Rect.overlaps returns true if they intersect.
            // We allow touching edges.
            
            final overlap = rect1.intersect(rect2);
            // If overlap width or height is <= 0, they don't overlap visually
            final hasOverlap = overlap.width > 0.01 && overlap.height > 0.01;

            expect(hasOverlap, isFalse,
                reason:
                    'Widgets ${positions[i].type} and ${positions[j].type} overlap. \nRect1: $rect1 \nRect2: $rect2');
          }
        }
      },
    );

    // Property 2: Screen Adaptation Consistency
    Glados(any.combine3(
      any.doubleInRange(1000, 2000), // Old width
      any.doubleInRange(2001, 4000), // New width
      any.doubleInRange(600, 2000),  // Height (assume constant for simplicity or vary it)
      (oldW, newW, h) => [oldW, newW, h],
    )).test(
      'adjustForScreenSize should keep widgets within bounds',
      (dims) {
        final oldSize = Size(dims[0], dims[2]);
        final newSize = Size(dims[1], dims[2]);
        
        final initialLayout = engine.calculateOptimalLayout(oldSize, null);
        final adjustedLayout = engine.adjustForScreenSize(initialLayout, oldSize, newSize);
        
        // 使用与代码相同的方式计算容器大小
        // 根据屏幕尺寸动态调整容器大小
        double containerWidth;
        if (newSize.width > 1920) {
          containerWidth = newSize.width / 3;
        } else if (newSize.width > 1440) {
          containerWidth = newSize.width / 3.5;
        } else {
          containerWidth = newSize.width / 4;
        }
        final containerHeight = newSize.height;

        for (final position in adjustedLayout.values) {
          // Check if widget is within container bounds
          expect(position.x, greaterThanOrEqualTo(0));
          expect(position.y, greaterThanOrEqualTo(0));
          expect(position.x + position.width, lessThanOrEqualTo(containerWidth + 0.1)); // Add epsilon
          expect(position.y + position.height, lessThanOrEqualTo(containerHeight + 0.1));
          
          // Check size constraints
          expect(position.width, greaterThanOrEqualTo(50.0));
          expect(position.height, greaterThanOrEqualTo(50.0));
        }
      },
    );
  });
}
