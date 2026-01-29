import 'dart:async';

import 'package:provider/provider.dart';

import 'package:flutter/material.dart';
import 'package:time_widgets/l10n/app_localizations.dart';
import 'package:time_widgets/services/desktop_widget_service.dart';
import 'package:time_widgets/services/settings_service.dart';
import 'package:time_widgets/utils/logger.dart';
import 'package:time_widgets/utils/responsive_utils.dart';
import 'package:time_widgets/view_models/countdown_view_model.dart';
import 'package:time_widgets/view_models/timetable_view_model.dart';
import 'package:time_widgets/view_models/weather_view_model.dart';
import 'package:time_widgets/widgets/countdown_widget.dart';
import 'package:time_widgets/widgets/current_class_widget.dart';
import 'package:time_widgets/widgets/date_display_widget.dart';
import 'package:time_widgets/widgets/enhanced_widget_wrapper.dart';
import 'package:time_widgets/widgets/time_display_widget.dart';
import 'package:time_widgets/widgets/timetable_widget.dart';
import 'package:time_widgets/widgets/weather_widget.dart';
import 'package:time_widgets/widgets/week_display_widget.dart';

/// 桌面小组件屏幕 - 自适应布局版
class DesktopWidgetScreen extends StatefulWidget {
  const DesktopWidgetScreen({
    super.key,
    this.isEditMode = false,
  });
  final bool isEditMode;

  @override
  State<DesktopWidgetScreen> createState() => _DesktopWidgetScreenState();
}

class _DesktopWidgetScreenState extends State<DesktopWidgetScreen> {
  final SettingsService _settingsService = SettingsService();

  // 数据状态
  // Weather state moved to WeatherViewModel
  // Countdown state moved to CountdownViewModel
  // Timetable state moved to TimetableViewModel

  // 布局状态
  Map<WidgetType, WidgetPosition>? _layout;
  bool _isLayoutLoaded = false;

  // 添加防抖相关变量
  Timer? _layoutTimer;

  @override
  void initState() {
    super.initState();
    // Countdown listener removed - handled by ViewModel

    // 延迟到下一帧执行，避免在构建过程中调用 setState
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadData();
      _loadLayout();
    });
  }

  void _loadData() {
    // Weather loading is handled by WeatherViewModel
    // Countdown loading is handled by CountdownViewModel
    // Timetable loading is handled by TimetableViewModel
  }

  Future<void> _loadLayout() async {
    try {
      final screenSize = MediaQuery.of(context).size;
      final layout = await DesktopWidgetService.loadWidgetPositions(screenSize);
      if (mounted) {
        setState(() {
          _layout = layout;
          _isLayoutLoaded = true;
        });
      }
    } catch (e) {
      Logger.e('Failed to load layout: $e');
      if (mounted) {
        setState(() {
          _isLayoutLoaded = true;
          // _layout will be null, handled in build
        });
      }
    }
  }

  // Weather loading methods removed - use WeatherViewModel instead

  Widget _buildWidget(WidgetType type) {
    final settings = _settingsService.currentSettings;

    switch (type) {
      case WidgetType.time:
        if (!settings.showTimeDisplayWidget) return const SizedBox.shrink();
        return const EnhancedWidgetWrapper(
          padding: EdgeInsets.zero,
          backgroundColor:
              Colors.transparent, // Time widget has its own card style
          child: TimeDisplayWidget(isCompact: true),
        );
      case WidgetType.date:
        if (!settings.showDateDisplayWidget) return const SizedBox.shrink();
        return const EnhancedWidgetWrapper(
          padding: EdgeInsets.zero,
          backgroundColor: Colors.transparent,
          child: DateDisplayWidget(isCompact: true),
        );
      case WidgetType.week:
        if (!settings.showWeekDisplayWidget) return const SizedBox.shrink();
        return const EnhancedWidgetWrapper(
          padding: EdgeInsets.zero,
          backgroundColor: Colors.transparent,
          child: WeekDisplayWidget(isCompact: true),
        );
      case WidgetType.weather:
        if (!settings.showWeatherWidget) return const SizedBox.shrink();
        
        // Use Consumer to listen to WeatherViewModel updates
        return Consumer<WeatherViewModel>(
          builder: (context, weatherVM, child) {
            return EnhancedWidgetWrapper(
              padding: EdgeInsets.zero,
              backgroundColor: Colors.transparent,
              onTap: weatherVM.refreshWeather,
              child: WeatherWidget(
                weatherData: weatherVM.isLoading && weatherVM.weatherData == null 
                    ? null 
                    : weatherVM.weatherData,
                error: weatherVM.error,
                onRetry: weatherVM.refreshWeather,
                isCompact: true,
              ),
            );
          },
        );
      case WidgetType.currentClass:
        if (!settings.showCurrentClassWidget) return const SizedBox.shrink();
        
        return Consumer<TimetableViewModel>(
          builder: (context, timetableVM, child) {
            return EnhancedWidgetWrapper(
              padding: EdgeInsets.zero,
              backgroundColor: Colors.transparent,
              onTap: timetableVM.refreshTimetable,
              child: CurrentClassWidget(
                isCompact: true,
                course: timetableVM.currentCourse,
                isLoading: timetableVM.isLoading,
              ),
            );
          },
        );
      case WidgetType.countdown:
        if (!settings.showCountdownWidget) return const SizedBox.shrink();
        
        // Use Consumer to listen to CountdownViewModel updates
        return Consumer<CountdownViewModel>(
          builder: (context, countdownVM, child) {
            return EnhancedWidgetWrapper(
              padding: EdgeInsets.zero,
              backgroundColor: Colors.transparent,
              onTap: countdownVM.refreshCountdown,
              child: CountdownWidget(
                countdownData: countdownVM.isLoading && countdownVM.countdownData == null
                    ? null 
                    : countdownVM.countdownData,
                error: countdownVM.error,
                onRetry: countdownVM.refreshCountdown,
                isCompact: true,
              ),
            );
          },
        );
      case WidgetType.timetable:
        return Consumer<TimetableViewModel>(
          builder: (context, timetableVM, child) {
            return EnhancedWidgetWrapper(
              padding: EdgeInsets.zero,
              backgroundColor: Colors.transparent,
              onTap: timetableVM.refreshTimetable,
              child: TimetableWidget(
                isCompact: true,
                courses: timetableVM.timetable?.courses,
              ),
            );
          },
        );
      case WidgetType.settings:
        // 设置按钮通常由托盘管理，但在布局中预留位置
        return const SizedBox.shrink();
    }
  }

  @override
  void dispose() {
    _layoutTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: LayoutBuilder(
        builder: (context, constraints) {
          // 如果禁用了桌面小组件且不在编辑模式，显示提示信息
          if (!_settingsService.currentSettings.enableDesktopWidgets &&
              !widget.isEditMode) {
            return Center(
              child: Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.surfaceContainer,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.1),
                      blurRadius: 10,
                    ),
                  ],
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.widgets_outlined,
                      size: 48,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                    const SizedBox(height: 16),
                    Text(
                      AppLocalizations.of(context)!.desktopWidgetDisabled,
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      AppLocalizations.of(context)!.desktopWidgetDisabledHint,
                      style: Theme.of(context).textTheme.bodyMedium,
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            );
          }

          if (!_isLayoutLoaded) {
            return const Center(child: CircularProgressIndicator());
          }

          // 如果布局为空，使用默认布局
          if (_layout == null) {
            return Center(child: Text(AppLocalizations.of(context)!.error));
          }

          final layout = _layout!;
          return Stack(
            children: layout.entries.map((entry) {
              if (!entry.value.isVisible) return const SizedBox.shrink();

              return Positioned(
                left: entry.value.x,
                top: entry.value.y,
                child: AnimatedOpacity(
                  duration: const Duration(milliseconds: 500),
                  opacity: _isLayoutLoaded ? 1.0 : 0.0,
                  curve: Curves.easeIn,
                  child: ConstrainedBox(
                    constraints: BoxConstraints(
                      maxWidth: entry.value.width,
                      // 移除 maxHeight 限制，让组件根据内容自适应高度
                    ),
                    child: widget.isEditMode
                        ? GestureDetector(
                            onPanUpdate: (details) {
                              setState(() {
                                final currentPos = layout[entry.key];
                                if (currentPos != null) {
                                  layout[entry.key] = currentPos.copyWith(
                                    x: currentPos.x + details.delta.dx,
                                    y: currentPos.y + details.delta.dy,
                                  );
                                }
                              });
                            },
                            onPanEnd: (details) {
                              // 直接保存当前布局
                              final currentLayout = _layout;
                              if (currentLayout != null) {
                                // 保存位置
                                DesktopWidgetService.saveWidgetPositions(
                                  currentLayout,
                                );
                                Logger.i('Widget positions saved after drag');
                              }
                            },
                            child: MouseRegion(
                              cursor: SystemMouseCursors.move,
                              child: DecoratedBox(
                                decoration: BoxDecoration(
                                  border: Border.all(
                                    color:
                                        Theme.of(context).colorScheme.primary,
                                    width: ResponsiveUtils.value(2),
                                  ),
                                  borderRadius: BorderRadius.circular(
                                    ResponsiveUtils.value(16),
                                  ),
                                  color: Theme.of(context)
                                      .colorScheme
                                      .surface
                                      .withValues(alpha: 0.5),
                                ),
                                child: IgnorePointer(
                                  child: _buildWidget(entry.key),
                                ),
                              ),
                            ),
                          )
                        : _buildWidget(entry.key),
                  ),
                ),
              );
            }).toList(),
          );
        },
      ),
    );
  }
}
