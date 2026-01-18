import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:time_widgets/models/course_model.dart';
import 'package:time_widgets/screens/timetable_edit_screen.dart';
import 'package:time_widgets/services/ntp_service.dart';
import 'package:time_widgets/services/timetable_service.dart';
import 'package:time_widgets/utils/color_utils.dart';
import 'package:time_widgets/utils/responsive_utils.dart';

enum TimetableViewMode { day, week }

/// 课程表组件 - 优化版
/// 
/// UX 优化点：
/// 1. 信息架构：增强了当前课程与非当前课程的视觉区分，周视图信息更紧凑清晰。
/// 2. 交互体验：新增左右滑动切换日期/周次，周视图支持点击查看详情。
/// 3. 视觉层次：优化了卡片阴影、颜色和排版，增加动效反馈。
/// 4. 情感化：空状态文案与插图优化。
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

  // Data State
  DateTime _selectedDate = DateTime.now();
  List<Course> _dayCourses = [];
  Map<int, List<Course>> _weekCourses = {};
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _selectedDate = DateTime.now();
    _loadData();
  }

  @override
  void didUpdateWidget(TimetableWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    // 如果外部传入的课程列表发生变化（通常是父组件刷新），我们应该更新显示
    // 但如果外部传入 null，我们需要自己加载
    if (widget.courses != oldWidget.courses) {
      if (widget.courses == null) {
        _loadData();
      } else {
        // 如果有外部数据，且当前是日视图，直接使用外部数据（不需要 setState，build 会直接用）
        // 但如果切换了日期，我们还是需要自己加载，除非父组件也根据日期更新了 widget.courses
        // 这里假设 widget.courses 仅对应 "今天" 或父组件控制的日期。
        // 为了支持内部日期切换，我们优先使用内部加载的数据 _dayCourses，
        // 除非 _selectedDate 是今天且 widget.courses 不为空。
      }
    }
  }

  Future<void> _loadData() async {
    setState(() => _isLoading = true);

    try {
      if (_viewMode == TimetableViewMode.day) {
        // 日视图加载
        final timetable = await _timetableService.getTimetable(_selectedDate);
        if (mounted) {
          setState(() {
            _dayCourses = timetable.courses;
          });
        }
      } else {
        // 周视图加载
        final now = _selectedDate;
        // 计算周一
        final monday = now.subtract(Duration(days: now.weekday - 1));

        final futures = List.generate(7, (i) {
          final date = monday.add(Duration(days: i));
          return _timetableService.getTimetable(date).then((t) => MapEntry(i, t.courses));
        });

        final results = await Future.wait(futures);
        if (mounted) {
          setState(() {
            _weekCourses = Map.fromEntries(results);
          });
        }
      }
    } catch (e) {
      debugPrint('Error loading timetable: $e');
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  void _onDateChanged(int offset) {
    setState(() {
      if (_viewMode == TimetableViewMode.day) {
        _selectedDate = _selectedDate.add(Duration(days: offset));
      } else {
        _selectedDate = _selectedDate.add(Duration(days: offset * 7));
      }
    });
    _loadData();
  }

  void _resetToToday() {
    setState(() {
      _selectedDate = DateTime.now();
    });
    _loadData();
  }

  void _toggleViewMode() {
    setState(() {
      _viewMode = _viewMode == TimetableViewMode.day
          ? TimetableViewMode.week
          : TimetableViewMode.day;
    });
    _loadData();
  }

  void _navigateToAddCourse() {
    Navigator.of(context)
        .push(
      MaterialPageRoute<void>(
        builder: (context) => const TimetableEditScreen(),
      ),
    )
        .then((_) {
      _loadData();
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final width = MediaQuery.sizeOf(context).width;

    return Card(
      elevation: 0,
      color: colorScheme.surfaceContainerLow,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(ResponsiveUtils.getBorderRadius(width)),
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

            // Content Area with Gesture Support
            GestureDetector(
              onHorizontalDragEnd: (details) {
                if (details.primaryVelocity! > 0) {
                  // Swipe Right -> Previous
                  _onDateChanged(-1);
                } else if (details.primaryVelocity! < 0) {
                  // Swipe Left -> Next
                  _onDateChanged(1);
                }
              },
              child: AnimatedSize(
                duration: const Duration(milliseconds: 300),
                curve: Curves.easeInOut,
                alignment: Alignment.topCenter,
                child: AnimatedSwitcher(
                  duration: const Duration(milliseconds: 300),
                  child: _viewMode == TimetableViewMode.day
                      ? _buildDayView(context, theme, width)
                      : _buildWeekView(context, theme, width),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context, ThemeData theme, ColorScheme colorScheme, double width) {
    final fontMultiplier = ResponsiveUtils.getFontSizeMultiplier(width);
    final now = NtpService().now;
    final isToday = _selectedDate.year == now.year &&
        _selectedDate.month == now.month &&
        _selectedDate.day == now.day;
    
    final displayDate = DateFormat('MM月dd日', 'zh_CN').format(_selectedDate);
    final weekBegin = _selectedDate.subtract(Duration(days: _selectedDate.weekday - 1));
    final weekEnd = weekBegin.add(const Duration(days: 6));
    final displayWeek = '${DateFormat('MM/dd').format(weekBegin)} - ${DateFormat('MM/dd').format(weekEnd)}';

    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: colorScheme.primaryContainer,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(
            Icons.calendar_month_rounded,
            size: ResponsiveUtils.getIconSize(width),
            color: colorScheme.onPrimaryContainer,
          ),
        ),
        SizedBox(width: ResponsiveUtils.value(16)),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Text(
                    _viewMode == TimetableViewMode.day ? '今日课程' : '本周课表',
                    style: theme.textTheme.titleLarge?.copyWith(
                      color: colorScheme.onSurface,
                      fontSize: (theme.textTheme.titleLarge?.fontSize ?? 22) * fontMultiplier,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  if (!isToday) ...[
                     const SizedBox(width: 8),
                     InkWell(
                       onTap: _resetToToday,
                       borderRadius: BorderRadius.circular(4),
                       child: Padding(
                         padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
                         child: Text(
                           '回今天',
                           style: TextStyle(
                             color: colorScheme.primary,
                             fontSize: 12 * fontMultiplier,
                             fontWeight: FontWeight.bold,
                           ),
                         ),
                       ),
                     ),
                  ],
                ],
              ),
              Row(
                children: [
                  IconButton(
                    icon: Icon(Icons.chevron_left_rounded, size: 18 * fontMultiplier),
                    onPressed: () => _onDateChanged(-1),
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints(),
                    style: IconButton.styleFrom(tapTargetSize: MaterialTapTargetSize.shrinkWrap),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 4),
                    child: Text(
                      _viewMode == TimetableViewMode.day ? displayDate : displayWeek,
                      style: theme.textTheme.labelMedium?.copyWith(
                        color: colorScheme.onSurfaceVariant,
                        fontSize: 14 * fontMultiplier,
                      ),
                    ),
                  ),
                  IconButton(
                    icon: Icon(Icons.chevron_right_rounded, size: 18 * fontMultiplier),
                    onPressed: () => _onDateChanged(1),
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints(),
                    style: IconButton.styleFrom(tapTargetSize: MaterialTapTargetSize.shrinkWrap),
                  ),
                ],
              ),
            ],
          ),
        ),
        
        // Actions
        IconButton.filledTonal(
          onPressed: _toggleViewMode,
          icon: Icon(
            _viewMode == TimetableViewMode.day ? Icons.view_week_rounded : Icons.view_day_rounded,
            size: 24,
          ),
          tooltip: _viewMode == TimetableViewMode.day ? '切换至周视图' : '切换至日视图',
        ),
        SizedBox(width: ResponsiveUtils.value(12)),
        // IconButton.filled(
        //   onPressed: _navigateToAddCourse,
        //   icon: const Icon(Icons.add_rounded, size: 24),
        //   tooltip: '添加课程',
        // ),
      ],
    );
  }

  Widget _buildDayView(BuildContext context, ThemeData theme, double width) {
    // 优先使用 widget.courses (如果它是今天的)，否则使用内部加载的 _dayCourses
    // 简单起见，如果 widget.courses 存在且 selectedDate 是今天，混合使用？
    // 更好的逻辑：
    // 如果 widget.courses 不为空且 selectedDate == today，使用 widget.courses
    // 否则使用 _dayCourses
    
    final now = NtpService().now;
    final isToday = _selectedDate.year == now.year &&
        _selectedDate.month == now.month &&
        _selectedDate.day == now.day;
    
    final courses = (isToday && widget.courses != null && widget.courses!.isNotEmpty)
        ? widget.courses!
        : _dayCourses;

    final fontMultiplier = ResponsiveUtils.getFontSizeMultiplier(width);

    if (_isLoading) {
      return Container(
        height: ResponsiveUtils.value(200),
        alignment: Alignment.center,
        child: const CircularProgressIndicator(),
      );
    }

    if (courses.isEmpty) {
      return Container(
        height: ResponsiveUtils.value(200),
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: theme.colorScheme.surfaceContainer,
          borderRadius: BorderRadius.circular(24),
          border: Border.all(color: theme.colorScheme.outlineVariant.withValues(alpha: 0.5)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.weekend_rounded,
              size: 64,
              color: theme.colorScheme.primary.withValues(alpha: 0.5),
            ),
            const SizedBox(height: 16),
            Text(
              '没有安排课程',
              style: theme.textTheme.titleMedium?.copyWith(
                color: theme.colorScheme.onSurface,
                fontWeight: FontWeight.bold,
                fontSize: (theme.textTheme.titleMedium?.fontSize ?? 16) * fontMultiplier,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              '享受自由时光吧',
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
                fontSize: 14 * fontMultiplier,
              ),
            ),
          ],
        ),
      );
    }

    // Identify next course
    int nextCourseIndex = -1;
    final hasCurrent = courses.any((c) => c.isCurrent);
    if (!hasCurrent && isToday) { // 只有今天是今天才计算 Next
       for(int i=0; i<courses.length; i++) {
         final parts = courses[i].time.split('~');
         if(parts.length == 2) {
            final endParts = parts[1].split(':');
            if(endParts.length == 2) {
               final endHour = int.tryParse(endParts[0]) ?? 0;
               final endMinute = int.tryParse(endParts[1]) ?? 0;
               final endTime = DateTime(now.year, now.month, now.day, endHour, endMinute);
               if(endTime.isAfter(now)) {
                 nextCourseIndex = i;
                 break;
               }
            }
         }
       }
    }

    return ListView.separated(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: courses.length,
      padding: const EdgeInsets.symmetric(vertical: 4),
      separatorBuilder: (context, index) => SizedBox(height: ResponsiveUtils.value(12)),
      itemBuilder: (context, index) {
        final course = courses[index];
        final isNext = index == nextCourseIndex;
        return _buildCourseCard(context, course, width, isNext: isNext);
      },
    );
  }

  Widget _buildCourseCard(BuildContext context, Course course, double width, {bool isNext = false}) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final fontMultiplier = ResponsiveUtils.getFontSizeMultiplier(width);

    final subjectColor = ColorUtils.generateColorFromName(course.subject);
    final isCurrent = course.isCurrent;

    // Calculate progress
    bool isCompleted = false;
    double progress = 0;
    
    // ... (Keep existing progress logic or simplify)
    // Reusing logic from before for consistency
    final parts = course.time.split('~');
    if (parts.length == 2) {
      final startParts = parts[0].split(':');
      final endParts = parts[1].split(':');
      if (startParts.length == 2 && endParts.length == 2) {
        final now = NtpService().now;
        final startHour = int.tryParse(startParts[0]) ?? 0;
        final startMinute = int.tryParse(startParts[1]) ?? 0;
        final startTime = DateTime(now.year, now.month, now.day, startHour, startMinute);
        final endHour = int.tryParse(endParts[0]) ?? 0;
        final endMinute = int.tryParse(endParts[1]) ?? 0;
        final endTime = DateTime(now.year, now.month, now.day, endHour, endMinute);
        
        if (now.isAfter(endTime)) {
          isCompleted = true;
          progress = 1.0;
        } else if (now.isAfter(startTime)) {
          final total = endTime.difference(startTime).inMinutes;
          final current = now.difference(startTime).inMinutes;
          progress = total > 0 ? current / total : 0.0;
        }
      }
    }

    final cardColor = isCurrent 
        ? colorScheme.primaryContainer 
        : isNext 
            ? colorScheme.surfaceContainerHigh 
            : colorScheme.surfaceContainer;

    final onCardColor = isCurrent 
        ? colorScheme.onPrimaryContainer 
        : colorScheme.onSurface;

    return Card(
      elevation: isCurrent ? 4 : (isNext ? 2 : 0),
      margin: EdgeInsets.zero,
      color: cardColor,
      shadowColor: isCurrent ? subjectColor.withValues(alpha: 0.4) : null,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: isCurrent
            ? BorderSide(color: subjectColor, width: 2)
            : BorderSide.none,
      ),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: _navigateToAddCourse,
        child: Stack(
          children: [
            if (isCurrent)
              Positioned(
                right: -20,
                top: -20,
                child: Icon(
                  Icons.school_rounded,
                  size: 120,
                  color: subjectColor.withValues(alpha: 0.1),
                ),
              ),
              
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        width: 4,
                        height: 24,
                        decoration: BoxDecoration(
                          color: isCompleted ? colorScheme.outline : subjectColor,
                          borderRadius: BorderRadius.circular(2),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          course.subject,
                          style: theme.textTheme.titleLarge?.copyWith(
                            fontWeight: FontWeight.bold,
                            color: isCompleted
                                ? onCardColor.withValues(alpha: 0.6)
                                : onCardColor,
                            fontSize: 20 * fontMultiplier,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      if (isCurrent)
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                          decoration: BoxDecoration(
                            color: subjectColor,
                            borderRadius: BorderRadius.circular(20),
                            boxShadow: [
                              BoxShadow(
                                color: subjectColor.withValues(alpha: 0.3),
                                blurRadius: 4,
                                offset: const Offset(0, 2),
                              ),
                            ],
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const Icon(Icons.play_circle_fill, size: 14, color: Colors.white),
                              const SizedBox(width: 4),
                              Text(
                                '进行中',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 12 * fontMultiplier,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      _buildInfoChip(context, Icons.location_on_rounded, course.classroom, isCurrent || isNext, width),
                      const SizedBox(width: 8),
                      _buildInfoChip(context, Icons.access_time_filled_rounded, course.time, isCurrent || isNext, width),
                      const Spacer(),
                      if (course.teacher.isNotEmpty)
                         Text(
                          course.teacher,
                          style: theme.textTheme.bodyMedium?.copyWith(
                            color: onCardColor.withValues(alpha: 0.7),
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                    ],
                  ),
                  
                  if (isCurrent) ...[
                    const SizedBox(height: 16),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(4),
                      child: LinearProgressIndicator(
                        value: progress,
                        backgroundColor: subjectColor.withValues(alpha: 0.2),
                        valueColor: AlwaysStoppedAnimation<Color>(subjectColor),
                        minHeight: 6,
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
  
  Widget _buildInfoChip(BuildContext context, IconData icon, String label, bool prominent, double width) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final fontMultiplier = ResponsiveUtils.getFontSizeMultiplier(width);
    
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: prominent 
            ? colorScheme.surface.withValues(alpha: 0.5)
            : colorScheme.surfaceContainerHighest.withValues(alpha: 0.5),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            size: 16 * fontMultiplier,
            color: prominent ? colorScheme.primary : colorScheme.onSurfaceVariant,
          ),
          const SizedBox(width: 6),
          Text(
            label,
            style: theme.textTheme.labelMedium?.copyWith(
              color: prominent ? colorScheme.onSurface : colorScheme.onSurfaceVariant,
              fontWeight: prominent ? FontWeight.bold : FontWeight.normal,
              fontSize: 13 * fontMultiplier,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildWeekView(BuildContext context, ThemeData theme, double width) {
    if (_isLoading) {
      return SizedBox(
        height: ResponsiveUtils.value(300),
        child: const Center(child: CircularProgressIndicator()),
      );
    }

    final days = ['一', '二', '三', '四', '五', '六', '日'];
    // 根据 selectedDate 计算当前周的星期几高亮
    // 注意：selectedDate 可能是任何一天，我们需要高亮 selectedDate 对应的 weekday
    // 但通常周视图高亮的是 "今天" (Real today)，而不是选中的那一天。
    // 不过，既然支持切换周，那么高亮 selectedDate 所在的列（如果 selectedDate 是今天，那就高亮今天）
    // 或者我们总是高亮 "Today" (Real time)
    final now = NtpService().now;
    final todayWeekday = now.weekday - 1; // 0-6
    // 简化的判断：如果选中的日期的周和现在的周一样。
    // 比较周一的日期
    final selectedMonday = _selectedDate.subtract(Duration(days: _selectedDate.weekday - 1));
    final currentMonday = now.subtract(Duration(days: now.weekday - 1));
    final isSameWeek = selectedMonday.year == currentMonday.year && 
                       selectedMonday.month == currentMonday.month && 
                       selectedMonday.day == currentMonday.day;

    final fontMultiplier = ResponsiveUtils.getFontSizeMultiplier(width);

    return Container(
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: theme.colorScheme.outlineVariant.withValues(alpha: 0.3)),
      ),
      padding: const EdgeInsets.all(8),
      child: Column(
        children: [
          // Week Header
          Row(
            children: List.generate(7, (index) {
              final isToday = isSameWeek && index == todayWeekday;
              return Expanded(
                child: Container(
                  alignment: Alignment.center,
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  decoration: isToday
                      ? BoxDecoration(
                          color: theme.colorScheme.primaryContainer,
                          borderRadius: BorderRadius.circular(8),
                        )
                      : null,
                  child: Text(
                    days[index],
                    style: theme.textTheme.labelLarge?.copyWith(
                      color: isToday
                          ? theme.colorScheme.onPrimaryContainer
                          : theme.colorScheme.onSurfaceVariant,
                      fontWeight: isToday ? FontWeight.bold : FontWeight.normal,
                      fontSize: 14 * fontMultiplier,
                    ),
                  ),
                ),
              );
            }),
          ),
          const SizedBox(height: 8),
          Divider(height: 1, color: theme.colorScheme.outlineVariant.withValues(alpha: 0.2)),
          const SizedBox(height: 8),

          // Week Grid
          SizedBox(
            height: ResponsiveUtils.value(350), 
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: List.generate(7, (dayIndex) {
                final courses = _weekCourses[dayIndex] ?? [];
                final isToday = isSameWeek && dayIndex == todayWeekday;

                return Expanded(
                  child: Container(
                    decoration: BoxDecoration(
                      color: isToday ? theme.colorScheme.surfaceContainerHighest.withValues(alpha: 0.3) : null,
                      borderRadius: BorderRadius.circular(8),
                      border: dayIndex < 6
                          ? Border(
                              right: BorderSide(
                                  color: theme.colorScheme.outlineVariant.withValues(alpha: 0.1),
                              ),
                            )
                          : null,
                    ),
                    padding: const EdgeInsets.symmetric(horizontal: 2, vertical: 4),
                    child: ListView.separated(
                      itemCount: courses.length,
                      separatorBuilder: (context, i) => const SizedBox(height: 4),
                      itemBuilder: (context, courseIndex) {
                        final course = courses[courseIndex];
                        final color = ColorUtils.generateColorFromName(course.subject);
                        
                        return InkWell(
                          onTap: () {
                             showDialog<void>(
                               context: context,
                               builder: (context) => AlertDialog(
                                 title: Text(course.subject),
                                 content: Column(
                                   mainAxisSize: MainAxisSize.min,
                                   crossAxisAlignment: CrossAxisAlignment.start,
                                   children: [
                                     Text('时间: ${course.time}'),
                                     Text('地点: ${course.classroom}'),
                                     Text('教师: ${course.teacher}'),
                                   ],
                                 ),
                                 actions: [
                                   TextButton(
                                     onPressed: () => Navigator.pop(context),
                                     child: const Text('关闭'),
                                   ),
                                   FilledButton(
                                      onPressed: () {
                                        Navigator.pop(context);
                                        _navigateToAddCourse();
                                      },
                                      child: const Text('编辑'),
                                   ),
                                 ],
                               ),
                             );
                          },
                          child: Container(
                            padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 4),
                            decoration: BoxDecoration(
                              color: color.withValues(alpha: 0.15),
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(
                                color: color.withValues(alpha: 0.3),
                              ),
                            ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  course.subject,
                                  style: TextStyle(
                                    fontSize: 11 * fontMultiplier,
                                    color: theme.colorScheme.onSurface,
                                    fontWeight: FontWeight.w600,
                                  ),
                                  textAlign: TextAlign.center,
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                const SizedBox(height: 2),
                                Text(
                                  course.classroom,
                                  style: TextStyle(
                                    fontSize: 9 * fontMultiplier,
                                    color: theme.colorScheme.onSurfaceVariant,
                                  ),
                                  textAlign: TextAlign.center,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                );
              }),
            ),
          ),
        ],
      ),
    );
  }
}
