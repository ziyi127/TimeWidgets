import 'package:flutter/material.dart';
import 'package:time_widgets/models/weather_model.dart';
import 'package:time_widgets/utils/md3_card_styles.dart';
import 'package:time_widgets/utils/md3_typography_styles.dart';
import 'package:time_widgets/services/localization_service.dart';


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
      return MD3CardStyles.errorContainer(
        context: context,
        padding: EdgeInsets.all(isCompact ? 16.0 : 20.0),
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
              style: MD3TypographyStyles.titleSmall(context, color: colorScheme.onErrorContainer),
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
      );
    }
    
    // 使用真实天气数据或默认值
    final weather = weatherData;
    final temperature = weather?.temperature ?? 20;
    final description = weather?.description ?? LocalizationService.getString('weather_loading');
    final humidity = weather?.humidity ?? 65;
    final wind = weather?.wind ?? '微风';
    final feelsLike = weather?.feelsLike ?? temperature;
    final pressure = weather?.pressure ?? 1013.0;
    final cityName = weather?.cityName ?? '北京';
    
    return MD3CardStyles.surfaceContainer(
      context: context,
      padding: EdgeInsets.all(isCompact ? 16.0 : 20.0),
      child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            // Header
            Row(
              children: [
                Icon(
                  _getWeatherIcon(description),
                  size: isCompact ? 16 : 18,
                  color: colorScheme.primary,
                ),
                const SizedBox(width: 8),
                Text(
                  LocalizationService.getString('weather_info'),
                  style: MD3TypographyStyles.titleSmall(context, color: colorScheme.onSurfaceVariant),
                ),
                const SizedBox(width: 4),
                Text(
                  cityName,
                  style: MD3TypographyStyles.labelSmall(context, color: colorScheme.onSurfaceVariant),
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
            
            SizedBox(height: isCompact ? 12 : 16),
            
            // Temperature and description
            Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  '$temperature°',
                  style: MD3TypographyStyles.displaySmall(context).copyWith(
                    fontWeight: FontWeight.w300,
                    fontSize: isCompact ? 32 : 40,
                    height: 1.0,
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(bottom: 8),
                    child: Text(
                      description,
                      style: MD3TypographyStyles.bodyMedium(context, color: colorScheme.onSurfaceVariant).copyWith(
                        fontSize: isCompact ? 12 : 14,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ),
              ],
            ),
            
            if (!isCompact) ...[
              const SizedBox(height: 12),
              
              // Weather details - 第一行
              Row(
                children: [
                  _buildWeatherDetail(
                    context,
                    Icons.water_drop_outlined,
                    '$humidity${LocalizationService.getString('unit_percent')}',
                    LocalizationService.getString('humidity'),
                  ),
                  const SizedBox(width: 12),
                  _buildWeatherDetail(
                    context,
                    Icons.air_rounded,
                    wind,
                    LocalizationService.getString('wind_speed'),
                  ),
                ],
              ),
              
              const SizedBox(height: 8),
              
              // Weather details - 第二行
              Row(
                children: [
                  _buildWeatherDetail(
                    context,
                    Icons.thermostat_outlined,
                    '$feelsLike${LocalizationService.getString('unit_celsius')}',
                    '体感温度',
                  ),
                  const SizedBox(width: 12),
                  _buildWeatherDetail(
                    context,
                    Icons.speed_outlined,
                    '${pressure.toStringAsFixed(1)}mb',
                    '气压',
                  ),
                ],
              ),
            ],
          ],
        ),
    );
  }

  Widget _buildWeatherDetail(
    BuildContext context,
    IconData icon,
    String value,
    String label,
  ) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
        decoration: BoxDecoration(
          color: colorScheme.surfaceContainerHighest.withValues(alpha: 0.5),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              size: 16,
              color: colorScheme.onSurfaceVariant,
            ),
            const SizedBox(height: 2),
            Text(
              value,
              style: MD3TypographyStyles.labelSmall(context).copyWith(
                fontWeight: FontWeight.w500,
              ),
            ),
            Text(
              label,
              style: MD3TypographyStyles.labelSmall(context, color: colorScheme.onSurfaceVariant).copyWith(
                fontSize: 10,
              ),
            ),
          ],
        ),
      ),
    );
  }

  IconData _getWeatherIcon(String description) {
    // 中文天气描述映射
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
      case '沙尘':
      case '沙尘暴':
        return Icons.blur_on_rounded;
      default:
        // 英文描述兼容
        switch (description.toLowerCase()) {
          case 'sunny':
          case 'clear':
            return Icons.wb_sunny_rounded;
          case 'cloudy':
          case 'overcast':
            return Icons.cloud_rounded;
          case 'rainy':
          case 'rain':
            return Icons.umbrella_rounded;
          case 'snowy':
          case 'snow':
            return Icons.ac_unit_rounded;
          case 'thunderstorm':
            return Icons.thunderstorm_rounded;
          default:
            return Icons.wb_cloudy_rounded;
        }
    }
  }
}