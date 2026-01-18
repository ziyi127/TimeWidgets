import 'package:flutter/material.dart';
import 'package:time_widgets/models/course_model.dart';
import 'package:time_widgets/screens/timetable_edit_screen.dart';
import 'package:time_widgets/services/ntp_service.dart';
import 'package:time_widgets/services/timetable_service.dart';
import 'package:time_widgets/utils/color_utils.dart';
import 'package:time_widgets/utils/responsive_utils.dart';

enum TimetableViewMode { day, week }

/// 课程表组件- MD3紧凑版，支持日/周视图切换
class TimetableWidget extends StatefulWidget {
  const TimetableWidget({
    super.key,
    this.courses,
    this.isCompact = false,
  });

  final List<Course>? courses;
  final bool isCompact;

  @override
  State<TimetableWidget> createState() => _TimetableWidgetState();
}

class _TimetableWidgetState extends State<TimetableWidget> {
  TimetableViewMode _viewMode = TimetableViewMode.day;
  final TimetableService _timetableService = TimetableService();

  // Cache for week view data
  Map<int, List<Course>> _weekCourses = {};
  bool _isLoadingWeek = false;
  DateTime _selectedDate = DateTime.now();

  @override
  void initState() {
    super.initState();
    // Initialize with current date
    _selectedDate = DateTime.now();
  }

  Future<void> _loadWeekData() async {
    if (_weekCourses.isNotEmpty) {
      return;
    }

    setState(() {
      _isLoadingWeek = true;
    });

    try {
      final now = _selectedDate;
      // Find Monday of the current week
      final monday = now.subtract(Duration(days: now.weekday - 1));

      final futures = List.generate(7, (i) {
        final date = monday.add(Duration(days: i));
        return _timetableService.getTimetable(date).then((timetable) {
          return MapEntry(i, timetable.courses);
        });
      });

      final results = await Future.wait(futures);
      final Map<int, List<Course>> newWeekCourses = Map.fromEntries(results);

      if (mounted) {
        setState(() {
          _weekCourses = newWeekCourses;
          _isLoadingWeek = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _isLoadingWeek = false;
        });
      }
      debugPrint('Error loading week data: $e');
    }
  }

  void _toggleViewMode() {
    setState(() {
      if (_viewMode == TimetableViewMode.day) {
        _viewMode = TimetableViewMode.week;
        _loadWeekData();
      } else {
        _viewMode = TimetableViewMode.day;
      }
    });
  }

  void _navigateToAddCourse() {
    Navigator.of(context)
        .push(
      MaterialPageRoute<void>(
        builder: (context) => const TimetableEditScreen(),
      ),
    )
        .then((_) {
      // Refresh data when returning
      setState(() {
        _weekCourses.clear();
      });
      if (_viewMode == TimetableViewMode.week) {
        _loadWeekData();
      }
      // Note: Day view usually updates via parent rebuild,
      // but if we managed day data internally we'd update it here too.
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final width = MediaQuery.sizeOf(context).width;

    // Use widget.courses for day view if provided, otherwise we might need to fetch it
    // For now assuming parent provides day courses or we show empty
    final dayCourses = widget.courses ?? [];

    return Card(
      elevation: 0,
      color: colorScheme.surfaceContainerLow,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(
          ResponsiveUtils.getBorderRadius(width),
        ),
      ),
      child: Padding(
        padding: EdgeInsets.all(ResponsiveUtils.value(16)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            // Header
            _buildHeader(context, theme, colorScheme, width),

            SizedBox(height: ResponsiveUtils.value(12)),

            // Content Area with Animation
            AnimatedSize(
              duration: const Duration(milliseconds: 300),
              curve: Curves.easeInOut,
              alignment: Alignment.topCenter,
              child: AnimatedSwitcher(
                duration: const Duration(milliseconds: 300),
                child: _viewMode == TimetableViewMode.day
                    ? _buildDayView(context, dayCourses, theme, width)
                    : _buildWeekView(context, theme, width),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context, ThemeData theme,
      ColorScheme colorScheme, double width,) {
    final fontMultiplier = ResponsiveUtils.getFontSizeMultiplier(width);

    return Row(
      children: [
        Icon(
          Icons.calendar_month_rounded,
          size: ResponsiveUtils.getIconSize(width, baseSize: 20),
          color: colorScheme.primary,
        ),
        SizedBox(width: ResponsiveUtils.value(12)),
        Text(
          _viewMode == TimetableViewMode.day ? '今日课程' : '本周课表',
          style: theme.textTheme.titleSmall?.copyWith(
            color: colorScheme.onSurfaceVariant,
            fontSize:
                (theme.textTheme.titleSmall?.fontSize ?? 14) * fontMultiplier,
            fontWeight: FontWeight.bold,
          ),
        ),
        const Spacer(),

        // View Toggle Button
        IconButton(
          onPressed: _toggleViewMode,
          icon: Icon(
            _viewMode == TimetableViewMode.day
                ? Icons.view_week_outlined
                : Icons.view_day_outlined,
            size: 20,
            color: colorScheme.primary,
          ),
          tooltip: _viewMode == TimetableViewMode.day ? '切换至周视图' : '切换至日视图',
          style: IconButton.styleFrom(
            backgroundColor: colorScheme.surfaceContainerHigh,
            padding: const EdgeInsets.all(8),
          ),
        ),

        SizedBox(width: ResponsiveUtils.value(8)),

        // Add Course Button
        IconButton(
          onPressed: _navigateToAddCourse,
          icon: Icon(
            Icons.add_rounded,
            size: 20,
            color: colorScheme.onPrimaryContainer,
          ),
          tooltip: '添加课程',
          style: IconButton.styleFrom(
            backgroundColor: colorScheme.primaryContainer,
            padding: const EdgeInsets.all(8),
          ),
        ),
      ],
    );
  }

  Widget _buildDayView(BuildContext context, List<Course> courses,
      ThemeData theme, double width,) {
    final fontMultiplier = ResponsiveUtils.getFontSizeMultiplier(width);

    if (courses.isEmpty) {
      return Container(
        height: ResponsiveUtils.value(120),
        alignment: Alignment.center,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.weekend_outlined,
              size: 48,
              color: theme.colorScheme.outlineVariant,
            ),
            const SizedBox(height: 8),
            Text(
              '今天没有课，好好休息吧',
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
                fontSize: (theme.textTheme.bodyMedium?.fontSize ?? 14) *
                    fontMultiplier,
              ),
            ),
          ],
        ),
      );
    }

    return ConstrainedBox(
      constraints: BoxConstraints(
        maxHeight:
            ResponsiveUtils.value(300), // Allow more height for improved cards
      ),
      child: ListView.separated(
        shrinkWrap: true,
        physics: const BouncingScrollPhysics(),
        itemCount: courses.length,
        separatorBuilder: (context, index) =>
            SizedBox(height: ResponsiveUtils.value(8)),
        itemBuilder: (context, index) {
          final course = courses[index];
          return _buildCourseCard(context, course, width);
        },
      ),
    );
  }

  Widget _buildCourseCard(BuildContext context, Course course, double width) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final fontMultiplier = ResponsiveUtils.getFontSizeMultiplier(width);

    // Use hash color for subject
    final subjectColor = ColorUtils.generateColorFromName(course.subject);
    final isCurrent = course.isCurrent;

    // Calculate status logic
    // This logic was previously inline, simplifying here
    bool isCompleted = false;
    final parts = course.time.split('~');
    if (parts.length == 2) {
      final endParts = parts[1].split(':');
      if (endParts.length == 2) {
        final now = NtpService().now;
        final endHour = int.tryParse(endParts[0]) ?? 0;
        final endMinute = int.tryParse(endParts[1]) ?? 0;
        final endTime =
            DateTime(now.year, now.month, now.day, endHour, endMinute);
        if (now.isAfter(endTime)) isCompleted = true;
      }
    }

    return Card(
      elevation: isCurrent ? 2 : 0,
      margin: EdgeInsets.zero,
      color:
          isCurrent ? colorScheme.surfaceContainerHighest : colorScheme.surface,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: isCurrent
            ? BorderSide(color: subjectColor, width: 1.5)
            : BorderSide.none,
      ),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: _navigateToAddCourse,
        child: IntrinsicHeight(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Color Indicator Strip
              Container(
                width: 6,
                color: isCompleted ? colorScheme.outlineVariant : subjectColor,
              ),

              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(12),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              course.subject,
                              style: theme.textTheme.titleMedium?.copyWith(
                                fontWeight: FontWeight.bold,
                                color: isCompleted
                                    ? colorScheme.onSurface
                                        .withValues(alpha: 0.6)
                                    : colorScheme.onSurface,
                                fontSize: 16 * fontMultiplier,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          if (isCurrent)
                            Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 8, vertical: 2,),
                              decoration: BoxDecoration(
                                color: subjectColor.withValues(alpha: 0.1),
                                borderRadius: BorderRadius.circular(4),
                              ),
                              child: Text(
                                '进行中',
                                style: TextStyle(
                                  color: subjectColor,
                                  fontSize: 10 * fontMultiplier,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          Icon(Icons.location_on_outlined,
                              size: 14, color: colorScheme.outline,),
                          const SizedBox(width: 4),
                          Expanded(
                            child: Text(
                              course.classroom,
                              style: theme.textTheme.bodySmall?.copyWith(
                                color: colorScheme.onSurfaceVariant,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          Icon(Icons.access_time,
                              size: 14, color: colorScheme.outline,),
                          const SizedBox(width: 4),
                          Text(
                            course.time,
                            style: theme.textTheme.labelSmall?.copyWith(
                              color: colorScheme.onSurfaceVariant,
                              fontFeatures: [
                                const FontFeature.tabularFigures(),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildWeekView(BuildContext context, ThemeData theme, double width) {
    if (_isLoadingWeek) {
      return const SizedBox(
        height: 200,
        child: Center(child: CircularProgressIndicator()),
      );
    }

    // Days of week labels
    final days = ['一', '二', '三', '四', '五', '六', '日'];
    final todayWeekday = DateTime.now().weekday - 1; // 0-6

    return Column(
      children: [
        // Week Header
        Row(
          children: List.generate(7, (index) {
            final isToday = index == todayWeekday;
            return Expanded(
              child: Container(
                alignment: Alignment.center,
                padding: const EdgeInsets.symmetric(vertical: 8),
                decoration: isToday
                    ? BoxDecoration(
                        color: theme.colorScheme.primaryContainer,
                        borderRadius: BorderRadius.circular(8),
                      )
                    : null,
                child: Text(
                  days[index],
                  style: theme.textTheme.labelMedium?.copyWith(
                    color: isToday
                        ? theme.colorScheme.onPrimaryContainer
                        : theme.colorScheme.onSurfaceVariant,
                    fontWeight: isToday ? FontWeight.bold : FontWeight.normal,
                  ),
                ),
              ),
            );
          }),
        ),
        const SizedBox(height: 8),

        // Week Grid
        // Finding the max number of courses in any day to determine height
        // Or just using a fixed height scrollable view
        Container(
          height: 300, // Fixed height for week view
          decoration: BoxDecoration(
            color: theme.colorScheme.surface,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
                color: theme.colorScheme.outlineVariant.withValues(alpha: 0.5),),
          ),
          child: SingleChildScrollView(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: List.generate(7, (dayIndex) {
                final courses = _weekCourses[dayIndex] ?? [];

                return Expanded(
                  child: Container(
                    decoration: BoxDecoration(
                      border: dayIndex < 6
                          ? Border(
                              right: BorderSide(
                                  color: theme.colorScheme.outlineVariant
                                      .withValues(alpha: 0.3),),
                            )
                          : null,
                    ),
                    padding: const EdgeInsets.all(2),
                    child: Column(
                      children: [
                        if (courses.isEmpty)
                          Padding(
                            padding: const EdgeInsets.only(top: 20),
                            child: Text(
                              '-',
                              style: TextStyle(
                                  color: theme.colorScheme.outlineVariant,),
                            ),
                          )
                        else
                          ...courses.map((course) {
                            final color = ColorUtils.generateColorFromName(
                                course.subject,);
                            return Tooltip(
                              message:
                                  '${course.subject}\n${course.time}\n${course.classroom}',
                              child: Container(
                                margin: const EdgeInsets.only(bottom: 4),
                                padding: const EdgeInsets.symmetric(
                                    vertical: 6, horizontal: 2,),
                                decoration: BoxDecoration(
                                  color: color.withValues(alpha: 0.15),
                                  borderRadius: BorderRadius.circular(6),
                                  border: Border.all(
                                      color: color.withValues(alpha: 0.3),
                                      width: 0.5,),
                                ),
                                child: Column(
                                  children: [
                                    Text(
                                      course.subject.substring(
                                          0,
                                          course.subject.length > 2
                                              ? 2
                                              : course.subject.length,),
                                      style: TextStyle(
                                        fontSize: 10,
                                        color: theme.colorScheme.onSurface,
                                        fontWeight: FontWeight.w500,
                                      ),
                                      textAlign: TextAlign.center,
                                      maxLines: 1,
                                    ),
                                    const SizedBox(height: 2),
                                    Container(
                                      width: 4,
                                      height: 4,
                                      decoration: BoxDecoration(
                                        color: color,
                                        shape: BoxShape.circle,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          }),
                      ],
                    ),
                  ),
                );
              }),
            ),
          ),
        ),
      ],
    );
  }
}
