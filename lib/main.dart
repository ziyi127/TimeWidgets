import 'package:flutter/material.dart';
import 'package:time_widgets/screens/desktop_widget_screen.dart';
import 'package:time_widgets/screens/timetable_edit_screen.dart';
import 'package:time_widgets/screens/settings_screen.dart';
import 'package:time_widgets/services/md3_tray_menu_service.dart';
import 'package:time_widgets/services/theme_service.dart';
import 'package:time_widgets/services/enhanced_window_manager.dart';
import 'package:time_widgets/services/ntp_service.dart';
import 'package:time_widgets/services/course_reminder_service.dart';
import 'package:time_widgets/widgets/dynamic_color_builder.dart';
import 'package:bitsdojo_window/bitsdojo_window.dart';
import 'package:time_widgets/utils/logger.dart';
import 'package:time_widgets/services/settings_service.dart';
import 'package:time_widgets/utils/responsive_utils.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // 初始化窗口管理器
  // await windowManager.ensureInitialized(); // EnhancedWindowManager handles this
  
  runApp(const TimeWidgetsApp());
}

class TimeWidgetsApp extends StatelessWidget {
  const TimeWidgetsApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const DesktopWrapper();
  }
}

/// 桌面模式包装器
class DesktopWrapper extends StatefulWidget {
  const DesktopWrapper({super.key});

  @override
  State<DesktopWrapper> createState() => _DesktopWrapperState();
}

class _DesktopWrapperState extends State<DesktopWrapper> {
  final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();
  final ThemeService _themeService = ThemeService();
  final SettingsService _settingsService = SettingsService();
  final CourseReminderService _courseReminderService = CourseReminderService();
  bool _isWindowVisible = true;
  bool _isWindowInitialized = false;
  bool _showTrayMenu = false;
  bool _isEditMode = false;
  
  @override
  void initState() {
    super.initState();
    
    // 加载设置并初始化UI缩放
    _settingsService.loadSettings().then((settings) {
      ResponsiveUtils.setScaleFactor(settings.uiScale);
      if (mounted) setState(() {});
      // Initialize NTP Service after settings are potentially loaded
      NtpService().initialize();
      // Initialize Course Reminder Service
      _courseReminderService.initialize();
    });

    // 监听设置变化
    _settingsService.settingsStream.listen((settings) {
      if (ResponsiveUtils.scaleFactor != settings.uiScale) {
        ResponsiveUtils.setScaleFactor(settings.uiScale);
        if (mounted) setState(() {});
      }
    });
    
    // 加载主题设置
    _themeService.loadSettings();
    
    // 初始化窗口
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _initializeWindow();
      _initializeSystemTray();
    });
  }

  /// 初始化窗口配置
  Future<void> _initializeWindow() async {
    if (_isWindowInitialized) return;
    
    try {
      final success = await EnhancedWindowManager.initializeWindow(
        onScreenSizeChanged: () {
          // 处理屏幕尺寸变化，可能需要重新布局
          if (mounted) {
            setState(() {
              // 触发重建
            });
          }
        },
      );
      
      if (!success) {
        Logger.w('Enhanced window initialization failed, falling back to default');
      }
      
      setState(() {
        _isWindowInitialized = true;
      });
      
      Logger.i('窗口初始化成功');
    } catch (e) {
      Logger.e('窗口初始化失败: $e');
      setState(() {
        _isWindowInitialized = true;
      });
    }
  }

  /// 初始化系统托盘
  Future<void> _initializeSystemTray() async {
    try {
      final trayService = MD3TrayMenuService.instance;
      
      // 设置回调
      trayService.onShowSettings = _navigateToSettings;
      trayService.onShowTimetableEdit = _navigateToTimetableEdit;
      trayService.onToggleWindow = _toggleMainWindow;
      trayService.onToggleEditMode = _toggleEditMode;
      trayService.onExit = _exitApplication;
      
      // 设置MD3菜单显示回调
      trayService.onShowMD3Menu = _showMD3TrayMenu;
      
      // 初始化托盘
      await trayService.initialize();
      
      Logger.i('系统托盘初始化成功');
    } catch (e) {
      Logger.e('系统托盘初始化失败: $e');
    }
  }

  /// 显示MD3风格的托盘菜单
  void _showMD3TrayMenu() {
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

  /// 导航到设置页面
  void _navigateToSettings() {
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

  /// 导航到课表编辑页面
  void _navigateToTimetableEdit() {
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

  /// 切换主窗口可见性
  void _toggleMainWindow() {
    _hideMD3TrayMenu();
    
    if (_isWindowVisible) {
      _hideMainWindow();
    } else {
      _showMainWindow();
    }
  }

  /// 切换编辑模式
  void _toggleEditMode() {
    _hideMD3TrayMenu();
    
    if (!_isWindowVisible) {
      _showMainWindow();
    }

    setState(() {
      _isEditMode = !_isEditMode;
    });

    if (_isEditMode) {
      // Show a snackbar or some indication
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('已进入布局编辑模式，拖动组件可调整位置'),
          duration: Duration(seconds: 2),
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('已退出布局编辑模式'),
          duration: Duration(seconds: 2),
        ),
      );
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
    MD3TrayMenuService.instance.destroy();
    appWindow.close();
  }

  @override
  void dispose() {
    _themeService.dispose();
    _courseReminderService.dispose();
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
              title: '智慧课程表',
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
                  // 主界面
                  DesktopWidgetScreen(
                    isEditMode: _isEditMode,
                  ),
                  
                  // MD3托盘菜单覆盖层
                  if (_showTrayMenu)
                    MD3TrayPopupMenu(
                      onShowSettings: _navigateToSettings,
                      onShowTimetableEdit: _navigateToTimetableEdit,
                      onToggleWindow: _toggleMainWindow,
                      onToggleEditMode: _toggleEditMode,
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
