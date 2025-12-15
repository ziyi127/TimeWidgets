import 'package:flutter/material.dart';
import 'package:time_widgets/utils/error_handler.dart';

class CustomErrorWidget extends StatelessWidget {
  final String message;
  final String? resolution;
  final VoidCallback? onRetry;
  final double? fontSize;
  final AppError? appError;

  const CustomErrorWidget({
    super.key,
    required this.message,
    this.resolution,
    this.onRetry,
    this.fontSize,
    this.appError,
  });

  factory CustomErrorWidget.fromAppError({
    Key? key,
    required AppError error,
    VoidCallback? onRetry,
    double? fontSize,
  }) {
    return CustomErrorWidget(
      key: key,
      message: error.userMessage ?? error.message,
      resolution: error.resolution,
      onRetry: onRetry,
      fontSize: fontSize,
      appError: error,
    );
  }

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
          if (resolution != null) ...[
            SizedBox(height: effectiveFontSize * 0.5),
            Container(
              padding: EdgeInsets.all(effectiveFontSize * 0.5),
              decoration: BoxDecoration(
                color: const Color(0xFF2A2A2A),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.lightbulb_outline,
                    color: const Color(0xFFFFB74D),
                    size: effectiveFontSize,
                  ),
                  SizedBox(width: effectiveFontSize * 0.3),
                  Flexible(
                    child: Text(
                      resolution!,
                      style: TextStyle(
                        fontSize: effectiveFontSize * 0.8,
                        color: const Color(0xFFFFB74D),
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ],
              ),
            ),
          ],
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