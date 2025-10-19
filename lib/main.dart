import 'package:flutter/material.dart';
import 'package:time_widgets/screens/home_screen.dart';
import 'package:time_widgets/screens/timetable_edit_screen.dart';
import 'package:time_widgets/services/system_tray_service.dart';
import 'package:bitsdojo_window/bitsdojo_window.dart';
import 'dart:io';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // 初始化窗口
  doWhenWindowReady(() {
    final win = appWindow;
    const initialSize = Size(400, 800);
    win.size = initialSize;
    win.minSize = const Size(350, 600);
    win.maxSize = const Size(500, 1200);
    win.alignment = Alignment.topRight;
    win.title = "智慧课程表";
    win.show();
  });
  
  runApp(const TimeWidgetsApp());
}

class TimeWidgetsApp extends StatelessWidget {
  const TimeWidgetsApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const DesktopWrapper();
  }
}

// 桌面模式包装器
class DesktopWrapper extends StatefulWidget {
  const DesktopWrapper({super.key});

  @override
  State<DesktopWrapper> createState() => _DesktopWrapperState();
}

class _DesktopWrapperState extends State<DesktopWrapper> {
  final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();
  
  @override
  void initState() {
    super.initState();
    
    // Initialize system tray service
    SystemTrayService().initialize(() {
      // Navigate to timetable edit screen
      navigatorKey.currentState?.push(
        MaterialPageRoute(
          builder: (context) => const TimetableEditScreen(),
        ),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      navigatorKey: navigatorKey,
      title: 'Smart Schedule',
      theme: _buildLightTheme(),
      darkTheme: _buildDarkTheme(),
      themeMode: ThemeMode.system,
      home: const HomeScreen(),
      debugShowCheckedModeBanner: false,
    );
  }

  // Material Design 3 浅色主题
  ThemeData _buildLightTheme() {
    const seedColor = Color(0xFF6750A4); // MD3 Primary color
    final colorScheme = ColorScheme.fromSeed(
      seedColor: seedColor,
      brightness: Brightness.light,
    );

    return ThemeData(
      useMaterial3: true,
      colorScheme: colorScheme,
      appBarTheme: AppBarTheme(
        backgroundColor: colorScheme.surface,
        foregroundColor: colorScheme.onSurface,
        elevation: 0,
        scrolledUnderElevation: 1,
      ),
      cardTheme: CardThemeData(
        elevation: 1,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
        ),
      ),
    );
  }

  // Material Design 3 深色主题
  ThemeData _buildDarkTheme() {
    const seedColor = Color(0xFF6750A4);
    final colorScheme = ColorScheme.fromSeed(
      seedColor: seedColor,
      brightness: Brightness.dark,
    );

    return ThemeData(
      useMaterial3: true,
      colorScheme: colorScheme,
      appBarTheme: AppBarTheme(
        backgroundColor: colorScheme.surface,
        foregroundColor: colorScheme.onSurface,
        elevation: 0,
        scrolledUnderElevation: 1,
      ),
      cardTheme: CardThemeData(
        elevation: 1,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
        ),
      ),
    );
  }
}