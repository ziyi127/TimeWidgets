import 'package:flutter/material.dart';
import 'package:time_widgets/services/week_service.dart';
import 'package:time_widgets/services/settings_service.dart';
import 'package:time_widgets/services/ntp_service.dart';
import 'package:time_widgets/utils/responsive_utils.dart';

/// 周次显示组件 - MD3紧凑版
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
      if (settings.semesterStartDate != null) {
        final weekNumber = _weekService.calculateWeekNumber(
          settings.semesterStartDate!,
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
    final width = MediaQuery.sizeOf(context).width;
    final fontMultiplier = ResponsiveUtils.getFontSizeMultiplier(width);

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
        borderRadius: BorderRadius.circular(
          ResponsiveUtils.getBorderRadius(width, baseRadius: 16),
        ),
      ),
      child: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: ResponsiveUtils.value(16),
          vertical: ResponsiveUtils.value(10),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.view_week_rounded,
              size: ResponsiveUtils.getIconSize(width, baseSize: 20),
              color: onContainerColor,
            ),
            SizedBox(width: ResponsiveUtils.value(12)),
            if (_isLoading)
              SizedBox(
                width: ResponsiveUtils.value(16),
                height: ResponsiveUtils.value(16),
                child: CircularProgressIndicator(
                  strokeWidth: ResponsiveUtils.value(2),
                  color: onContainerColor,
                ),
              )
            else ...[
              Text(
                '第$_weekNumber周',
                style: theme.textTheme.titleSmall?.copyWith(
                  color: onContainerColor,
                  fontWeight: FontWeight.w600,
                  fontSize: (theme.textTheme.titleSmall?.fontSize ?? 14) * fontMultiplier,
                ),
              ),
              SizedBox(width: ResponsiveUtils.value(8)),
              Container(
                padding: EdgeInsets.symmetric(
                  horizontal: ResponsiveUtils.value(8),
                  vertical: ResponsiveUtils.value(4),
                ),
                decoration: BoxDecoration(
                  color: onContainerColor.withAlpha(38),
                  borderRadius: BorderRadius.circular(ResponsiveUtils.value(8)),
                ),
                child: Text(
                  _isOddWeek ? '单周' : '双周',
                  style: theme.textTheme.labelMedium?.copyWith(
                    color: onContainerColor,
                    fontWeight: FontWeight.w600,
                    fontSize: (theme.textTheme.labelMedium?.fontSize ?? 12) * fontMultiplier,
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
