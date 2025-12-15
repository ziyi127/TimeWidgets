import 'package:flutter/material.dart';
import 'package:time_widgets/services/week_service.dart';
import 'package:time_widgets/services/settings_service.dart';

class WeekDisplayWidget extends StatefulWidget {
  final bool isCompact;

  const WeekDisplayWidget({
    super.key,
    this.isCompact = false,
  });

  @override
  State<WeekDisplayWidget> createState() => _WeekDisplayWidgetState();
}

class _WeekDisplayWidgetState extends State<WeekDisplayWidget> {
  final WeekService _weekService = WeekService();
  final SettingsService _settingsService = SettingsService();
  int _weekNumber = 0;
  bool _isOddWeek = true;

  @override
  void initState() {
    super.initState();
    _loadWeekInfo();
  }

  Future<void> _loadWeekInfo() async {
    final settings = await _settingsService.loadSettings();
    if (settings.semesterStartDate != null) {
      final weekNumber = _weekService.calculateWeekNumber(
        settings.semesterStartDate!,
        DateTime.now(),
      );
      setState(() {
        _weekNumber = weekNumber;
        _isOddWeek = _weekService.isOddWeek(weekNumber);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    if (_weekNumber <= 0) {
      return const SizedBox.shrink();
    }

    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: widget.isCompact ? 8 : 12,
        vertical: widget.isCompact ? 4 : 6,
      ),
      decoration: BoxDecoration(
        color: _isOddWeek
            ? colorScheme.primaryContainer
            : colorScheme.secondaryContainer,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.calendar_view_week,
            size: widget.isCompact ? 14 : 16,
            color: _isOddWeek
                ? colorScheme.onPrimaryContainer
                : colorScheme.onSecondaryContainer,
          ),
          const SizedBox(width: 4),
          Text(
            '第$_weekNumber周',
            style: theme.textTheme.labelMedium?.copyWith(
              color: _isOddWeek
                  ? colorScheme.onPrimaryContainer
                  : colorScheme.onSecondaryContainer,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(width: 4),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
            decoration: BoxDecoration(
              color: _isOddWeek
                  ? colorScheme.primary.withValues(alpha: 0.2)
                  : colorScheme.secondary.withValues(alpha: 0.2),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(
              _isOddWeek ? '单周' : '双周',
              style: theme.textTheme.labelSmall?.copyWith(
                color: _isOddWeek
                    ? colorScheme.onPrimaryContainer
                    : colorScheme.onSecondaryContainer,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
