import 'dart:async';

import 'package:flutter/material.dart';
import 'package:time_widgets/models/countdown_model.dart';
import 'package:time_widgets/models/course_model.dart';
import 'package:time_widgets/models/weather_model.dart';
import 'package:time_widgets/services/api_service.dart';
import 'package:time_widgets/services/cache_service.dart';
import 'package:time_widgets/services/countdown_storage_service.dart';
import 'package:time_widgets/services/desktop_widget_service.dart';
import 'package:time_widgets/services/ntp_service.dart';
import 'package:time_widgets/services/settings_service.dart';
import 'package:time_widgets/services/timetable_service.dart';
import 'package:time_widgets/utils/logger.dart';
import 'package:time_widgets/utils/responsive_utils.dart';
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
  final ApiService _apiService = ApiService();
  final SettingsService _settingsService = SettingsService();
  
  // 数据状态
  WeatherData? _weatherData;
  bool _isLoadingWeather = true;
  String? _weatherError;
  CountdownData? _countdownData;
  bool _isLoadingCountdown = true;
  String? _countdownError;
  
  // 课表数据
  Timetable? _timetable;
  bool _isLoadingTimetable = true;

  // 布局状态
  Map<WidgetType, WidgetPosition>? _layout;
  bool _isLayoutLoaded = false;
  
  // 添加防抖相关变量
  Timer? _layoutTimer;
  StreamSubscription? _countdownSubscription;

  @override
  void initState() {
    super.initState();
    // 监听倒计时数据变化
    _countdownSubscription = CountdownStorageService().onChange.listen((_) {
      _loadCountdownData();
    });
    
    // 延迟到下一帧执行，避免在构建过程中调用 setState
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadData();
      _loadLayout();
    });
  }

  void _loadData() {
    final settings = _settingsService.currentSettings;
    if (settings.showWeatherWidget) _loadWeatherData();
    if (settings.showCountdownWidget) _loadCountdownData();
    
    if (settings.showCurrentClassWidget || settings.enableDesktopWidgets) {
      _loadTimetableData();
    } else {
      if (mounted) {
        setState(() {
          _isLoadingTimetable = false;
        });
      }
    }
  }

  Future<void> _loadLayout() async {
    try {
      final layout = await DesktopWidgetService.loadWidgetPositions();
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

  Future<void> _loadCountdownData() async {
    try {
      final cachedCountdown = await CacheService.getCachedCountdownData();
      if (cachedCountdown != null && mounted) {
        setState(() {
          _countdownData = cachedCountdown;
          _isLoadingCountdown = false;
        });
      }

      final countdownData = await _apiService.getCountdown();
      if (mounted) {
        setState(() {
          _countdownData = countdownData;
          _isLoadingCountdown = false;
          _countdownError = null;
        });
        await CacheService.cacheCountdownData(countdownData);
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _countdownError = e.toString();
          _isLoadingCountdown = false;
        });
      }
    }
  }

  Future<void> _loadTimetableData() async {
    try {
      final now = NtpService().now;
      final timetable = await TimetableService().getTimetable(now);
      if (mounted) {
        setState(() {
          _timetable = timetable;
          _isLoadingTimetable = false;
        });
      }
    } catch (e) {
      Logger.e('Failed to load timetable: $e');
      if (mounted) {
        setState(() {
          _isLoadingTimetable = false;
        });
      }
    }
  }

  Future<void> _loadWeatherData() async {
    try {
      final cachedWeather = await CacheService.getCachedWeatherData();
      if (cachedWeather != null && mounted) {
        setState(() {
          _weatherData = cachedWeather;
          _isLoadingWeather = false;
        });
      }

      final weatherData = await _apiService.getWeather();
      if (mounted) {
        setState(() {
          _weatherData = weatherData;
          _isLoadingWeather = false;
          _weatherError = null;
        });
        await CacheService.cacheWeatherData(weatherData);
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _weatherError = e.toString();
          _isLoadingWeather = false;
        });
      }
    }
  }

  Widget _buildWidget(WidgetType type) {
    final settings = _settingsService.currentSettings;

    switch (type) {
      case WidgetType.time:
        if (!settings.showTimeDisplayWidget) return const SizedBox.shrink();
        return const EnhancedWidgetWrapper(
          padding: EdgeInsets.zero,
          backgroundColor: Colors.transparent, // Time widget has its own card style
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
        return EnhancedWidgetWrapper(
          padding: EdgeInsets.zero,
          backgroundColor: Colors.transparent,
          onTap: _loadWeatherData,
          child: WeatherWidget(
            weatherData: _isLoadingWeather ? null : _weatherData,
            error: _weatherError,
            onRetry: _loadWeatherData,
            isCompact: true,
          ),
        );
      case WidgetType.currentClass:
        if (!settings.showCurrentClassWidget) return const SizedBox.shrink();
        // Find current course
        Course? currentCourse;
        final timetable = _timetable;
        if (timetable != null && timetable.courses.isNotEmpty) {
           try {
             currentCourse = timetable.courses.firstWhere((c) => c.isCurrent);
           } catch (e) {
             // No current course
           }
        }
        
        return EnhancedWidgetWrapper(
          padding: EdgeInsets.zero,
          backgroundColor: Colors.transparent,
          onTap: _loadTimetableData,
          child: CurrentClassWidget(
            isCompact: true,
            course: currentCourse,
            isLoading: _isLoadingTimetable,
          ),
        );
      case WidgetType.countdown:
        if (!settings.showCountdownWidget) return const SizedBox.shrink();
        return EnhancedWidgetWrapper(
          padding: EdgeInsets.zero,
          backgroundColor: Colors.transparent,
          onTap: _loadCountdownData,
          child: CountdownWidget(
            countdownData: _isLoadingCountdown ? null : _countdownData,
            error: _countdownError,
            onRetry: _loadCountdownData,
            isCompact: true,
          ),
        );
      case WidgetType.timetable:
        return EnhancedWidgetWrapper(
          padding: EdgeInsets.zero,
          backgroundColor: Colors.transparent,
          onTap: _loadTimetableData,
          child: TimetableWidget(
            isCompact: true,
            courses: _timetable?.courses,
          ),
        );
      case WidgetType.settings:
        // 设置按钮通常由托盘管理，但在布局中预留位置
        return const SizedBox.shrink(); 
    }
  }

  @override
  void dispose() {
    _layoutTimer?.cancel();
    _countdownSubscription?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: LayoutBuilder(
        builder: (context, constraints) {
          // 如果禁用了桌面小组件且不在编辑模式，显示提示信息
          if (!_settingsService.currentSettings.enableDesktopWidgets && !widget.isEditMode) {
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
                    Icon(Icons.widgets_outlined, size: 48, color: Theme.of(context).colorScheme.primary),
                    const SizedBox(height: 16),
                    Text(
                      '桌面小组件已禁用',
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      '请在设置中启用，或右键托盘图标进行设置',
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
             return const Center(child: Text('无法加载布局'));
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
                              DesktopWidgetService.saveWidgetPositions(currentLayout);
                              Logger.i('Widget positions saved after drag');
                            }
                          },
                          child: MouseRegion(
                            cursor: SystemMouseCursors.move,
                            child: DecoratedBox(
                              decoration: BoxDecoration(
                                border: Border.all(
                                  color: Theme.of(context).colorScheme.primary,
                                  width: ResponsiveUtils.value(2),
                                ),
                                borderRadius: BorderRadius.circular(ResponsiveUtils.value(16)),
                                color: Theme.of(context).colorScheme.surface.withOpacity(0.5),
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
