import 'package:flutter/material.dart';
import 'package:time_widgets/widgets/time_display_widget.dart';
import 'package:time_widgets/widgets/date_display_widget.dart';
import 'package:time_widgets/widgets/weather_widget.dart';
import 'package:time_widgets/widgets/countdown_widget.dart';
import 'package:time_widgets/widgets/current_class_widget.dart';
import 'package:time_widgets/widgets/timetable_widget.dart';
import 'package:time_widgets/widgets/week_display_widget.dart';
import 'package:time_widgets/services/api_service.dart';
import 'package:time_widgets/screens/settings_screen.dart';
import 'package:time_widgets/services/cache_service.dart';
import 'package:time_widgets/models/weather_model.dart';
import 'package:time_widgets/models/countdown_model.dart';
import 'package:time_widgets/utils/md3_button_styles.dart';
import 'package:time_widgets/utils/md3_typography_styles.dart';
import 'package:time_widgets/utils/md3_navigation_styles.dart';

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
      // 首先尝试从缓存获取数�?
      final cachedCountdown = await CacheService.getCachedCountdownData();
      if (cachedCountdown != null && mounted) {
        setState(() {
          _countdownData = cachedCountdown;
          _isLoadingCountdown = false;
        });
      }
      
      // 然后从API获取最新数�?
      final countdownData = await _apiService.getCountdown();
      if (mounted) {
        setState(() {
          _countdownData = countdownData;
          _isLoadingCountdown = false;
          _countdownError = null;
        });
        // 缓存新数�?
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
      
      // 首先尝试从缓存获取数�?
      final cachedWeather = await CacheService.getCachedWeatherData();
      if (cachedWeather != null && mounted) {
        setState(() {
          _weatherData = cachedWeather;
          _isLoadingWeather = false;
        });
      }
      
      // 然后从API获取最新数�?
      final weatherData = await _apiService.getWeather();
      
      if (mounted) {
        setState(() {
          _weatherData = weatherData;
          _isLoadingWeather = false;
          _weatherError = null;
        });
        // 缓存新数�?
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
    
    // 响应式断�?
    final isCompact = constraints.maxWidth < 600;
    final isMedium = constraints.maxWidth >= 600 && constraints.maxWidth < 840;
    final isExpanded = constraints.maxWidth >= 840;
    
    // 计算间距和尺�?
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
          MD3NavigationStyles.sliverAppBar(
            context: context,
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
                  colorScheme.primaryContainer.withValues(alpha: 0.1),
                  colorScheme.secondaryContainer.withValues(alpha: 0.1),
                ],
              ),
              ),
            ),
            title: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      'Smart Schedule',
                      style: MD3TypographyStyles.headlineSmall(context).copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(width: 12),
                    const WeekDisplayWidget(isCompact: true),
                  ],
                ),
                Text(
                  'Your Intelligent Time Manager',
                  style: MD3TypographyStyles.bodySmall(context),
                ),
              ],
            ),
            actions: [
              MD3ButtonStyles.icon(
                icon: const Icon(Icons.settings_outlined),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const SettingsScreen()),
                  );
                },
                tooltip: '设置',
              ),
            ],
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
        
        // 倒计�?
        CountdownWidget(
          countdownData: _isLoadingCountdown ? null : _countdownData,
          error: _countdownError,
          onRetry: _loadCountdownData,
          isCompact: false,
        ),
        SizedBox(height: spacing),
        
        // 课程�?
        TimetableWidget(
          isCompact: false,
        ),
      ]),
    );
  }

  Widget _buildExpandedLayout(double spacing) {
    return SliverList(
      delegate: SliverChildListDelegate([
        // 第一行：时间、日期、天�?
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
        
        // 第二行：当前课程和倒计�?
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
        
        // 第三行：课程�?
        TimetableWidget(
          isCompact: false,
        ),
      ]),
    );
  }
}
