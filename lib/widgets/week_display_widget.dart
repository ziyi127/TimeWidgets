import 'package:flutter/material.dart';
import 'package:time_widgets/services/ntp_service.dart';
import 'package:time_widgets/services/settings_service.dart';
import 'package:time_widgets/services/week_service.dart';

/// 周数显示组件 - MD3紧凑版
class WeekDisplayWidget extends StatefulWidget {

  const WeekDisplayWidget({
    super.key,
    this.isCompact = false,
  });
  final bool isCompact;

  @override
  State<WeekDisplayWidget> createState() => _WeekDisplayWidgetState();
}

class _WeekDisplayWidgetState extends State<WeekDisplayWidget> {
  final WeekService _weekService = WeekService();
  final SettingsService _settingsService = SettingsService();
  int _weekNumber = 1;
  bool _isOddWeek = true;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadWeekInfo();
  }

  Future<void> _loadWeekInfo() async {
    try {
      final settings = await _settingsService.loadSettings();
      final semesterStartDate = settings.semesterStartDate;
      if (semesterStartDate != null) {
        final weekNumber = _weekService.calculateWeekNumber(
          semesterStartDate,
          NtpService().now,
        );
        if (mounted) {
          setState(() {
            _weekNumber = weekNumber > 0 ? weekNumber : 1;
            _isOddWeek = _weekService.isOddWeek(_weekNumber);
            _isLoading = false;
          });
        }
      } else {
        if (mounted) {
          setState(() {
            _isLoading = false;
          });
        }
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    // MD3: 使用 primaryContainer/secondaryContainer 作为强调背景
    final containerColor = _isOddWeek 
        ? colorScheme.primaryContainer 
        : colorScheme.secondaryContainer;
    final onContainerColor = _isOddWeek 
        ? colorScheme.onPrimaryContainer 
        : colorScheme.onSecondaryContainer;

    return Card(
      elevation: 0,
      color: containerColor,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.view_week_rounded,
              size: 16,
              color: onContainerColor,
            ),
            const SizedBox(width: 8),
            if (_isLoading)
              SizedBox(
                width: 14,
                height: 14,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  color: onContainerColor,
                ),
              )
            else ...[
              Text(
                '第$_weekNumber周',
                style: theme.textTheme.labelLarge?.copyWith(
                  color: onContainerColor,
                  fontWeight: FontWeight.w600,
                  fontSize: 12,
                ),
              ),
              const SizedBox(width: 6),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 6,
                  vertical: 2,
                ),
                decoration: BoxDecoration(
                  color: onContainerColor.withAlpha(38),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Text(
                  _isOddWeek ? '单周' : '双周',
                  style: theme.textTheme.labelSmall?.copyWith(
                    color: onContainerColor,
                    fontWeight: FontWeight.w600,
                    fontSize: 11,
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
