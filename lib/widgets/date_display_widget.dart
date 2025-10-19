import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class DateDisplayWidget extends StatelessWidget {
  final double? fontSize;
  final double? padding;
  
  const DateDisplayWidget({
    super.key,
    this.fontSize,
    this.padding,
  });

  @override
  Widget build(BuildContext context) {
    final effectivePadding = padding ?? 24.0;
    final effectiveBaseFontSize = fontSize ?? 14.0;
    final titleFontSize = effectiveBaseFontSize;
    final dateFontSize = effectiveBaseFontSize * 1.7;
    final lunarFontSize = effectiveBaseFontSize * 1.1;
    final dayFontSize = effectiveBaseFontSize * 1.3;
    final weekFontSize = effectiveBaseFontSize;
    final timeFontSize = effectiveBaseFontSize * 0.9;
    
    return Container(
      padding: EdgeInsets.all(effectivePadding),
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
                'Date Information',
                style: TextStyle(
                  fontSize: titleFontSize,
                  color: const Color(0xFFB3B3B3),  // MD3 onSurfaceVariant
                  fontWeight: FontWeight.w500,
                ),
              ),
              Container(
                padding: EdgeInsets.symmetric(horizontal: effectiveBaseFontSize * 0.6, vertical: effectiveBaseFontSize * 0.3),
                decoration: BoxDecoration(
                  color: const Color(0xFF2196F3).withValues(alpha: 0.12),  // MD3 primary with opacity
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  'Today',
                  style: TextStyle(
                    fontSize: effectiveBaseFontSize * 0.7,
                    color: const Color(0xFF2196F3),  // MD3 primary
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: effectiveBaseFontSize * 1.1),
          
          // Gregorian date
          Text(
            '${DateTime.now().year}-${DateFormat('MM.dd').format(DateTime.now())}',
            style: TextStyle(
              fontSize: dateFontSize,
              fontWeight: FontWeight.w500,
              color: const Color(0xFFFFFFFF),  // MD3 onSurface
            ),
          ),
          SizedBox(height: effectiveBaseFontSize * 0.6),
          
          // Lunar date
          Text(
            _getLunarDate(DateTime.now()),
            style: TextStyle(
              fontSize: lunarFontSize,
              color: const Color(0xFFB3B3B3),  // MD3 onSurfaceVariant
              fontWeight: FontWeight.w400,
            ),
          ),
          SizedBox(height: effectiveBaseFontSize * 0.9),
          
          // Day of week and week number
          FittedBox(
            fit: BoxFit.scaleDown,
            child: Row(
              children: [
                Text(
                  _getChineseDayOfWeek(DateTime.now().weekday),
                  style: TextStyle(
                    fontSize: dayFontSize,
                    fontWeight: FontWeight.w500,
                    color: const Color(0xFFFFFFFF),  // MD3 onSurface
                  ),
                ),
                SizedBox(width: effectiveBaseFontSize * 1.1),
                Text(
                  'Week 12',
                  style: TextStyle(
                    fontSize: weekFontSize,
                    color: const Color(0xFFB3B3B3),  // MD3 onSurfaceVariant
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ],
            ),
          ),
          
          // Time of day
          SizedBox(height: effectiveBaseFontSize * 0.6),
          Text(
            _getTimeOfDay(),
            style: TextStyle(
              fontSize: timeFontSize,
              color: const Color(0xFF808080),  // MD3 onSurfaceVariant with less opacity
              fontStyle: FontStyle.italic,
            ),
          ),
        ],
      ),
    );
  }

  String _getChineseDayOfWeek(int weekday) {
    switch (weekday) {
      case 1:
        return '周一';
      case 2:
        return '周二';
      case 3:
        return '周三';
      case 4:
        return '周四';
      case 5:
        return '周五';
      case 6:
        return '周六';
      case 7:
        return '周日';
      default:
        return '未知';
    }
  }
  
  String _getLunarDate(DateTime date) {
    // 简化的农历显示，实际应用中需要农历转换库
    return '农历三月初八';
  }
  
  String _getTimeOfDay() {
    final hour = DateTime.now().hour;
    if (hour < 6) return '凌晨时分';
    if (hour < 12) return '上午时光';
    if (hour < 14) return '中午时分';
    if (hour < 18) return '下午时光';
    if (hour < 21) return '傍晚时分';
    return '夜晚时分';
  }
}