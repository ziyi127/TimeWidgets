import 'dart:async';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

/// 时间显示组件 - MD3紧凑版
class TimeDisplayWidget extends StatefulWidget {
  const TimeDisplayWidget({
    super.key,
    this.isCompact = false,
  });
  final bool isCompact;

  @override
  State<TimeDisplayWidget> createState() => _TimeDisplayWidgetState();
}

class _TimeDisplayWidgetState extends State<TimeDisplayWidget> {
  static final DateFormat _timeFormat = DateFormat('HH:mm');
  static final DateFormat _secondsFormat = DateFormat('ss');

  String _currentTime = '';
  String _currentSeconds = '';
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
    if (!mounted) return;

    final now = DateTime.now();
    final newTime = _timeFormat.format(now);
    final newSeconds = _secondsFormat.format(now);

    // 只有当时间真正改变时才调用 setState
    if (_currentTime != newTime || _currentSeconds != newSeconds) {
      if (mounted) {
        setState(() {
          _currentTime = newTime;
          _currentSeconds = newSeconds;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    // MD3: 使用 surfaceContainerLow 作为卡片背景
    return Card(
      elevation: 0,
      color: colorScheme.surfaceContainerLow,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.schedule_rounded,
              size: 16,
              color: colorScheme.primary,
            ),
            const SizedBox(width: 8),
            Text(
              '当前时间',
              style: theme.textTheme.labelLarge?.copyWith(
                color: colorScheme.onSurfaceVariant,
                fontSize: 12,
              ),
            ),
            const SizedBox(width: 12),
            Text(
              _currentTime,
              style: theme.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.w500,
                color: colorScheme.onSurface,
                fontSize: 20,
              ),
            ),
            const SizedBox(width: 4),
            Text(
              _currentSeconds,
              style: theme.textTheme.titleSmall?.copyWith(
                color: colorScheme.onSurfaceVariant,
                fontSize: 14,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
