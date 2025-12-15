import 'package:flutter/material.dart';

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
      {'subject': 'Chinese', 'teacher': 'Teacher A', 'time': '08:30-09:10', 'status': 'completed', 'room': 'A101'},
      {'subject': 'Math', 'teacher': 'Teacher B', 'time': '09:20-10:00', 'status': 'completed', 'room': 'B205'},
      {'subject': 'English', 'teacher': 'Teacher C', 'time': '10:10-11:50', 'status': 'current', 'room': 'C302'},
      {'subject': 'Physics', 'teacher': 'Teacher D', 'time': '14:00-14:40', 'status': 'upcoming', 'room': 'D108'},
      {'subject': 'Chemistry', 'teacher': 'Teacher E', 'time': '14:50-15:30', 'status': 'upcoming', 'room': 'E201'},
    ];

    final currentClassCount = timetableData.where((item) => item['status'] == 'current').length;
    final upcomingClassCount = timetableData.where((item) => item['status'] == 'upcoming').length;
    final completedClassCount = timetableData.where((item) => item['status'] == 'completed').length;

    return Card(
      elevation: 0,
      color: colorScheme.surfaceContainer,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(
          color: colorScheme.outline.withValues(alpha: 0.2),
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
                  Icons.schedule_rounded,
                  size: isCompact ? 16 : 18,
                  color: colorScheme.primary,
                ),
                const SizedBox(width: 8),
                Text(
                  'Today\'s Classes',
                  style: theme.textTheme.titleSmall?.copyWith(
                    color: colorScheme.onSurfaceVariant,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const Spacer(),
                _buildStatusChip(
                  context,
                  '${timetableData.length} Classes',
                  colorScheme.primary,
                ),
              ],
            ),
            
            if (!isCompact) ...[
              const SizedBox(height: 12),
              
              // Status summary
              Row(
                children: [
                  if (completedClassCount > 0)
                    _buildStatusIndicator(
                      context,
                      Icons.check_circle_outline_rounded,
                      '$completedClassCount Completed',
                      colorScheme.tertiary,
                    ),
                  if (currentClassCount > 0) ...[
                    if (completedClassCount > 0) const SizedBox(width: 12),
                    _buildStatusIndicator(
                      context,
                      Icons.play_circle_outline_rounded,
                      '$currentClassCount Current',
                      colorScheme.primary,
                    ),
                  ],
                  if (upcomingClassCount > 0) ...[
                    if (completedClassCount > 0 || currentClassCount > 0) const SizedBox(width: 12),
                    _buildStatusIndicator(
                      context,
                      Icons.schedule_rounded,
                      '$upcomingClassCount Upcoming',
                      colorScheme.secondary,
                    ),
                  ],
                ],
              ),
            ],
            
            SizedBox(height: isCompact ? 12 : 16),
            
            // Classes list
            ConstrainedBox(
              constraints: BoxConstraints(maxHeight: isCompact ? 200 : 280),
              child: ListView.separated(
                shrinkWrap: true,
                physics: const ClampingScrollPhysics(),
                itemCount: timetableData.length,
                separatorBuilder: (context, index) => SizedBox(height: isCompact ? 8 : 12),
                itemBuilder: (context, index) {
                  final item = timetableData[index];
                  return _buildCourseItem(context, item, index);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatusChip(BuildContext context, String text, Color color) {
    final theme = Theme.of(context);
    
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        text,
        style: theme.textTheme.labelSmall?.copyWith(
          color: color,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  Widget _buildStatusIndicator(BuildContext context, IconData icon, String text, Color color) {
    final theme = Theme.of(context);
    
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(
          icon,
          size: 14,
          color: color,
        ),
        const SizedBox(width: 4),
        Text(
          text,
          style: theme.textTheme.labelSmall?.copyWith(
            color: color,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }

  Widget _buildCourseItem(BuildContext context, Map<String, String> item, int index) {
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
        ? colorScheme.primaryContainer.withValues(alpha: 0.3)
        : colorScheme.surfaceContainerHighest;

    return Container(
      padding: EdgeInsets.all(isCompact ? 12.0 : 16.0),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isCurrent 
              ? statusColor.withValues(alpha: 0.3) 
              : colorScheme.outline.withValues(alpha: 0.1),
          width: 1,
        ),
      ),
      child: Row(
        children: [
          // Status indicator
          Container(
            width: 4,
            height: isCompact ? 32 : 40,
            decoration: BoxDecoration(
              color: statusColor,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          
          SizedBox(width: isCompact ? 12 : 16),
          
          // Course info
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        item['subject']!,
                        style: theme.textTheme.titleSmall?.copyWith(
                          color: colorScheme.onSurface,
                          fontWeight: FontWeight.w600,
                          fontSize: isCompact ? 14 : 16,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    if (isCurrent)
                      Container(
                        margin: const EdgeInsets.only(left: 8),
                        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                        decoration: BoxDecoration(
                          color: statusColor.withValues(alpha: 0.12),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          'LIVE',
                          style: theme.textTheme.labelSmall?.copyWith(
                            color: statusColor,
                            fontWeight: FontWeight.w700,
                            fontSize: 10,
                          ),
                        ),
                      ),
                  ],
                ),
                
                const SizedBox(height: 4),
                
                Row(
                  children: [
                    Icon(
                      Icons.person_outline_rounded,
                      size: 14,
                      color: colorScheme.onSurfaceVariant,
                    ),
                    const SizedBox(width: 4),
                    Expanded(
                      child: Text(
                        item['teacher']!,
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: colorScheme.onSurfaceVariant,
                          fontSize: isCompact ? 11 : 12,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    if (!isCompact && item['room'] != null) ...[
                      const SizedBox(width: 8),
                      Icon(
                        Icons.location_on_outlined,
                        size: 14,
                        color: colorScheme.onSurfaceVariant,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        item['room']!,
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: colorScheme.onSurfaceVariant,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ],
                ),
              ],
            ),
          ),
          
          // Time info
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                item['time']!,
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: colorScheme.onSurface,
                  fontWeight: FontWeight.w500,
                  fontSize: isCompact ? 12 : 14,
                ),
              ),
              if (!isCompact) ...[
                const SizedBox(height: 2),
                Icon(
                  _getStatusIcon(status),
                  size: 16,
                  color: statusColor,
                ),
              ],
            ],
          ),
        ],
      ),
    );
  }

  IconData _getStatusIcon(String status) {
    switch (status) {
      case 'current':
        return Icons.play_circle_filled_rounded;
      case 'completed':
        return Icons.check_circle_rounded;
      case 'upcoming':
        return Icons.schedule_rounded;
      default:
        return Icons.circle_outlined;
    }
  }
}