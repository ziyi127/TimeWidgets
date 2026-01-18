import 'package:flutter/material.dart';
import 'package:time_widgets/models/course_model.dart';
import 'package:time_widgets/services/ntp_service.dart';
import 'package:time_widgets/utils/responsive_utils.dart';

/// 课程表组件- MD3紧凑版，支持内部滚动
class TimetableWidget extends StatelessWidget {

  const TimetableWidget({
    super.key,
    this.courses,
    this.isCompact = false,
  });
  final List<Course>? courses;
  final bool isCompact;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final displayCourses = courses ?? [];
    final width = MediaQuery.sizeOf(context).width;
    final fontMultiplier = ResponsiveUtils.getFontSizeMultiplier(width);

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
        borderRadius: BorderRadius.circular(
          ResponsiveUtils.getBorderRadius(width),
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
              children: [
                Icon(
                  Icons.view_agenda_rounded,
                  size: ResponsiveUtils.getIconSize(width, baseSize: 20),
                  color: colorScheme.primary,
                ),
                SizedBox(width: ResponsiveUtils.value(12)),
                Text(
                  '今日课程',
                  style: theme.textTheme.titleSmall?.copyWith(
                    color: colorScheme.onSurfaceVariant,
                    fontSize: (theme.textTheme.titleSmall?.fontSize ?? 14) * fontMultiplier,
                  ),
                ),
                const Spacer(),
                // 状态统计 - 限制显示数量，避免溢出
                if (completedCount > 0 || currentCount > 0 || upcomingCount > 0)
                  Row(
                    children: [
                      if (completedCount > 0)
                        _buildStatusBadge(context, '$completedCount', colorScheme.tertiary, '完成', width),
                      if (completedCount > 0 && (currentCount > 0 || upcomingCount > 0))
                        SizedBox(width: ResponsiveUtils.value(8)),
                      if (currentCount > 0)
                        _buildStatusBadge(context, '$currentCount', colorScheme.primary, '进行', width),
                      if (currentCount > 0 && upcomingCount > 0)
                        SizedBox(width: ResponsiveUtils.value(8)),
                      if (upcomingCount > 0)
                        _buildStatusBadge(context, '$upcomingCount', colorScheme.secondary, '待上', width),
                    ],
                  ),
              ],
            ),
            SizedBox(height: ResponsiveUtils.value(12)),
            // 课程列表 - 限制高度并支持滚动
            ConstrainedBox(
              constraints: BoxConstraints(
                maxHeight: ResponsiveUtils.value(120),
              ),
              child: displayCourses.isEmpty
                  ? Center(
                      child: Text(
                        '今天没有课',
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: colorScheme.onSurfaceVariant,
                          fontSize: (theme.textTheme.bodyMedium?.fontSize ?? 14) * fontMultiplier,
                        ),
                      ),
                    )
                  : ListView.separated(
                      shrinkWrap: true,
                      physics: const BouncingScrollPhysics(),
                      itemCount: displayCourses.length,
                      separatorBuilder: (context, index) => SizedBox(height: ResponsiveUtils.value(6)),
                      itemBuilder: (context, index) {
                        final course = displayCourses[index];
                        final status = courseStatuses[index];
                        return _buildCourseItem(context, course, status, width);
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatusBadge(BuildContext context, String count, Color color, String label, double width) {
    final fontMultiplier = ResponsiveUtils.getFontSizeMultiplier(width);
    
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: ResponsiveUtils.value(6),
          height: ResponsiveUtils.value(6),
          decoration: BoxDecoration(
            color: color,
            shape: BoxShape.circle,
          ),
        ),
        SizedBox(width: ResponsiveUtils.value(4)),
        Text(
          '$count$label',
          style: Theme.of(context).textTheme.labelSmall?.copyWith(
            color: color,
            fontWeight: FontWeight.w500,
            fontSize: (Theme.of(context).textTheme.labelSmall?.fontSize ?? 11) * fontMultiplier,
          ),
        ),
      ],
    );
  }

  Widget _buildCourseItem(BuildContext context, Course course, String status, double width) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final fontMultiplier = ResponsiveUtils.getFontSizeMultiplier(width);

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
      padding: EdgeInsets.symmetric(
        horizontal: ResponsiveUtils.value(12),
        vertical: ResponsiveUtils.value(10),
      ),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(ResponsiveUtils.value(12)),
        border: isCurrent ? Border.all(
          color: statusColor.withAlpha(77),
          width: ResponsiveUtils.value(1),
        ) : null,
      ),
      child: Row(
        children: [
          // 状态指示条
          Container(
            width: ResponsiveUtils.value(4),
            height: ResponsiveUtils.value(32),
            decoration: BoxDecoration(
              color: statusColor,
              borderRadius: BorderRadius.circular(ResponsiveUtils.value(2)),
            ),
          ),
          SizedBox(width: ResponsiveUtils.value(12)),
          // 课程信息
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        course.subject,
                        style: theme.textTheme.titleSmall?.copyWith(
                          fontWeight: FontWeight.w600,
                          color: colorScheme.onSurface,
                          fontSize: (theme.textTheme.titleSmall?.fontSize ?? 14) * fontMultiplier,
                        ),
                        overflow: TextOverflow.ellipsis,
                        maxLines: 1,
                      ),
                    ),
                    if (isCurrent) ...[
                      SizedBox(width: ResponsiveUtils.value(8)),
                      Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: ResponsiveUtils.value(6),
                          vertical: ResponsiveUtils.value(2),
                        ),
                        decoration: BoxDecoration(
                          color: statusColor.withAlpha(38),
                          borderRadius: BorderRadius.circular(ResponsiveUtils.value(6)),
                        ),
                        child: Text(
                          '进行中',
                          style: theme.textTheme.labelSmall?.copyWith(
                            color: statusColor,
                            fontWeight: FontWeight.w700,
                            fontSize: 10.0 * fontMultiplier,
                          ),
                        ),
                      ),
                    ],
                  ],
                ),
                SizedBox(height: ResponsiveUtils.value(2)),
                Text(
                  course.teacher,
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: colorScheme.onSurfaceVariant,
                    fontSize: (theme.textTheme.bodySmall?.fontSize ?? 12) * fontMultiplier,
                  ),
                  overflow: TextOverflow.ellipsis,
                  maxLines: 1,
                ),
                SizedBox(height: ResponsiveUtils.value(2)),
                Row(
                  children: [
                    Icon(
                      Icons.location_on_outlined,
                      size: ResponsiveUtils.getIconSize(width, baseSize: 12),
                      color: colorScheme.onSurfaceVariant,
                    ),
                    SizedBox(width: ResponsiveUtils.value(4)),
                    Expanded(
                      child: Text(
                        course.classroom,
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: colorScheme.onSurfaceVariant,
                          fontSize: (theme.textTheme.bodySmall?.fontSize ?? 12) * fontMultiplier,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          // 时间
          SizedBox(width: ResponsiveUtils.value(8)),
          Text(
            course.time,
            style: theme.textTheme.labelSmall?.copyWith(
              color: colorScheme.onSurfaceVariant,
              fontWeight: FontWeight.w500,
              fontSize: (theme.textTheme.labelSmall?.fontSize ?? 11) * fontMultiplier,
            ),
          ),
        ],
      ),
    );
  }
}
