import 'package:flutter/material.dart';
import 'package:time_widgets/services/ntp_service.dart';
import 'package:time_widgets/utils/responsive_utils.dart';

/// 日期显示组件 - MD3紧凑版
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
    final now = NtpService().now;
    final width = MediaQuery.sizeOf(context).width;
    final fontMultiplier = ResponsiveUtils.getFontSizeMultiplier(width);

    return Card(
      elevation: 0,
      color: colorScheme.surfaceContainerLow,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(
          ResponsiveUtils.getBorderRadius(width, baseRadius: 16),
        ),
      ),
      child: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: ResponsiveUtils.getHorizontalPadding(width),
          vertical: ResponsiveUtils.value(12),
        ),
        child: Row(
          children: [
            Icon(
              Icons.calendar_today_rounded,
              size: ResponsiveUtils.getIconSize(width, baseSize: 20),
              color: colorScheme.primary,
            ),
            SizedBox(width: ResponsiveUtils.value(12)),
            Text(
              '日期',
              style: theme.textTheme.titleSmall?.copyWith(
                color: colorScheme.onSurfaceVariant,
                fontSize: (theme.textTheme.titleSmall?.fontSize ?? 14) * fontMultiplier,
              ),
            ),
            const Spacer(),
            Text(
              '${now.month}月${now.day}日',
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w500,
                color: colorScheme.onSurface,
                fontSize: (theme.textTheme.titleMedium?.fontSize ?? 16) * fontMultiplier,
              ),
            ),
            SizedBox(width: ResponsiveUtils.value(8)),
            Container(
              padding: EdgeInsets.symmetric(
                horizontal: ResponsiveUtils.value(8),
                vertical: ResponsiveUtils.value(4),
              ),
              decoration: BoxDecoration(
                color: colorScheme.primaryContainer,
                borderRadius: BorderRadius.circular(ResponsiveUtils.value(8)),
              ),
              child: Text(
                _getWeekdayName(now.weekday),
                style: theme.textTheme.labelMedium?.copyWith(
                  color: colorScheme.onPrimaryContainer,
                  fontWeight: FontWeight.w600,
                  fontSize: (theme.textTheme.labelMedium?.fontSize ?? 12) * fontMultiplier,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _getWeekdayName(int weekday) {
    const weekdays = ['周一', '周二', '周三', '周四', '周五', '周六', '周日'];
    return weekdays[weekday - 1];
  }
}
