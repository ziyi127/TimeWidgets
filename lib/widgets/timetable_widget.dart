import 'package:flutter/material.dart';

/// 课程表组�?- MD3紧凑版，支持内部滚动
class TimetableWidget extends StatelessWidget {
  final bool isCompact;

  const TimetableWidget({
    super.key,
    this.isCompact = false,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    final timetableData = [
      {'subject': '语文', 'teacher': '张老师', 'time': '08:00-08:45', 'status': 'completed'},
      {'subject': '数学', 'teacher': '李老师', 'time': '08:55-09:40', 'status': 'completed'},
      {'subject': '英语', 'teacher': '王老师', 'time': '10:00-10:45', 'status': 'current'},
      {'subject': '物理', 'teacher': '赵老师', 'time': '14:00-14:45', 'status': 'upcoming'},
      {'subject': '化学', 'teacher': '刘老师', 'time': '14:55-15:40', 'status': 'upcoming'},
    ];

    final completedCount = timetableData.where((item) => item['status'] == 'completed').length;
    final currentCount = timetableData.where((item) => item['status'] == 'current').length;
    final upcomingCount = timetableData.where((item) => item['status'] == 'upcoming').length;

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
                // 状态统�?
                _buildStatusBadge(context, '$completedCount', colorScheme.tertiary, '完成'),
                const SizedBox(width: 8),
                _buildStatusBadge(context, '$currentCount', colorScheme.primary, '进行'),
                const SizedBox(width: 8),
                _buildStatusBadge(context, '$upcomingCount', colorScheme.secondary, '待上'),
              ],
            ),
            const SizedBox(height: 12),
            // 课程列表 - 限制高度并支持滚�?
            ConstrainedBox(
              constraints: const BoxConstraints(maxHeight: 180),
              child: ListView.separated(
                shrinkWrap: true,
                physics: const ClampingScrollPhysics(),
                itemCount: timetableData.length,
                separatorBuilder: (context, index) => const SizedBox(height: 8),
                itemBuilder: (context, index) {
                  final item = timetableData[index];
                  return _buildCourseItem(context, item);
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

  Widget _buildCourseItem(BuildContext context, Map<String, String> item) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    final status = item['status'] ?? 'upcoming';
    final isCurrent = status == 'current';
    final isCompleted = status == 'completed';

    final statusColor = isCurrent
        ? colorScheme.primary
        : isCompleted
            ? colorScheme.tertiary
            : colorScheme.secondary;

    final backgroundColor = isCurrent
        ? colorScheme.primaryContainer.withValues(alpha: 0.4)
        : colorScheme.surfaceContainerHighest.withValues(alpha: 0.5);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(12),
        border: isCurrent ? Border.all(
          color: statusColor.withValues(alpha: 0.3),
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
                      item['subject']!,
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
                          color: statusColor.withValues(alpha: 0.15),
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Text(
                          '进行�?,
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
                  item['teacher']!,
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: colorScheme.onSurfaceVariant,
                  ),
                ),
              ],
            ),
          ),
          // 时间
          Text(
            item['time']!,
            style: theme.textTheme.labelMedium?.copyWith(
              color: colorScheme.onSurfaceVariant,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}
