import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:time_widgets/widgets/dynamic_color_builder.dart';
import 'package:time_widgets/services/theme_service.dart';

void main() {
  group('DynamicColorBuilder Tests', () {
    testWidgets('DynamicColorBuilder builds with default themes', (tester) async {
      bool builderCalled = false;
      ThemeData? receivedLightTheme;
      ThemeData? receivedDarkTheme;

      await tester.pumpWidget(
        MaterialApp(
          home: DynamicColorBuilder(
            defaultSeedColor: const Color(0xFF6750A4),
            builder: (lightTheme, darkTheme) {
              builderCalled = true;
              receivedLightTheme = lightTheme;
              receivedDarkTheme = darkTheme;
              return const Scaffold(
                body: Text('Test'),
              );
            },
          ),
        ),
      );

      // Wait for the widget to build
      await tester.pumpAndSettle();

      expect(builderCalled, isTrue);
      expect(receivedLightTheme, isNotNull);
      expect(receivedDarkTheme, isNotNull);
      expect(receivedLightTheme!.colorScheme.brightness, equals(Brightness.light));
      expect(receivedDarkTheme!.colorScheme.brightness, equals(Brightness.dark));
    });

    testWidgets('SimpleDynamicColorBuilder builds with current theme', (tester) async {
      bool builderCalled = false;
      ThemeData? receivedTheme;

      await tester.pumpWidget(
        MaterialApp(
          home: SimpleDynamicColorBuilder(
            defaultSeedColor: const Color(0xFFFF0000),
            forceBrightness: Brightness.light,
            builder: (theme) {
              builderCalled = true;
              receivedTheme = theme;
              return const Scaffold(
                body: Text('Test'),
              );
            },
          ),
        ),
      );

      await tester.pumpAndSettle();

      expect(builderCalled, isTrue);
      expect(receivedTheme, isNotNull);
      expect(receivedTheme!.colorScheme.brightness, equals(Brightness.light));
    });

    testWidgets('ThemePreview builds with correct theme', (tester) async {
      const seedColor = Color(0xFF00FF00);

      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: ThemePreview(
              seedColor: seedColor,
              isDark: false,
            ),
          ),
        ),
      );

      await tester.pumpAndSettle();

      // Find the preview content
      expect(find.text('浅色主题'), findsOneWidget);
      expect(find.text('主要'), findsOneWidget);
      expect(find.text('次要'), findsOneWidget);
      expect(find.text('文本'), findsOneWidget);
      expect(find.text('这是一个示例卡片'), findsOneWidget);
    });

    testWidgets('ThemePreview builds dark theme correctly', (tester) async {
      const seedColor = Color(0xFF9C27B0);

      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: ThemePreview(
              seedColor: seedColor,
              isDark: true,
            ),
          ),
        ),
      );

      await tester.pumpAndSettle();

      expect(find.text('深色主题'), findsOneWidget);
    });

    test('ThemeService integration works correctly', () {
      final themeService = ThemeService();
      const seedColor = Color(0xFF6750A4);

      final lightTheme = themeService.generateLightTheme(seedColor);
      final darkTheme = themeService.generateDarkTheme(seedColor);

      expect(lightTheme.useMaterial3, isTrue);
      expect(darkTheme.useMaterial3, isTrue);
      expect(lightTheme.colorScheme.brightness, equals(Brightness.light));
      expect(darkTheme.colorScheme.brightness, equals(Brightness.dark));
    });
  });
}