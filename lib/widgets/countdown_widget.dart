import 'package:flutter/material.dart';
import 'package:time_widgets/models/countdown_model.dart';
import 'package:time_widgets/screens/countdown_list_screen.dart';

/// 倒计时组�?- MD3紧凑�?
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

    if (error != null) {
      return _buildErrorCard(context, colorScheme);
    }

    final countdown = countdownData;
    final description = countdown?.description ?? '期末考试';
    final remainingDays = countdown?.remainingDays ?? 45;
    final eventType = countdown?.type ?? 'exam';
    final typeColor = _getEventTypeColor(colorScheme, eventType);

    return Card(
      elevation: 0,
      color: colorScheme.surfaceContainerLow,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: InkWell(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const CountdownListScreen()),
          );
        },
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              // 左侧图标
              Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  color: typeColor.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  _getEventTypeIcon(eventType),
                  size: 22,
                  color: typeColor,
                ),
              ),
              const SizedBox(width: 12),
              // 中间信息
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Row(
                      children: [
                        Text(
                          '倒计�?,
                          style: theme.textTheme.titleSmall?.copyWith(
                            color: colorScheme.onSurfaceVariant,
                          ),
                        ),
                        const SizedBox(width: 8),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                          decoration: BoxDecoration(
                            color: typeColor.withValues(alpha: 0.15),
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: Text(
                            _getEventTypeLabel(eventType),
                            style: theme.textTheme.labelSmall?.copyWith(
                              color: typeColor,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text(
                      description,
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                        color: colorScheme.onSurface,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
              // 右侧天数
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    '$remainingDays',
                    style: theme.textTheme.headlineMedium?.copyWith(
                      color: typeColor,
                      fontWeight: FontWeight.w500,
                      height: 1.0,
                    ),
                  ),
                  Text(
                    '�?,
                    style: theme.textTheme.labelMedium?.copyWith(
                      color: colorScheme.onSurfaceVariant,
                    ),
                  ),
                ],
              ),
              const SizedBox(width: 4),
              Icon(
                Icons.chevron_right_rounded,
                color: colorScheme.onSurfaceVariant,
                size: 24,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildErrorCard(BuildContext context, ColorScheme colorScheme) {
    return Card(
      elevation: 0,
      color: colorScheme.errorContainer,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            Icon(Icons.event_busy_rounded, color: colorScheme.onErrorContainer, size: 20),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                '倒计时加载失�?,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: colorScheme.onErrorContainer,
                ),
              ),
            ),
            if (onRetry != null)
              TextButton(
                onPressed: onRetry,
                child: Text(
                  '重试',
                  style: TextStyle(color: colorScheme.onErrorContainer),
                ),
              ),
          ],
        ),
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

  String _getEventTypeLabel(String eventType) {
    switch (eventType.toLowerCase()) {
      case 'exam':
        return '考试';
      case 'assignment':
        return '作业';
      case 'project':
        return '项目';
      case 'holiday':
        return '假期';
      default:
        return '事件';
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
