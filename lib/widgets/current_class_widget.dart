import 'package:flutter/material.dart';
import 'package:time_widgets/models/course_model.dart';
import 'package:time_widgets/utils/responsive_utils.dart';

/// 当前课程组件 - MD3紧凑版
class CurrentClassWidget extends StatelessWidget {
  final bool isCompact;
  final Course? course;
  final bool isLoading;

  const CurrentClassWidget({
    super.key,
    this.isCompact = false,
    this.course,
    this.isLoading = false,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final width = MediaQuery.sizeOf(context).width;
    final fontMultiplier = ResponsiveUtils.getFontSizeMultiplier(width);

    if (isLoading) {
      return Card(
        elevation: 0,
        color: colorScheme.surfaceContainerLow,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(
            ResponsiveUtils.getBorderRadius(width, baseRadius: 16),
          ),
        ),
        child: const Center(child: CircularProgressIndicator()),
      );
    }

    if (course == null) {
      return Card(
        elevation: 0,
        color: colorScheme.surfaceContainerLow,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(
            ResponsiveUtils.getBorderRadius(width, baseRadius: 16),
          ),
        ),
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.free_breakfast_outlined,
                color: colorScheme.secondary,
                size: ResponsiveUtils.getIconSize(width, baseSize: 32),
              ),
              SizedBox(height: ResponsiveUtils.value(8)),
              Text(
                '当前无课',
                style: theme.textTheme.titleMedium?.copyWith(
                  color: colorScheme.secondary,
                  fontSize: (theme.textTheme.titleMedium?.fontSize ?? 16) * fontMultiplier,
                ),
              ),
            ],
          ),
        ),
      );
    }

    return Card(
      elevation: 0,
      color: colorScheme.surfaceContainerLow,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(
          ResponsiveUtils.getBorderRadius(width, baseRadius: 16),
        ),
      ),
      child: Padding(
        padding: EdgeInsets.all(ResponsiveUtils.value(16)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            // 头部
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  Icons.school_rounded,
                  size: ResponsiveUtils.getIconSize(width, baseSize: 20),
                  color: colorScheme.primary,
                ),
                SizedBox(width: ResponsiveUtils.value(12)),
                Text(
                  '当前课程',
                  style: theme.textTheme.titleSmall?.copyWith(
                    color: colorScheme.onSurfaceVariant,
                    fontSize: (theme.textTheme.titleSmall?.fontSize ?? 14) * fontMultiplier,
                  ),
                ),
                SizedBox(width: ResponsiveUtils.value(16)),
                Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: ResponsiveUtils.value(10),
                    vertical: ResponsiveUtils.value(4),
                  ),
                  decoration: BoxDecoration(
                    color: colorScheme.tertiaryContainer,
                    borderRadius: BorderRadius.circular(ResponsiveUtils.value(12)),
                  ),
                  child: Text(
                    '进行中',
                    style: theme.textTheme.labelMedium?.copyWith(
                      color: colorScheme.onTertiaryContainer,
                      fontWeight: FontWeight.w600,
                      fontSize: (theme.textTheme.labelMedium?.fontSize ?? 12) * fontMultiplier,
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: ResponsiveUtils.value(12)),
            // 课程信息
            Row(
              children: [
                // 课程图标
                Container(
                  width: ResponsiveUtils.value(44),
                  height: ResponsiveUtils.value(44),
                  decoration: BoxDecoration(
                    color: colorScheme.primaryContainer,
                    borderRadius: BorderRadius.circular(ResponsiveUtils.value(12)),
                  ),
                  child: Icon(
                    Icons.menu_book_rounded,
                    size: ResponsiveUtils.getIconSize(width, baseSize: 22),
                    color: colorScheme.onPrimaryContainer,
                  ),
                ),
                SizedBox(width: ResponsiveUtils.value(12)),
                // 课程详情
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '${course!.subject} · ${course!.teacher}',
                        style: theme.textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.w600,
                          color: colorScheme.onSurface,
                          fontSize: (theme.textTheme.titleMedium?.fontSize ?? 16) * fontMultiplier,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      SizedBox(height: ResponsiveUtils.value(2)),
                      Text(
                        '${course!.time} · ${course!.classroom}',
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: colorScheme.onSurfaceVariant,
                          fontSize: (theme.textTheme.bodySmall?.fontSize ?? 12) * fontMultiplier,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
