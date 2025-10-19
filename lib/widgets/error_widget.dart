import 'package:flutter/material.dart';

class CustomErrorWidget extends StatelessWidget {
  final String message;
  final VoidCallback? onRetry;
  final double? fontSize;

  const CustomErrorWidget({
    super.key,
    required this.message,
    this.onRetry,
    this.fontSize,
  });

  @override
  Widget build(BuildContext context) {
    final effectiveFontSize = fontSize ?? 14.0;
    
    return Container(
      padding: EdgeInsets.all(effectiveFontSize * 1.5),
      decoration: BoxDecoration(
        color: const Color(0xFF1E1E1E).withValues(alpha: 0.8),
        borderRadius: BorderRadius.circular(16.0),
        border: Border.all(
          color: const Color(0xFFF44336).withValues(alpha: 0.5),
          width: 1.0,
        ),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Icon(
            Icons.error_outline,
            color: const Color(0xFFF44336),
            size: effectiveFontSize * 2,
          ),
          SizedBox(height: effectiveFontSize * 0.5),
          Text(
            '加载失败',
            style: TextStyle(
              fontSize: effectiveFontSize * 1.2,
              fontWeight: FontWeight.w600,
              color: const Color(0xFFF44336),
            ),
          ),
          SizedBox(height: effectiveFontSize * 0.3),
          Text(
            message,
            style: TextStyle(
              fontSize: effectiveFontSize * 0.9,
              color: const Color(0xFFB3B3B3),
            ),
            textAlign: TextAlign.center,
          ),
          if (onRetry != null) ...[
            SizedBox(height: effectiveFontSize * 0.8),
            ElevatedButton(
              onPressed: onRetry,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFF44336),
                foregroundColor: Colors.white,
                padding: EdgeInsets.symmetric(
                  horizontal: effectiveFontSize * 1.5,
                  vertical: effectiveFontSize * 0.5,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: Text(
                '重试',
                style: TextStyle(fontSize: effectiveFontSize),
              ),
            ),
          ],
        ],
      ),
    );
  }
}