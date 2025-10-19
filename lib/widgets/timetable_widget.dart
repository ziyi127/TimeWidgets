import 'package:flutter/material.dart';

class TimetableWidget extends StatelessWidget {
  final double? fontSize;
  final double? padding;

  const TimetableWidget({
    super.key,
    this.fontSize,
    this.padding,
  });

  @override
  Widget build(BuildContext context) {
    final effectivePadding = padding ?? 24.0;
    final effectiveBaseFontSize = fontSize ?? 14.0;
    final titleFontSize = effectiveBaseFontSize * 1.4;
    final badgeFontSize = effectiveBaseFontSize * 0.85;
    // 移除未使用的变量
    // final courseFontSize = effectiveBaseFontSize * 1.15;
    // final teacherFontSize = effectiveBaseFontSize * 0.93;
    // final timeFontSize = effectiveBaseFontSize;
    // final statusFontSize = effectiveBaseFontSize * 0.7;

    final timetableData = [
      {'subject': 'Chinese', 'teacher': 'Teacher A', 'time': '08:30-09:10', 'status': 'completed'},
      {'subject': 'Math', 'teacher': 'Teacher B', 'time': '09:20-10:00', 'status': 'completed'},
      {'subject': 'English', 'teacher': 'Teacher C', 'time': '10:10-11:50', 'status': 'current'},
      {'subject': 'Physics', 'teacher': 'Teacher D', 'time': '14:00-14:40', 'status': 'upcoming'},
      {'subject': 'Chemistry', 'teacher': 'Teacher E', 'time': '14:50-15:30', 'status': 'upcoming'},
    ];

    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(effectivePadding),
      decoration: BoxDecoration(
        color: const Color(0xFF2a2a3e).withValues(alpha: 0.8),  // 保持半透明背景
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: const Color(0xFF4a4a5e).withValues(alpha: 0.5),  // 半透明边框
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.1),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Today\'s Classes',
                style: TextStyle(
                  fontSize: titleFontSize,
                  fontWeight: FontWeight.w500,
                  color: Colors.white,
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: const Color(0xFF4CAF50).withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: const Color(0xFF4CAF50).withValues(alpha: 0.3),
                    width: 1,
                  ),
                ),
                child: Text(
                  '5 Classes',
                  style: TextStyle(
                    fontSize: badgeFontSize,
                    color: const Color(0xFF4CAF50).withValues(alpha: 0.8),
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: effectivePadding * 0.83),
          ConstrainedBox(
            constraints: const BoxConstraints(maxHeight: 280),
            child: ListView.separated(
              shrinkWrap: true,
              physics: const ClampingScrollPhysics(),
              itemCount: timetableData.length,
              separatorBuilder: (context, index) => SizedBox(height: effectivePadding * 0.33),
              itemBuilder: (context, index) {
                final item = timetableData[index];
                return _buildCourseItem(item, index, effectiveBaseFontSize, effectivePadding);
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCourseItem(Map<String, String> item, int index, double effectiveBaseFontSize, double effectivePadding) {
    // 字体大小变量
    final courseFontSize = effectiveBaseFontSize * 1.15;
    final teacherFontSize = effectiveBaseFontSize * 0.93;
    final timeFontSize = effectiveBaseFontSize;
    
    final status = item['status'] ?? 'upcoming';
    final isCurrent = status == 'current';
    final isCompleted = status == 'completed';
    
    final statusColor = isCurrent 
        ? const Color(0xFF2196F3)
        : isCompleted
            ? const Color(0xFF757575)
            : const Color(0xFF9E9E9E);
    
    final backgroundColor = isCurrent
        ? const Color(0xFF2196F3).withValues(alpha: 0.08)  // MD3 降低透明度
        : const Color(0xFF3a3a4e);

    return Container(
      margin: EdgeInsets.only(bottom: effectivePadding * 0.5),
      padding: EdgeInsets.symmetric(horizontal: effectivePadding * 0.67, vertical: effectivePadding * 0.5),
      decoration: BoxDecoration(
        color: backgroundColor.withValues(alpha: 0.6),  // 半透明内卡片
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isCurrent ? statusColor.withValues(alpha: 0.24) : const Color(0xFF4a4a5e).withValues(alpha: 0.3),  // 半透明边框
          width: 1,
        ),
      ),
      child: Row(
        children: [
          // 状态指示器
          Container(
            width: 4,
            height: 40,
            decoration: BoxDecoration(
              color: statusColor,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          SizedBox(width: effectivePadding * 0.67),
          
          // 课程信息
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    FittedBox(
                      fit: BoxFit.scaleDown,
                      child: Text(
                        item['subject']!,
                        style: TextStyle(
                          fontSize: courseFontSize,
                          fontWeight: FontWeight.w600,
                          color: const Color(0xFFFFFFFF),  // MD3 onSurface
                        ),
                      ),
                    ),
                    SizedBox(height: effectivePadding * 0.17),
                    Text(
                      item['teacher']!,
                      style: TextStyle(
                        fontSize: teacherFontSize,
                        color: const Color(0xFFB3B3B3),  // MD3 onSurfaceVariant
                      ),
                    ),
                  ],
                ),
              ),
          
          // 时间信息
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                item['time']!,
                style: TextStyle(
                  fontSize: timeFontSize,
                  fontWeight: FontWeight.w500,
                  color: const Color(0xFFFFFFFF),  // MD3 onSurface
                ),
              ),
              if (isCurrent)
                Container(
                  margin: const EdgeInsets.only(top: 4),
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                  decoration: BoxDecoration(
                    color: statusColor.withValues(alpha: 0.12),  // MD3 降低透明度
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Text(
                    '进行中',
                    style: TextStyle(
                      fontSize: 10,
                      color: statusColor,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }
}