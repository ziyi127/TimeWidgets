import 'package:flutter/material.dart';
import 'package:time_widgets/models/course_model.dart';
import 'package:time_widgets/services/ntp_service.dart';

/// 课程表组件- MD3紧凑版，支持内部滚动
class TimetableWidget extends StatelessWidget {
  final List<Course>? courses;
  final bool isCompact;

  const TimetableWidget({
    super.key,
    this.courses,
    this.isCompact = false,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final displayCourses = courses ?? [];

    int completedCount = 0;
    int currentCount = 0;
    int upcomingCount = 0;

    // Calculate status for each course
    final courseStatuses = displayCourses.map((course) {
      if (course.isCurrent) {
        currentCount++;
        return 'current';
      }
      
      // Parse time to check if completed
      // Format: "HH:MM~HH:MM"
      final parts = course.time.split('~');
      if (parts.length == 2) {
        final endParts = parts[1].split(':');
        if (endParts.length == 2) {
          final now = NtpService().now;
          final endHour = int.tryParse(endParts[0]) ?? 0;
          final endMinute = int.tryParse(endParts[1]) ?? 0;
          final endTime = DateTime(now.year, now.month, now.day, endHour, endMinute);
          
          if (now.isAfter(endTime)) {
            completedCount++;
            return 'completed';
          }
        }
      }
      
      upcomingCount++;
      return 'upcoming';
    }).toList();

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
                Icon(Icons.view_agenda_rounded, size: 20, color: colorScheme.primary),
                const SizedBox(width: 12),
                Text(
                  '今日课程',
                  style: theme.textTheme.titleSmall?.copyWith(
                    color: colorScheme.onSurfaceVariant,
                  ),
                ),
                const Spacer(),
                // 状态统计
                _buildStatusBadge(context, '$completedCount', colorScheme.tertiary, '完成'),
                const SizedBox(width: 8),
                _buildStatusBadge(context, '$currentCount', colorScheme.primary, '进行'),
                const SizedBox(width: 8),
                _buildStatusBadge(context, '$upcomingCount', colorScheme.secondary, '待上'),
              ],
            ),
            const SizedBox(height: 12),
            // 课程列表 - 限制高度并支持滚动
            ConstrainedBox(
              constraints: const BoxConstraints(maxHeight: 180),
              child: displayCourses.isEmpty
                  ? Center(
                      child: Text(
                        '今天没有课',
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: colorScheme.onSurfaceVariant,
                        ),
                      ),
                    )
                  : ListView.separated(
                      shrinkWrap: true,
                      physics: const ClampingScrollPhysics(),
                      itemCount: displayCourses.length,
                      separatorBuilder: (context, index) => const SizedBox(height: 8),
                      itemBuilder: (context, index) {
                        final course = displayCourses[index];
                        final status = courseStatuses[index];
                        return _buildCourseItem(context, course, status);
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatusBadge(BuildContext context, String count, Color color, String label) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 6,
          height: 6,
          decoration: BoxDecoration(
            color: color,
            shape: BoxShape.circle,
          ),
        ),
        const SizedBox(width: 4),
        Text(
          '$count$label',
          style: Theme.of(context).textTheme.labelSmall?.copyWith(
            color: color,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }

  Widget _buildCourseItem(BuildContext context, Course course, String status) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    final isCurrent = status == 'current';
    final isCompleted = status == 'completed';

    final statusColor = isCurrent
        ? colorScheme.primary
        : isCompleted
            ? colorScheme.tertiary
            : colorScheme.secondary;

    final backgroundColor = isCurrent
        ? colorScheme.primaryContainer.withAlpha(102)
        : colorScheme.surfaceContainerHighest.withAlpha(128);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(12),
        border: isCurrent ? Border.all(
          color: statusColor.withAlpha(77),
          width: 1,
        ) : null,
      ),
      child: Row(
        children: [
          // 状态指示条
          Container(
            width: 4,
            height: 32,
            decoration: BoxDecoration(
              color: statusColor,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          const SizedBox(width: 12),
          // 课程信息
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  children: [
                    Text(
                      course.subject,
                      style: theme.textTheme.titleSmall?.copyWith(
                        fontWeight: FontWeight.w600,
                        color: colorScheme.onSurface,
                      ),
                    ),
                    if (isCurrent) ...[
                      const SizedBox(width: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                        decoration: BoxDecoration(
                          color: statusColor.withAlpha(38),
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Text(
                          '进行中',
                          style: theme.textTheme.labelSmall?.copyWith(
                            color: statusColor,
                            fontWeight: FontWeight.w700,
                            fontSize: 10,
                          ),
                        ),
                      ),
                    ],
                  ],
                ),
                const SizedBox(height: 2),
                Text(
                  course.teacher,
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: colorScheme.onSurfaceVariant,
                  ),
                ),
                const SizedBox(height: 2),
                Row(
                  children: [
                    Icon(Icons.location_on_outlined, size: 12, color: colorScheme.onSurfaceVariant),
                    const SizedBox(width: 4),
                    Text(
                      course.classroom,
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: colorScheme.onSurfaceVariant,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ],
            ),
          ),
          // 时间
          Text(
            course.time,
            style: theme.textTheme.labelSmall?.copyWith(
              color: colorScheme.onSurfaceVariant,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}
