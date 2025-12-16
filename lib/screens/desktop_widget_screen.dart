import 'package:flutter/material.dart';
import 'package:time_widgets/widgets/time_display_widget.dart';
import 'package:time_widgets/widgets/date_display_widget.dart';
import 'package:time_widgets/widgets/weather_widget.dart';
import 'package:time_widgets/widgets/countdown_widget.dart';
import 'package:time_widgets/widgets/current_class_widget.dart';
import 'package:time_widgets/widgets/timetable_widget.dart';
import 'package:time_widgets/widgets/week_display_widget.dart';
import 'package:time_widgets/services/api_service.dart';
import 'package:time_widgets/services/cache_service.dart';
import 'package:time_widgets/models/weather_model.dart';
import 'package:time_widgets/models/countdown_model.dart';
import 'package:time_widgets/models/course_model.dart';
import 'package:time_widgets/services/desktop_widget_service.dart';
import 'package:time_widgets/services/enhanced_layout_engine.dart';
import 'package:time_widgets/services/timetable_service.dart';
import 'package:time_widgets/widgets/enhanced_widget_wrapper.dart';
import 'package:time_widgets/utils/logger.dart';
import 'package:time_widgets/services/ntp_service.dart';
import 'package:time_widgets/utils/responsive_utils.dart';

/// 桌面小组件屏幕 - 自适应布局版
class DesktopWidgetScreen extends StatefulWidget {
  final bool isEditMode;
  
  const DesktopWidgetScreen({
    super.key,
    this.isEditMode = false,
  });

  @override
  State<DesktopWidgetScreen> createState() => _DesktopWidgetScreenState();
}

class _DesktopWidgetScreenState extends State<DesktopWidgetScreen> {
  final ApiService _apiService = ApiService();
  final EnhancedLayoutEngine _layoutEngine = EnhancedLayoutEngine();
  
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
  Size? _lastConstraints;
  double? _lastScaleFactor;

  @override
  void initState() {
    super.initState();
    _loadData();
    _loadLayout();
  }

  void _loadData() {
    _loadWeatherData();
    _loadCountdownData();
    _loadTimetableData();
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
    switch (type) {
      case WidgetType.time:
        return const EnhancedWidgetWrapper(
          padding: EdgeInsets.zero,
          backgroundColor: Colors.transparent, // Time widget has its own card style
          child: TimeDisplayWidget(isCompact: true),
        );
      case WidgetType.date:
        return const EnhancedWidgetWrapper(
          padding: EdgeInsets.zero,
          backgroundColor: Colors.transparent,
          child: DateDisplayWidget(isCompact: true),
        );
      case WidgetType.week:
        return const EnhancedWidgetWrapper(
          padding: EdgeInsets.zero,
          backgroundColor: Colors.transparent,
          child: WeekDisplayWidget(isCompact: true),
        );
      case WidgetType.weather:
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
        // Find current course
        Course? currentCourse;
        if (_timetable != null && _timetable!.courses.isNotEmpty) {
           try {
             currentCourse = _timetable!.courses.firstWhere((c) => c.isCurrent);
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
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: LayoutBuilder(
        builder: (context, constraints) {
          if (!_isLayoutLoaded) {
            return const Center(child: CircularProgressIndicator());
          }

          final containerSize = Size(constraints.maxWidth, constraints.maxHeight);
          final currentScale = ResponsiveUtils.scaleFactor;
          
          // 如果布局为空或尺寸发生显著变化，或缩放比例发生变化，重新计算布局
          if (_layout == null || 
              (_lastConstraints != null && _lastConstraints != containerSize) ||
              _lastScaleFactor != currentScale) {
            
            _layout = _layoutEngine.calculateOptimalLayout(containerSize, _layout);
            _lastConstraints = containerSize;
            _lastScaleFactor = currentScale;
            
            // 异步保存新布局，不阻塞渲染
            DesktopWidgetService.saveWidgetPositions(_layout!);
          }

          // 如果还是没有布局（不应该发生），使用默认布局
          if (_layout == null) {
             return const Center(child: Text('无法加载布局'));
          }

          return Stack(
            children: _layout!.entries.map((entry) {
              if (!entry.value.isVisible) return const SizedBox.shrink();
              
              return Positioned(
                left: entry.value.x,
                top: entry.value.y,
                width: entry.value.width,
                height: entry.value.height,
                child: widget.isEditMode 
                  ? GestureDetector(
                      onPanUpdate: (details) {
                        setState(() {
                          final currentPos = _layout![entry.key]!;
                          _layout![entry.key] = currentPos.copyWith(
                            x: currentPos.x + details.delta.dx,
                            y: currentPos.y + details.delta.dy,
                          );
                        });
                      },
                      onPanEnd: (details) {
                        // Resolve collisions and save
                        if (_layout != null && _lastConstraints != null) {
                          // Recalculate layout to ensure no overlaps and valid bounds
                          final resolvedLayout = _layoutEngine.calculateOptimalLayout(
                            _lastConstraints!, 
                            _layout
                          );
                          
                          setState(() {
                            _layout = resolvedLayout;
                          });
                          
                          DesktopWidgetService.saveWidgetPositions(resolvedLayout);
                        }
                      },
                      child: MouseRegion(
                        cursor: SystemMouseCursors.move,
                        child: Container(
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
              );
            }).toList(),
          );
        },
      ),
    );
  }
}
