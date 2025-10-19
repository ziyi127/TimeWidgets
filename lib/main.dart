import 'package:flutter/material.dart';
import 'package:time_widgets/screens/home_screen.dart';
import 'package:time_widgets/screens/timetable_edit_screen.dart';
import 'package:time_widgets/services/system_tray_service.dart';
import 'package:bitsdojo_window/bitsdojo_window.dart';
import 'package:tray_manager/tray_manager.dart';
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

class _DesktopWrapperState extends State<DesktopWrapper> with TrayListener {
  final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();
  
  @override
  void initState() {
    super.initState();
    trayManager.addListener(this);
    
    // Initialize system tray service
    SystemTrayService().initialize(() {
      // Navigate to timetable edit screen
      navigatorKey.currentState?.push(
        MaterialPageRoute(
          builder: (context) => const TimetableEditScreen(),
        ),
      );
    });
    
    // Setup system tray menu
    _setupTrayMenu();
  }
  
  // 设置系统托盘菜单
  Future<void> _setupTrayMenu() async {
    try {
      Menu menu = Menu(
        items: [
          MenuItem(label: '显示窗口', onClick: (_) => appWindow.show()),
          MenuItem(label: '编辑课表', onClick: (_) {
            // 导航到课表编辑页面
            navigatorKey.currentState?.push(
              MaterialPageRoute(
                builder: (context) => const TimetableEditScreen(),
              ),
            );
            appWindow.show();
          }),
          MenuItem.separator(),
          MenuItem(label: '退出', onClick: (_) => exit(0)),
        ],
      );
      
      await trayManager.setContextMenu(menu);
      await trayManager.setToolTip('智慧课程表');
    } catch (e) {
      // 托盘初始化失败，静默处理避免影响应用启动
      debugPrint('Tray initialization failed: $e');
    }
  }

  @override
  void dispose() {
    trayManager.removeListener(this);
    super.dispose();
  }

  @override
  void onTrayIconMouseDown() async {
    // 点击托盘图标时显示/隐藏窗口
    if (appWindow.isVisible) {
      appWindow.hide();
    } else {
      appWindow.show();
    }
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