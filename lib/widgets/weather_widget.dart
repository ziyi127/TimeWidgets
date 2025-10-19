import 'package:flutter/material.dart';
import 'package:time_widgets/models/weather_model.dart';
import 'package:time_widgets/widgets/error_widget.dart';

class WeatherWidget extends StatelessWidget {
  final double? fontSize;
  final double? padding;
  final WeatherData? weatherData;
  final String? error;
  final VoidCallback? onRetry;
  
  const WeatherWidget({
    super.key,
    this.fontSize,
    this.padding,
    this.weatherData,
    this.error,
    this.onRetry,
  });

  @override
  Widget build(BuildContext context) {
    final padding = this.padding ?? 24.0;
    final baseFontSize = fontSize ?? 14.0;
    final titleFontSize = baseFontSize;
    final badgeFontSize = baseFontSize * 0.7;
    final iconSize = baseFontSize * 3.4;
    final tempFontSize = baseFontSize * 2.6;
    final unitFontSize = baseFontSize * 1.4;
    final weatherFontSize = baseFontSize * 1.1;
    final detailFontSize = baseFontSize * 0.85;
    final detailValueFontSize = baseFontSize * 0.85;
    
    // 错误处理
    if (error != null) {
      return CustomErrorWidget(
        message: error!,
        onRetry: onRetry,
        fontSize: baseFontSize,
      );
    }
    
    // 使用真实天气数据或默认值
    final weather = weatherData;
    final temperature = weather?.temperature ?? 20;
    final description = weather?.description ?? 'Sunny';
    final humidity = weather?.humidity ?? 65;
    final wind = weather?.wind ?? '微风';
    final pressure = weather?.pressure ?? 1016;
    
    return Container(
      padding: EdgeInsets.all(padding),
      decoration: BoxDecoration(
        color: const Color(0xFF1E1E1E).withValues(alpha: 0.8),  // Semi-transparent background
        borderRadius: BorderRadius.circular(16.0),
        border: Border.all(
          color: const Color(0xFF3D3D3D).withValues(alpha: 0.5),  // Semi-transparent border
          width: 1.0,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.1),
            blurRadius: 8.0,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Title area
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Weather Info',
                style: TextStyle(
                  fontSize: titleFontSize,
                  color: const Color(0xFFB3B3B3),  // MD3 onSurfaceVariant
                  fontWeight: FontWeight.w500,
                ),
              ),
              Container(
                padding: EdgeInsets.symmetric(horizontal: baseFontSize * 0.6, vertical: baseFontSize * 0.3),
                decoration: BoxDecoration(
                  color: const Color(0xFFFF9800).withValues(alpha: 0.12),  // MD3 primary with opacity
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  'Live Update',
                  style: TextStyle(
                    fontSize: badgeFontSize,
                    color: const Color(0xFFFF9800),  // MD3 primary
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: baseFontSize * 0.8),
          
          // Main weather info
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Weather icon
              Container(
                width: iconSize,
                height: iconSize,
                decoration: BoxDecoration(
                  color: const Color(0xFFFF9800).withValues(alpha: 0.12),  // MD3 primary with opacity
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  Icons.wb_sunny,
                  size: iconSize * 0.67,
                  color: const Color(0xFFFF9800),  // MD3 primary
                ),
              ),
              SizedBox(width: baseFontSize * 0.8),
              
              // Temperature display
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    FittedBox(
                      fit: BoxFit.scaleDown,
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.baseline,
                        textBaseline: TextBaseline.alphabetic,
                        children: [
                          Text(
                            '$temperature',
                            style: TextStyle(
                              fontSize: tempFontSize,
                              fontWeight: FontWeight.w300,
                              color: const Color(0xFFFFFFFF),  // MD3 onSurface
                            ),
                          ),
                          Text(
                            '°C',
                            style: TextStyle(
                              fontSize: unitFontSize,
                              fontWeight: FontWeight.w300,
                              color: const Color(0xFFB3B3B3),  // MD3 onSurfaceVariant
                            ),
                          ),
                        ],
                      ),
                    ),
                    Text(
                      description,
                      style: TextStyle(
                        fontSize: weatherFontSize,
                        color: const Color(0xFFFFFFFF),  // MD3 onSurface
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          
          SizedBox(height: baseFontSize * 0.8),
          
          // Detail info card
          Container(
            padding: EdgeInsets.all(baseFontSize * 1.1),
            decoration: BoxDecoration(
              color: const Color(0xFF2A2A2A).withValues(alpha: 0.6),  // Semi-transparent inner card
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: const Color(0xFF3D3D3D).withValues(alpha: 0.3),  // Semi-transparent border
                width: 1,
              ),
            ),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Feels Like',
                      style: TextStyle(
                        fontSize: detailFontSize,
                        color: const Color(0xFFB3B3B3),  // MD3 onSurfaceVariant
                      ),
                    ),
                    Text(
                      '${pressure}hPa',
                      style: TextStyle(
                        fontSize: detailValueFontSize,
                        color: const Color(0xFFFFFFFF),  // MD3 onSurface
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: baseFontSize * 0.6),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Humidity',
                      style: TextStyle(
                        fontSize: detailFontSize,
                        color: const Color(0xFFB3B3B3),  // MD3 onSurfaceVariant
                      ),
                    ),
                    Text(
                      '$humidity%',
                      style: TextStyle(
                        fontSize: detailValueFontSize,
                        color: const Color(0xFFFFFFFF),  // MD3 onSurface
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: baseFontSize * 0.6),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Wind',
                      style: TextStyle(
                        fontSize: detailFontSize,
                        color: const Color(0xFFB3B3B3),  // MD3 onSurfaceVariant
                      ),
                    ),
                    Text(
                      wind,
                      style: TextStyle(
                        fontSize: detailValueFontSize,
                        color: const Color(0xFFFFFFFF),  // MD3 onSurface
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}