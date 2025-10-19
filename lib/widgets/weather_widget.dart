import 'package:flutter/material.dart';
import 'package:time_widgets/models/weather_model.dart';
import 'package:time_widgets/widgets/error_widget.dart';

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
      return Card(
        elevation: 0,
        color: colorScheme.errorContainer,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        child: Container(
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
                'Weather Error',
                style: theme.textTheme.titleSmall?.copyWith(
                  color: colorScheme.onErrorContainer,
                ),
              ),
              if (onRetry != null) ...[
                const SizedBox(height: 8),
                FilledButton.tonal(
                  onPressed: onRetry,
                  child: const Text('Retry'),
                ),
              ],
            ],
          ),
        ),
      );
    }
    
    // 使用真实天气数据或默认值
    final weather = weatherData;
    final temperature = weather?.temperature ?? 20;
    final description = weather?.description ?? 'Sunny';
    final humidity = weather?.humidity ?? 65;
    final wind = weather?.wind ?? '微风';
    final pressure = weather?.pressure ?? 1016;
    
    return Card(
      elevation: 0,
      color: colorScheme.surfaceContainer,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(
          color: colorScheme.outline.withOpacity(0.2),
          width: 1,
        ),
      ),
      child: Container(
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
                  'Weather',
                  style: theme.textTheme.titleSmall?.copyWith(
                    color: colorScheme.onSurfaceVariant,
                    fontWeight: FontWeight.w500,
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
            
            SizedBox(height: isCompact ? 12 : 16),
            
            // Temperature and description
            Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  '${temperature}°',
                  style: theme.textTheme.displaySmall?.copyWith(
                    color: colorScheme.onSurface,
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
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: colorScheme.onSurfaceVariant,
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
              
              // Weather details
              Row(
                children: [
                  _buildWeatherDetail(
                    context,
                    Icons.water_drop_outlined,
                    '${humidity}%',
                    'Humidity',
                  ),
                  const SizedBox(width: 16),
                  _buildWeatherDetail(
                    context,
                    Icons.air_rounded,
                    wind,
                    'Wind',
                  ),
                ],
              ),
            ],
          ],
        ),
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
          color: colorScheme.surfaceContainerHighest.withOpacity(0.5),
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
              style: theme.textTheme.labelSmall?.copyWith(
                color: colorScheme.onSurface,
                fontWeight: FontWeight.w500,
              ),
            ),
            Text(
              label,
              style: theme.textTheme.labelSmall?.copyWith(
                color: colorScheme.onSurfaceVariant,
                fontSize: 10,
              ),
            ),
          ],
        ),
      ),
    );
  }

  IconData _getWeatherIcon(String description) {
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