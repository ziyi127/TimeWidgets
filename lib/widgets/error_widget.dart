import 'package:flutter/material.dart';
import 'package:time_widgets/utils/error_handler.dart';
import 'package:time_widgets/utils/responsive_utils.dart';

class CustomErrorWidget extends StatelessWidget {
  final String message;
  final String? resolution;
  final VoidCallback? onRetry;
  final VoidCallback? onDetails;
  final double? fontSize;
  final AppError? appError;
  final bool showIcon;

  const CustomErrorWidget({
    super.key,
    required this.message,
    this.resolution,
    this.onRetry,
    this.onDetails,
    this.fontSize,
    this.appError,
    this.showIcon = true,
  });

  factory CustomErrorWidget.fromAppError({
    Key? key,
    required AppError error,
    VoidCallback? onRetry,
    VoidCallback? onDetails,
    double? fontSize,
    bool showIcon = true,
  }) {
    return CustomErrorWidget(
      key: key,
      message: error.userMessage ?? error.message,
      resolution: error.resolution,
      onRetry: onRetry,
      onDetails: onDetails,
      fontSize: fontSize,
      appError: error,
      showIcon: showIcon,
    );
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.sizeOf(context).width;
    final fontMultiplier = ResponsiveUtils.getFontSizeMultiplier(width);
    final effectiveFontSize = (fontSize ?? 14.0) * fontMultiplier;
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    
    return Container(
      padding: EdgeInsets.all(effectiveFontSize * 1.5),
      decoration: BoxDecoration(
        color: colorScheme.errorContainer.withAlpha(229),
        borderRadius: BorderRadius.circular(ResponsiveUtils.getBorderRadius(width, baseRadius: 16.0)),
        border: Border.all(
          color: colorScheme.error.withAlpha(128),
          width: ResponsiveUtils.value(1.0),
        ),
        boxShadow: [
          BoxShadow(
            color: colorScheme.shadow.withAlpha(25),
            blurRadius: ResponsiveUtils.value(8),
            offset: Offset(0, ResponsiveUtils.value(2)),
          ),
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          if (showIcon) ...[
            Icon(
              Icons.error_outline,
              color: colorScheme.error,
              size: effectiveFontSize * 2,
            ),
            SizedBox(height: effectiveFontSize * 0.5),
          ],
          Text(
            '加载失败',
            style: TextStyle(
              fontSize: effectiveFontSize * 1.2,
              fontWeight: FontWeight.w600,
              color: colorScheme.error,
            ),
          ),
          SizedBox(height: effectiveFontSize * 0.3),
          Text(
            message,
            style: TextStyle(
              fontSize: effectiveFontSize * 0.9,
              color: colorScheme.onErrorContainer,
            ),
            textAlign: TextAlign.center,
            maxLines: 3,
            overflow: TextOverflow.ellipsis,
          ),
          if (resolution != null) ...[
            SizedBox(height: effectiveFontSize * 0.5),
            Container(
              padding: EdgeInsets.all(effectiveFontSize * 0.5),
              decoration: BoxDecoration(
                color: colorScheme.onErrorContainer.withAlpha(25),
                borderRadius: BorderRadius.circular(ResponsiveUtils.value(8)),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.lightbulb_outline,
                    color: colorScheme.onErrorContainer.withAlpha(204),
                    size: effectiveFontSize,
                  ),
                  SizedBox(width: effectiveFontSize * 0.3),
                  Flexible(
                    child: Text(
                      resolution!,
                      style: TextStyle(
                        fontSize: effectiveFontSize * 0.8,
                        color: colorScheme.onErrorContainer.withAlpha(230),
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ],
              ),
            ),
          ],
          SizedBox(height: effectiveFontSize * 0.8),
          Wrap(
            spacing: effectiveFontSize * 0.8,
            runSpacing: effectiveFontSize * 0.5,
            alignment: WrapAlignment.center,
            children: [
              if (onRetry != null) ...[
                ElevatedButton(
                  onPressed: onRetry,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: colorScheme.error,
                    foregroundColor: colorScheme.onError,
                    padding: EdgeInsets.symmetric(
                      horizontal: effectiveFontSize * 1.5,
                      vertical: effectiveFontSize * 0.5,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(ResponsiveUtils.value(8)),
                    ),
                  ),
                  child: Row(
                    children: [
                      Icon(Icons.refresh, size: effectiveFontSize),
                      SizedBox(width: effectiveFontSize * 0.5),
                      Text(
                        '重试',
                        style: TextStyle(fontSize: effectiveFontSize),
                      ),
                    ],
                  ),
                ),
              ],
              if (onDetails != null) ...[
                OutlinedButton(
                  onPressed: onDetails,
                  style: OutlinedButton.styleFrom(
                    foregroundColor: colorScheme.onErrorContainer,
                    side: BorderSide(
                      color: colorScheme.onErrorContainer.withAlpha(128),
                    ),
                    padding: EdgeInsets.symmetric(
                      horizontal: effectiveFontSize * 1.5,
                      vertical: effectiveFontSize * 0.5,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(ResponsiveUtils.value(8)),
                    ),
                  ),
                  child: Row(
                    children: [
                      Icon(Icons.info_outline, size: effectiveFontSize),
                      SizedBox(width: effectiveFontSize * 0.5),
                      Text(
                        '详情',
                        style: TextStyle(fontSize: effectiveFontSize),
                      ),
                    ],
                  ),
                ),
              ],
            ],
          ),
        ],
      ),
    );
  }
}

/// 轻量级错误提示组件，用于非阻塞场景
class ErrorToast extends StatelessWidget {
  final String message;
  final VoidCallback? onRetry;
  final Duration duration;
  
  const ErrorToast({
    super.key,
    required this.message,
    this.onRetry,
    this.duration = const Duration(seconds: 3),
  });
  
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final width = MediaQuery.sizeOf(context).width;
    final fontMultiplier = ResponsiveUtils.getFontSizeMultiplier(width);
    
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: ResponsiveUtils.value(16),
        vertical: ResponsiveUtils.value(12),
      ),
      decoration: BoxDecoration(
        color: colorScheme.errorContainer,
        borderRadius: BorderRadius.circular(ResponsiveUtils.getBorderRadius(width, baseRadius: 12)),
        border: Border.all(
          color: colorScheme.error.withAlpha(128),
          width: ResponsiveUtils.value(1.0),
        ),
        boxShadow: [
          BoxShadow(
            color: colorScheme.shadow.withAlpha(38),
            blurRadius: ResponsiveUtils.value(12),
            offset: Offset(0, ResponsiveUtils.value(4)),
          ),
        ],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.error_outline,
            color: colorScheme.error,
            size: ResponsiveUtils.getIconSize(width, baseSize: 20),
          ),
          SizedBox(width: ResponsiveUtils.value(8)),
          Flexible(
            child: Text(
              message,
              style: TextStyle(
                fontSize: 14 * fontMultiplier,
                color: colorScheme.onErrorContainer,
              ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          if (onRetry != null) ...[
            SizedBox(width: ResponsiveUtils.value(12)),
            TextButton(
              onPressed: onRetry,
              style: TextButton.styleFrom(
                foregroundColor: colorScheme.onError,
                padding: EdgeInsets.symmetric(
                  horizontal: ResponsiveUtils.value(12),
                  vertical: ResponsiveUtils.value(4),
                ),
                minimumSize: Size.zero,
                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
              ),
              child: Text(
                '重试',
                style: TextStyle(fontSize: 14 * fontMultiplier),
              ),
            ),
          ],
        ],
      ),
    );
  }
}

/// 错误详情对话框组件，用于显示详细错误信息和日志
class ErrorDetailsDialog extends StatelessWidget {
  final AppError? error;
  final String? title;
  final String? description;
  
  const ErrorDetailsDialog({
    super.key,
    this.error,
    this.title,
    this.description,
  });
  
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final width = MediaQuery.sizeOf(context).width;
    final fontMultiplier = ResponsiveUtils.getFontSizeMultiplier(width);
    
    return AlertDialog(
      title: Row(
        children: [
          Icon(Icons.error_outline, color: colorScheme.error, size: ResponsiveUtils.getIconSize(width, baseSize: 24)),
          SizedBox(width: ResponsiveUtils.value(12)),
          Text(title ?? '错误详情', style: TextStyle(fontSize: (theme.textTheme.titleLarge?.fontSize ?? 22) * fontMultiplier)),
        ],
      ),
      content: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (description != null) ...[
              Text(description!, style: TextStyle(fontSize: 16 * fontMultiplier)),
              SizedBox(height: ResponsiveUtils.value(16)),
            ],
            if (error != null) ...[
              Text('错误消息:', style: theme.textTheme.titleSmall?.copyWith(
                fontWeight: FontWeight.bold,
                fontSize: (theme.textTheme.titleSmall?.fontSize ?? 14) * fontMultiplier,
              )),
              SizedBox(height: ResponsiveUtils.value(4)),
              Text(error!.message, style: TextStyle(fontSize: 14 * fontMultiplier)),
              SizedBox(height: ResponsiveUtils.value(16)),
              if (error!.userMessage != null && error!.userMessage != error!.message) ...[
                Text('用户提示:', style: theme.textTheme.titleSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                  fontSize: (theme.textTheme.titleSmall?.fontSize ?? 14) * fontMultiplier,
                )),
                SizedBox(height: ResponsiveUtils.value(4)),
                Text(error!.userMessage!, style: TextStyle(fontSize: 14 * fontMultiplier)),
                SizedBox(height: ResponsiveUtils.value(16)),
              ],
              if (error!.resolution != null) ...[
                Text('解决建议:', style: theme.textTheme.titleSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                  fontSize: (theme.textTheme.titleSmall?.fontSize ?? 14) * fontMultiplier,
                )),
                SizedBox(height: ResponsiveUtils.value(4)),
                Text(error!.resolution!, style: TextStyle(fontSize: 14 * fontMultiplier)),
                SizedBox(height: ResponsiveUtils.value(16)),
              ],
              if (error!.code.isNotEmpty) ...[
                Text('错误代码:', style: theme.textTheme.titleSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                  fontSize: (theme.textTheme.titleSmall?.fontSize ?? 14) * fontMultiplier,
                )),
                SizedBox(height: ResponsiveUtils.value(4)),
                Text(error!.code, style: TextStyle(fontSize: 14 * fontMultiplier)),
                SizedBox(height: ResponsiveUtils.value(16)),
              ],
            ],
            Text('错误类型:', style: theme.textTheme.titleSmall?.copyWith(
              fontWeight: FontWeight.bold,
              fontSize: (theme.textTheme.titleSmall?.fontSize ?? 14) * fontMultiplier,
            )),
            SizedBox(height: ResponsiveUtils.value(4)),
            Text(error?.code ?? '未知', style: TextStyle(fontSize: 14 * fontMultiplier)),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: Text('关闭', style: TextStyle(fontSize: 14 * fontMultiplier)),
        ),
        ElevatedButton(
          onPressed: () {
            // 可以添加复制日志或分享错误信息的功能
            Navigator.of(context).pop();
          },
          child: Text('复制日志', style: TextStyle(fontSize: 14 * fontMultiplier)),
        ),
      ],
    );
  }
}
