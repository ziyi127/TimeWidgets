import 'package:flutter/material.dart';
import 'package:time_widgets/screens/desktop_widget_screen.dart';
import 'package:time_widgets/screens/timetable_edit_screen.dart';
import 'package:time_widgets/screens/settings_screen.dart';
import 'package:time_widgets/services/md3_tray_menu_service.dart';
import 'package:time_widgets/services/theme_service.dart';
import 'package:time_widgets/widgets/dynamic_color_builder.dart';
import 'package:bitsdojo_window/bitsdojo_window.dart';
import 'package:window_manager/window_manager.dart';
import 'package:time_widgets/utils/logger.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // 初始化窗口管理器
  await windowManager.ensureInitialized();
  
  runApp(const TimeWidgetsApp());
}

class TimeWidgetsApp extends StatelessWidget {
  const TimeWidgetsApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const DesktopWrapper();
  }
}

/// 桌面模式包装�?class DesktopWrapper extends StatefulWidget {
  const DesktopWrapper({super.key});

  @override
  State<DesktopWrapper> createState() => _DesktopWrapperState();
}

class _DesktopWrapperState extends State<DesktopWrapper> {
  final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();
  final ThemeService _themeService = ThemeService();
  bool _isWindowVisible = true;
  bool _isWindowInitialized = false;
  bool _showTrayMenu = false;
  
  @override
  void initState() {
    super.initState();
    
    // 加载主题设置
    _themeService.loadSettings();
    
    // 初始化窗�?    WidgetsBinding.instance.addPostFrameCallback((_) {
      _initializeWindow();
      _initializeSystemTray();
    });
  }

  /// 初始化窗口配�?  Future<void> _initializeWindow() async {
    if (_isWindowInitialized) return;
    
    try {
      const windowWidth = 400.0;
      const windowHeight = 900.0;
      const windowX = 1520.0;
      
      await windowManager.setSize(const Size(windowWidth, windowHeight));
      await windowManager.setPosition(const Offset(windowX, 50));
      await windowManager.setAsFrameless();
      await windowManager.setBackgroundColor(Colors.transparent);
      await windowManager.setHasShadow(false);
      await windowManager.setAlwaysOnTop(false);
      await windowManager.setAlwaysOnBottom(false);
      await windowManager.show();
      
      doWhenWindowReady(() {
        final win = appWindow;
        win.title = "智慧课程�?;
        win.show();
      });
      
      setState(() {
        _isWindowInitialized = true;
      });
      
      Logger.i('窗口初始化成�?);
    } catch (e) {
      Logger.e('窗口初始化失�? $e');
      setState(() {
        _isWindowInitialized = true;
      });
    }
  }

  /// 初始化系统托�?  Future<void> _initializeSystemTray() async {
    try {
      final trayService = MD3TrayMenuService.instance;
      
      // 设置回调
      trayService.onShowSettings = _navigateToSettings;
      trayService.onShowTimetableEdit = _navigateToTimetableEdit;
      trayService.onToggleWindow = _toggleMainWindow;
      trayService.onExit = _exitApplication;
      
      // 设置MD3菜单显示回调
      trayService.onShowMD3Menu = _showMD3TrayMenu;
      
      // 初始化托�?      await trayService.initialize();
      
      Logger.i('系统托盘初始化成�?);
    } catch (e) {
      Logger.e('系统托盘初始化失�? $e');
    }
  }

  /// 显示MD3风格的托盘菜�?  void _showMD3TrayMenu() {
    // 确保窗口可见
    if (!_isWindowVisible) {
      _showMainWindow();
    }
    
    setState(() {
      _showTrayMenu = true;
    });
  }

  /// 隐藏MD3托盘菜单
  void _hideMD3TrayMenu() {
    setState(() {
      _showTrayMenu = false;
    });
  }

  /// 导航到设置页�?  void _navigateToSettings() {
    _hideMD3TrayMenu();
    
    if (!_isWindowVisible) {
      _showMainWindow();
    }
    
    navigatorKey.currentState?.push(
      MaterialPageRoute(
        builder: (context) => const SettingsScreen(),
      ),
    );
  }

  /// 导航到课表编辑页�?  void _navigateToTimetableEdit() {
    _hideMD3TrayMenu();
    
    if (!_isWindowVisible) {
      _showMainWindow();
    }
    
    navigatorKey.currentState?.push(
      MaterialPageRoute(
        builder: (context) => const TimetableEditScreen(),
      ),
    );
  }

  /// 切换主窗口可见�?  void _toggleMainWindow() {
    _hideMD3TrayMenu();
    
    if (_isWindowVisible) {
      _hideMainWindow();
    } else {
      _showMainWindow();
    }
  }

  /// 显示主窗�?  void _showMainWindow() {
    appWindow.show();
    setState(() {
      _isWindowVisible = true;
    });
  }

  /// 隐藏主窗�?  void _hideMainWindow() {
    appWindow.hide();
    setState(() {
      _isWindowVisible = false;
    });
  }

  /// 退出应用程�?  void _exitApplication() {
    MD3TrayMenuService.instance.destroy();
    appWindow.close();
  }

  @override
  void dispose() {
    _themeService.dispose();
    MD3TrayMenuService.instance.destroy();
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
              title: '智慧课程�?,
              theme: lightTheme.copyWith(
                scaffoldBackgroundColor: Colors.transparent,
                canvasColor: Colors.transparent,
              ),
              darkTheme: darkTheme.copyWith(
                scaffoldBackgroundColor: Colors.transparent,
                canvasColor: Colors.transparent,
              ),
              themeMode: themeSettings.themeMode,
              home: Stack(
                children: [
                  // 主界�?                  const DesktopWidgetScreen(),
                  
                  // MD3托盘菜单覆盖�?                  if (_showTrayMenu)
                    MD3TrayPopupMenu(
                      onShowSettings: _navigateToSettings,
                      onShowTimetableEdit: _navigateToTimetableEdit,
                      onToggleWindow: _toggleMainWindow,
                      onExit: _exitApplication,
                      onDismiss: _hideMD3TrayMenu,
                    ),
                ],
              ),
              debugShowCheckedModeBanner: false,
            );
          },
        );
      },
    );
  }
}
