import 'package:flutter/material.dart';
import 'package:time_widgets/models/weather_model.dart';

/// 天气组件 - MD3紧凑�?
class WeatherWidget extends StatelessWidget {
  final WeatherData? weatherData;
  final String? error;
  final VoidCallback? onRetry;
  final bool isCompact;

  const WeatherWidget({
    super.key,
    this.weatherData,
    this.error,
    this.onRetry,
    this.isCompact = false,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    if (error != null) {
      return _buildErrorCard(context, colorScheme);
    }

    final weather = weatherData;
    final temperature = weather?.temperature ?? 20;
    final description = weather?.description ?? '加载�?..';
    final humidity = weather?.humidity ?? 65;
    final wind = weather?.wind ?? '微风';
    final cityName = weather?.cityName ?? '北京';

    return Card(
      elevation: 0,
      color: colorScheme.surfaceContainerLow,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            // 头部
            Row(
              children: [
                Icon(
                  _getWeatherIcon(description),
                  size: 20,
                  color: colorScheme.primary,
                ),
                const SizedBox(width: 12),
                Text(
                  '天气 · $cityName',
                  style: theme.textTheme.titleSmall?.copyWith(
                    color: colorScheme.onSurfaceVariant,
                  ),
                ),
                const Spacer(),
                if (weatherData == null)
                  SizedBox(
                    width: 16,
                    height: 16,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      color: colorScheme.primary,
                    ),
                  ),
              ],
            ),
            const SizedBox(height: 12),
            // 温度和详�?
            Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  '$temperature°',
                  style: theme.textTheme.displaySmall?.copyWith(
                    fontWeight: FontWeight.w400,
                    color: colorScheme.onSurface,
                    height: 1.0,
                  ),
                ),
                const SizedBox(width: 12),
                Padding(
                  padding: const EdgeInsets.only(bottom: 8),
                  child: Text(
                    description,
                    style: theme.textTheme.bodyLarge?.copyWith(
                      color: colorScheme.onSurfaceVariant,
                    ),
                  ),
                ),
                const Spacer(),
                // 详情
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    _buildMiniDetail(context, Icons.water_drop_outlined, '$humidity%'),
                    const SizedBox(height: 4),
                    _buildMiniDetail(context, Icons.air_rounded, wind),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMiniDetail(BuildContext context, IconData icon, String value) {
    final colorScheme = Theme.of(context).colorScheme;
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 14, color: colorScheme.onSurfaceVariant),
        const SizedBox(width: 4),
        Text(
          value,
          style: Theme.of(context).textTheme.labelMedium?.copyWith(
            color: colorScheme.onSurfaceVariant,
          ),
        ),
      ],
    );
  }

  Widget _buildErrorCard(BuildContext context, ColorScheme colorScheme) {
    return Card(
      elevation: 0,
      color: colorScheme.errorContainer,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            Icon(Icons.cloud_off_rounded, color: colorScheme.onErrorContainer, size: 20),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                '天气加载失败',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: colorScheme.onErrorContainer,
                ),
              ),
            ),
            if (onRetry != null)
              TextButton(
                onPressed: onRetry,
                child: Text(
                  '重试',
                  style: TextStyle(color: colorScheme.onErrorContainer),
                ),
              ),
          ],
        ),
      ),
    );
  }

  IconData _getWeatherIcon(String description) {
    switch (description) {
      case '�?:
      case '晴天':
        return Icons.wb_sunny_rounded;
      case '多云':
      case '少云':
        return Icons.wb_cloudy_rounded;
      case '�?:
      case '阴天':
        return Icons.cloud_rounded;
      case '小雨':
      case '中雨':
      case '大雨':
      case '�?:
        return Icons.water_drop_rounded;
      case '雷阵�?:
      case '雷雨':
        return Icons.thunderstorm_rounded;
      case '小雪':
      case '中雪':
      case '大雪':
      case '�?:
        return Icons.ac_unit_rounded;
      case '�?:
      case '�?:
        return Icons.cloud_queue_rounded;
      case '沙尘':
        return Icons.blur_on_rounded;
      default:
        return Icons.wb_cloudy_rounded;
    }
  }
}
