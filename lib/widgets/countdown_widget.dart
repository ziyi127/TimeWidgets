import 'package:flutter/material.dart';
import 'package:time_widgets/models/countdown_model.dart';
import 'package:time_widgets/screens/countdown_list_screen.dart';

/// 倒计时组件 - 简化版
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
      return _buildErrorCard(context, colorScheme);
    }

    // 使用真实倒计时数据或默认值
    final countdown = countdownData;
    final description = countdown?.description ?? '期末考试';
    final remainingDays = countdown?.remainingDays ?? 45;
    final eventType = countdown?.type ?? 'exam';
    final progress = countdown?.progress ?? 0.6;

    final typeColor = _getEventTypeColor(colorScheme, eventType);

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
      child: Padding(
        padding: EdgeInsets.all(isCompact ? 12.0 : 16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            // 头部
            _buildHeader(context, colorScheme, typeColor, eventType),
            SizedBox(height: isCompact ? 8 : 12),

            // 事件描述
            Text(
              description,
              style: theme.textTheme.titleMedium?.copyWith(
                color: colorScheme.onSurface,
                fontSize: isCompact ? 16 : 18,
                fontWeight: FontWeight.w600,
              ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
            SizedBox(height: isCompact ? 6 : 10),

            // 倒计时显示
            _buildCountdown(context, colorScheme, typeColor, remainingDays),

            // 进度条（非紧凑模式）
            if (!isCompact) ...[
              const SizedBox(height: 12),
              _buildProgress(context, colorScheme, typeColor, progress),
              const SizedBox(height: 10),
              _buildFooter(context, colorScheme, remainingDays, description),
            ],
          ],
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
        padding: EdgeInsets.all(isCompact ? 12.0 : 16.0),
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
              '倒计时加载失败',
              style: Theme.of(context).textTheme.titleSmall?.copyWith(
                    color: colorScheme.onErrorContainer,
                  ),
            ),
            if (onRetry != null) ...[
              const SizedBox(height: 8),
              FilledButton.tonal(
                onPressed: onRetry,
                child: const Text('重试'),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(
    BuildContext context,
    ColorScheme colorScheme,
    Color typeColor,
    String eventType,
  ) {
    return Row(
      children: [
        Icon(
          _getEventTypeIcon(eventType),
          size: isCompact ? 16 : 18,
          color: typeColor,
        ),
        const SizedBox(width: 8),
        Text(
          '倒计时',
          style: Theme.of(context).textTheme.titleSmall?.copyWith(
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
            _getEventTypeLabel(eventType),
            style: Theme.of(context).textTheme.labelSmall?.copyWith(
                  color: typeColor,
                  fontWeight: FontWeight.w600,
                ),
          ),
        ),
      ],
    );
  }

  Widget _buildCountdown(
    BuildContext context,
    ColorScheme colorScheme,
    Color typeColor,
    int remainingDays,
  ) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Text(
          '$remainingDays',
          style: Theme.of(context).textTheme.displayMedium?.copyWith(
                color: typeColor,
                fontWeight: FontWeight.w300,
                fontSize: isCompact ? 32 : 42,
                height: 1.0,
              ),
        ),
        const SizedBox(width: 6),
        Padding(
          padding: const EdgeInsets.only(bottom: 6),
          child: Text(
            '天',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  color: colorScheme.onSurfaceVariant,
                  fontSize: isCompact ? 14 : 16,
                  fontWeight: FontWeight.w500,
                ),
          ),
        ),
      ],
    );
  }

  Widget _buildProgress(
    BuildContext context,
    ColorScheme colorScheme,
    Color typeColor,
    double progress,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              '学习进度',
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: colorScheme.onSurfaceVariant,
                  ),
            ),
            Text(
              '${(progress * 100).toInt()}%',
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: colorScheme.onSurface,
                    fontWeight: FontWeight.w600,
                  ),
            ),
          ],
        ),
        const SizedBox(height: 6),
        LinearProgressIndicator(
          value: progress,
          backgroundColor: colorScheme.surfaceContainerHighest,
          valueColor: AlwaysStoppedAnimation<Color>(typeColor),
          minHeight: 6,
          borderRadius: BorderRadius.circular(3),
        ),
      ],
    );
  }

  Widget _buildFooter(
    BuildContext context,
    ColorScheme colorScheme,
    int remainingDays,
    String description,
  ) {
    return Row(
      children: [
        Expanded(
          child: Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: colorScheme.surfaceContainerHighest.withValues(alpha: 0.5),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Row(
              children: [
                Icon(
                  Icons.info_outline_rounded,
                  size: 14,
                  color: colorScheme.onSurfaceVariant,
                ),
                const SizedBox(width: 6),
                Expanded(
                  child: Text(
                    '距离$description还有$remainingDays天',
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: colorScheme.onSurface,
                        ),
                    maxLines: 1,
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
          style: FilledButton.styleFrom(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          ),
          child: const Text('查看全部'),
        ),
      ],
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
