import 'dart:async';
import 'package:flutter/material.dart';
import 'package:time_widgets/l10n/app_localizations.dart';
import 'package:time_widgets/services/ntp_service.dart';

/// 日期显示组件 - MD3紧凑版
/// Converts to StatefulWidget to auto-refresh at midnight.
class DateDisplayWidget extends StatefulWidget {
  const DateDisplayWidget({
    super.key,
    this.isCompact = false,
  });
  final bool isCompact;

  @override
  State<DateDisplayWidget> createState() => _DateDisplayWidgetState();
}

class _DateDisplayWidgetState extends State<DateDisplayWidget> {
  late DateTime _now;
  Timer? _midnightTimer;
  Timer? _minuteTimer;

  @override
  void initState() {
    super.initState();
    _now = NtpService().now;
    _scheduleMidnightRefresh();
    // Also refresh every minute to stay reasonably current
    _minuteTimer = Timer.periodic(const Duration(minutes: 1), (_) {
      _refreshDate();
    });
  }

  @override
  void dispose() {
    _midnightTimer?.cancel();
    _minuteTimer?.cancel();
    super.dispose();
  }

  void _refreshDate() {
    if (!mounted) return;
    final newNow = NtpService().now;
    if (newNow.day != _now.day || newNow.month != _now.month) {
      setState(() {
        _now = newNow;
      });
      _scheduleMidnightRefresh();
    } else {
      _now = newNow;
    }
  }

  void _scheduleMidnightRefresh() {
    _midnightTimer?.cancel();
    final tomorrow = DateTime(_now.year, _now.month, _now.day + 1);
    final duration = tomorrow.difference(_now) + const Duration(seconds: 1);
    _midnightTimer = Timer(duration, () {
      _refreshDate();
    });
  }

  String _getWeekdayName(BuildContext context, int weekday) {
    final l10n = AppLocalizations.of(context)!;
    switch (weekday) {
      case 1: return l10n.weekdayMon;
      case 2: return l10n.weekdayTue;
      case 3: return l10n.weekdayWed;
      case 4: return l10n.weekdayThu;
      case 5: return l10n.weekdayFri;
      case 6: return l10n.weekdaySat;
      case 7: return l10n.weekdaySun;
      default: return '';
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final l10n = AppLocalizations.of(context)!;
    final dateStr = l10n.dateFormatMonthDay(_now.month, _now.day);
    final weekdayStr = _getWeekdayName(context, _now.weekday);

    return Semantics(
      label: '${l10n.dateLabel}: $dateStr $weekdayStr',
      child: Card(
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
                Icons.calendar_today_rounded,
                size: 16,
                color: colorScheme.primary,
              ),
              const SizedBox(width: 8),
              Text(
                l10n.dateLabel,
                style: theme.textTheme.labelLarge?.copyWith(
                  color: colorScheme.onSurfaceVariant,
                  fontSize: 12,
                ),
              ),
              const SizedBox(width: 12),
              Text(
                dateStr,
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w500,
                  color: colorScheme.onSurface,
                  fontSize: 14,
                ),
              ),
              const SizedBox(width: 6),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 6,
                  vertical: 2,
                ),
                decoration: BoxDecoration(
                  color: colorScheme.primaryContainer,
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Text(
                  weekdayStr,
                  style: theme.textTheme.labelSmall?.copyWith(
                    color: colorScheme.onPrimaryContainer,
                    fontWeight: FontWeight.w600,
                    fontSize: 11,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
