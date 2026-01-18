import 'package:flutter/material.dart';
import 'package:time_widgets/models/course_model.dart';
import 'package:time_widgets/services/ntp_service.dart';
import 'package:time_widgets/services/timetable_service.dart';
import 'package:time_widgets/utils/color_utils.dart';
import 'package:time_widgets/utils/responsive_utils.dart';

/// 增强版课程表组件 - UX优化版
/// 
/// 主要改进：
/// 1. 信息层级更清晰
/// 2. 视觉对比度增强
/// 3. 交互反馈更丰富
/// 4. 支持无障碍访问
class EnhancedTimetableWidget extends StatefulWidget {
  const EnhancedTimetableWidget({
    super.key,
    this.courses,
    this.isCompact = false,
  });

  final List<Course>? courses;
  final bool isCompact;

  @override
  State<EnhancedTimetableWidget> createState() =>
      _EnhancedTimetableWidgetState();
}

class _EnhancedTimetableWidgetState extends State<EnhancedTimetableWidget>
    with SingleTickerProviderStateMixin {
  TimetableViewMode _viewMode = TimetableViewMode.day;
  final TimetableService _timetableService = TimetableService();

  Map<int, List<Course>> _weekCourses = {};
  bool _isLoadingWeek = false;
  DateTime _selectedDate = DateTime.now();
  final int _currentWeek = 0;

  late AnimationController _pulseController;
  late Animation<double> _pulseAnimation;

  @override
  void initState() {
    super.initState();
    _selectedDate = DateTime.now();

    // 初始化脉动动画（用于进行中的课程）
    _pulseController = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    )..repeat(reverse: true);

    _pulseAnimation = Tween<double>(begin: 1, end: 1.08).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _pulseController.dispose();
    super.dispose();
  }

  Future<void> _loadWeekData() async {
    if (_weekCourses.isNotEmpty) return;

    setState(() => _isLoadingWeek = true);

    try {
      final now = _selectedDate;
      final monday = now.subtract(Duration(days: now.weekday - 1));

      final futures = List.generate(7, (i) {
        final date = monday.add(Duration(days: i));
        return _timetableService.getTimetable(date).then((timetable) {
          return MapEntry(i, timetable.courses);
        });
      });

      final results = await Future.wait(futures);
      if (mounted) {
        setState(() {
          _weekCourses = Map.fromEntries(results);
          _isLoadingWeek = false;
        });
      }
    } catch (e) {
      if (mounted) setState(() => _isLoadingWeek = false);
    }
  }

  void _toggleViewMode() {
    setState(() {
      _viewMode = _viewMode == TimetableViewMode.day
          ? TimetableViewMode.week
          : TimetableViewMode.day;
      if (_viewMode == TimetableViewMode.week) _loadWeekData();
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final width = MediaQuery.sizeOf(context).width;
    final dayCourses = widget.courses ?? [];

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
            _buildEnhancedHeader(context, theme, colorScheme, width),
            SizedBox(height: ResponsiveUtils.value(16)),
            AnimatedSwitcher(
              duration: const Duration(milliseconds: 400),
              transitionBuilder: (child, animation) {
                return FadeTransition(
                  opacity: animation,
                  child: SlideTransition(
                    position: Tween<Offset>(
                      begin: const Offset(0.05, 0),
                      end: Offset.zero,
                    ).animate(animation),
                    child: child,
                  ),
                );
              },
              child: _viewMode == TimetableViewMode.day
                  ? _buildEnhancedDayView(context, dayCourses, theme, width)
                  : _buildEnhancedWeekView(context, theme, width),
            ),
          ],
        ),
      ),
    );
  }

  /// 增强版头部 - 使用 SegmentedButton 替代 IconButton
  Widget _buildEnhancedHeader(
    BuildContext context,
    ThemeData theme,
    ColorScheme colorScheme,
    double width,
  ) {
    final fontMultiplier = ResponsiveUtils.getFontSizeMultiplier(width);

    return Row(
      children: [
        Icon(
          Icons.calendar_month_rounded,
          size: ResponsiveUtils.getIconSize(width),
          color: colorScheme.primary,
        ),
        SizedBox(width: ResponsiveUtils.value(12)),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                _viewMode == TimetableViewMode.day ? '今日课程' : '本周课表',
                style: theme.textTheme.titleMedium?.copyWith(
                  color: colorScheme.onSurface,
                  fontSize: (theme.textTheme.titleMedium?.fontSize ?? 16) *
                      fontMultiplier,
                  fontWeight: FontWeight.bold,
                ),
              ),
              if (_viewMode == TimetableViewMode.week)
                Text(
                  '第 $_currentWeek 周',
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: colorScheme.onSurfaceVariant,
                  ),
                ),
            ],
          ),
        ),
        // 视图切换 SegmentedButton
        SegmentedButton<TimetableViewMode>(
          segments: const [
            ButtonSegment(
              value: TimetableViewMode.day,
              icon: Icon(Icons.view_day_outlined, size: 18),
              label: Text('日'),
            ),
            ButtonSegment(
              value: TimetableViewMode.week,
              icon: Icon(Icons.view_week_outlined, size: 18),
              label: Text('周'),
            ),
          ],
          selected: {_viewMode},
          onSelectionChanged: (newSelection) {
            _toggleViewMode();
          },
          style: const ButtonStyle(
            visualDensity: VisualDensity.compact,
          ),
        ),
      ],
    );
  }

  /// 增强版日视图 - 骨架屏 + 空状态优化
  Widget _buildEnhancedDayView(
    BuildContext context,
    List<Course> courses,
    ThemeData theme,
    double width,
  ) {
    if (courses.isEmpty) {
      return _buildEmptyState(theme);
    }

    return ConstrainedBox(
      constraints: BoxConstraints(maxHeight: ResponsiveUtils.value(350)),
      child: ListView.separated(
        shrinkWrap: true,
        physics: const BouncingScrollPhysics(),
        itemCount: courses.length,
        separatorBuilder: (context, index) =>
            SizedBox(height: ResponsiveUtils.value(12)),
        itemBuilder: (context, index) {
          final course = courses[index];
          return _buildEnhancedCourseCard(context, course, width);
        },
      ),
    );
  }

  /// 空状态优化 - 情感化设计
  Widget _buildEmptyState(ThemeData theme) {
    return Container(
      height: ResponsiveUtils.value(200),
      alignment: Alignment.center,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.free_breakfast_rounded,
            size: 64,
            color: theme.colorScheme.primary.withValues(alpha: 0.3),
          ),
          const SizedBox(height: 16),
          Text(
            '今天没有课程',
            style: theme.textTheme.titleMedium?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            '好好享受自由时光吧 ☕',
            style: theme.textTheme.bodyMedium?.copyWith(
              color: theme.colorScheme.onSurfaceVariant.withValues(alpha: 0.7),
            ),
          ),
        ],
      ),
    );
  }

  /// 增强版课程卡片 - 多维度状态区分
  Widget _buildEnhancedCourseCard(
    BuildContext context,
    Course course,
    double width,
  ) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final fontMultiplier = ResponsiveUtils.getFontSizeMultiplier(width);

    final subjectColor = ColorUtils.generateColorFromName(course.subject);
    final isCurrent = course.isCurrent;
    final isCompleted = _isCourseCompleted(course);
    final isUpcoming = _isCourseUpcoming(course);

    return Semantics(
      label: '${course.subject}课程，时间${course.time}，地点${course.classroom}',
      button: true,
      child: AnimatedBuilder(
        animation: _pulseAnimation,
        builder: (context, child) {
          return Transform.scale(
            scale: isCurrent ? _pulseAnimation.value : 1.0,
            child: child,
          );
        },
        child: Card(
          elevation: isCurrent ? 4 : 0,
          margin: EdgeInsets.zero,
          color: _getCardBackgroundColor(
            colorScheme,
            subjectColor,
            isCurrent,
            isCompleted,
            isUpcoming,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
            side: isCurrent
                ? BorderSide(color: subjectColor, width: 2)
                : isUpcoming
                    ? BorderSide(
                        color: colorScheme.tertiary.withValues(alpha: 0.5),
                        width: 1.5,
                      )
                    : BorderSide.none,
          ),
          child: InkWell(
            onTap: () => _onCourseTap(course),
            onLongPress: () => _showCourseMenu(context, course),
            borderRadius: BorderRadius.circular(16),
            splashColor: subjectColor.withValues(alpha: 0.12),
            highlightColor: subjectColor.withValues(alpha: 0.08),
            child: IntrinsicHeight(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // 状态指示条 - 多维度区分
                  _buildStatusIndicator(
                    colorScheme,
                    subjectColor,
                    isCurrent,
                    isCompleted,
                    isUpcoming,
                  ),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: _buildCardContent(
                        theme,
                        colorScheme,
                        course,
                        subjectColor,
                        isCurrent,
                        isCompleted,
                        isUpcoming,
                        fontMultiplier,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  /// 状态指示条 - 颜色 + 图案纹理（色盲友好）
  Widget _buildStatusIndicator(
    ColorScheme colorScheme,
    Color subjectColor,
    bool isCurrent,
    bool isCompleted,
    bool isUpcoming,
  ) {
    Color indicatorColor;
    Widget? pattern;

    if (isCompleted) {
      indicatorColor = colorScheme.outlineVariant;
      // 虚线图案
      pattern = CustomPaint(
        painter: DashedLinePainter(color: indicatorColor),
      );
    } else if (isCurrent) {
      indicatorColor = subjectColor;
      // 实线 + 脉动点
      pattern = Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 6,
            height: 6,
            decoration: BoxDecoration(
              color: subjectColor,
              shape: BoxShape.circle,
            ),
          ),
        ],
      );
    } else if (isUpcoming) {
      indicatorColor = colorScheme.tertiary;
      // 斜线图案
      pattern = CustomPaint(
        painter: DiagonalLinePainter(color: indicatorColor),
      );
    } else {
      indicatorColor = subjectColor.withValues(alpha: 0.5);
    }

    return Container(
      width: 6,
      decoration: BoxDecoration(
        color: indicatorColor,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(16),
          bottomLeft: Radius.circular(16),
        ),
      ),
      child: pattern,
    );
  }

  /// 卡片内容 - 信息层级优化
  Widget _buildCardContent(
    ThemeData theme,
    ColorScheme colorScheme,
    Course course,
    Color subjectColor,
    bool isCurrent,
    bool isCompleted,
    bool isUpcoming,
    double fontMultiplier,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // 第一行：课程名 + 状态标签
        Row(
          children: [
            Expanded(
              child: Text(
                course.subject,
                style: theme.textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                  fontSize: 18 * fontMultiplier,
                  color: isCompleted
                      ? colorScheme.onSurface.withValues(alpha: 0.5)
                      : colorScheme.onSurface,
                  decoration: isCompleted ? TextDecoration.lineThrough : null,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            if (isCurrent) _buildStatusChip('进行中', subjectColor, colorScheme),
            if (isUpcoming)
              _buildStatusChip('即将开始', colorScheme.tertiary, colorScheme),
            if (isCompleted)
              _buildStatusChip('已结束', colorScheme.outline, colorScheme),
          ],
        ),
        const SizedBox(height: 8),
        // 第二行：时间（等宽字体）
        Row(
          children: [
            Icon(
              Icons.access_time_rounded,
              size: 16,
              color: colorScheme.onSurfaceVariant,
            ),
            const SizedBox(width: 6),
            Text(
              course.time,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: colorScheme.onSurfaceVariant,
                fontWeight: FontWeight.w500,
                fontFeatures: [const FontFeature.tabularFigures()],
              ),
            ),
          ],
        ),
        const SizedBox(height: 4),
        // 第三行：地点 + 教师
        Row(
          children: [
            Icon(
              Icons.location_on_rounded,
              size: 16,
              color: colorScheme.onSurfaceVariant,
            ),
            const SizedBox(width: 6),
            Expanded(
              child: Text(
                course.classroom,
                style: theme.textTheme.bodySmall?.copyWith(
                  color: colorScheme.onSurfaceVariant.withValues(alpha: 0.8),
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            if (course.teacher.isNotEmpty) ...[
              const SizedBox(width: 8),
              Icon(
                Icons.person_outline_rounded,
                size: 14,
                color: colorScheme.onSurfaceVariant,
              ),
              const SizedBox(width: 4),
              Text(
                course.teacher,
                style: theme.textTheme.bodySmall?.copyWith(
                  color: colorScheme.onSurfaceVariant.withValues(alpha: 0.7),
                ),
              ),
            ],
          ],
        ),
      ],
    );
  }

  /// 状态标签
  Widget _buildStatusChip(String label, Color color, ColorScheme colorScheme) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: color.withValues(alpha: 0.3)),
      ),
      child: Text(
        label,
        style: TextStyle(
          color: color,
          fontSize: 11,
          fontWeight: FontWeight.bold,
          letterSpacing: 0.5,
        ),
      ),
    );
  }

  /// 获取卡片背景色
  Color _getCardBackgroundColor(
    ColorScheme colorScheme,
    Color subjectColor,
    bool isCurrent,
    bool isCompleted,
    bool isUpcoming,
  ) {
    if (isCompleted) {
      return colorScheme.surfaceContainerHighest.withValues(alpha: 0.5);
    } else if (isCurrent) {
      return subjectColor.withValues(alpha: 0.08);
    } else if (isUpcoming) {
      return colorScheme.tertiaryContainer.withValues(alpha: 0.3);
    }
    return colorScheme.surface;
  }

  /// 判断课程是否已结束
  bool _isCourseCompleted(Course course) {
    final parts = course.time.split('~');
    if (parts.length != 2) return false;

    final endParts = parts[1].trim().split(':');
    if (endParts.length != 2) return false;

    final now = NtpService().now;
    final endHour = int.tryParse(endParts[0]) ?? 0;
    final endMinute = int.tryParse(endParts[1]) ?? 0;
    final endTime = DateTime(now.year, now.month, now.day, endHour, endMinute);

    return now.isAfter(endTime);
  }

  /// 判断课程是否即将开始（15分钟内）
  bool _isCourseUpcoming(Course course) {
    final parts = course.time.split('~');
    if (parts.length != 2) return false;

    final startParts = parts[0].trim().split(':');
    if (startParts.length != 2) return false;

    final now = NtpService().now;
    final startHour = int.tryParse(startParts[0]) ?? 0;
    final startMinute = int.tryParse(startParts[1]) ?? 0;
    final startTime =
        DateTime(now.year, now.month, now.day, startHour, startMinute);

    final diff = startTime.difference(now);
    return diff.inMinutes > 0 && diff.inMinutes <= 15;
  }

  /// 点击课程卡片
  void _onCourseTap(Course course) {
    // TODO: 导航到课程详情
  }

  /// 长按显示菜单
  void _showCourseMenu(BuildContext context, Course course) {
    showModalBottomSheet(
      context: context,
      builder: (context) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.edit_outlined),
              title: const Text('编辑课程'),
              onTap: () {
                Navigator.pop(context);
                // TODO: 编辑课程
              },
            ),
            ListTile(
              leading: const Icon(Icons.copy_outlined),
              title: const Text('复制到其他时间'),
              onTap: () {
                Navigator.pop(context);
                // TODO: 复制课程
              },
            ),
            ListTile(
              leading: const Icon(Icons.notifications_outlined),
              title: const Text('设置提醒'),
              onTap: () {
                Navigator.pop(context);
                // TODO: 设置提醒
              },
            ),
            ListTile(
              leading: const Icon(Icons.delete_outline, color: Colors.red),
              title: const Text('删除课程', style: TextStyle(color: Colors.red)),
              onTap: () {
                Navigator.pop(context);
                // TODO: 删除课程
              },
            ),
          ],
        ),
      ),
    );
  }

  /// 增强版周视图 - 支持滑动切换
  Widget _buildEnhancedWeekView(
    BuildContext context,
    ThemeData theme,
    double width,
  ) {
    if (_isLoadingWeek) {
      return _buildWeekSkeleton(theme);
    }

    return Column(
      children: [
        _buildWeekHeader(theme),
        const SizedBox(height: 12),
        _buildWeekGrid(theme),
      ],
    );
  }

  /// 周视图头部
  Widget _buildWeekHeader(ThemeData theme) {
    final days = ['一', '二', '三', '四', '五', '六', '日'];
    final todayWeekday = DateTime.now().weekday - 1;

    return Row(
      children: List.generate(7, (index) {
        final isToday = index == todayWeekday;
        return Expanded(
          child: Container(
            alignment: Alignment.center,
            padding: const EdgeInsets.symmetric(vertical: 10),
            decoration: isToday
                ? BoxDecoration(
                    color: theme.colorScheme.primaryContainer,
                    borderRadius: BorderRadius.circular(12),
                  )
                : null,
            child: Text(
              days[index],
              style: theme.textTheme.labelLarge?.copyWith(
                color: isToday
                    ? theme.colorScheme.onPrimaryContainer
                    : theme.colorScheme.onSurfaceVariant,
                fontWeight: isToday ? FontWeight.bold : FontWeight.normal,
              ),
            ),
          ),
        );
      }),
    );
  }

  /// 周视图网格
  Widget _buildWeekGrid(ThemeData theme) {
    return Container(
      height: 320,
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: theme.colorScheme.outlineVariant.withValues(alpha: 0.5),
        ),
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
                                .withValues(alpha: 0.3),
                          ),
                        )
                      : null,
                ),
                padding: const EdgeInsets.all(4),
                child: Column(
                  children: courses.isEmpty
                      ? [
                          const SizedBox(height: 24),
                          Text(
                            '-',
                            style: TextStyle(
                              color: theme.colorScheme.outlineVariant,
                            ),
                          ),
                        ]
                      : courses.map((course) {
                          final color =
                              ColorUtils.generateColorFromName(course.subject);
                          return Tooltip(
                            message:
                                '${course.subject}\n${course.time}\n${course.classroom}',
                            child: Container(
                              margin: const EdgeInsets.only(bottom: 6),
                              padding: const EdgeInsets.symmetric(
                                vertical: 8,
                                horizontal: 4,
                              ),
                              decoration: BoxDecoration(
                                color: color.withValues(alpha: 0.15),
                                borderRadius: BorderRadius.circular(8),
                                border: Border.all(
                                  color: color.withValues(alpha: 0.4),
                                ),
                              ),
                              child: Column(
                                children: [
                                  Text(
                                    course.subject.length > 3
                                        ? course.subject.substring(0, 3)
                                        : course.subject,
                                    style: TextStyle(
                                      fontSize: 11,
                                      color: theme.colorScheme.onSurface,
                                      fontWeight: FontWeight.w600,
                                    ),
                                    textAlign: TextAlign.center,
                                    maxLines: 1,
                                  ),
                                  const SizedBox(height: 4),
                                  Container(
                                    width: 5,
                                    height: 5,
                                    decoration: BoxDecoration(
                                      color: color,
                                      shape: BoxShape.circle,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        }).toList(),
                ),
              ),
            );
          }),
        ),
      ),
    );
  }

  /// 周视图骨架屏
  Widget _buildWeekSkeleton(ThemeData theme) {
    return Container(
      height: 300,
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceContainerHighest.withValues(alpha: 0.3),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            CircularProgressIndicator(
              color: theme.colorScheme.primary,
            ),
            const SizedBox(height: 16),
            Text(
              '正在加载周课表...',
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// 视图模式枚举
enum TimetableViewMode { day, week }

/// 虚线画笔（色盲友好）
class DashedLinePainter extends CustomPainter {
  DashedLinePainter({required this.color});
  final Color color;

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = 2
      ..style = PaintingStyle.stroke;

    const dashWidth = 4.0;
    const dashSpace = 4.0;
    double startY = 0;

    while (startY < size.height) {
      canvas.drawLine(
        Offset(size.width / 2, startY),
        Offset(size.width / 2, startY + dashWidth),
        paint,
      );
      startY += dashWidth + dashSpace;
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

/// 斜线画笔（色盲友好）
class DiagonalLinePainter extends CustomPainter {
  DiagonalLinePainter({required this.color});
  final Color color;

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color.withValues(alpha: 0.3)
      ..strokeWidth = 1.5
      ..style = PaintingStyle.stroke;

    for (double i = 0; i < size.height; i += 8) {
      canvas.drawLine(
        Offset(0, i),
        Offset(size.width, i + size.width),
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
