import 'package:flutter/material.dart';

class CurrentClassWidget extends StatelessWidget {
  final double? fontSize;
  final double? padding;

  const CurrentClassWidget({
    super.key,
    this.fontSize,
    this.padding,
  });

  @override
  Widget build(BuildContext context) {
    final effectivePadding = padding ?? 24.0;
    final effectiveBaseFontSize = fontSize ?? 14.0;
    final titleFontSize = effectiveBaseFontSize;
    final badgeFontSize = effectiveBaseFontSize * 0.7;
    final courseFontSize = effectiveBaseFontSize * 1.4;
    final timeFontSize = effectiveBaseFontSize;
    final progressFontSize = effectiveBaseFontSize * 0.85;
    final nextClassFontSize = effectiveBaseFontSize * 0.85;

    return Container(
      padding: EdgeInsets.all(effectivePadding),
      decoration: BoxDecoration(
        color: const Color(0xFF1E1E1E).withValues(alpha: 0.8),  // 半透明背景
        borderRadius: BorderRadius.circular(16.0),
        border: Border.all(
          color: const Color(0xFF3D3D3D).withValues(alpha: 0.5),  // 半透明边框
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
          // 标题区域
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Current Class',
                style: TextStyle(
                  fontSize: titleFontSize,
                  color: const Color(0xFFB3B3B3),  // MD3 onSurfaceVariant
                  fontWeight: FontWeight.w500,
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: const Color(0xFF4CAF50).withValues(alpha: 0.12),  // MD3 primary with opacity
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  'In Progress',
                  style: TextStyle(
                    fontSize: badgeFontSize,
                    color: const Color(0xFF4CAF50),  // MD3 primary
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: effectivePadding * 0.67),
          
          // 课程信息
          Row(
            children: [
              // 课程图标
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: const Color(0xFF2196F3).withValues(alpha: 0.12),  // MD3 primary with opacity
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(
                  Icons.class_,
                  size: 32,
                  color: Color(0xFF2196F3),  // MD3 primary
                ),
              ),
              const SizedBox(width: 16),
              
              // 课程详情
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    FittedBox(
                      fit: BoxFit.scaleDown,
                      child: Text(
                        'Chinese A Teacher',
                        style: TextStyle(
                          fontSize: courseFontSize,
                          fontWeight: FontWeight.w600,
                          color: const Color(0xFFFFFFFF),  // MD3 onSurface
                        ),
                      ),
                    ),
                    SizedBox(height: effectivePadding * 0.17),
                    Text(
                      '8:00 - 8:45',
                      style: TextStyle(
                        fontSize: timeFontSize,
                        color: const Color(0xFFB3B3B3),  // MD3 onSurfaceVariant
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          
          SizedBox(height: effectivePadding * 0.67),
          
          // 课程进度条
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Class Progress',
                    style: TextStyle(
                      fontSize: progressFontSize,
                      color: const Color(0xFFB3B3B3),  // MD3 onSurfaceVariant
                    ),
                  ),
                  Text(
                    '30/45 min',
                    style: TextStyle(
                      fontSize: progressFontSize,
                      color: const Color(0xFFFFFFFF),  // MD3 onSurface
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
              SizedBox(height: effectivePadding * 0.33),
              ClipRRect(
                borderRadius: BorderRadius.circular(4),
                child: LinearProgressIndicator(
                  value: 0.67, // 30/45 ≈ 0.67
                  backgroundColor: const Color(0xFF3D3D3D),  // MD3 surface variant
                  valueColor: const AlwaysStoppedAnimation<Color>(Color(0xFF2196F3)),  // MD3 primary
                  minHeight: effectivePadding * 0.25,
                ),
              ),
            ],
          ),
          
          SizedBox(height: effectivePadding * 0.67),
          
          // 下节课预告
          Container(
            padding: EdgeInsets.all(effectivePadding * 0.67),
            decoration: BoxDecoration(
              color: const Color(0xFF2A2A2A).withValues(alpha: 0.6),  // 半透明内卡片
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: const Color(0xFF3D3D3D).withValues(alpha: 0.3),  // 半透明边框
                width: 1,
              ),
            ),
            child: Row(
              children: [
                const Icon(
                  Icons.schedule,
                  size: 16,
                  color: Color(0xFFB3B3B3),  // MD3 onSurfaceVariant
                ),
                SizedBox(width: effectivePadding * 0.33),
                Text(
                  'Next: Math B Teacher (8:50)',
                  style: TextStyle(
                    fontSize: nextClassFontSize,
                    color: const Color(0xFFFFFFFF),  // MD3 onSurface
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}