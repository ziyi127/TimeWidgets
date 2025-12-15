import 'package:flutter/material.dart';
import 'package:time_widgets/screens/home_screen.dart';
import 'package:time_widgets/screens/timetable_edit_screen.dart';
import 'package:time_widgets/screens/settings_screen.dart';
import 'package:time_widgets/services/system_tray_service.dart';
import 'package:time_widgets/services/theme_service.dart';
import 'package:time_widgets/widgets/dynamic_color_builder.dart';
import 'package:bitsdojo_window/bitsdojo_window.dart';


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
    
    // 设置窗口关闭行为 - 隐藏到托盘而不是退出
    // 注意：bitsdojo_window 可能不支持 onWindowClose，
    // 这个功能将在系统托盘服务中处理
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
  final ThemeService _themeService = ThemeService();
  final SystemTrayService _systemTrayService = SystemTrayService();
  bool _isWindowVisible = true;
  
  @override
  void initState() {
    super.initState();
    
    // Initialize system tray service
    _initializeSystemTray();
    
    // Load theme settings on startup
    _themeService.loadSettings();
  }

  /// 初始化系统托盘
  Future<void> _initializeSystemTray() async {
    try {
      // 设置回调函数
      _systemTrayService.onMenuItemSelected = _handleTrayMenuSelection;
      _systemTrayService.onToggleWindow = _toggleMainWindow;
      _systemTrayService.onExitApplication = _exitApplication;
      
      // 暂时禁用系统托盘初始化，因为在开发环境中可能有权限问题
      // await _systemTrayService.initializeSystemTray();
      
      print('System tray service configured (initialization skipped in debug mode)');
    } catch (e) {
      print('Failed to initialize system tray: $e');
      // 系统托盘初始化失败不应该阻止应用启动
    }
  }

  /// 处理托盘菜单选择
  void _handleTrayMenuSelection(TrayMenuItem item) {
    switch (item) {
      case TrayMenuItem.settings:
        _navigateToSettings();
        break;
      case TrayMenuItem.timetableEdit:
        _navigateToTimetableEdit();
        break;
      case TrayMenuItem.toggleWindow:
      case TrayMenuItem.exit:
        // 这些由其他回调处理
        break;
    }
  }

  /// 导航到设置页面
  void _navigateToSettings() {
    // 确保窗口可见
    if (!_isWindowVisible) {
      _showMainWindow();
    }
    
    // 导航到设置页面
    navigatorKey.currentState?.push(
      MaterialPageRoute(
        builder: (context) => const SettingsScreen(),
      ),
    );
  }

  /// 导航到课表编辑页面
  void _navigateToTimetableEdit() {
    // 确保窗口可见
    if (!_isWindowVisible) {
      _showMainWindow();
    }
    
    // 导航到课表编辑页面
    navigatorKey.currentState?.push(
      MaterialPageRoute(
        builder: (context) => const TimetableEditScreen(),
      ),
    );
  }

  /// 切换主窗口可见性
  void _toggleMainWindow() {
    if (_isWindowVisible) {
      _hideMainWindow();
    } else {
      _showMainWindow();
    }
  }

  /// 显示主窗口
  void _showMainWindow() {
    appWindow.show();
    setState(() {
      _isWindowVisible = true;
    });
  }

  /// 隐藏主窗口
  void _hideMainWindow() {
    appWindow.hide();
    setState(() {
      _isWindowVisible = false;
    });
  }

  /// 退出应用程序
  void _exitApplication() {
    _systemTrayService.destroy();
    appWindow.close();
  }

  @override
  void dispose() {
    _themeService.dispose();
    _systemTrayService.destroy();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return DynamicColorBuilder(
      themeService: _themeService,
      defaultSeedColor: const Color(0xFF6750A4),
      builder: (lightTheme, darkTheme) {
        return StreamBuilder(
          stream: _themeService.themeStream,
          builder: (context, snapshot) {
            final themeSettings = snapshot.data ?? _themeService.currentSettings;
            
            return MaterialApp(
              navigatorKey: navigatorKey,
              title: 'Smart Schedule',
              theme: lightTheme,
              darkTheme: darkTheme,
              themeMode: themeSettings.themeMode,
              home: const HomeScreen(),
              debugShowCheckedModeBanner: false,
            );
          },
        );
      },
    );
  }


}