import 'package:flutter/painting.dart';

/// Color utility functions for MD3 timetable
class ColorUtils {
  /// Generate a deterministic color from a name string
  /// The same name will always produce the same color
  static Color generateColorFromName(String name) {
    if (name.isEmpty) {
      return const Color(0xFF2196F3); // Default blue
    }
    
    // Use a simple hash function for deterministic color generation
    int hash = 0;
    for (int i = 0; i < name.length; i++) {
      hash = name.codeUnitAt(i) + ((hash << 5) - hash);
    }
    
    // Generate HSL color for better visual distribution
    // Hue: 0-360 degrees
    final hue = (hash.abs() % 360).toDouble();
    // Saturation: 50-80% for vibrant but not overwhelming colors
    final saturation = 0.5 + (((hash >> 8).abs() % 30) / 100);
    // Lightness: 40-60% for good contrast with both light and dark text
    final lightness = 0.4 + (((hash >> 16).abs() % 20) / 100);
    
    return HSLColor.fromAHSL(1.0, hue, saturation, lightness).toColor();
  }

  /// Calculate the relative luminance of a color
  /// Based on WCAG 2.1 formula
  static double getRelativeLuminance(Color color) {
    double r = color.red / 255;
    double g = color.green / 255;
    double b = color.blue / 255;
    
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
  static bool meetsWcagAA(Color foreground, Color background, {bool isLargeText = false}) {
    final ratio = getContrastRatio(foreground, background);
    return isLargeText ? ratio >= 3.0 : ratio >= 4.5;
  }

  /// Check if a color combination meets WCAG AAA standards
  /// Normal text: 7:1, Large text: 4.5:1
  static bool meetsWcagAAA(Color foreground, Color background, {bool isLargeText = false}) {
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
      return '#${color.value.toRadixString(16).padLeft(8, '0').toUpperCase()}';
    }
    return '#${(color.value & 0xFFFFFF).toRadixString(16).padLeft(6, '0').toUpperCase()}';
  }

  /// Predefined MD3 color palette for subjects
  static const List<Color> subjectColors = [
    Color(0xFFF44336), // Red
    Color(0xFFE91E63), // Pink
    Color(0xFF9C27B0), // Purple
    Color(0xFF673AB7), // Deep Purple
    Color(0xFF3F51B5), // Indigo
    Color(0xFF2196F3), // Blue
    Color(0xFF03A9F4), // Light Blue
    Color(0xFF00BCD4), // Cyan
    Color(0xFF009688), // Teal
    Color(0xFF4CAF50), // Green
    Color(0xFF8BC34A), // Light Green
    Color(0xFFCDDC39), // Lime
    Color(0xFFFFEB3B), // Yellow
    Color(0xFFFFC107), // Amber
    Color(0xFFFF9800), // Orange
    Color(0xFFFF5722), // Deep Orange
    Color(0xFF795548), // Brown
    Color(0xFF607D8B), // Blue Grey
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
    double base = this;
    int exp = exponent.toInt();
    double frac = exponent - exp;
    
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
    double x = (base - 1) / (base + 1);
    double term = x;
    for (int i = 1; i <= 10; i += 2) {
      ln += term / i;
      term *= x * x;
    }
    ln *= 2;
    
    // Exp approximation
    double expVal = frac * ln;
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
