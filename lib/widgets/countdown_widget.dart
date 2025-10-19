import 'package:flutter/material.dart';
import 'package:time_widgets/models/countdown_model.dart';
import 'package:time_widgets/widgets/error_widget.dart';

class CountdownWidget extends StatelessWidget {
  final double? fontSize;
  final double? padding;
  final CountdownData? countdownData;
  final String? error;
  final VoidCallback? onRetry;

  const CountdownWidget({
    super.key,
    this.fontSize,
    this.padding,
    this.countdownData,
    this.error,
    this.onRetry,
  });

  @override
  Widget build(BuildContext context) {
    final effectivePadding = padding ?? 24.0;
    final effectiveBaseFontSize = fontSize ?? 14.0;
    final titleFontSize = effectiveBaseFontSize;
    final badgeFontSize = effectiveBaseFontSize * 0.7;
    final eventFontSize = effectiveBaseFontSize * 2.3;
    final numberFontSize = effectiveBaseFontSize * 3.4;
    final unitFontSize = effectiveBaseFontSize * 1.7;
    final progressFontSize = effectiveBaseFontSize * 0.85;
    final hintFontSize = effectiveBaseFontSize;
    
    // 错误处理
    if (error != null) {
      return CustomErrorWidget(
        message: error!,
        onRetry: onRetry,
        fontSize: effectiveBaseFontSize,
      );
    }
    
    // 使用真实倒计时数据或默认值
    final countdown = countdownData;
    final title = countdown?.title ?? 'Important Event';
    final description = countdown?.description ?? 'High School Exam';
    final remainingDays = countdown?.remainingDays ?? 10;
    final type = countdown?.type ?? 'exam';
    final typeLabel = countdown?.typeLabel ?? 'Exam';
    final typeColor = countdown?.typeColor ?? const Color(0xFFF44336);
    final progress = countdown?.progress ?? 0.85;

    return Container(
      padding: EdgeInsets.all(effectivePadding),
      decoration: BoxDecoration(
        color: const Color(0xFF1E1E1E).withValues(alpha: 0.8),  // 半透明背景
        borderRadius: BorderRadius.circular(16.0),
        border: Border.all(
          color: const Color(0xFF3D3D3D).withValues(alpha: 0.5),  // 半透明边框
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
          // 标题区域
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                title,
                style: TextStyle(
                  fontSize: titleFontSize,
                  color: const Color(0xFFB3B3B3),  // MD3 onSurfaceVariant
                  fontWeight: FontWeight.w500,
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: typeColor.withValues(alpha: 0.12),  // 使用真实类型颜色
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  typeLabel,
                  style: TextStyle(
                    fontSize: badgeFontSize,
                    color: typeColor,  // 使用真实类型颜色
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: effectivePadding * 0.3),
          
          // 倒计时标题
          Text(
            description,
            style: TextStyle(
              fontSize: eventFontSize,
              fontWeight: FontWeight.w600,
              color: const Color(0xFFFFFFFF),  // MD3 onSurface
            ),
          ),
          SizedBox(height: effectivePadding * 0.15),
          
          // 倒计时数字
          FittedBox(
            fit: BoxFit.scaleDown,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.baseline,
              textBaseline: TextBaseline.alphabetic,
              children: [
                Text(
                  '$remainingDays',
                  style: TextStyle(
                    fontSize: numberFontSize,
                    fontWeight: FontWeight.w700,
                    color: const Color(0xFFFFFFFF),  // MD3 onSurface
                  ),
                ),
                SizedBox(width: effectivePadding * 0.33),
                Text(
                  'days',
                  style: TextStyle(
                    fontSize: unitFontSize,
                    fontWeight: FontWeight.w500,
                    color: const Color(0xFFB3B3B3),  // MD3 onSurfaceVariant
                  ),
                ),
              ],
            ),
          ),
          
          SizedBox(height: effectivePadding * 0.3),
          
          // 进度条
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Study Progress',
                    style: TextStyle(
                      fontSize: progressFontSize,
                      color: const Color(0xFFB3B3B3),  // MD3 onSurfaceVariant
                    ),
                  ),
                  Text(
                    '${(progress * 100).toInt()}%',
                    style: TextStyle(
                      fontSize: progressFontSize,
                      color: const Color(0xFFFFFFFF),  // MD3 onSurface
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
              SizedBox(height: effectivePadding * 0.15),
              ClipRRect(
                borderRadius: BorderRadius.circular(4),
                child: LinearProgressIndicator(
                  value: progress,
                  backgroundColor: const Color(0xFF3D3D3D),  // MD3 surface variant
                  valueColor: AlwaysStoppedAnimation<Color>(typeColor),  // 使用真实类型颜色
                  minHeight: effectivePadding * 0.2,
                ),
              ),
            ],
          ),
          
          SizedBox(height: effectivePadding * 0.2),
          
          // 提示文字
          Text(
            '$remainingDays days until $description',
            style: TextStyle(
              fontSize: hintFontSize,
              color: const Color(0xFFB3B3B3),  // MD3 onSurfaceVariant
              fontWeight: FontWeight.w400,
            ),
          ),
        ],
      ),
    );
  }
}