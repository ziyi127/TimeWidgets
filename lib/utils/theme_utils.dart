import 'package:flutter/material.dart';

/// Material Design 3 theme utilities
class ThemeUtils {
  // Private constructor to prevent instantiation
  ThemeUtils._();

  /// MD3 seed color
  static const Color _seedColor = Color(0xFF6750A4);

  /// Global Font Family
  static const String fontFamily = 'Google Sans';

  /// Global Font Family Fallback
  static const List<String> fontFamilyFallback = ['Noto Sans SC'];

  /// Build light theme
  static ThemeData buildLightTheme() {
    final colorScheme = ColorScheme.fromSeed(
      seedColor: _seedColor,
    );

    return _buildTheme(colorScheme);
  }

  /// Build dark theme
  static ThemeData buildDarkTheme() {
    final colorScheme = ColorScheme.fromSeed(
      seedColor: _seedColor,
      brightness: Brightness.dark,
    );

    return _buildTheme(colorScheme);
  }

  /// Build common theme configuration
  static ThemeData _buildTheme(ColorScheme colorScheme) {
    return ThemeData(
      useMaterial3: true,
      colorScheme: colorScheme,
      fontFamily: fontFamily,
      fontFamilyFallback: fontFamilyFallback,

      // AppBar theme
      appBarTheme: AppBarTheme(
        backgroundColor: Colors.transparent,
        elevation: 0,
        scrolledUnderElevation: 0,
        centerTitle: false,
        titleTextStyle: TextStyle(
          color: colorScheme.onSurface,
          fontSize: 22,
          fontWeight: FontWeight.w600,
          fontFamily: fontFamily,
          fontFamilyFallback: fontFamilyFallback,
        ),
      ),

      // Card theme
      cardTheme: CardThemeData(
        elevation: 0,
        color: colorScheme.surfaceContainer,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: BorderSide(
            color: colorScheme.outline.withAlpha((255 * 0.2).round()),
          ),
        ),
      ),

      // Button theme
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          textStyle: const TextStyle(
            fontFamily: fontFamily,
            fontFamilyFallback: fontFamilyFallback,
          ),
        ),
      ),

      // Text button theme
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          textStyle: const TextStyle(
            fontFamily: fontFamily,
            fontFamilyFallback: fontFamilyFallback,
          ),
        ),
      ),

      // Input decoration theme
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: colorScheme.surfaceContainerHighest,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(
            color: colorScheme.outline.withAlpha((255 * 0.5).round()),
          ),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(
            color: colorScheme.outline.withAlpha((255 * 0.5).round()),
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(
            color: colorScheme.primary,
            width: 2,
          ),
        ),
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        labelStyle: const TextStyle(
          fontFamily: fontFamily,
          fontFamilyFallback: fontFamilyFallback,
        ),
        hintStyle: const TextStyle(
          fontFamily: fontFamily,
          fontFamilyFallback: fontFamilyFallback,
        ),
      ),

      // Progress indicator theme
      progressIndicatorTheme: ProgressIndicatorThemeData(
        color: colorScheme.primary,
        linearTrackColor: colorScheme.surfaceContainerHighest,
      ),

      // Divider theme
      dividerTheme: DividerThemeData(
        color: colorScheme.outline.withAlpha((255 * 0.2).round()),
        thickness: 1,
        space: 1,
      ),

      // Icon theme
      iconTheme: IconThemeData(
        color: colorScheme.onSurfaceVariant,
        size: 24,
      ),

      // Text theme
      textTheme: buildTextTheme(colorScheme),
    );
  }

  /// Helper to create text style with global font settings
  static TextStyle _createTextStyle({
    required Color color,
    required double fontSize,
    required FontWeight fontWeight,
    double? letterSpacing,
  }) {
    return TextStyle(
      color: color,
      fontSize: fontSize,
      fontWeight: fontWeight,
      letterSpacing: letterSpacing,
      fontFamily: fontFamily,
      fontFamilyFallback: fontFamilyFallback,
    );
  }

  /// Build text theme
  static TextTheme buildTextTheme(ColorScheme colorScheme) {
    return TextTheme(
      // Display text
      displayLarge: _createTextStyle(
        color: colorScheme.onSurface,
        fontSize: 57,
        fontWeight: FontWeight.w400,
        letterSpacing: -0.25,
      ),
      displayMedium: _createTextStyle(
        color: colorScheme.onSurface,
        fontSize: 45,
        fontWeight: FontWeight.w400,
      ),
      displaySmall: _createTextStyle(
        color: colorScheme.onSurface,
        fontSize: 36,
        fontWeight: FontWeight.w400,
      ),

      // Headline text
      headlineLarge: _createTextStyle(
        color: colorScheme.onSurface,
        fontSize: 32,
        fontWeight: FontWeight.w400,
      ),
      headlineMedium: _createTextStyle(
        color: colorScheme.onSurface,
        fontSize: 28,
        fontWeight: FontWeight.w400,
      ),
      headlineSmall: _createTextStyle(
        color: colorScheme.onSurface,
        fontSize: 24,
        fontWeight: FontWeight.w400,
      ),

      // Title text
      titleLarge: _createTextStyle(
        color: colorScheme.onSurface,
        fontSize: 22,
        fontWeight: FontWeight.w400,
      ),
      titleMedium: _createTextStyle(
        color: colorScheme.onSurface,
        fontSize: 16,
        fontWeight: FontWeight.w500,
        letterSpacing: 0.15,
      ),
      titleSmall: _createTextStyle(
        color: colorScheme.onSurface,
        fontSize: 14,
        fontWeight: FontWeight.w500,
        letterSpacing: 0.1,
      ),

      // Label text
      labelLarge: _createTextStyle(
        color: colorScheme.onSurface,
        fontSize: 14,
        fontWeight: FontWeight.w500,
        letterSpacing: 0.1,
      ),
      labelMedium: _createTextStyle(
        color: colorScheme.onSurface,
        fontSize: 12,
        fontWeight: FontWeight.w500,
        letterSpacing: 0.5,
      ),
      labelSmall: _createTextStyle(
        color: colorScheme.onSurface,
        fontSize: 11,
        fontWeight: FontWeight.w500,
        letterSpacing: 0.5,
      ),

      // Body text
      bodyLarge: _createTextStyle(
        color: colorScheme.onSurface,
        fontSize: 16,
        fontWeight: FontWeight.w400,
        letterSpacing: 0.5,
      ),
      bodyMedium: _createTextStyle(
        color: colorScheme.onSurface,
        fontSize: 14,
        fontWeight: FontWeight.w400,
        letterSpacing: 0.25,
      ),
      bodySmall: _createTextStyle(
        color: colorScheme.onSurface,
        fontSize: 12,
        fontWeight: FontWeight.w400,
        letterSpacing: 0.4,
      ),
    );
  }

  /// Get status color
  static Color getStatusColor(ColorScheme colorScheme, String status) {
    switch (status.toLowerCase()) {
      case 'success':
      case 'completed':
        return colorScheme.tertiary;
      case 'warning':
      case 'pending':
        return colorScheme.secondary;
      case 'error':
      case 'failed':
        return colorScheme.error;
      case 'info':
      case 'current':
      case 'active':
        return colorScheme.primary;
      default:
        return colorScheme.onSurfaceVariant;
    }
  }

  /// Get event type color
  static Color getEventTypeColor(ColorScheme colorScheme, String eventType) {
    switch (eventType.toLowerCase()) {
      case 'exam':
        return colorScheme.error;
      case 'assignment':
        return colorScheme.tertiary;
      case 'project':
        return colorScheme.secondary;
      case 'holiday':
      case 'vacation':
        return colorScheme.primary;
      case 'meeting':
        return colorScheme.secondary;
      default:
        return colorScheme.primary;
    }
  }

  /// Get event type icon
  static IconData getEventTypeIcon(String eventType) {
    switch (eventType.toLowerCase()) {
      case 'exam':
        return Icons.quiz_rounded;
      case 'assignment':
        return Icons.assignment_rounded;
      case 'project':
        return Icons.work_rounded;
      case 'holiday':
      case 'vacation':
        return Icons.celebration_rounded;
      case 'meeting':
        return Icons.meeting_room_rounded;
      default:
        return Icons.event_rounded;
    }
  }

  /// Get course status icon
  static IconData getCourseStatusIcon(String status) {
    switch (status.toLowerCase()) {
      case 'current':
      case 'active':
        return Icons.play_circle_filled_rounded;
      case 'completed':
      case 'finished':
        return Icons.check_circle_rounded;
      case 'upcoming':
      case 'pending':
        return Icons.schedule_rounded;
      case 'cancelled':
        return Icons.cancel_rounded;
      default:
        return Icons.circle_outlined;
    }
  }
}
