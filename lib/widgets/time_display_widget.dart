import 'dart:async';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:time_widgets/services/ntp_service.dart';
import 'package:time_widgets/utils/responsive_utils.dart';

/// 时间显示组件 - MD3紧凑?
class TimeDisplayWidget extends StatefulWidget {
  final bool isCompact;

  const TimeDisplayWidget({
    super.key,
    this.isCompact = false,
  });

  @override
  State<TimeDisplayWidget> createState() => _TimeDisplayWidgetState();
}

class _TimeDisplayWidgetState extends State<TimeDisplayWidget> {
  late String _currentTime;
  late String _currentSeconds;
  late Timer _timer;

  @override
  void initState() {
    super.initState();
    _updateTime();
    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      _updateTime();
    });
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  void _updateTime() {
    final now = NtpService().now;
    setState(() {
      _currentTime = DateFormat('HH:mm').format(now);
      _currentSeconds = DateFormat('ss').format(now);
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final width = MediaQuery.sizeOf(context).width;
    final fontMultiplier = ResponsiveUtils.getFontSizeMultiplier(width);

    // MD3: 使用 surfaceContainerLow 作为卡片背景
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
              Icons.schedule_rounded,
              size: ResponsiveUtils.getIconSize(width, baseSize: 20),
              color: colorScheme.primary,
            ),
            SizedBox(width: ResponsiveUtils.value(12)),
            Text(
              '当前时间',
              style: theme.textTheme.titleSmall?.copyWith(
                color: colorScheme.onSurfaceVariant,
                fontSize: (theme.textTheme.titleSmall?.fontSize ?? 14) * fontMultiplier,
              ),
            ),
            const Spacer(),
            Text(
              _currentTime,
              style: theme.textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.w500,
                color: colorScheme.onSurface,
                fontSize: (theme.textTheme.headlineSmall?.fontSize ?? 24) * fontMultiplier,
              ),
            ),
            SizedBox(width: ResponsiveUtils.value(4)),
            Text(
              _currentSeconds,
              style: theme.textTheme.titleMedium?.copyWith(
                color: colorScheme.onSurfaceVariant,
                fontSize: (theme.textTheme.titleMedium?.fontSize ?? 16) * fontMultiplier,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
