import 'package:flutter/material.dart';
import 'package:time_widgets/l10n/app_localizations.dart';
import 'package:time_widgets/models/countdown_model.dart';
import 'package:time_widgets/screens/countdown_list_screen.dart';
import 'package:time_widgets/utils/responsive_utils.dart';

/// 倒计时组件- MD3紧凑版
class CountdownWidget extends StatelessWidget {
  const CountdownWidget({
    super.key,
    this.countdownData,
    this.allCountdowns,
    this.error,
    this.onRetry,
    this.onViewAll,
    this.isCompact = false,
  });
  final CountdownData? countdownData;
  final List<CountdownData>? allCountdowns;
  final String? error;
  final VoidCallback? onRetry;
  final VoidCallback? onViewAll;
  final bool isCompact;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final width = MediaQuery.sizeOf(context).width;
    final fontMultiplier = ResponsiveUtils.getFontSizeMultiplier(width);

    if (error != null) {
      return _buildErrorCard(context, colorScheme, width);
    }

    if (countdownData == null) {
      return _buildEmptyCard(context, theme, colorScheme, width);
    }

    final countdown = countdownData!;
    final description = countdown.title;
    final remainingDays = countdown.remainingDays;
    final eventType = countdown.type;
    final typeColor = _getEventTypeColor(colorScheme, eventType);

    return RepaintBoundary(
      child: Card(
        elevation: 0,
        color: colorScheme.surfaceContainerLow,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(
          ResponsiveUtils.getBorderRadius(width),
        ),
      ),
      child: InkWell(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute<void>(
              builder: (context) => const CountdownListScreen(),
            ),
          );
        },
        borderRadius: BorderRadius.circular(
          ResponsiveUtils.getBorderRadius(width),
        ),
        child: Padding(
          padding: EdgeInsets.all(ResponsiveUtils.value(16)),
          child: Row(
            children: [
              // 左侧图标
              Container(
                width: ResponsiveUtils.value(44),
                height: ResponsiveUtils.value(44),
                decoration: BoxDecoration(
                  color: typeColor.withAlpha(38),
                  borderRadius:
                      BorderRadius.circular(ResponsiveUtils.value(12)),
                ),
                child: Icon(
                  _getEventTypeIcon(eventType),
                  size: ResponsiveUtils.getIconSize(width, baseSize: 22),
                  color: typeColor,
                ),
              ),
              SizedBox(width: ResponsiveUtils.value(12)),
              // 中间信息
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        // 限制文本宽度，避免溢出
                        Flexible(
                          child: Text(
                            AppLocalizations.of(context)!.countdownTitle,
                            style: theme.textTheme.titleSmall?.copyWith(
                              color: colorScheme.onSurfaceVariant,
                              fontSize:
                                  (theme.textTheme.titleSmall?.fontSize ?? 14) *
                                      fontMultiplier,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        SizedBox(width: ResponsiveUtils.value(8)),
                        Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: ResponsiveUtils.value(6),
                            vertical: ResponsiveUtils.value(2),
                          ),
                          decoration: BoxDecoration(
                            color: typeColor.withAlpha(38),
                            borderRadius:
                                BorderRadius.circular(ResponsiveUtils.value(6)),
                          ),
                          child: Text(
                            _getEventTypeLabel(context, eventType),
                            style: theme.textTheme.labelSmall?.copyWith(
                              color: typeColor,
                              fontWeight: FontWeight.w600,
                              fontSize:
                                  (theme.textTheme.labelSmall?.fontSize ?? 11) *
                                      fontMultiplier,
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: ResponsiveUtils.value(4)),
                    Text(
                      description,
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                        color: colorScheme.onSurface,
                        fontSize:
                            (theme.textTheme.titleMedium?.fontSize ?? 16) *
                                fontMultiplier,
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
                      height: 1,
                      fontSize:
                          (theme.textTheme.headlineMedium?.fontSize ?? 28) *
                              fontMultiplier,
                    ),
                  ),
                  Text(
                    AppLocalizations.of(context)!.days,
                    style: theme.textTheme.labelMedium?.copyWith(
                      color: colorScheme.onSurfaceVariant,
                      fontSize: (theme.textTheme.labelMedium?.fontSize ?? 12) *
                          fontMultiplier,
                    ),
                  ),
                ],
              ),
              SizedBox(width: ResponsiveUtils.value(4)),
              Icon(
                Icons.chevron_right_rounded,
                color: colorScheme.onSurfaceVariant,
                size: ResponsiveUtils.getIconSize(width),
              ),
            ],
          ),
        ),
      ),
      ),
    );
  }

  Widget _buildEmptyCard(
    BuildContext context,
    ThemeData theme,
    ColorScheme colorScheme,
    double width,
  ) {
    return RepaintBoundary(
      child: Card(
        elevation: 0,
        color: colorScheme.surfaceContainerLow,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(
          ResponsiveUtils.getBorderRadius(width),
        ),
      ),
      child: InkWell(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute<void>(
              builder: (context) => const CountdownListScreen(),
            ),
          );
        },
        borderRadius: BorderRadius.circular(
          ResponsiveUtils.getBorderRadius(width),
        ),
        child: Padding(
          padding: EdgeInsets.all(ResponsiveUtils.value(16)),
          child: Row(
            children: [
              Container(
                width: ResponsiveUtils.value(44),
                height: ResponsiveUtils.value(44),
                decoration: BoxDecoration(
                  color: colorScheme.primaryContainer.withAlpha(38),
                  borderRadius:
                      BorderRadius.circular(ResponsiveUtils.value(12)),
                ),
                child: Icon(
                  Icons.add_alarm,
                  size: ResponsiveUtils.getIconSize(width, baseSize: 22),
                  color: colorScheme.primary,
                ),
              ),
              SizedBox(width: ResponsiveUtils.value(12)),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      AppLocalizations.of(context)!.countdownEmpty,
                      style: theme.textTheme.titleSmall?.copyWith(
                        color: colorScheme.onSurfaceVariant,
                      ),
                    ),
                    Text(
                      AppLocalizations.of(context)!.countdownAddHint,
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: colorScheme.outline,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    ));
  }

  Widget _buildErrorCard(
    BuildContext context,
    ColorScheme colorScheme,
    double width,
  ) {
    final fontMultiplier = ResponsiveUtils.getFontSizeMultiplier(width);

    return RepaintBoundary(
      child: Card(
        elevation: 0,
        color: colorScheme.errorContainer,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(
          ResponsiveUtils.getBorderRadius(width),
        ),
      ),
      child: Padding(
        padding: EdgeInsets.all(ResponsiveUtils.value(16)),
        child: Row(
          children: [
            Icon(
              Icons.event_busy_rounded,
              color: colorScheme.onErrorContainer,
              size: ResponsiveUtils.getIconSize(width, baseSize: 20),
            ),
            SizedBox(width: ResponsiveUtils.value(12)),
            Expanded(
              child: Text(
                AppLocalizations.of(context)!.countdownLoadFailed,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: colorScheme.onErrorContainer,
                      fontSize:
                          (Theme.of(context).textTheme.bodyMedium?.fontSize ??
                                  14) *
                              fontMultiplier,
                    ),
              ),
            ),
            if (onRetry != null)
              TextButton(
                onPressed: onRetry,
                child: Text(
                  AppLocalizations.of(context)!.retry,
                  style: TextStyle(
                    color: colorScheme.onErrorContainer,
                    fontSize: 14.0 * fontMultiplier,
                  ),
                ),
              ),
          ],
        ),
      ),
    ));
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

  String _getEventTypeLabel(BuildContext context, String eventType) {
    switch (eventType.toLowerCase()) {
      case 'exam':
        return AppLocalizations.of(context)!.eventExam;
      case 'assignment':
        return AppLocalizations.of(context)!.eventAssignment;
      case 'project':
        return AppLocalizations.of(context)!.eventProject;
      case 'holiday':
        return AppLocalizations.of(context)!.eventHoliday;
      default:
        return AppLocalizations.of(context)!.eventDefault;
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
