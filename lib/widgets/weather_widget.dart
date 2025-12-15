import 'package:flutter/material.dart';
import 'package:time_widgets/models/weather_model.dart';
import 'package:time_widgets/services/localization_service.dart';

/// 天气组件 - 简化版
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

    // 错误处理
    if (error != null) {
      return _buildErrorCard(context, colorScheme);
    }

    // 使用真实天气数据或默认值
    final weather = weatherData;
    final temperature = weather?.temperature ?? 20;
    final description = weather?.description ?? LocalizationService.getString('weather_loading');
    final humidity = weather?.humidity ?? 65;
    final wind = weather?.wind ?? '微风';
    final feelsLike = weather?.feelsLike ?? temperature;
    final cityName = weather?.cityName ?? '北京';

    return Card(
      elevation: 0,
      color: colorScheme.surfaceContainer,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(
          color: colorScheme.outline.withValues(alpha: 0.2),
          width: 1,
        ),
      ),
      child: Padding(
        padding: EdgeInsets.all(isCompact ? 12.0 : 16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            // 头部
            _buildHeader(context, colorScheme, description, cityName, weatherData == null),
            SizedBox(height: isCompact ? 8 : 12),

            // 温度显示
            _buildTemperature(context, colorScheme, temperature, description),

            // 详细信息（非紧凑模式）
            if (!isCompact) ...[
              const SizedBox(height: 12),
              _buildDetails(context, colorScheme, humidity, wind, feelsLike),
            ],
          ],
        ),
      ),
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
        padding: EdgeInsets.all(isCompact ? 12.0 : 16.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.error_outline_rounded,
              color: colorScheme.onErrorContainer,
              size: 24,
            ),
            const SizedBox(height: 8),
            Text(
              LocalizationService.getString('weather_error'),
              style: Theme.of(context).textTheme.titleSmall?.copyWith(
                    color: colorScheme.onErrorContainer,
                  ),
            ),
            if (onRetry != null) ...[
              const SizedBox(height: 8),
              FilledButton.tonal(
                onPressed: onRetry,
                child: Text(LocalizationService.getString('dialog_button_retry')),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(
    BuildContext context,
    ColorScheme colorScheme,
    String description,
    String cityName,
    bool isLoading,
  ) {
    return Row(
      children: [
        Icon(
          _getWeatherIcon(description),
          size: isCompact ? 16 : 18,
          color: colorScheme.primary,
        ),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            '${LocalizationService.getString('weather_info')} $cityName',
            style: Theme.of(context).textTheme.titleSmall?.copyWith(
                  color: colorScheme.onSurfaceVariant,
                  fontWeight: FontWeight.w500,
                ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ),
        if (isLoading)
          SizedBox(
            width: 16,
            height: 16,
            child: CircularProgressIndicator(
              strokeWidth: 2,
              color: colorScheme.primary,
            ),
          ),
      ],
    );
  }

  Widget _buildTemperature(
    BuildContext context,
    ColorScheme colorScheme,
    int temperature,
    String description,
  ) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Text(
          '$temperature°',
          style: Theme.of(context).textTheme.displaySmall?.copyWith(
                fontWeight: FontWeight.w300,
                fontSize: isCompact ? 32 : 40,
                height: 1.0,
              ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.only(bottom: 6),
            child: Text(
              description,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: colorScheme.onSurfaceVariant,
                  ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildDetails(
    BuildContext context,
    ColorScheme colorScheme,
    int humidity,
    String wind,
    int feelsLike,
  ) {
    return Row(
      children: [
        _buildDetailItem(
          context,
          colorScheme,
          Icons.water_drop_outlined,
          '$humidity%',
          LocalizationService.getString('humidity'),
        ),
        const SizedBox(width: 8),
        _buildDetailItem(
          context,
          colorScheme,
          Icons.air_rounded,
          wind,
          LocalizationService.getString('wind_speed'),
        ),
        const SizedBox(width: 8),
        _buildDetailItem(
          context,
          colorScheme,
          Icons.thermostat_outlined,
          '$feelsLike°',
          '体感',
        ),
      ],
    );
  }

  Widget _buildDetailItem(
    BuildContext context,
    ColorScheme colorScheme,
    IconData icon,
    String value,
    String label,
  ) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 4),
        decoration: BoxDecoration(
          color: colorScheme.surfaceContainerHighest.withValues(alpha: 0.5),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 14, color: colorScheme.onSurfaceVariant),
            const SizedBox(height: 2),
            Text(
              value,
              style: Theme.of(context).textTheme.labelSmall?.copyWith(
                    fontWeight: FontWeight.w500,
                  ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            Text(
              label,
              style: Theme.of(context).textTheme.labelSmall?.copyWith(
                    color: colorScheme.onSurfaceVariant,
                    fontSize: 10,
                  ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }

  IconData _getWeatherIcon(String description) {
    switch (description) {
      case '晴':
      case '晴天':
        return Icons.wb_sunny_rounded;
      case '多云':
      case '少云':
        return Icons.wb_cloudy_rounded;
      case '阴':
      case '阴天':
        return Icons.cloud_rounded;
      case '小雨':
      case '中雨':
      case '大雨':
      case '雨':
        return Icons.umbrella_rounded;
      case '雷阵雨':
      case '雷雨':
        return Icons.thunderstorm_rounded;
      case '小雪':
      case '中雪':
      case '大雪':
      case '雪':
        return Icons.ac_unit_rounded;
      case '雾':
      case '霾':
        return Icons.cloud_queue_rounded;
      default:
        return Icons.wb_cloudy_rounded;
    }
  }
}
