import 'package:flutter/material.dart';
import 'package:time_widgets/widgets/time_display_widget.dart';
import 'package:time_widgets/widgets/date_display_widget.dart';
import 'package:time_widgets/widgets/weather_widget.dart';
import 'package:time_widgets/widgets/countdown_widget.dart';
import 'package:time_widgets/widgets/current_class_widget.dart';
import 'package:time_widgets/widgets/timetable_widget.dart';
import 'package:time_widgets/services/api_service.dart';
import 'package:time_widgets/services/cache_service.dart';
import 'package:time_widgets/models/weather_model.dart';
import 'package:time_widgets/models/countdown_model.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
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
      // 首先尝试从缓存获取数据
      final cachedCountdown = await CacheService.getCachedCountdownData();
      if (cachedCountdown != null && mounted) {
        setState(() {
          _countdownData = cachedCountdown;
          _isLoadingCountdown = false;
        });
      }
      
      // 然后从API获取最新数据
      final countdownData = await _apiService.getCountdown();
      if (mounted) {
        setState(() {
          _countdownData = countdownData;
          _isLoadingCountdown = false;
          _countdownError = null;
        });
        // 缓存新数据
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
      setState(() {
        _isLoadingWeather = true;
        _weatherError = null;
      });
      
      // 首先尝试从缓存获取数据
      final cachedWeather = await CacheService.getCachedWeatherData();
      if (cachedWeather != null && mounted) {
        setState(() {
          _weatherData = cachedWeather;
          _isLoadingWeather = false;
        });
      }
      
      // 然后从API获取最新数据
      final weatherData = await _apiService.getWeather();
      
      if (mounted) {
        setState(() {
          _weatherData = weatherData;
          _isLoadingWeather = false;
          _weatherError = null;
        });
        // 缓存新数据
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
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    
    return Scaffold(
      backgroundColor: colorScheme.surface,
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            return _buildResponsiveLayout(context, constraints);
          },
        ),
      ),
    );
  }

  Widget _buildResponsiveLayout(BuildContext context, BoxConstraints constraints) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    
    // 响应式断点
    final isCompact = constraints.maxWidth < 600;
    final isMedium = constraints.maxWidth >= 600 && constraints.maxWidth < 840;
    final isExpanded = constraints.maxWidth >= 840;
    
    // 计算间距和尺寸
    final horizontalPadding = isCompact ? 16.0 : (isMedium ? 24.0 : 32.0);
    final verticalPadding = isCompact ? 16.0 : 24.0;
    final cardSpacing = isCompact ? 12.0 : 16.0;
    
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            colorScheme.surface,
            colorScheme.surfaceContainerLowest,
          ],
        ),
      ),
      child: CustomScrollView(
        slivers: [
          // App Bar
          SliverAppBar(
            floating: true,
            snap: true,
            backgroundColor: Colors.transparent,
            elevation: 0,
            flexibleSpace: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    colorScheme.primaryContainer.withOpacity(0.1),
                    colorScheme.secondaryContainer.withOpacity(0.1),
                  ],
                ),
              ),
            ),
            title: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Smart Schedule',
                  style: theme.textTheme.headlineSmall?.copyWith(
                    color: colorScheme.onSurface,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Text(
                  'Your Intelligent Time Manager',
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: colorScheme.onSurfaceVariant,
                  ),
                ),
              ],
            ),
            toolbarHeight: 80,
          ),
          
          // Content
          SliverPadding(
            padding: EdgeInsets.symmetric(
              horizontal: horizontalPadding,
              vertical: verticalPadding,
            ),
            sliver: isExpanded 
              ? _buildExpandedLayout(cardSpacing)
              : _buildCompactLayout(cardSpacing),
          ),
        ],
      ),
    );
  }

  Widget _buildCompactLayout(double spacing) {
    return SliverList(
      delegate: SliverChildListDelegate([
        // 时间和日期行
        Row(
          children: [
            Expanded(
              flex: 2,
              child: TimeDisplayWidget(
                isCompact: true,
              ),
            ),
            SizedBox(width: spacing),
            Expanded(
              child: DateDisplayWidget(
                isCompact: true,
              ),
            ),
          ],
        ),
        SizedBox(height: spacing),
        
        // 天气和当前课程行
        Row(
          children: [
            Expanded(
              child: WeatherWidget(
                weatherData: _isLoadingWeather ? null : _weatherData,
                error: _weatherError,
                onRetry: _loadWeatherData,
                isCompact: true,
              ),
            ),
            SizedBox(width: spacing),
            Expanded(
              child: CurrentClassWidget(
                isCompact: true,
              ),
            ),
          ],
        ),
        SizedBox(height: spacing),
        
        // 倒计时
        CountdownWidget(
          countdownData: _isLoadingCountdown ? null : _countdownData,
          error: _countdownError,
          onRetry: _loadCountdownData,
          isCompact: false,
        ),
        SizedBox(height: spacing),
        
        // 课程表
        TimetableWidget(
          isCompact: false,
        ),
      ]),
    );
  }

  Widget _buildExpandedLayout(double spacing) {
    return SliverList(
      delegate: SliverChildListDelegate([
        // 第一行：时间、日期、天气
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              flex: 2,
              child: TimeDisplayWidget(
                isCompact: false,
              ),
            ),
            SizedBox(width: spacing),
            Expanded(
              child: DateDisplayWidget(
                isCompact: false,
              ),
            ),
            SizedBox(width: spacing),
            Expanded(
              child: WeatherWidget(
                weatherData: _isLoadingWeather ? null : _weatherData,
                error: _weatherError,
                onRetry: _loadWeatherData,
                isCompact: false,
              ),
            ),
          ],
        ),
        SizedBox(height: spacing),
        
        // 第二行：当前课程和倒计时
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: CurrentClassWidget(
                isCompact: false,
              ),
            ),
            SizedBox(width: spacing),
            Expanded(
              flex: 2,
              child: CountdownWidget(
                countdownData: _isLoadingCountdown ? null : _countdownData,
                error: _countdownError,
                onRetry: _loadCountdownData,
                isCompact: false,
              ),
            ),
          ],
        ),
        SizedBox(height: spacing),
        
        // 第三行：课程表
        TimetableWidget(
          isCompact: false,
        ),
      ]),
    );
  }
}