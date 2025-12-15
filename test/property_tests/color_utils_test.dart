import 'dart:ui';
import 'package:flutter_test/flutter_test.dart';
import 'package:glados/glados.dart' hide group, expect, test;
import 'package:time_widgets/utils/color_utils.dart';

/// **Feature: md3-settings-timetable-enhancement**
/// **Property 5: Color contrast for text readability**
/// **Property 6: Deterministic color generation from name**
/// **Validates: Requirements 14.2, 14.3**
void main() {
  group('Color Utils Properties', () {
    group('Property 6: Deterministic color generation from name', () {
      test('same name should always generate same color', () {
        const name = '数学';
        
        final color1 = ColorUtils.generateColorFromName(name);
        final color2 = ColorUtils.generateColorFromName(name);
        final color3 = ColorUtils.generateColorFromName(name);
        
        expect(color1, equals(color2));
        expect(color2, equals(color3));
      });

      test('different names should generate different colors', () {
        final color1 = ColorUtils.generateColorFromName('数学');
        final color2 = ColorUtils.generateColorFromName('语文');
        final color3 = ColorUtils.generateColorFromName('英语');
        
        // Different names should produce different colors
        expect(color1, isNot(equals(color2)));
        expect(color2, isNot(equals(color3)));
        expect(color1, isNot(equals(color3)));
      });

      test('empty name should return default color', () {
        final color = ColorUtils.generateColorFromName('');
        expect(color, equals(const Color(0xFF2196F3)));
      });

      test('similar names should generate different colors', () {
        final color1 = ColorUtils.generateColorFromName('Math');
        final color2 = ColorUtils.generateColorFromName('Math1');
        final color3 = ColorUtils.generateColorFromName('Math2');
        
        expect(color1, isNot(equals(color2)));
        expect(color2, isNot(equals(color3)));
      });

      // Property-based test
      Glados(any.intInRange(0, 1000)).test(
        'color generation should be deterministic for any string',
        (seed) {
          final name = 'Subject_$seed';
          final color1 = ColorUtils.generateColorFromName(name);
          final color2 = ColorUtils.generateColorFromName(name);
          
          expect(color1, equals(color2),
            reason: 'Same name "$name" should always produce same color');
        },
      );

      Glados(any.intInRange(0, 1000)).test(
        'generated colors should be valid (non-transparent)',
        (seed) {
          final name = 'Subject_$seed';
          final color = ColorUtils.generateColorFromName(name);
          
          expect(color.alpha, equals(255),
            reason: 'Generated color should be fully opaque');
        },
      );
    });

    group('Property 5: Color contrast for text readability', () {
      test('getContrastTextColor should return white for dark backgrounds', () {
        const darkColors = [
          Color(0xFF000000), // Black
          Color(0xFF1A1A1A), // Very dark grey
          Color(0xFF333333), // Dark grey
          Color(0xFF0D47A1), // Dark blue
          Color(0xFF1B5E20), // Dark green
          Color(0xFF4A148C), // Dark purple
        ];
        
        for (final bg in darkColors) {
          final textColor = ColorUtils.getContrastTextColor(bg);
          expect(textColor, equals(const Color(0xFFFFFFFF)),
            reason: 'Dark background ${ColorUtils.toHexString(bg)} should use white text');
        }
      });

      test('getContrastTextColor should return black for light backgrounds', () {
        const lightColors = [
          Color(0xFFFFFFFF), // White
          Color(0xFFF5F5F5), // Very light grey
          Color(0xFFE0E0E0), // Light grey
          Color(0xFFBBDEFB), // Light blue
          Color(0xFFC8E6C9), // Light green
          Color(0xFFFFEB3B), // Yellow
        ];
        
        for (final bg in lightColors) {
          final textColor = ColorUtils.getContrastTextColor(bg);
          expect(textColor, equals(const Color(0xFF000000)),
            reason: 'Light background ${ColorUtils.toHexString(bg)} should use black text');
        }
      });

      test('contrast ratio should meet WCAG AA for generated text colors', () {
        // Test with various background colors
        final testColors = [
          const Color(0xFFF44336), // Red
          const Color(0xFF2196F3), // Blue
          const Color(0xFF4CAF50), // Green
          const Color(0xFFFFEB3B), // Yellow
          const Color(0xFF9C27B0), // Purple
          const Color(0xFF607D8B), // Blue Grey
        ];
        
        for (final bg in testColors) {
          final textColor = ColorUtils.getContrastTextColor(bg);
          final ratio = ColorUtils.getContrastRatio(textColor, bg);
          
          expect(ratio, greaterThanOrEqualTo(4.5),
            reason: 'Text on ${ColorUtils.toHexString(bg)} should have at least 4.5:1 contrast ratio, got $ratio');
        }
      });

      test('contrast ratio calculation should be symmetric', () {
        const color1 = Color(0xFF000000);
        const color2 = Color(0xFFFFFFFF);
        
        final ratio1 = ColorUtils.getContrastRatio(color1, color2);
        final ratio2 = ColorUtils.getContrastRatio(color2, color1);
        
        expect(ratio1, equals(ratio2));
      });

      test('contrast ratio with same color should be 1', () {
        const color = Color(0xFF2196F3);
        final ratio = ColorUtils.getContrastRatio(color, color);
        
        expect(ratio, closeTo(1.0, 0.01));
      });

      test('black and white should have maximum contrast', () {
        const black = Color(0xFF000000);
        const white = Color(0xFFFFFFFF);
        
        final ratio = ColorUtils.getContrastRatio(black, white);
        
        // Maximum contrast ratio is 21:1
        expect(ratio, closeTo(21.0, 0.5));
      });

      // Property-based test
      Glados(any.intInRange(0, 0xFFFFFF)).test(
        'getContrastTextColor should always meet WCAG AA',
        (colorValue) {
          final bg = Color(0xFF000000 | colorValue);
          final textColor = ColorUtils.getContrastTextColor(bg);
          final ratio = ColorUtils.getContrastRatio(textColor, bg);
          
          expect(ratio, greaterThanOrEqualTo(4.5),
            reason: 'Contrast ratio for ${ColorUtils.toHexString(bg)} should be at least 4.5:1');
        },
      );

      Glados(any.intInRange(0, 100)).test(
        'generated subject colors should have readable text',
        (seed) {
          final name = 'Subject_$seed';
          final bg = ColorUtils.generateColorFromName(name);
          final textColor = ColorUtils.getContrastTextColor(bg);
          final ratio = ColorUtils.getContrastRatio(textColor, bg);
          
          expect(ratio, greaterThanOrEqualTo(4.5),
            reason: 'Generated color for "$name" should have readable text');
        },
      );
    });

    group('Hex color parsing', () {
      test('parseHexColor should handle various formats', () {
        expect(ColorUtils.parseHexColor('#FF0000'), equals(const Color(0xFFFF0000)));
        expect(ColorUtils.parseHexColor('FF0000'), equals(const Color(0xFFFF0000)));
        expect(ColorUtils.parseHexColor('#FFFF0000'), equals(const Color(0xFFFF0000)));
        expect(ColorUtils.parseHexColor('FFFF0000'), equals(const Color(0xFFFF0000)));
      });

      test('parseHexColor should return null for invalid input', () {
        expect(ColorUtils.parseHexColor('invalid'), isNull);
        expect(ColorUtils.parseHexColor(''), isNull);
        expect(ColorUtils.parseHexColor('GG0000'), isNull);
      });

      test('toHexString should produce valid hex strings', () {
        expect(ColorUtils.toHexString(const Color(0xFFFF0000)), equals('#FF0000'));
        expect(ColorUtils.toHexString(const Color(0xFF00FF00)), equals('#00FF00'));
        expect(ColorUtils.toHexString(const Color(0xFF0000FF)), equals('#0000FF'));
      });

      test('hex string round-trip should preserve color', () {
        const original = Color(0xFF2196F3);
        final hexString = ColorUtils.toHexString(original);
        final parsed = ColorUtils.parseHexColor(hexString);
        
        expect(parsed, equals(original));
      });
    });

    group('Subject color palette', () {
      test('getSubjectColorByIndex should wrap around', () {
        final paletteSize = ColorUtils.subjectColors.length;
        
        expect(ColorUtils.getSubjectColorByIndex(0), 
               equals(ColorUtils.getSubjectColorByIndex(paletteSize)));
        expect(ColorUtils.getSubjectColorByIndex(1), 
               equals(ColorUtils.getSubjectColorByIndex(paletteSize + 1)));
      });

      test('all palette colors should have readable text', () {
        for (var i = 0; i < ColorUtils.subjectColors.length; i++) {
          final bg = ColorUtils.subjectColors[i];
          final textColor = ColorUtils.getContrastTextColor(bg);
          final ratio = ColorUtils.getContrastRatio(textColor, bg);
          
          expect(ratio, greaterThanOrEqualTo(4.5),
            reason: 'Palette color $i should have readable text');
        }
      });
    });
  });
}
