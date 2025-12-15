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

/// 桌面小组件屏�?- 自适应紧凑�?
class DesktopWidgetScreen extends StatefulWidget {
  const DesktopWidgetScreen({super.key});

  @override
  State<DesktopWidgetScreen> createState() => _DesktopWidgetScreenState();
}

class _DesktopWidgetScreenState extends State<DesktopWidgetScreen> {
  final ApiService _apiService = ApiService();
  WeatherData? _weatherData;
  bool _isLoadingWeather = true;
  String? _weatherError;
  CountdownData? _countdownData;
  bool _isLoadingCountdown = true;
  String? _countdownError;

  @override
  void initState() {
    super.initState();
    _loadWeatherData();
    _loadCountdownData();
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: LayoutBuilder(
        builder: (context, constraints) {
          // 根据可用高度自适应
          return SingleChildScrollView(
            padding: const EdgeInsets.all(8),
            child: ConstrainedBox(
              constraints: BoxConstraints(
                minHeight: constraints.maxHeight - 16,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                mainAxisSize: MainAxisSize.min,
                children: [
                  // 时间显示
                  const TimeDisplayWidget(isCompact: true),
                  const SizedBox(height: 6),

                  // 日期显示
                  const DateDisplayWidget(isCompact: true),
                  const SizedBox(height: 6),

                  // 周次显示
                  const WeekDisplayWidget(isCompact: true),
                  const SizedBox(height: 6),

                  // 天气信息
                  GestureDetector(
                    onTap: _loadWeatherData,
                    child: WeatherWidget(
                      weatherData: _isLoadingWeather ? null : _weatherData,
                      error: _weatherError,
                      onRetry: _loadWeatherData,
                      isCompact: true,
                    ),
                  ),
                  const SizedBox(height: 6),

                  // 当前课程
                  const CurrentClassWidget(isCompact: true),
                  const SizedBox(height: 6),

                  // 倒计�?
                  GestureDetector(
                    onTap: _loadCountdownData,
                    child: CountdownWidget(
                      countdownData: _isLoadingCountdown ? null : _countdownData,
                      error: _countdownError,
                      onRetry: _loadCountdownData,
                      isCompact: true,
                    ),
                  ),
                  const SizedBox(height: 6),

                  // 课程�?
                  const TimetableWidget(isCompact: true),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
