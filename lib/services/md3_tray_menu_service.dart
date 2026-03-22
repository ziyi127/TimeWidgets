import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:tray_manager/tray_manager.dart';
import 'package:time_widgets/services/global_animation_service.dart';
import 'package:time_widgets/utils/logger.dart';

/// MD3 风格的系统托盘菜单服务
/// 使用 system_tray 库实现系统托盘功能
class MD3TrayMenuService {
  MD3TrayMenuService._();
  static MD3TrayMenuService? _instance;
  static MD3TrayMenuService get instance =>
      _instance ??= MD3TrayMenuService._();

  bool _isInitialized = false;
  bool _linuxTrayListenerRegistered = false;

  static const String _actionToggleWindow = 'toggle_window';
  static const String _actionEditTimetable = 'edit_timetable';
  static const String _actionEditLayout = 'edit_layout';
  static const String _actionTempSchedule = 'temp_schedule';
  static const String _actionSettings = 'settings';
  static const String _actionExit = 'exit';

  // 回调函数
  VoidCallback? onShowSettings;
  VoidCallback? onShowTimetableEdit;
  VoidCallback? onToggleWindow;
  VoidCallback? onToggleEditMode;
  VoidCallback? onExit;
  VoidCallback? onTempScheduleChange; // 新增：临时调课回调

  // MD3 菜单显示回调 - 由 main.dart 设置
  VoidCallback? onShowMD3Menu;

  /// 初始化系统托盘
  Future<bool> initialize() async {
    if (_isInitialized) return true;

    try {
      final iconPath = _resolveTrayIconPath();
      await trayManager.setIcon(iconPath);
      await _trySetTrayTooltip('智慧课程表');
      await trayManager.setContextMenu(_buildNativeTrayMenu());
      if (!_linuxTrayListenerRegistered) {
        trayManager.addListener(_linuxTrayListener);
        _linuxTrayListenerRegistered = true;
      }

      _isInitialized = true;
      Logger.i('系统托盘初始化成功（tray_manager）');
      return true;
    } catch (e) {
      Logger.e('系统托盘初始化失败: $e');
      _isInitialized = false;
      return false;
    }
  }

  /// 更新托盘提示
  Future<void> updateTooltip(String tooltip) async {
    if (!_isInitialized) return;

    try {
      await _trySetTrayTooltip(tooltip);
    } catch (e) {
      Logger.e('更新托盘提示失败: $e');
    }
  }

  Future<void> _trySetTrayTooltip(String tooltip) async {
    try {
      await trayManager.setToolTip(tooltip);
    } on MissingPluginException {
      // 某些 Linux 发行版/插件版本不支持 tooltip，忽略即可。
    }
  }

  Menu _buildNativeTrayMenu() {
    return Menu(
      items: [
        MenuItem(
          key: _actionToggleWindow,
          label: '显示/隐藏窗口',
        ),
        MenuItem.separator(),
        MenuItem(
          key: _actionEditTimetable,
          label: '编辑课表',
        ),
        MenuItem(
          key: _actionEditLayout,
          label: '编辑布局',
        ),
        MenuItem(
          key: _actionTempSchedule,
          label: '临时调课',
        ),
        MenuItem(
          key: _actionSettings,
          label: '设置',
        ),
        MenuItem.separator(),
        MenuItem(
          key: _actionExit,
          label: '退出',
        ),
      ],
    );
  }

  String _resolveTrayIconPath() {
    final candidates = <String>[
      'assets/icons/tray_icon.png',
      'assets/icons/app_icon.png',
      '${Directory.current.path}/assets/icons/tray_icon.png',
      '${Directory.current.path}/assets/icons/app_icon.png',
      '${Directory.current.path}/data/flutter_assets/assets/icons/tray_icon.png',
      '${Directory.current.path}/data/flutter_assets/assets/icons/app_icon.png',
      // 某些平台也可接受 ico，作为末级回退。
      'assets/icons/tray_icon.ico',
      '${Directory.current.path}/assets/icons/tray_icon.ico',
      '${Directory.current.path}/data/flutter_assets/assets/icons/tray_icon.ico',
    ];

    for (final candidate in candidates) {
      if (File(candidate).existsSync()) {
        return File(candidate).absolute.path;
      }
    }

    return 'assets/icons/app_icon.png';
  }

  /// 销毁托盘
  Future<void> destroy() async {
    try {
      if (_linuxTrayListenerRegistered) {
        trayManager.removeListener(_linuxTrayListener);
        _linuxTrayListenerRegistered = false;
      }
      await trayManager.destroy();
    } catch (e) {
      Logger.e('销毁托盘失败: $e');
    }
    _isInitialized = false;
  }

  bool get isInitialized => _isInitialized;

  final _linuxTrayListener = _LinuxTrayListener();
}

class _LinuxTrayListener with TrayListener {
  @override
  void onTrayIconMouseDown() {
    MD3TrayMenuService.instance.onShowMD3Menu?.call();
  }

  @override
  void onTrayIconRightMouseDown() {
    MD3TrayMenuService.instance.onShowMD3Menu?.call();
  }

  @override
  void onTrayMenuItemClick(MenuItem menuItem) {
    switch (menuItem.key) {
      case MD3TrayMenuService._actionToggleWindow:
        MD3TrayMenuService.instance.onToggleWindow?.call();
        return;
      case MD3TrayMenuService._actionEditTimetable:
        MD3TrayMenuService.instance.onShowTimetableEdit?.call();
        return;
      case MD3TrayMenuService._actionEditLayout:
        MD3TrayMenuService.instance.onToggleEditMode?.call();
        return;
      case MD3TrayMenuService._actionTempSchedule:
        MD3TrayMenuService.instance.onTempScheduleChange?.call();
        return;
      case MD3TrayMenuService._actionSettings:
        MD3TrayMenuService.instance.onShowSettings?.call();
        return;
      case MD3TrayMenuService._actionExit:
        MD3TrayMenuService.instance.onExit?.call();
        return;
      default:
        return;
    }
  }
}

/// MD3 风格的托盘悬浮菜单
/// 显示在屏幕右下角，靠近系统托盘位置
class MD3TrayPopupMenu extends StatefulWidget {
  const MD3TrayPopupMenu({
    super.key,
    this.onShowSettings,
    this.onShowTimetableEdit,
    this.onToggleWindow,
    this.onToggleEditMode,
    this.onExit,
    // this.onImportExport,
    this.onTempScheduleChange, // 新增
    this.onDismiss,
  });
  final VoidCallback? onShowSettings;
  final VoidCallback? onShowTimetableEdit;
  final VoidCallback? onToggleWindow;
  final VoidCallback? onToggleEditMode;
  final VoidCallback? onExit;
  // final VoidCallback? onImportExport;
  final VoidCallback? onTempScheduleChange; // 新增
  final VoidCallback? onDismiss;

  @override
  State<MD3TrayPopupMenu> createState() => _MD3TrayPopupMenuState();
}

class _MD3TrayPopupMenuState extends State<MD3TrayPopupMenu>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _opacityAnimation;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();

    // 使用全局动画服务初始化动画控制器
    _animationController =
        GlobalAnimationService.instance.getAnimationController(
      key: 'tray_menu_animation',
      vsync: this,
      duration: GlobalAnimationService.defaultDuration,
    );

    // 使用全局动画服务创建淡入动画
    _opacityAnimation = GlobalAnimationService.instance.createFadeAnimation(
      key: 'tray_menu',
      controller: _animationController,
      curve: GlobalAnimationService.defaultCurve,
    );

    // 使用全局动画服务创建缩放动画
    _scaleAnimation = GlobalAnimationService.instance.createScaleAnimation(
      key: 'tray_menu',
      controller: _animationController,
      curve: GlobalAnimationService.popCurve,
    );

    // 开始动画
    GlobalAnimationService.instance.smartAnimate(
      controller: _animationController,
      target: 1,
    );
  }

  @override
  void dispose() {
    // 不在这里 dispose，因为动画控制器可能被缓存重用
    // _animationController.dispose();
    super.dispose();
  }

  /// 安全关闭菜单，带反向动画效果
  void _safeCloseMenu(VoidCallback? action) {
    // 使用全局动画服务的智能反向动画
    GlobalAnimationService.instance.smartReverse(
      controller: _animationController,
    );
    // 直接执行操作，不等待动画结束
    action?.call();
    // 调用关闭回调
    widget.onDismiss?.call();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Material(
      color: Colors.transparent,
      child: ColoredBox(
        color: Colors.transparent,
        child: Stack(
          children: [
            FadeTransition(
              opacity: _opacityAnimation,
              child: ScaleTransition(
                scale: _scaleAnimation,
                alignment: Alignment.bottomRight,
                child: Container(
                  width: 240,
                  decoration: BoxDecoration(
                    color: colorScheme.surfaceContainerHigh,
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: colorScheme.shadow.withValues(alpha: 0.2),
                        blurRadius: 20,
                        offset: const Offset(0, 8),
                      ),
                    ],
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      _buildMenuHeader(theme, colorScheme),
                      Divider(
                        height: 1,
                        color: colorScheme.outlineVariant,
                      ),
                      _buildMenuItems(context),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMenuHeader(ThemeData theme, ColorScheme colorScheme) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 12),
      child: Row(
        children: [
          Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              color: colorScheme.primaryContainer,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(
              Icons.schedule_rounded,
              color: colorScheme.onPrimaryContainer,
              size: 20,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '智慧课程表',
                  style: theme.textTheme.titleSmall?.copyWith(
                    color: colorScheme.onSurface,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Text(
                  '桌面小组件',
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: colorScheme.onSurfaceVariant,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMenuItems(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        // 菜单项 - 按功能分组
        // 窗口控制
        _buildMenuItem(
          context: context,
          icon: Icons.visibility_rounded,
          label: '显示/隐藏窗口',
          onTap: () {
            _safeCloseMenu(widget.onToggleWindow);
          },
        ),

        // 功能设置
        _buildMenuItem(
          context: context,
          icon: Icons.edit_calendar_rounded,
          label: '编辑课表',
          onTap: () {
            _safeCloseMenu(widget.onShowTimetableEdit);
          },
        ),

        _buildMenuItem(
          context: context,
          icon: Icons.dashboard_customize_rounded,
          label: '编辑布局',
          onTap: () {
            _safeCloseMenu(widget.onToggleEditMode);
          },
        ),

        _buildMenuItem(
          context: context,
          icon: Icons.swap_horiz_rounded,
          label: '临时调课',
          onTap: () {
            _safeCloseMenu(widget.onTempScheduleChange);
          },
        ),

        _buildMenuItem(
          context: context,
          icon: Icons.settings_rounded,
          label: '设置',
          onTap: () {
            _safeCloseMenu(widget.onShowSettings);
          },
        ),

        // 分隔线
        Divider(
          height: 1,
          indent: 16,
          endIndent: 16,
          color: colorScheme.outlineVariant,
        ),

        // 程序控制
        _buildMenuItem(
          context: context,
          icon: Icons.exit_to_app_rounded,
          label: '退出程序',
          isDestructive: true,
          onTap: () {
            _safeCloseMenu(widget.onExit);
          },
        ),

        const SizedBox(height: 8),
      ],
    );
  }

  Widget _buildMenuItem({
    required BuildContext context,
    required IconData icon,
    required String label,
    required VoidCallback onTap,
    bool isDestructive = false,
  }) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    final color = isDestructive ? colorScheme.error : colorScheme.onSurface;
    final hoverColor = isDestructive
        ? colorScheme.errorContainer.withValues(alpha: 0.2)
        : colorScheme.surfaceContainerHighest;
    final focusColor = colorScheme.onSurface.withValues(alpha: 0.1);

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      hoverColor: hoverColor,
      focusColor: focusColor,
      highlightColor: colorScheme.onSurface.withValues(alpha: 0.1),
      splashColor: colorScheme.onSurface.withValues(alpha: 0.15),
      child: DecoratedBox(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
          child: Row(
            children: [
              Icon(
                icon,
                color: color,
                size: 22,
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  label,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: color,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
