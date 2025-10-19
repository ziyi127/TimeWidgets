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
  final double screenWidth;
  final double screenHeight;
  
  const HomeScreen({
    super.key,
    required this.screenWidth,
    required this.screenHeight,
  });

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
    return Scaffold(
      backgroundColor: Colors.transparent,  // 透明背景
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Colors.transparent,  // 完全透明
              Colors.transparent,  // 完全透明
            ],
          ),
        ),
        child: SafeArea(
          child: LayoutBuilder(
            builder: (context, constraints) {
              // 计算自适应尺寸
              final availableHeight = constraints.maxHeight;
              final availableWidth = constraints.maxWidth;
              
              // 根据可用高度计算卡片尺寸
              final cardSpacing = availableHeight * 0.02; // 2%的间距
              final minCardHeight = availableHeight * 0.15; // 最小卡片高度15%
              final maxCardHeight = availableHeight * 0.25; // 最大卡片高度25%
              
              // 根据屏幕尺寸计算字体大小
              final baseFontSize = (availableWidth / 30).clamp(12.0, 16.0);
              final titleFontSize = (availableWidth / 20).clamp(16.0, 24.0);
              
              // 判断是否使用宽屏布局
              final useWideScreenLayout = availableWidth > 800;
              
              return SingleChildScrollView(
                padding: EdgeInsets.symmetric(
                  horizontal: availableWidth * 0.05, // 5%的水平边距
                  vertical: availableHeight * 0.02, // 2%的垂直边距
                ),
                child: ConstrainedBox(
                  constraints: BoxConstraints(
                    maxHeight: availableHeight * 0.95, // 最大高度95%可用空间
                  ),
                  child: useWideScreenLayout 
                    ? _buildWideScreenLayout(baseFontSize)
                    : Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // 顶部标题区域
                          _buildHeaderSection(titleFontSize),
                          SizedBox(height: cardSpacing),
                          
                          // 主要内容区域 - 自适应网格布局
                          Expanded(
                            child: LayoutBuilder(
                              builder: (context, constraints) {
                                final crossAxisCount = constraints.maxWidth > 600 ? 2 : 1;
                                const itemCount = 6;
                                final itemHeight = ((constraints.maxHeight - (cardSpacing * ((itemCount / crossAxisCount).ceil() - 1))) / 
                                                  (itemCount / crossAxisCount)).clamp(minCardHeight, maxCardHeight);
                                
                                return GridView.count(
                                  shrinkWrap: true,
                                  physics: const ClampingScrollPhysics(),
                                  crossAxisCount: crossAxisCount,
                                  childAspectRatio: constraints.maxWidth / crossAxisCount / itemHeight,
                                  mainAxisSpacing: cardSpacing,
                                  crossAxisSpacing: cardSpacing,
                                  children: [
                                    // 时间和日期组件
                                    TimeDisplayWidget(
                                      fontSize: baseFontSize,
                                      padding: baseFontSize * 1.7,
                                    ),
                                    DateDisplayWidget(
                                      fontSize: baseFontSize,
                                      padding: baseFontSize * 1.7,
                                    ),
                                    // 天气和当前课程
                                    WeatherWidget(
                                      fontSize: baseFontSize,
                                      padding: baseFontSize * 1.7,
                                      weatherData: _isLoadingWeather ? null : _weatherData,
                                      error: _weatherError,
                                      onRetry: _loadWeatherData,
                                    ),
                                    CurrentClassWidget(
                                      fontSize: baseFontSize,
                                      padding: baseFontSize * 1.7,
                                    ),
                                    // 倒计时
                                    CountdownWidget(
                                      fontSize: baseFontSize,
                                      padding: baseFontSize * 1.7,
                                      countdownData: _isLoadingCountdown ? null : _countdownData,
                                      error: _countdownError,
                                      onRetry: _loadCountdownData,
                                    ),
                                    // 课程表（跨列显示）
                                    TimetableWidget(
                                      fontSize: baseFontSize,
                                      padding: baseFontSize * 1.7,
                                    ),
                                  ],
                                );
                              },
                            ),
                          ),
                        ],
                      ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  Widget _buildHeaderSection(double titleFontSize) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Smart Schedule',
              style: TextStyle(
                fontSize: titleFontSize,
                fontWeight: FontWeight.w600,
                color: const Color(0xFFFFFFFF),
                letterSpacing: 0.5,
              ),
            ),
            SizedBox(height: titleFontSize * 0.2),
            Text(
              'Your Intelligent Time Manager',
              style: TextStyle(
                fontSize: titleFontSize * 0.5,
                color: const Color(0xFFB3B3B3),
                letterSpacing: 0.3,
              ),
            ),
          ],
        ),
        Row(
          children: [
            DateDisplayWidget(
              fontSize: titleFontSize * 0.7,
              padding: titleFontSize * 0.7 * 1.7,
            ),
            SizedBox(width: titleFontSize * 0.7),
            TimeDisplayWidget(
              fontSize: titleFontSize * 0.7,
              padding: titleFontSize * 0.7 * 1.7,
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildWideScreenLayout(double baseFontSize) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // 标题区域
        _buildHeaderSection((baseFontSize * 20).clamp(16.0, 24.0)),
        const SizedBox(height: 20),
        
        // 第一行：时间和日期
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              flex: 2,
              child: TimeDisplayWidget(
                fontSize: baseFontSize,
                padding: baseFontSize * 1.7,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              flex: 1,
              child: DateDisplayWidget(
                fontSize: baseFontSize,
                padding: baseFontSize * 1.7,
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        
        // 第二行：天气和当前课程
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              flex: 1,
              child: WeatherWidget(
                fontSize: baseFontSize,
                padding: baseFontSize * 1.7,
                weatherData: _isLoadingWeather ? null : _weatherData,
                error: _weatherError,
                onRetry: _loadWeatherData,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              flex: 1,
              child: CurrentClassWidget(
                fontSize: baseFontSize,
                padding: baseFontSize * 1.7,
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        
        // 第三行：倒计时和课程表
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              flex: 1,
              child: CountdownWidget(
                fontSize: baseFontSize,
                padding: baseFontSize * 1.7,
                countdownData: _isLoadingCountdown ? null : _countdownData,
                error: _countdownError,
                onRetry: _loadCountdownData,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              flex: 2,
              child: TimetableWidget(
                fontSize: baseFontSize,
                padding: baseFontSize * 1.7,
              ),
            ),
          ],
        ),
      ],
    );
  }

}