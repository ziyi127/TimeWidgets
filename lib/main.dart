import 'dart:async';
import 'dart:convert';

import 'package:desktop_multi_window/desktop_multi_window.dart';
import 'package:window_manager/window_manager.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:provider/provider.dart';
import 'package:time_widgets/controllers/desktop_controller.dart';
import 'package:time_widgets/l10n/app_localizations.dart';
import 'package:time_widgets/screens/desktop_widget_screen.dart';
import 'package:time_widgets/screens/sub_window_screen.dart';
import 'package:time_widgets/services/course_reminder_service.dart';
import 'package:time_widgets/services/md3_tray_menu_service.dart';
import 'package:time_widgets/services/ntp_service.dart';
import 'package:time_widgets/services/settings_service.dart';
import 'package:time_widgets/services/startup_service.dart';
import 'package:time_widgets/services/theme_service.dart';
import 'package:time_widgets/utils/responsive_utils.dart';
import 'package:time_widgets/view_models/countdown_view_model.dart';
import 'package:time_widgets/view_models/timetable_view_model.dart';
import 'package:time_widgets/view_models/weather_view_model.dart';
import 'package:time_widgets/widgets/dynamic_color_builder.dart';

void main(List<String> args) async {
  WidgetsFlutterBinding.ensureInitialized();

  if (args.isNotEmpty && args.first == 'multi_window') {
    final windowId = int.parse(args[1]);
    final argument = args[2].isEmpty
        ? const <String, dynamic>{}
        : jsonDecode(args[2]) as Map<String, dynamic>;
    
    // Initialize window manager for sub-window
    await windowManager.ensureInitialized();
    
    runApp(SubWindowScreen(windowId: windowId, arguments: argument));
  } else {
    // 禁用调试信息以减少内存和CPU
    debugPrint = (message, {wrapWidth}) {};

    runApp(const TimeWidgetsApp());
  }
}

class TimeWidgetsApp extends StatelessWidget {
  const TimeWidgetsApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider.value(value: SettingsService()),
        ChangeNotifierProvider.value(value: ThemeService()),
        ChangeNotifierProvider(
          create: (_) => DesktopController(
            settingsService: SettingsService(),
            navigatorKey: GlobalKey<NavigatorState>(),
          ),
        ),
        ChangeNotifierProvider(
          create: (context) => WeatherViewModel(
            settingsService: context.read<SettingsService>(),
          ),
        ),
        ChangeNotifierProvider(
          create: (context) => CountdownViewModel(
            settingsService: context.read<SettingsService>(),
          ),
        ),
        ChangeNotifierProvider(
          create: (context) => TimetableViewModel(
            settingsService: context.read<SettingsService>(),
          ),
        ),
      ],
      child: const DesktopWrapper(),
    );
  }
}

/// 桌面模式包装器
class DesktopWrapper extends StatefulWidget {
  const DesktopWrapper({super.key});

  @override
  State<DesktopWrapper> createState() => _DesktopWrapperState();
}

class _DesktopWrapperState extends State<DesktopWrapper> {
  final CourseReminderService _courseReminderService = CourseReminderService();

  @override
  void initState() {
    super.initState();

    // Initialize Settings Logic
    final settingsService = context.read<SettingsService>();
    final themeService = context.read<ThemeService>();
    final desktopController = context.read<DesktopController>();

    // 加载设置并初始化UI缩放
    settingsService.loadSettings().then((settings) async {
      ResponsiveUtils.scaleFactor = settings.uiScale;

      // 初始化开机自启服务
      await StartupService().initialize();

      if (mounted) {
        setState(() {});
      }
      // Initialize NTP Service after settings are potentially loaded
      unawaited(NtpService().initialize());
      // Initialize Course Reminder Service
      unawaited(_courseReminderService.initialize());
    });

    // 加载主题设置
    themeService.loadSettings();

    // 初始化窗口和托盘
    WidgetsBinding.instance.addPostFrameCallback((_) {
      desktopController.initializeWindow();
      desktopController.initializeSystemTray();
    });
  }

  @override
  void dispose() {
    _courseReminderService.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Watch services
    final themeService = context.watch<ThemeService>();
    final desktopController = context.watch<DesktopController>();
    
    final themeSettings = themeService.currentSettings;

    return DynamicColorBuilder(
      builder: (lightTheme, darkTheme) {
        return MaterialApp(
          navigatorKey: desktopController.navigatorKey,
          onGenerateTitle: (context) => AppLocalizations.of(context)!.appTitle,
          localizationsDelegates: const [
            AppLocalizations.delegate,
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          supportedLocales: const [
            Locale('zh', 'CN'),
            Locale('en', 'US'),
          ],
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
                isEditMode: desktopController.isEditMode,
              ),

              // MD3托盘菜单覆盖层
              if (desktopController.showTrayMenu)
                MD3TrayPopupMenu(
                  onShowSettings: desktopController.navigateToSettings,
                  onShowTimetableEdit: desktopController.navigateToTimetableEdit,
                  onToggleWindow: desktopController.toggleMainWindow,
                  onToggleEditMode: desktopController.toggleEditMode,
                  onExit: desktopController.exitApplication,
                  onTempScheduleChange: desktopController.showTempScheduleChangeMenu,
                  onDismiss: desktopController.hideMD3TrayMenu,
                ),
            ],
          ),
          debugShowCheckedModeBanner: false,
        );
      },
    );
  }
}
