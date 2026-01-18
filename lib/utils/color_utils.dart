import 'package:flutter/painting.dart';

/// Color utility functions for MD3 timetable
class ColorUtils {
  /// Generate a deterministic color from a name string
  /// The same name will always produce the same color
  /// Follows MD3 color guidelines for better visual harmony
  static Color generateColorFromName(String name) {
    if (name.isEmpty) {
      return const Color(0xFF3B82F6); // Default MD3 blue
    }

    // Use a simple hash function for deterministic color generation
    int hash = 0;
    for (int i = 0; i < name.length; i++) {
      hash = name.codeUnitAt(i) + ((hash << 5) - hash);
    }

    // Generate HSL color following MD3 guidelines
    // Hue: 0-360 degrees, but using MD3 preferred hue ranges
    final hue = (hash.abs() % 360).toDouble();
    // Saturation: 60-85% for MD3 vibrant yet harmonious colors
    final saturation = 0.6 + (((hash >> 8).abs() % 25) / 100);
    // Lightness: 45-65% for better contrast and MD3 compliance
    final lightness = 0.45 + (((hash >> 16).abs() % 20) / 100);

    return HSLColor.fromAHSL(1, hue, saturation, lightness).toColor();
  }

  /// Calculate the relative luminance of a color
  /// Based on WCAG 2.1 formula
  static double getRelativeLuminance(Color color) {
    double r = (color.r * 255.0).round() / 255;
    double g = (color.g * 255.0).round() / 255;
    double b = (color.b * 255.0).round() / 255;

    r = r <= 0.03928 ? r / 12.92 : ((r + 0.055) / 1.055).pow(2.4);
    g = g <= 0.03928 ? g / 12.92 : ((g + 0.055) / 1.055).pow(2.4);
    b = b <= 0.03928 ? b / 12.92 : ((b + 0.055) / 1.055).pow(2.4);

    return 0.2126 * r + 0.7152 * g + 0.0722 * b;
  }

  /// Calculate contrast ratio between two colors
  /// Returns a value between 1 and 21
  static double getContrastRatio(Color foreground, Color background) {
    final l1 = getRelativeLuminance(foreground);
    final l2 = getRelativeLuminance(background);

    final lighter = l1 > l2 ? l1 : l2;
    final darker = l1 > l2 ? l2 : l1;

    return (lighter + 0.05) / (darker + 0.05);
  }

  /// Get the appropriate text color (black or white) for a given background
  /// Ensures WCAG AA compliance (4.5:1 contrast ratio for normal text)
  static Color getContrastTextColor(Color backgroundColor) {
    const white = Color(0xFFFFFFFF);
    const black = Color(0xFF000000);

    final whiteContrast = getContrastRatio(white, backgroundColor);
    final blackContrast = getContrastRatio(black, backgroundColor);

    // Return the color with better contrast
    return whiteContrast > blackContrast ? white : black;
  }

  /// Check if a color combination meets WCAG AA standards
  /// Normal text: 4.5:1, Large text: 3:1
  static bool meetsWcagAA(Color foreground, Color background,
      {bool isLargeText = false}) {
    final ratio = getContrastRatio(foreground, background);
    return isLargeText ? ratio >= 3.0 : ratio >= 4.5;
  }

  /// Check if a color combination meets WCAG AAA standards
  /// Normal text: 7:1, Large text: 4.5:1
  static bool meetsWcagAAA(Color foreground, Color background,
      {bool isLargeText = false}) {
    final ratio = getContrastRatio(foreground, background);
    return isLargeText ? ratio >= 4.5 : ratio >= 7.0;
  }

  /// Parse a hex color string to Color
  static Color? parseHexColor(String hexString) {
    try {
      String hex = hexString.replaceFirst('#', '');
      if (hex.length == 6) {
        hex = 'FF$hex'; // Add alpha
      }
      return Color(int.parse(hex, radix: 16));
    } catch (e) {
      return null;
    }
  }

  /// Convert Color to hex string
  static String toHexString(Color color, {bool includeAlpha = false}) {
    if (includeAlpha) {
      return '#${color.toARGB32().toRadixString(16).padLeft(8, '0').toUpperCase()}';
    }
    return '#${(color.toARGB32() & 0xFFFFFF).toRadixString(16).padLeft(6, '0').toUpperCase()}';
  }

  /// Predefined MD3 color palette for subjects
  static const List<Color> subjectColors = [
    Color(0xFFEF4444), // Red
    Color(0xFFEC4899), // Pink
    Color(0xFF8B5CF6), // Purple
    Color(0xFF6366F1), // Indigo
    Color(0xFF3B82F6), // Blue
    Color(0xFF0EA5E9), // Light Blue
    Color(0xFF06B6D4), // Cyan
    Color(0xFF10B981), // Teal
    Color(0xFF22C55E), // Green
    Color(0xFF84CC16), // Light Green
    Color(0xFFEAB308), // Yellow
    Color(0xFFF59E0B), // Amber
    Color(0xFFF97316), // Orange
    Color(0xFFEF4444), // Deep Red
    Color(0xFF7C3AED), // Violet
    Color(0xFFF43F5E), // Rose
    Color(0xFF14B8A6), // Emerald
    Color(0xFFFBBF24), // Gold
  ];

  /// Get a color from the predefined palette by index
  static Color getSubjectColorByIndex(int index) {
    return subjectColors[index % subjectColors.length];
  }
}

/// Extension for pow operation on double
extension DoublePow on double {
  double pow(double exponent) {
    if (this < 0) return 0;
    double result = 1;
    final double base = this;
    final int exp = exponent.toInt();
    final double frac = exponent - exp;

    // Integer part
    for (int i = 0; i < exp; i++) {
      result *= base;
    }

    // Fractional part approximation using Newton's method
    if (frac > 0) {
      // For 2.4 exponent, we can use a simpler approximation
      result *= _powFractional(base, frac);
    }

    return result;
  }

  static double _powFractional(double base, double frac) {
    // Simple approximation for fractional exponents
    // Using exp(frac * ln(base))
    if (base <= 0) return 0;

    // Natural log approximation
    double ln = 0;
    final double x = (base - 1) / (base + 1);
    double term = x;
    for (int i = 1; i <= 10; i += 2) {
      ln += term / i;
      term *= x * x;
    }
    ln *= 2;

    // Exp approximation
    final double expVal = frac * ln;
    double result = 1;
    double factorial = 1;
    double power = 1;
    for (int i = 1; i <= 10; i++) {
      factorial *= i;
      power *= expVal;
      result += power / factorial;
    }

    return result;
  }
}
