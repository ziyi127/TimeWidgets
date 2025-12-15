import 'dart:async';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:time_widgets/utils/md3_card_styles.dart';
import 'package:time_widgets/utils/md3_typography_styles.dart';

class TimeDisplayWidget extends StatefulWidget {
  final bool isCompact;
  
  const TimeDisplayWidget({
    super.key,
    this.isCompact = false,
  });

  @override
  State<TimeDisplayWidget> createState() => _TimeDisplayWidgetState();
}

class _TimeDisplayWidgetState extends State<TimeDisplayWidget> {
  late String _currentTime;
  late String _currentSeconds;
  late Timer _timer;

  @override
  void initState() {
    super.initState();
    _updateTime();
    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      _updateTime();
    });
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  void _updateTime() {
    final now = DateTime.now();
    setState(() {
      _currentTime = DateFormat('HH:mm').format(now);
      _currentSeconds = DateFormat('ss').format(now);
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    
    return MD3CardStyles.surfaceContainer(
      context: context,
      padding: EdgeInsets.all(widget.isCompact ? 16.0 : 20.0),
      child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            // Header
            Row(
              children: [
                Icon(
                  Icons.access_time_rounded,
                  size: widget.isCompact ? 16 : 18,
                  color: colorScheme.primary,
                ),
                const SizedBox(width: 8),
                Text(
                  'Current Time',
                  style: MD3TypographyStyles.titleSmall(context, color: colorScheme.onSurfaceVariant),
                ),
              ],
            ),
            
            SizedBox(height: widget.isCompact ? 12 : 16),
            
            // Time Display
            Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                // Main time
                Text(
                  _currentTime,
                  style: MD3TypographyStyles.displayMedium(context).copyWith(
                    fontWeight: FontWeight.w300,
                    fontSize: widget.isCompact ? 36 : 48,
                    height: 1.0,
                  ),
                ),
                
                const SizedBox(width: 8),
                
                // Seconds
                Padding(
                  padding: const EdgeInsets.only(bottom: 8),
                  child: Text(
                    _currentSeconds,
                    style: MD3TypographyStyles.titleLarge(context, color: colorScheme.onSurfaceVariant).copyWith(
                      fontWeight: FontWeight.w400,
                      fontSize: widget.isCompact ? 16 : 20,
                    ),
                  ),
                ),
              ],
            ),
            
            if (!widget.isCompact) ...[
              const SizedBox(height: 8),
              
              // Additional info
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: colorScheme.primaryContainer.withValues(alpha: 0.3),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  'Live',
                  style: MD3TypographyStyles.labelSmall(context, color: colorScheme.onPrimaryContainer).copyWith(
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ],
        ),
    );
  }
}