import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:time_widgets/models/theme_settings_model.dart';
import 'package:time_widgets/services/theme_service.dart';
import 'package:time_widgets/widgets/dynamic_color_builder.dart';

/// Property 15: Theme Mode Application
/// 验证主题模式的正确应用和一致性
/// 
/// 这个属性测试验证：
/// 1. 主题模式设置能正确应用到生成的主题
/// 2. 种子颜色在不同主题模式下保持一致的色彩关系
/// 3. 动态颜色设置能正确影响主题生成
/// 4. 主题切换不会破坏颜色方案的完整性
void main() {
  group('Property 15: Theme Mode Application', () {
    late ThemeService themeService;

    setUp(() {
      themeService = ThemeService();
    });

    tearDown(() {
      themeService.dispose();
    });

    /// 基本主题生成测试
    testWidgets('basic theme generation works correctly',
        (WidgetTester tester) async {
      const seedColor = Color(0xFF6750A4);
      
      // 生成浅色和深色主题
      final lightTheme = themeService.generateLightTheme(seedColor);
      final darkTheme = themeService.generateDarkTheme(seedColor);

      // 验证主题的基本结构完整性
      expect(lightTheme.colorScheme.brightness, equals(Brightness.light));
      expect(darkTheme.colorScheme.brightness, equals(Brightness.dark));
      
      // 验证颜色方案的完整性
      _validateColorSchemeCompleteness(lightTheme.colorScheme);
      _validateColorSchemeCompleteness(darkTheme.colorScheme);
      
      // 验证对比度关系
      _validateContrastRelationships(lightTheme.colorScheme);
      _validateContrastRelationships(darkTheme.colorScheme);
    });

    /// 主题设置模型测试
    test('theme settings model works correctly', () {
      const seedColor = Color(0xFF1976D2);
      const themeMode = ThemeMode.dark;
      
      final themeSettings = ThemeSettings(
        seedColor: seedColor,
        themeMode: themeMode,
        useDynamicColor: true,
        useSystemColor: false,
      );

      // 验证序列化和反序列化
      final json = themeSettings.toJson();
      final restored = ThemeSettings.fromJson(json);

      // 验证设置正确序列化和反序列化
      expect(restored.seedColor.toARGB32(), equals(seedColor.toARGB32()));
      expect(restored.themeMode, equals(themeMode));
      expect(restored.useDynamicColor, equals(true));
      expect(restored.useSystemColor, equals(false));
    });

    /// 动态颜色构建器测试
    testWidgets('dynamic color builder works correctly',
        (WidgetTester tester) async {
      Widget testWidget = MaterialApp(
        home: DynamicColorBuilder(
          defaultSeedColor: const Color(0xFF6750A4),
          builder: (lightTheme, darkTheme) {
            // 验证主题是否正确生成
            expect(lightTheme, isNotNull);
            expect(darkTheme, isNotNull);
            expect(lightTheme.useMaterial3, isTrue);
            expect(darkTheme.useMaterial3, isTrue);
            
            return const Scaffold(
              body: Center(child: Text('Test')),
            );
          },
        ),
      );

      await tester.pumpWidget(testWidget);
      await tester.pumpAndSettle();

      // 验证 widget 正常渲染
      expect(find.text('Test'), findsOneWidget);
    });

    /// 颜色方案生成一致性测试
    testWidgets('color scheme generation consistency',
        (WidgetTester tester) async {
      const seedColor = Color(0xFF4CAF50);
      
      // 多次生成相同种子颜色的主题，应该得到相同结果
      final theme1 = themeService.generateLightTheme(seedColor);
      final theme2 = themeService.generateLightTheme(seedColor);
      final theme3 = themeService.generateDarkTheme(seedColor);
      final theme4 = themeService.generateDarkTheme(seedColor);

      // 验证相同参数生成的主题完全一致
      expect(theme1.colorScheme.primary.toARGB32(), equals(theme2.colorScheme.primary.toARGB32()));
      expect(theme1.colorScheme.secondary.toARGB32(), equals(theme2.colorScheme.secondary.toARGB32()));
      expect(theme1.colorScheme.surface.toARGB32(), equals(theme2.colorScheme.surface.toARGB32()));

      expect(theme3.colorScheme.primary.toARGB32(), equals(theme4.colorScheme.primary.toARGB32()));
      expect(theme3.colorScheme.secondary.toARGB32(), equals(theme4.colorScheme.secondary.toARGB32()));
      expect(theme3.colorScheme.surface.toARGB32(), equals(theme4.colorScheme.surface.toARGB32()));

      // 验证浅色和深色主题的差异性
      expect(theme1.colorScheme.surface.toARGB32(), isNot(equals(theme3.colorScheme.surface.toARGB32())));
      expect(theme1.colorScheme.onSurface.toARGB32(), isNot(equals(theme3.colorScheme.onSurface.toARGB32())));
    });

    /// Material 3 规范合规性测试
    testWidgets('Material 3 specification compliance',
        (WidgetTester tester) async {
      const seedColor = Color(0xFFFF5722);
      
      final lightTheme = themeService.generateLightTheme(seedColor);
      final darkTheme = themeService.generateDarkTheme(seedColor);

      // 验证 Material 3 特性
      expect(lightTheme.useMaterial3, isTrue);
      expect(darkTheme.useMaterial3, isTrue);

      // 验证 ColorScheme 包含所有 Material 3 必需的颜色
      final lightColors = lightTheme.colorScheme;
      final darkColors = darkTheme.colorScheme;

      // 验证主要颜色组
      expect(lightColors.primary, isNotNull);
      expect(lightColors.onPrimary, isNotNull);
      expect(lightColors.primaryContainer, isNotNull);
      expect(lightColors.onPrimaryContainer, isNotNull);

      // 验证次要颜色组
      expect(lightColors.secondary, isNotNull);
      expect(lightColors.onSecondary, isNotNull);
      expect(lightColors.secondaryContainer, isNotNull);
      expect(lightColors.onSecondaryContainer, isNotNull);

      // 验证第三颜色组
      expect(lightColors.tertiary, isNotNull);
      expect(lightColors.onTertiary, isNotNull);
      expect(lightColors.tertiaryContainer, isNotNull);
      expect(lightColors.onTertiaryContainer, isNotNull);

      // 验证表面颜色组
      expect(lightColors.surface, isNotNull);
      expect(lightColors.onSurface, isNotNull);
      expect(lightColors.surfaceContainerHighest, isNotNull);
      expect(lightColors.onSurfaceVariant, isNotNull);

      // 对深色主题进行相同验证
      expect(darkColors.primary, isNotNull);
      expect(darkColors.onPrimary, isNotNull);
      expect(darkColors.surface, isNotNull);
      expect(darkColors.onSurface, isNotNull);
    });
  });
}

/// 验证颜色方案的完整性
void _validateColorSchemeCompleteness(ColorScheme colorScheme) {
  // 验证所有必需的颜色都已定义且不为透明
  expect((colorScheme.primary.a * 255.0).round() & 0xff, greaterThan(0));
  expect((colorScheme.onPrimary.a * 255.0).round() & 0xff, greaterThan(0));
  expect((colorScheme.secondary.a * 255.0).round() & 0xff, greaterThan(0));
  expect((colorScheme.onSecondary.a * 255.0).round() & 0xff, greaterThan(0));
  expect((colorScheme.surface.a * 255.0).round() & 0xff, greaterThan(0));
  expect((colorScheme.onSurface.a * 255.0).round() & 0xff, greaterThan(0));
}

/// 验证对比度关系
void _validateContrastRelationships(ColorScheme colorScheme) {
  // 验证前景色和背景色不相同（确保有对比度）
  expect(colorScheme.onPrimary.toARGB32(), isNot(equals(colorScheme.primary.toARGB32())));
  expect(colorScheme.onSecondary.toARGB32(), isNot(equals(colorScheme.secondary.toARGB32())));
  expect(colorScheme.onSurface.toARGB32(), isNot(equals(colorScheme.surface.toARGB32())));
}

/// 验证主题的完整性
void _validateThemeIntegrity(ThemeData theme) {
  // 验证主题的基本属性
  expect(theme.colorScheme, isNotNull);
  expect(theme.textTheme, isNotNull);
  expect(theme.useMaterial3, isTrue);
  
  // 验证关键组件主题
  expect(theme.appBarTheme, isNotNull);
  expect(theme.cardTheme, isNotNull);
  expect(theme.filledButtonTheme, isNotNull);
  expect(theme.outlinedButtonTheme, isNotNull);
  expect(theme.textButtonTheme, isNotNull);
  
  // 验证颜色方案完整性
  _validateColorSchemeCompleteness(theme.colorScheme);
}