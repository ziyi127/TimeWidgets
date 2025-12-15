import 'package:flutter/material.dart';
import 'package:time_widgets/models/countdown_model.dart';
import 'package:time_widgets/screens/countdown_list_screen.dart';
import 'package:time_widgets/utils/md3_card_styles.dart';

class CountdownWidget extends StatelessWidget {
  final CountdownData? countdownData;
  final List<CountdownData>? allCountdowns;
  final String? error;
  final VoidCallback? onRetry;
  final VoidCallback? onViewAll;
  final bool isCompact;

  const CountdownWidget({
    super.key,
    this.countdownData,
    this.allCountdowns,
    this.error,
    this.onRetry,
    this.onViewAll,
    this.isCompact = false,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    
    // 错误处理
    if (error != null) {
      return MD3CardStyles.errorContainer(
        context: context,
        padding: EdgeInsets.all(isCompact ? 16.0 : 20.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.error_outline_rounded,
              color: colorScheme.onErrorContainer,
              size: 24,
            ),
            const SizedBox(height: 8),
            Text(
              'Countdown Error',
              style: theme.textTheme.titleSmall?.copyWith(
                color: colorScheme.onErrorContainer,
              ),
            ),
            if (onRetry != null) ...[
              const SizedBox(height: 8),
              FilledButton.tonal(
                onPressed: onRetry,
                child: const Text('Retry'),
              ),
            ],
          ],
        ),
      );
    }
    
    // 使用真实倒计时数据或默认值
    final countdown = countdownData;
    final description = countdown?.description ?? 'Final Exam';
    final remainingDays = countdown?.remainingDays ?? 45;
    final eventType = countdown?.type ?? 'exam';
    final progress = countdown?.progress ?? 0.6;
    
    // 根据事件类型确定颜色
    final typeColor = _getEventTypeColor(colorScheme, eventType);
    
    return MD3CardStyles.surfaceContainer(
      context: context,
      padding: EdgeInsets.all(isCompact ? 16.0 : 20.0),
      child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            // Header
            Row(
              children: [
                Icon(
                  _getEventTypeIcon(eventType),
                  size: isCompact ? 16 : 18,
                  color: typeColor,
                ),
                const SizedBox(width: 8),
                Text(
                  'Countdown',
                  style: theme.textTheme.titleSmall?.copyWith(
                    color: colorScheme.onSurfaceVariant,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const Spacer(),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: typeColor.withValues(alpha: 0.12),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    eventType.toUpperCase(),
                    style: theme.textTheme.labelSmall?.copyWith(
                      color: typeColor,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
            
            SizedBox(height: isCompact ? 12 : 16),
            
            // Event description
            Text(
              description,
              style: theme.textTheme.titleLarge?.copyWith(
                color: colorScheme.onSurface,
                fontSize: isCompact ? 18 : 22,
                fontWeight: FontWeight.w600,
              ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
            
            SizedBox(height: isCompact ? 8 : 12),
            
            // Countdown display
            Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  '$remainingDays',
                  style: theme.textTheme.displayMedium?.copyWith(
                    color: typeColor,
                    fontWeight: FontWeight.w300,
                    fontSize: isCompact ? 36 : 48,
                    height: 1.0,
                  ),
                ),
                const SizedBox(width: 8),
                Padding(
                  padding: const EdgeInsets.only(bottom: 8),
                  child: Text(
                    'days',
                    style: theme.textTheme.titleMedium?.copyWith(
                      color: colorScheme.onSurfaceVariant,
                      fontSize: isCompact ? 14 : 16,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ],
            ),
            
            if (!isCompact) ...[
              const SizedBox(height: 16),
              
              // Progress section
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Study Progress',
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: colorScheme.onSurfaceVariant,
                        ),
                      ),
                      Text(
                        '${(progress * 100).toInt()}%',
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: colorScheme.onSurface,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  LinearProgressIndicator(
                    value: progress,
                    backgroundColor: colorScheme.surfaceContainerHighest,
                    valueColor: AlwaysStoppedAnimation<Color>(typeColor),
                    minHeight: 6,
                    borderRadius: BorderRadius.circular(3),
                  ),
                ],
              ),
              
              const SizedBox(height: 12),
              
              // Summary text and view all button
              Row(
                children: [
                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: colorScheme.surfaceContainerHighest.withValues(alpha: 0.5),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Row(
                        children: [
                          Icon(
                            Icons.info_outline_rounded,
                            size: 16,
                            color: colorScheme.onSurfaceVariant,
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              '$remainingDays days until $description',
                              style: theme.textTheme.bodySmall?.copyWith(
                                color: colorScheme.onSurface,
                              ),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  FilledButton.tonal(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const CountdownListScreen(),
                        ),
                      );
                    },
                    child: const Text('查看全部'),
                  ),
                ],
              ),
            ],
          ],
        ),
    );
  }

  Color _getEventTypeColor(ColorScheme colorScheme, String eventType) {
    switch (eventType.toLowerCase()) {
      case 'exam':
        return colorScheme.error;
      case 'assignment':
        return colorScheme.tertiary;
      case 'project':
        return colorScheme.secondary;
      case 'holiday':
        return colorScheme.primary;
      default:
        return colorScheme.primary;
    }
  }

  IconData _getEventTypeIcon(String eventType) {
    switch (eventType.toLowerCase()) {
      case 'exam':
        return Icons.quiz_rounded;
      case 'assignment':
        return Icons.assignment_rounded;
      case 'project':
        return Icons.work_rounded;
      case 'holiday':
        return Icons.celebration_rounded;
      default:
        return Icons.event_rounded;
    }
  }
}