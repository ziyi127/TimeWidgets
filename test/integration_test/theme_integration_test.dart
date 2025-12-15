import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:time_widgets/main.dart';
import 'package:time_widgets/models/theme_settings_model.dart';
import 'package:time_widgets/services/theme_service.dart';
import 'package:time_widgets/widgets/dynamic_color_builder.dart';

/// 主题集成测试
/// 验证主题系统在整个应用中的正确工作
void main() {
  group('Theme Integration Tests', () {
    testWidgets('App should load with default theme', (WidgetTester tester) async {
      await tester.pumpWidget(const TimeWidgetsApp());
      await tester.pumpAndSettle();

      // 验证应用正常加载
      expect(find.byType(MaterialApp), findsOneWidget);
      expect(find.byType(DynamicColorBuilder), findsOneWidget);
    });

    testWidgets('Theme should change when seed color changes', (WidgetTester tester) async {
      final themeService = ThemeService();
      
      // 设置初始种子颜色
      await themeService.setSeedColor(Colors.blue);
      
      await tester.pumpWidget(const TimeWidgetsApp());
      await tester.pumpAndSettle();

      // 获取初始主题
      final materialApp = tester.widget<MaterialApp>(find.byType(MaterialApp));
      final initialTheme = materialApp.theme;
      
      // 更改种子颜色
      await themeService.setSeedColor(Colors.red);
      await tester.pumpAndSettle();

      // 验证主题已更改
      final updatedMaterialApp = tester.widget<MaterialApp>(find.byType(MaterialApp));
      final updatedTheme = updatedMaterialApp.theme;
      
      // 主题应该不同（种子颜色不同会导致配色方案不同）
      expect(initialTheme?.colorScheme.primary, isNot(equals(updatedTheme?.colorScheme.primary)));
      
      themeService.dispose();
    });

    testWidgets('Theme mode should affect app appearance', (WidgetTester tester) async {
      final themeService = ThemeService();
      
      // 设置为浅色模式
      final lightSettings = ThemeSettings.defaultSettings().copyWith(
        themeMode: ThemeMode.light,
      );
      await themeService.saveSettings(lightSettings);
      
      await tester.pumpWidget(const TimeWidgetsApp());
      await tester.pumpAndSettle();

      // 获取MaterialApp
      final materialApp = tester.widget<MaterialApp>(find.byType(MaterialApp));
      expect(materialApp.themeMode, equals(ThemeMode.light));
      
      themeService.dispose();
    });

    testWidgets('Dynamic color builder should generate consistent themes', (WidgetTester tester) async {
      const seedColor = Color(0xFF6750A4);
      
      await tester.pumpWidget(
        DynamicColorBuilder(
          defaultSeedColor: seedColor,
          builder: (lightTheme, darkTheme) {
            // 验证主题生成
            expect(lightTheme.useMaterial3, isTrue);
            expect(darkTheme.useMaterial3, isTrue);
            expect(lightTheme.colorScheme.brightness, equals(Brightness.light));
            expect(darkTheme.colorScheme.brightness, equals(Brightness.dark));
            
            return MaterialApp(
              theme: lightTheme,
              darkTheme: darkTheme,
              home: const Scaffold(
                body: Center(child: Text('Test')),
              ),
            );
          },
        ),
      );
      
      await tester.pumpAndSettle();
      expect(find.text('Test'), findsOneWidget);
    });

    testWidgets('Theme settings should persist across app restarts', (WidgetTester tester) async {
      final themeService = ThemeService();
      const testColor = Color(0xFFFF5722);
      
      // 保存主题设置
      final settings = ThemeSettings.defaultSettings().copyWith(
        seedColor: testColor,
        themeMode: ThemeMode.dark,
        useDynamicColor: false,
      );
      await themeService.saveSettings(settings);
      
      // 创建新的服务实例（模拟应用重启）
      final newThemeService = ThemeService();
      final loadedSettings = await newThemeService.loadSettings();
      
      // 验证设置已正确加载
      expect(loadedSettings.seedColor.toARGB32(), equals(testColor.toARGB32()));
      expect(loadedSettings.themeMode, equals(ThemeMode.dark));
      expect(loadedSettings.useDynamicColor, isFalse);
      
      themeService.dispose();
      newThemeService.dispose();
    });
  });
}