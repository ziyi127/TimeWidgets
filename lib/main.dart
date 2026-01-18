import 'dart:async';
import 'dart:io';

import 'package:bitsdojo_window/bitsdojo_window.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:time_widgets/models/temp_schedule_change_model.dart';
import 'package:time_widgets/models/timetable_edit_model.dart';
import 'package:time_widgets/screens/desktop_widget_screen.dart';
import 'package:time_widgets/screens/dynamic_island_screen.dart';
import 'package:time_widgets/screens/settings_screen.dart';
import 'package:time_widgets/screens/temp_schedule_manage_screen.dart';
import 'package:time_widgets/screens/timetable_edit_screen.dart';
import 'package:time_widgets/services/countdown_storage_service.dart';
import 'package:time_widgets/services/course_reminder_service.dart';
import 'package:time_widgets/services/enhanced_window_manager.dart';
import 'package:time_widgets/services/global_animation_service.dart';
import 'package:time_widgets/services/md3_tray_menu_service.dart';
import 'package:time_widgets/services/ntp_service.dart';
import 'package:time_widgets/services/performance_optimization_service.dart';
import 'package:time_widgets/services/settings_service.dart';
import 'package:time_widgets/services/startup_service.dart';
import 'package:time_widgets/services/temp_schedule_change_service.dart';
import 'package:time_widgets/services/theme_service.dart';
import 'package:time_widgets/services/timetable_storage_service.dart';
import 'package:time_widgets/utils/logger.dart';
import 'package:time_widgets/utils/memory_optimizer.dart';
import 'package:time_widgets/utils/responsive_utils.dart';
import 'package:time_widgets/utils/theme_utils.dart';
import 'package:time_widgets/widgets/dynamic_color_builder.dart';
import 'package:window_manager/window_manager.dart';

void main(List<String> args) async {
  WidgetsFlutterBinding.ensureInitialized();

  if (args.firstOrNull == 'multi_window') {
    try {
      final windowId = args[1]; // desktop_multi_window 0.3.0+ uses String IDs

      // 在runApp之前初始化子窗口属性
      await windowManager.ensureInitialized();

      // 设置窗口属性
      const WindowOptions windowOptions = WindowOptions(
        size: Size(450, 100),
        center: true,
        backgroundColor: Colors.transparent,
        skipTaskbar: false,
        titleBarStyle: TitleBarStyle.hidden,
      );

      await windowManager.waitUntilReadyToShow(windowOptions, () async {
        await windowManager.setAsFrameless();
        await windowManager.setBackgroundColor(Colors.transparent);
        await windowManager.setAlwaysOnTop(true);
        await windowManager.setHasShadow(false);
        await windowManager.show();
      });

      runApp(DynamicIslandApp(windowId: windowId));
    } catch (e) {
      debugPrint('Error starting dynamic island: $e');
      runApp(
        MaterialApp(
          home: Scaffold(
            backgroundColor: Colors.white,
            body: SingleChildScrollView(
              child: Center(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        'Error: $e',
                        style: const TextStyle(color: Colors.red),
                      ),
                      const SizedBox(height: 16),
                      Text(
                        'Args: $args',
                        style: const TextStyle(color: Colors.black87),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      );
    }
  } else {
    // 禁用调试信息以减少内存和CPU
    debugPrint = (message, {wrapWidth}) {};

    runApp(const TimeWidgetsApp());
  }
}

class DynamicIslandApp extends StatelessWidget {
  const DynamicIslandApp({super.key, required this.windowId});
  final String windowId;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: DynamicIslandScreen(windowId: windowId),
      theme: ThemeUtils.buildLightTheme().copyWith(
        scaffoldBackgroundColor: Colors.transparent,
        canvasColor: Colors.transparent,
      ),
    );
  }
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

class _DesktopWrapperState extends State<DesktopWrapper> with WindowListener {
  final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();
  final ThemeService _themeService = ThemeService();
  final SettingsService _settingsService = SettingsService();
  final CourseReminderService _courseReminderService = CourseReminderService();
  StreamSubscription<dynamic>? _settingsSubscription;
  bool _isWindowVisible = true;
  bool _isWindowInitialized = false;
  bool _showTrayMenu = false;
  bool _isEditMode = false;
  // bool _isDynamicIslandMode = false; // 已废弃，使用多窗口

  @override
  void initState() {
    super.initState();
    windowManager.addListener(this);

    // 加载设置并初始化UI缩放
    _settingsService.loadSettings().then((settings) async {
      ResponsiveUtils.setScaleFactor(settings.uiScale);

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

    // 监听设置变化
    _settingsSubscription = _settingsService.settingsStream.listen((settings) {
      bool shouldRebuild = false;

      if (ResponsiveUtils.scaleFactor != settings.uiScale) {
        ResponsiveUtils.setScaleFactor(settings.uiScale);
        shouldRebuild = true;
      } else {
        // 其他设置改变也应该触发重绘
        shouldRebuild = true;
      }

      // 根据设置更新窗口可见性
      if (!settings.enableDesktopWidgets && !_showTrayMenu && !_isEditMode) {
        if (_isWindowVisible) {
          _hideMainWindow();
        }
      } else if (settings.enableDesktopWidgets) {
        if (!_isWindowVisible) {
          _showMainWindow();
        }
      }

      if (shouldRebuild && mounted) {
        setState(() {});
      }
    });

    // 加载主题设置
    _themeService.loadSettings();

    // 初始化窗口
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _initializeWindow();
      // 只初始化一个托盘服务，避免冲突
      _initializeSystemTray();
    });
  }

  /// 初始化窗口配置
  Future<void> _initializeWindow() async {
    if (_isWindowInitialized) {
      return;
    }

    try {
      final success = await EnhancedWindowManager.initializeWindow(
        onScreenSizeChanged: () {
          // 处理屏幕尺寸变化，可能需要重新布局
          // 延迟执行，避免在构建过程中触发重建
          unawaited(
            Future.delayed(const Duration(milliseconds: 100), () {
              if (mounted) {
                setState(() {
                  // 触发重建
                });
              }
            }),
          );
        },
      );

      if (!success) {
        Logger.w(
          'Enhanced window initialization failed, falling back to default',
        );
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
      // trayService.onImportExport = _showImportExportMenu;  // 已移除
      trayService.onTempScheduleChange = _showTempScheduleChangeMenu; // 新增

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

    // 如果没有开启桌面挂件且不在编辑模式，隐藏窗口
    if (!_settingsService.currentSettings.enableDesktopWidgets &&
        !_isEditMode) {
      _hideMainWindow();
    }
  }

  /// 导航到设置页面
  void _navigateToSettings() {
    _hideMD3TrayMenu();

    final context = navigatorKey.currentContext;
    if (context == null) {
      return;
    }

    // 使用全屏对话框而不是创建新窗口，避免影响桌面小组件位置
    unawaited(
      showDialog<void>(
        context: context,
        builder: (dialogContext) => const Dialog.fullscreen(
          child: SettingsScreen(),
        ),
      ),
    );
  }

  /// 导航到课表编辑页面
  Future<void> _navigateToTimetableEdit() async {
    _hideMD3TrayMenu();

    // 创建独立的16:9窗口
    await EnhancedWindowManager.createEditWindow('课表编辑');

    // 打开课表编辑页面时，禁用指针穿透，确保可以交互
    await EnhancedWindowManager.setIgnoreMouseEvents(false);

    if (navigatorKey.currentState != null) {
      await navigatorKey.currentState!.push(
        MaterialPageRoute<void>(
          builder: (context) => const TimetableEditScreen(),
        ),
      );

      // 页面关闭后恢复主窗口状态
      await EnhancedWindowManager.restoreMainWindow();
    }
  }

  /// 显示临时调课菜单
  void _showTempScheduleChangeMenu() {
    _hideMD3TrayMenu();

    // 确保窗口可见
    if (!_isWindowVisible) {
      _showMainWindow();
    }

    // 使用navigatorKey来显示对话框
    final context = navigatorKey.currentContext;
    if (context == null) {
      return;
    }

    // 显示临时调课选项对话框
    unawaited(
      showDialog<void>(
        context: context,
        builder: (dialogContext) => AlertDialog(
          title: const Text('临时调课'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: const Icon(Icons.today_outlined),
                title: const Text('按天调课'),
                subtitle: const Text('调整某一天的课程安排'),
                onTap: () {
                  Navigator.pop(dialogContext);
                  _showDayScheduleChange();
                },
              ),
              const Divider(),
              ListTile(
                leading: const Icon(Icons.schedule_outlined),
                title: const Text('按节调课'),
                subtitle: const Text('调整某一节课的内容'),
                onTap: () {
                  Navigator.pop(dialogContext);
                  _showPeriodScheduleChange();
                },
              ),
              const Divider(),
              ListTile(
                leading: const Icon(Icons.manage_history_outlined),
                title: const Text('管理临时调课'),
                subtitle: const Text('查看和删除已设置的调课'),
                onTap: () {
                  Navigator.pop(dialogContext);
                  _navigateToTempScheduleManage();
                },
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(dialogContext),
              child: const Text('取消'),
            ),
          ],
        ),
      ),
    );
  }

  /// 导航到临时调课管理页面
  void _navigateToTempScheduleManage() {
    final context = navigatorKey.currentContext;
    if (context == null) {
      return;
    }

    // 使用全屏对话框而不是创建新窗口，避免影响桌面小组件位置
    unawaited(
      showDialog<void>(
        context: context,
        builder: (dialogContext) => const Dialog.fullscreen(
          child: TempScheduleManageScreen(),
        ),
      ),
    );
  }

  /// 按天调课
  Future<void> _showDayScheduleChange() async {
    final context = navigatorKey.currentContext;
    if (context == null) {
      return;
    }

    // 加载课表数据
    final storageService = TimetableStorageService();
    final timetableData = await storageService.loadTimetableData();

    if (timetableData.schedules.isEmpty) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('没有可用的课表，请先创建课表'),
            backgroundColor: Colors.orange,
          ),
        );
      }
      return;
    }

    DateTime selectedDate = DateTime.now();
    String? selectedScheduleId;

    if (!context.mounted) {
      return;
    }

    unawaited(
      showDialog<void>(
        context: context,
        builder: (dialogContext) => StatefulBuilder(
          builder: (context, setState) => AlertDialog(
            title: const Text('按天调课'),
            content: SizedBox(
              width: 400,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('选择要调整的日期：'),
                  const SizedBox(height: 8),
                  ListTile(
                    leading: const Icon(Icons.calendar_today),
                    title: Text(
                      '${selectedDate.year}-${selectedDate.month.toString().padLeft(2, '0')}-${selectedDate.day.toString().padLeft(2, '0')}',
                    ),
                    trailing: const Icon(Icons.arrow_drop_down),
                    onTap: () async {
                      final date = await showDatePicker(
                        context: dialogContext,
                        initialDate: selectedDate,
                        firstDate: DateTime.now(),
                        lastDate: DateTime.now().add(const Duration(days: 365)),
                      );
                      if (date != null) {
                        setState(() {
                          selectedDate = date;
                        });
                      }
                    },
                  ),
                  const SizedBox(height: 16),
                  const Text('选择要使用的课表：'),
                  const SizedBox(height: 8),
                  Container(
                    constraints: const BoxConstraints(maxHeight: 300),
                    child: SingleChildScrollView(
                      child: Column(
                        children: timetableData.schedules.map((schedule) {
                          return RadioListTile<String>(
                            title: Text(schedule.name),
                            subtitle: Text(_getScheduleDescription(schedule)),
                            value: schedule.id,
                            groupValue: selectedScheduleId,
                            onChanged: (value) {
                              setState(() {
                                selectedScheduleId = value;
                              });
                            },
                          );
                        }).toList(),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(dialogContext),
                child: const Text('取消'),
              ),
              FilledButton(
                onPressed: selectedScheduleId == null
                    ? null
                    : () async {
                        await _saveDayScheduleChange(
                          selectedDate,
                          selectedScheduleId!,
                        );
                        if (dialogContext.mounted) {
                          Navigator.pop(dialogContext);
                        }
                      },
                child: const Text('确定'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// 获取课表描述
  String _getScheduleDescription(Schedule schedule) {
    final weekDays = ['周日', '周一', '周二', '周三', '周四', '周五', '周六'];
    final weekDay = weekDays[schedule.triggerRule.weekDay];
    final weekType = schedule.triggerRule.weekType == WeekType.single
        ? '单周'
        : schedule.triggerRule.weekType == WeekType.double
            ? '双周'
            : '每周';
    return '$weekType$weekDay • ${schedule.courses.length}节课';
  }

  /// 保存按天调课记录
  Future<void> _saveDayScheduleChange(DateTime date, String scheduleId) async {
    try {
      final tempService = TempScheduleChangeService();

      // 检查是否已有该日期的调课记录
      final existingChange = await tempService.getDayChangeForDate(date);
      if (existingChange != null) {
        await tempService.removeChange(existingChange.id);
      }

      // 创建新的调课记录
      final change = TempScheduleChange(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        type: TempChangeType.day,
        date: date,
        newScheduleId: scheduleId,
        createdAt: DateTime.now(),
      );

      await tempService.addChange(change);

      final context = navigatorKey.currentContext;
      if (context != null && context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              '已设置 ${date.month}月${date.day}日 的临时课表',
            ),
          ),
        );
      }
    } catch (e) {
      final context = navigatorKey.currentContext;
      if (context != null && context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('保存失败: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  /// 按节调课
  Future<void> _showPeriodScheduleChange() async {
    final context = navigatorKey.currentContext;
    if (context == null) {
      return;
    }

    // 加载课表数据
    final storageService = TimetableStorageService();
    final timetableData = await storageService.loadTimetableData();

    if (timetableData.courses.isEmpty) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('没有可用的课程，请先创建课程'),
            backgroundColor: Colors.orange,
          ),
        );
      }
      return;
    }

    DateTime selectedDate = DateTime.now();
    String? selectedTimeSlotId;
    String? selectedCourseId;

    // 获取时间段列表
    final timeSlots = timetableData.timeSlots.isNotEmpty
        ? timetableData.timeSlots
        : timetableData.timeLayouts.isNotEmpty
            ? timetableData.timeLayouts.first.timeSlots
            : <TimeSlot>[];

    if (timeSlots.isEmpty) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('没有可用的时间段，请先创建时间表'),
            backgroundColor: Colors.orange,
          ),
        );
      }
      return;
    }

    if (!context.mounted) {
      return;
    }

    unawaited(
      showDialog<void>(
        context: context,
        builder: (dialogContext) => StatefulBuilder(
          builder: (context, setState) => AlertDialog(
            title: const Text('按节调课'),
            content: SizedBox(
              width: 400,
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('选择日期：'),
                    const SizedBox(height: 8),
                    ListTile(
                      leading: const Icon(Icons.calendar_today),
                      title: Text(
                        '${selectedDate.year}-${selectedDate.month.toString().padLeft(2, '0')}-${selectedDate.day.toString().padLeft(2, '0')}',
                      ),
                      trailing: const Icon(Icons.arrow_drop_down),
                      onTap: () async {
                        final date = await showDatePicker(
                          context: dialogContext,
                          initialDate: selectedDate,
                          firstDate: DateTime.now(),
                          lastDate:
                              DateTime.now().add(const Duration(days: 365)),
                        );
                        if (date != null) {
                          setState(() {
                            selectedDate = date;
                          });
                        }
                      },
                    ),
                    const SizedBox(height: 16),
                    const Text('选择节次：'),
                    const SizedBox(height: 8),
                    Container(
                      constraints: const BoxConstraints(maxHeight: 200),
                      child: SingleChildScrollView(
                        child: Column(
                          children: timeSlots.map((slot) {
                            return RadioListTile<String>(
                              title: Text(slot.name),
                              subtitle:
                                  Text('${slot.startTime} - ${slot.endTime}'),
                              value: slot.id,
                              groupValue: selectedTimeSlotId,
                              onChanged: (value) {
                                setState(() {
                                  selectedTimeSlotId = value;
                                });
                              },
                            );
                          }).toList(),
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    const Text('选择新课程：'),
                    const SizedBox(height: 8),
                    Container(
                      constraints: const BoxConstraints(maxHeight: 200),
                      child: SingleChildScrollView(
                        child: Column(
                          children: timetableData.courses.map((course) {
                            return RadioListTile<String>(
                              title: Text(course.name),
                              subtitle: Text(course.teacher),
                              value: course.id,
                              groupValue: selectedCourseId,
                              onChanged: (value) {
                                setState(() {
                                  selectedCourseId = value;
                                });
                              },
                            );
                          }).toList(),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(dialogContext),
                child: const Text('取消'),
              ),
              FilledButton(
                onPressed:
                    selectedTimeSlotId == null || selectedCourseId == null
                        ? null
                        : () async {
                            await _savePeriodScheduleChange(
                              selectedDate,
                              selectedTimeSlotId!,
                              selectedCourseId!,
                            );
                            if (dialogContext.mounted) {
                              Navigator.pop(dialogContext);
                            }
                          },
                child: const Text('确定'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// 保存按节调课记录
  Future<void> _savePeriodScheduleChange(
    DateTime date,
    String timeSlotId,
    String courseId,
  ) async {
    try {
      final tempService = TempScheduleChangeService();

      // 检查是否已有该日期和节次的调课记录
      final existingChange =
          await tempService.getChangeForPeriod(date, timeSlotId);
      if (existingChange != null) {
        await tempService.removeChange(existingChange.id);
      }

      // 创建新的调课记录
      final change = TempScheduleChange(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        type: TempChangeType.period,
        date: date,
        timeSlotId: timeSlotId,
        newCourseId: courseId,
        createdAt: DateTime.now(),
      );

      await tempService.addChange(change);

      final context = navigatorKey.currentContext;
      if (context != null && context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              '已设置 ${date.month}月${date.day}日 的临时调课',
            ),
          ),
        );
      }
    } catch (e) {
      final context = navigatorKey.currentContext;
      if (context != null && context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('保存失败: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
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

      // 如果没有开启桌面挂件且不在编辑模式，隐藏窗口
      if (!_settingsService.currentSettings.enableDesktopWidgets) {
        _hideMainWindow();
      }
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
  Future<void> _exitApplication() async {
    await MD3TrayMenuService.instance.destroy();
    
    try {
      // 允许窗口关闭
      await windowManager.setPreventClose(false);
    } catch (e) {
      Logger.e('Error setting prevent close to false: $e');
    }

    appWindow.close();
    
    // 强制退出进程，确保所有后台任务（如Timer）都被终止
    exit(0);
  }

  @override
  Future<void> onWindowClose() async {
    final settings = _settingsService.currentSettings;
    if (settings.minimizeToTray) {
      // 最小化到托盘（隐藏窗口）
      await windowManager.hide();
      setState(() {
        _isWindowVisible = false;
      });

      // 显示提示（可选）
      // if (mounted) {
      //   ScaffoldMessenger.of(context).showSnackBar(
      //     const SnackBar(content: Text('已最小化到托盘')),
      //   );
      // }
    } else {
      await _exitApplication();
    }
  }

  @override
  void dispose() {
    windowManager.removeListener(this);
    _settingsSubscription?.cancel();
    _themeService.dispose();
    _courseReminderService.dispose();
    _settingsService.dispose();
    NtpService().dispose();
    MD3TrayMenuService.instance.destroy();

    // 清理新增的需要手动释放的服务
    GlobalAnimationService.instance.dispose();
    EnhancedWindowManager.dispose();
    PerformanceOptimizationService.stopMemoryMonitoring();
    PerformanceOptimizationService.stopPerformanceMonitoring();
    CountdownStorageService().dispose();

    MemoryOptimizer.stopAggressiveGC();
    MemoryOptimizer.clearImageCache();
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
            final themeSettings =
                snapshot.data ?? _themeService.currentSettings;

            return MaterialApp(
              navigatorKey: navigatorKey,
              title: '智慧课程表',
              localizationsDelegates: const [
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
                      onTempScheduleChange: _showTempScheduleChangeMenu, // 新增
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
