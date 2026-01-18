import 'dart:async';

import 'package:bitsdojo_window/bitsdojo_window.dart';
import 'package:desktop_multi_window/desktop_multi_window.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:time_widgets/models/course_model.dart';
import 'package:time_widgets/services/ntp_service.dart';
import 'package:time_widgets/services/timetable_service.dart';
import 'package:window_manager/window_manager.dart';

class DynamicIslandScreen extends StatefulWidget {
  const DynamicIslandScreen({super.key, this.windowId});
  final String? windowId;

  @override
  State<DynamicIslandScreen> createState() => _DynamicIslandScreenState();
}

class _DynamicIslandScreenState extends State<DynamicIslandScreen> {
  final TimetableService _timetableService = TimetableService();
  final NtpService _ntpService = NtpService();

  Course? _currentCourse;
  Course? _nextCourse;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    // 窗口初始化逻辑已移至 main.dart，确保在 runApp 前执行
    _updateData();
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (mounted) {
        setState(() {});
        // Refresh course data every minute
        if (timer.tick % 60 == 0) {
          _updateData();
        }
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  Future<void> _setupWindowHandler() async {
    try {
      final controller = await WindowController.fromCurrentEngine();
      controller.setWindowMethodHandler((call) async {
        if (call.method == 'close') {
          await windowManager.close();
          return "success";
        } else if (call.method == 'setFrame') {
          final args = call.arguments as Map;
          final x = args['x'] as double;
          final y = args['y'] as double;
          final width = args['width'] as double;
          final height = args['height'] as double;
          await windowManager.setBounds(Rect.fromLTWH(x, y, width, height));
          return "success";
        }
        return null;
      });
    } catch (e) {
      debugPrint('Error setting up window handler: $e');
    }
  }

  Future<void> _updateData() async {
    try {
      // 简单延迟以确保服务初始化（如果是冷启动）
      // 虽然NtpService不需要await初始化，但TimetableService可能会有IO
      final data = await _timetableService.getCurrentAndNextCourse();
      if (mounted) {
        setState(() {
          _currentCourse = data['current'];
          _nextCourse = data['next'];
        });
      }
    } catch (e) {
      debugPrint('Error updating dynamic island data: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    final now = _ntpService.now;
    final timeStr = DateFormat('HH:mm').format(now);
    final dateStr = DateFormat('MM-dd EEE', 'zh_CN').format(now);

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: GestureDetector(
        onDoubleTap: () {
          // Double tap to toggle back to normal mode
          if (widget.windowId != null) {
            windowManager.close();
          } else {
            // Fallback for single window mode
            Future.delayed(const Duration(milliseconds: 100), () {
              // MD3TrayMenuService.instance.onToggleDynamicIsland?.call();
            });
          }
        },
        child: widget.windowId != null
            ? GestureDetector(
                onPanStart: (_) {
                  windowManager.startDragging();
                },
                child: _buildContent(),
              )
            : MoveWindow(
                child: _buildContent(),
              ),
      ),
    );
  }

  Widget _buildContent() {
    final now = _ntpService.now;
    final timeStr = DateFormat('HH:mm').format(now);
    final dateStr = DateFormat('MM-dd EEE', 'zh_CN').format(now);

    return Center(
      child: Container(
        width: 450, // Compact width
        height: 100,
        decoration: BoxDecoration(
          color: Colors.black.withOpacity(0.95),
          borderRadius: BorderRadius.circular(50),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.3),
              blurRadius: 15,
              spreadRadius: 2,
            ),
          ],
        ),
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
        child: Row(
          children: [
            // Time & Date Section
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  timeStr,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    height: 1,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  dateStr,
                  style: const TextStyle(
                    color: Colors.white70,
                    fontSize: 12,
                  ),
                ),
              ],
            ),

            const SizedBox(width: 20),
            Container(
              width: 1,
              height: 50,
              color: Colors.white12,
            ),
            const SizedBox(width: 20),

            // Course Info Section
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (_currentCourse != null) ...[
                    _buildCourseRow(
                      '当前: ${_currentCourse!.subject}',
                      _getRemainingTime(_currentCourse!),
                      isCurrent: true,
                    ),
                    const SizedBox(height: 4),
                  ] else ...[
                    const Text(
                      '当前无课',
                      style: TextStyle(color: Colors.white54, fontSize: 14),
                    ),
                    const SizedBox(height: 4),
                  ],
                  if (_nextCourse != null)
                    _buildCourseRow(
                      '下节: ${_nextCourse!.subject}',
                      _nextCourse!.classroom,
                      isCurrent: false,
                    )
                  else
                    const Text(
                      '后续无课',
                      style: TextStyle(color: Colors.white38, fontSize: 12),
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCourseRow(
    String title,
    String rightInfo, {
    required bool isCurrent,
  }) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: Text(
            title,
            style: TextStyle(
              color: isCurrent ? Colors.white : Colors.white70,
              fontSize: isCurrent ? 14 : 12,
              fontWeight: isCurrent ? FontWeight.w600 : FontWeight.normal,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ),
        const SizedBox(width: 8),
        Text(
          rightInfo,
          style: TextStyle(
            color: isCurrent ? const Color(0xFF4ADE80) : Colors.white54,
            fontSize: isCurrent ? 14 : 12,
            fontWeight: isCurrent ? FontWeight.bold : FontWeight.normal,
          ),
        ),
      ],
    );
  }

  String _getRemainingTime(Course course) {
    try {
      final now = _ntpService.now;
      final parts = course.time.split('~');
      if (parts.length != 2) return '';

      final endParts = parts[1].split(':');
      final end = DateTime(
        now.year,
        now.month,
        now.day,
        int.parse(endParts[0]),
        int.parse(endParts[1]),
      );

      final diff = end.difference(now);
      if (diff.isNegative) return '已结束';

      if (diff.inHours > 0) {
        return '${diff.inHours}小时${diff.inMinutes % 60}分';
      }
      return '${diff.inMinutes}分钟';
    } catch (e) {
      return '';
    }
  }
}
