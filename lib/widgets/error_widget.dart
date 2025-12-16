import 'package:flutter/material.dart';
import 'package:time_widgets/utils/error_handler.dart';

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
    final effectiveFontSize = fontSize ?? 14.0;
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    
    return Container(
      padding: EdgeInsets.all(effectiveFontSize * 1.5),
      decoration: BoxDecoration(
        color: colorScheme.errorContainer.withAlpha(229),
        borderRadius: BorderRadius.circular(16.0),
        border: Border.all(
          color: colorScheme.error.withAlpha(128),
          width: 1.0,
        ),
        boxShadow: [
          BoxShadow(
            color: colorScheme.shadow.withAlpha(25),
            blurRadius: 8,
            offset: const Offset(0, 2),
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
                borderRadius: BorderRadius.circular(8),
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
                      borderRadius: BorderRadius.circular(8),
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
                      borderRadius: BorderRadius.circular(8),
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
    
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: colorScheme.errorContainer,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: colorScheme.error.withAlpha(128),
          width: 1.0,
        ),
        boxShadow: [
          BoxShadow(
            color: colorScheme.shadow.withAlpha(38),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.error_outline,
            color: colorScheme.error,
            size: 20,
          ),
          const SizedBox(width: 8),
          Flexible(
            child: Text(
              message,
              style: TextStyle(
                fontSize: 14,
                color: colorScheme.onErrorContainer,
              ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          if (onRetry != null) ...[
            const SizedBox(width: 12),
            TextButton(
              onPressed: onRetry,
              style: TextButton.styleFrom(
                foregroundColor: colorScheme.onError,
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                minimumSize: Size.zero,
                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
              ),
              child: const Text('重试'),
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
    
    return AlertDialog(
      title: Row(
        children: [
          Icon(Icons.error_outline, color: colorScheme.error),
          const SizedBox(width: 12),
          Text(title ?? '错误详情'),
        ],
      ),
      content: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (description != null) ...[
              Text(description!),
              const SizedBox(height: 16),
            ],
            if (error != null) ...[
              Text('错误消息:', style: theme.textTheme.titleSmall?.copyWith(
                fontWeight: FontWeight.bold,
              )),
              const SizedBox(height: 4),
              Text(error!.message),
              const SizedBox(height: 16),
              if (error!.userMessage != null && error!.userMessage != error!.message) ...[
                Text('用户提示:', style: theme.textTheme.titleSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                )),
                const SizedBox(height: 4),
                Text(error!.userMessage!),
                const SizedBox(height: 16),
              ],
              if (error!.resolution != null) ...[
                Text('解决建议:', style: theme.textTheme.titleSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                )),
                const SizedBox(height: 4),
                Text(error!.resolution!),
                const SizedBox(height: 16),
              ],
              if (error!.code.isNotEmpty) ...[
                Text('错误代码:', style: theme.textTheme.titleSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                )),
                const SizedBox(height: 4),
                Text(error!.code),
                const SizedBox(height: 16),
              ],
            ],
            Text('错误类型:', style: theme.textTheme.titleSmall?.copyWith(
              fontWeight: FontWeight.bold,
            )),
            const SizedBox(height: 4),
            Text(error?.code ?? '未知'),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: const Text('关闭'),
        ),
        ElevatedButton(
          onPressed: () {
            // 可以添加复制日志或分享错误信息的功能
            Navigator.of(context).pop();
          },
          child: const Text('复制日志'),
        ),
      ],
    );
  }
}