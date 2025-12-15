import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class DateDisplayWidget extends StatelessWidget {
  final bool isCompact;
  
  const DateDisplayWidget({
    super.key,
    this.isCompact = false,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final now = DateTime.now();
    
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
                  Icons.calendar_today_rounded,
                  size: isCompact ? 16 : 18,
                  color: colorScheme.primary,
                ),
                const SizedBox(width: 8),
                Text(
                  'Date',
                  style: theme.textTheme.titleSmall?.copyWith(
                    color: colorScheme.onSurfaceVariant,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const Spacer(),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: colorScheme.primaryContainer,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    'Today',
                    style: theme.textTheme.labelSmall?.copyWith(
                      color: colorScheme.onPrimaryContainer,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
            
            SizedBox(height: isCompact ? 12 : 16),
            
            // Main date display
            Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                // Day number
                Text(
                  '${now.day}',
                  style: theme.textTheme.displaySmall?.copyWith(
                    color: colorScheme.onSurface,
                    fontWeight: FontWeight.w300,
                    fontSize: isCompact ? 32 : 40,
                    height: 1.0,
                  ),
                ),
                const SizedBox(width: 8),
                
                // Month and year
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(bottom: 8),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          DateFormat('MMMM').format(now),
                          style: theme.textTheme.titleMedium?.copyWith(
                            color: colorScheme.onSurface,
                            fontSize: isCompact ? 14 : 16,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        Text(
                          '${now.year}',
                          style: theme.textTheme.bodyMedium?.copyWith(
                            color: colorScheme.onSurfaceVariant,
                            fontSize: isCompact ? 12 : 14,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            
            if (!isCompact) ...[
              const SizedBox(height: 12),
              
              // Additional info
              Row(
                children: [
                  _buildDateDetail(
                    context,
                    Icons.event_rounded,
                    DateFormat('EEEE').format(now),
                    'Weekday',
                  ),
                  const SizedBox(width: 16),
                  _buildDateDetail(
                    context,
                    Icons.schedule_rounded,
                    'Week ${_getWeekOfYear(now)}',
                    'Week of Year',
                  ),
                ],
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildDateDetail(
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
          color: colorScheme.surfaceContainerHighest.withValues(alpha: 0.5),
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

  int _getWeekOfYear(DateTime date) {
    final firstDayOfYear = DateTime(date.year, 1, 1);
    final daysSinceFirstDay = date.difference(firstDayOfYear).inDays;
    return ((daysSinceFirstDay + firstDayOfYear.weekday - 1) / 7).ceil();
  }
}