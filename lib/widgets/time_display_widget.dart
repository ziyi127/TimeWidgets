import 'dart:async';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class TimeDisplayWidget extends StatefulWidget {
  final double? fontSize;
  final double? padding;
  
  const TimeDisplayWidget({
    super.key,
    this.fontSize,
    this.padding,
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
    final padding = widget.padding ?? 24.0;
    final baseFontSize = widget.fontSize ?? 14.0;
    final timeFontSize = baseFontSize * 3.4;
    final secondsFontSize = baseFontSize * 1.7;
    
    return Container(
      padding: EdgeInsets.all(padding),
      decoration: BoxDecoration(
        color: const Color(0xFF1E1E1E).withValues(alpha: 0.8),  // Semi-transparent background
        borderRadius: BorderRadius.circular(16.0),
        border: Border.all(
          color: const Color(0xFF3D3D3D).withValues(alpha: 0.5),  // Semi-transparent border
          width: 1.0,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.1),
            blurRadius: 8.0,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Title area
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Current Time',
                style: TextStyle(
                  fontSize: baseFontSize,
                  color: const Color(0xFFB3B3B3),  // MD3 onSurfaceVariant
                  fontWeight: FontWeight.w500,
                ),
              ),
              Container(
                padding: EdgeInsets.symmetric(horizontal: baseFontSize * 0.6, vertical: baseFontSize * 0.3),
                decoration: BoxDecoration(
                  color: const Color(0xFF4CAF50).withValues(alpha: 0.12),  // MD3 primary with opacity
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  'Live',
                  style: TextStyle(
                    fontSize: baseFontSize * 0.7,
                    color: const Color(0xFF4CAF50),  // MD3 primary
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: baseFontSize * 1.1),
          
          // Time display area
          FittedBox(
            fit: BoxFit.scaleDown,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.baseline,
              textBaseline: TextBaseline.alphabetic,
              children: [
                Text(
                  _currentTime,
                  style: TextStyle(
                    fontSize: timeFontSize,
                    fontWeight: FontWeight.w300,
                    color: const Color(0xFFFFFFFF),  // MD3 onSurface
                    fontFeatures: const [FontFeature.tabularFigures()], // Monospaced numbers
                  ),
                ),
                SizedBox(width: baseFontSize * 0.6),
                Text(
                  ':$_currentSeconds',
                  style: TextStyle(
                    fontSize: secondsFontSize,
                    fontWeight: FontWeight.w300,
                    color: const Color(0xFFB3B3B3),  // MD3 onSurfaceVariant
                    fontFeatures: const [FontFeature.tabularFigures()],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}