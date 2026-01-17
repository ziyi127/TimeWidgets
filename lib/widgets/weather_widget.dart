import 'package:flutter/material.dart';
import 'package:time_widgets/models/weather_model.dart';
import 'package:time_widgets/utils/responsive_utils.dart';

/// 天气组件 - MD3紧凑版
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
    final width = MediaQuery.sizeOf(context).width;
    final fontMultiplier = ResponsiveUtils.getFontSizeMultiplier(width);

    if (error != null) {
      return _buildErrorCard(context, colorScheme, width);
    }

    final weather = weatherData;
    final temperature = weather?.temperature ?? 20;
    final description = weather?.description ?? '加载中..';
    final humidity = weather?.humidity ?? 65;
    final wind = weather?.wind ?? '微风';
    final cityName = weather?.cityName ?? '北京';

    return Card(
      elevation: 0,
      color: colorScheme.surfaceContainerLow,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(
          ResponsiveUtils.getBorderRadius(width, baseRadius: 16),
        ),
      ),
      child: Padding(
          padding: EdgeInsets.all(ResponsiveUtils.value(16)),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              // 头部
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          _getWeatherIcon(description),
                          size: ResponsiveUtils.getIconSize(width, baseSize: 20),
                          color: colorScheme.primary,
                        ),
                        SizedBox(width: ResponsiveUtils.value(12)),
                        // 限制文本宽度，避免溢出
                        Flexible(
                          child: Text(
                            '天气 · $cityName',
                            style: theme.textTheme.titleSmall?.copyWith(
                              color: colorScheme.onSurfaceVariant,
                              fontSize: (theme.textTheme.titleSmall?.fontSize ?? 14) * fontMultiplier,
                            ),
                            overflow: TextOverflow.ellipsis,
                            maxLines: 1,
                          ),
                        ),
                      ],
                    ),
                  ),
                  if (weatherData == null)
                    SizedBox(
                      width: ResponsiveUtils.value(16),
                      height: ResponsiveUtils.value(16),
                      child: CircularProgressIndicator(
                        strokeWidth: ResponsiveUtils.value(2),
                        color: colorScheme.primary,
                      ),
                    ),
                ],
              ),
            SizedBox(height: ResponsiveUtils.value(12)),
            // 温度和详情
            Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  '$temperature°',
                  style: theme.textTheme.displaySmall?.copyWith(
                    fontWeight: FontWeight.w400,
                    color: colorScheme.onSurface,
                    height: 1.0,
                    fontSize: (theme.textTheme.displaySmall?.fontSize ?? 36) * fontMultiplier,
                  ),
                ),
                SizedBox(width: ResponsiveUtils.value(12)),
                Padding(
                  padding: EdgeInsets.only(bottom: ResponsiveUtils.value(8)),
                  child: Text(
                    description,
                    style: theme.textTheme.bodyLarge?.copyWith(
                      color: colorScheme.onSurfaceVariant,
                      fontSize: (theme.textTheme.bodyLarge?.fontSize ?? 16) * fontMultiplier,
                    ),
                  ),
                ),
                const Spacer(),
                // 详情
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    _buildMiniDetail(context, Icons.water_drop_outlined, '$humidity%', width),
                    SizedBox(height: ResponsiveUtils.value(4)),
                    _buildMiniDetail(context, Icons.air_rounded, wind, width),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMiniDetail(BuildContext context, IconData icon, String value, double width) {
    final colorScheme = Theme.of(context).colorScheme;
    final fontMultiplier = ResponsiveUtils.getFontSizeMultiplier(width);
    
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(
          icon, 
          size: ResponsiveUtils.getIconSize(width, baseSize: 14), 
          color: colorScheme.onSurfaceVariant
        ),
        SizedBox(width: ResponsiveUtils.value(4)),
        Text(
          value,
          style: Theme.of(context).textTheme.labelMedium?.copyWith(
            color: colorScheme.onSurfaceVariant,
            fontSize: (Theme.of(context).textTheme.labelMedium?.fontSize ?? 12) * fontMultiplier,
          ),
        ),
      ],
    );
  }

  Widget _buildErrorCard(BuildContext context, ColorScheme colorScheme, double width) {
    final fontMultiplier = ResponsiveUtils.getFontSizeMultiplier(width);
    
    return Card(
      elevation: 0,
      color: colorScheme.errorContainer,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(
          ResponsiveUtils.getBorderRadius(width, baseRadius: 16),
        ),
      ),
      child: Padding(
        padding: EdgeInsets.all(ResponsiveUtils.value(16)),
        child: Row(
          children: [
            Icon(
              Icons.cloud_off_rounded, 
              color: colorScheme.onErrorContainer, 
              size: ResponsiveUtils.getIconSize(width, baseSize: 20)
            ),
            SizedBox(width: ResponsiveUtils.value(12)),
            Expanded(
              child: Text(
                '天气加载失败',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: colorScheme.onErrorContainer,
                  fontSize: (Theme.of(context).textTheme.bodyMedium?.fontSize ?? 14) * fontMultiplier,
                ),
              ),
            ),
            if (onRetry != null)
              TextButton(
                onPressed: onRetry,
                child: Text(
                  '重试',
                  style: TextStyle(
                    color: colorScheme.onErrorContainer,
                    fontSize: 14.0 * fontMultiplier,
                  ),
                ),
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
      case '暴雨':
        return Icons.water_drop_rounded;
      case '雷阵雨':
      case '雷雨':
        return Icons.thunderstorm_rounded;
      case '小雪':
      case '中雪':
      case '大雪':
      case '暴雪':
        return Icons.ac_unit_rounded;
      case '雾':
      case '霾':
        return Icons.cloud_queue_rounded;
      case '沙尘':
        return Icons.blur_on_rounded;
      default:
        return Icons.wb_cloudy_rounded;
    }
  }
}
