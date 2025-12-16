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
import 'package:time_widgets/services/settings_service.dart';
import 'package:time_widgets/models/settings_model.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final ApiService _apiService = ApiService();
  final SettingsService _settingsService = SettingsService();
  WeatherData? _weatherData;
  bool _isLoadingWeather = true;
  String? _weatherError;
  CountdownData? _countdownData;
  bool _isLoadingCountdown = true;
  String? _countdownError;
  late AppSettings _settings;
  bool _isLoadingSettings = true;

  @override
  void initState() {
    super.initState();
    _loadSettings();
    _loadWeatherData();
    _loadCountdownData();
  }

  Future<void> _loadSettings() async {
    try {
      final settings = await _settingsService.loadSettings();
      setState(() {
        _settings = settings;
        _isLoadingSettings = false;
      });
    } catch (e) {
      // 如果加载失败，使用默认设置
      setState(() {
        _settings = AppSettings.defaultSettings();
        _isLoadingSettings = false;
      });
    }
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
    
    if (_isLoadingSettings) {
      return Scaffold(
        backgroundColor: colorScheme.surface,
        body: const Center(child: CircularProgressIndicator()),
      );
    }
    
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
                context: context,
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
    final List<Widget> children = [];

    // 时间和日期行
    final timeDateWidgets = <Widget>[];
    if (_settings.showTimeDisplayWidget) {
      timeDateWidgets.add(
        Expanded(
          flex: 2,
          child: TimeDisplayWidget(
            isCompact: true,
          ),
        ),
      );
    }
    if (_settings.showDateDisplayWidget) {
      if (timeDateWidgets.isNotEmpty) {
        timeDateWidgets.add(SizedBox(width: spacing));
      }
      timeDateWidgets.add(
        Expanded(
          child: DateDisplayWidget(
            isCompact: true,
          ),
        ),
      );
    }
    if (timeDateWidgets.isNotEmpty) {
      children.add(Row(children: timeDateWidgets));
      children.add(SizedBox(height: spacing));
    }

    // 天气和当前课程行
    final weatherClassWidgets = <Widget>[];
    if (_settings.showWeatherWidget) {
      weatherClassWidgets.add(
        Expanded(
          child: WeatherWidget(
            weatherData: _isLoadingWeather ? null : _weatherData,
            error: _weatherError,
            onRetry: _loadWeatherData,
            isCompact: true,
          ),
        ),
      );
    }
    if (_settings.showCurrentClassWidget) {
      if (weatherClassWidgets.isNotEmpty) {
        weatherClassWidgets.add(SizedBox(width: spacing));
      }
      weatherClassWidgets.add(
        Expanded(
          child: CurrentClassWidget(
            isCompact: true,
          ),
        ),
      );
    }
    if (weatherClassWidgets.isNotEmpty) {
      children.add(Row(children: weatherClassWidgets));
      children.add(SizedBox(height: spacing));
    }

    // 倒计时
    if (_settings.showCountdownWidget) {
      children.add(
        CountdownWidget(
          countdownData: _isLoadingCountdown ? null : _countdownData,
          error: _countdownError,
          onRetry: _loadCountdownData,
          isCompact: false,
        ),
      );
      children.add(SizedBox(height: spacing));
    }

    // 课程表
    children.add(
      TimetableWidget(
        isCompact: false,
      ),
    );

    return SliverList(
      delegate: SliverChildListDelegate(children),
    );
  }

  Widget _buildExpandedLayout(double spacing) {
    final List<Widget> children = [];

    // 第一行：时间、日期、天气
    final firstRowWidgets = <Widget>[];
    if (_settings.showTimeDisplayWidget) {
      firstRowWidgets.add(
        Expanded(
          flex: 2,
          child: TimeDisplayWidget(
            isCompact: false,
          ),
        ),
      );
    }
    if (_settings.showDateDisplayWidget) {
      if (firstRowWidgets.isNotEmpty) {
        firstRowWidgets.add(SizedBox(width: spacing));
      }
      firstRowWidgets.add(
        Expanded(
          child: DateDisplayWidget(
            isCompact: false,
          ),
        ),
      );
    }
    if (_settings.showWeatherWidget) {
      if (firstRowWidgets.isNotEmpty) {
        firstRowWidgets.add(SizedBox(width: spacing));
      }
      firstRowWidgets.add(
        Expanded(
          child: WeatherWidget(
            weatherData: _isLoadingWeather ? null : _weatherData,
            error: _weatherError,
            onRetry: _loadWeatherData,
            isCompact: false,
          ),
        ),
      );
    }
    if (firstRowWidgets.isNotEmpty) {
      children.add(Row(children: firstRowWidgets));
      children.add(SizedBox(height: spacing));
    }

    // 第二行：当前课程和倒计时
    final secondRowWidgets = <Widget>[];
    if (_settings.showCurrentClassWidget) {
      secondRowWidgets.add(
        Expanded(
          child: CurrentClassWidget(
            isCompact: false,
          ),
        ),
      );
    }
    if (_settings.showCountdownWidget) {
      if (secondRowWidgets.isNotEmpty) {
        secondRowWidgets.add(SizedBox(width: spacing));
      }
      secondRowWidgets.add(
        Expanded(
          flex: 2,
          child: CountdownWidget(
            countdownData: _isLoadingCountdown ? null : _countdownData,
            error: _countdownError,
            onRetry: _loadCountdownData,
            isCompact: false,
          ),
        ),
      );
    }
    if (secondRowWidgets.isNotEmpty) {
      children.add(Row(children: secondRowWidgets));
      children.add(SizedBox(height: spacing));
    }

    // 第三行：课程表
    children.add(
      TimetableWidget(
        isCompact: false,
      ),
    );

    return SliverList(
      delegate: SliverChildListDelegate(children),
    );
  }
}
