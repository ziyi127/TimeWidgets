import 'package:flutter/material.dart';
import 'md3_button_styles.dart';
import 'md3_typography_styles.dart';

/// Material Design 3 Dialog 样式工具�?
/// 提供统一�?MD3 Dialog 样式和变�?
class MD3DialogStyles {
  /// MD3 标准圆角半径
  static const double _cornerRadius = 28.0;
  
  /// MD3 标准内边�?
  static const EdgeInsets _contentPadding = EdgeInsets.fromLTRB(24, 16, 24, 0);
  static const EdgeInsets _actionsPadding = EdgeInsets.fromLTRB(24, 16, 24, 24);
  
  /// 标准 MD3 对话�?
  static Widget dialog({
    required BuildContext context,
    required String title,
    required Widget content,
    required List<Widget> actions,
    Widget? icon,
    bool scrollable = false,
  }) {
    final colorScheme = Theme.of(context).colorScheme;
    
    return AlertDialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(_cornerRadius),
      ),
      backgroundColor: colorScheme.surfaceContainerHigh,
      surfaceTintColor: colorScheme.surfaceTint,
      icon: icon,
      title: Text(
        title,
        style: MD3TypographyStyles.headlineSmall(context),
      ),
      content: scrollable
          ? SingleChildScrollView(child: content)
          : content,
      contentPadding: _contentPadding,
      actionsPadding: _actionsPadding,
      actionsAlignment: MainAxisAlignment.end,
      actions: _buildActionsWithSpacing(actions),
    );
  }

  /// 确认对话�?
  static Future<bool?> showConfirmDialog({
    required BuildContext context,
    required String title,
    required String message,
    String confirmText = '确定',
    String cancelText = '取消',
    bool isDestructive = false,
    Widget? icon,
  }) {
    final colorScheme = Theme.of(context).colorScheme;
    
    return showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(_cornerRadius),
        ),
        backgroundColor: colorScheme.surfaceContainerHigh,
        surfaceTintColor: colorScheme.surfaceTint,
        icon: icon,
        title: Text(
          title,
          style: MD3TypographyStyles.headlineSmall(context),
        ),
        content: Text(
          message,
          style: MD3TypographyStyles.bodyMedium(context),
        ),
        contentPadding: _contentPadding,
        actionsPadding: _actionsPadding,
        actionsAlignment: MainAxisAlignment.end,
        actions: [
          MD3ButtonStyles.text(
            onPressed: () => Navigator.of(context).pop(false),
            child: Text(cancelText),
          ),
          const SizedBox(width: 8),
          isDestructive
              ? FilledButton(
                  onPressed: () => Navigator.of(context).pop(true),
                  style: FilledButton.styleFrom(
                    backgroundColor: colorScheme.error,
                    foregroundColor: colorScheme.onError,
                  ),
                  child: Text(confirmText),
                )
              : MD3ButtonStyles.filled(
                  onPressed: () => Navigator.of(context).pop(true),
                  child: Text(confirmText),
                ),
        ],
      ),
    );
  }

  /// 删除确认对话�?
  static Future<bool?> showDeleteConfirmDialog({
    required BuildContext context,
    required String itemName,
    String? additionalMessage,
  }) {
    return showConfirmDialog(
      context: context,
      title: '确认删除',
      message: additionalMessage ?? '确定要删�?$itemName"吗？此操作无法撤销�?,
      confirmText: '删除',
      cancelText: '取消',
      isDestructive: true,
      icon: Icon(
        Icons.delete_outline,
        color: Theme.of(context).colorScheme.error,
      ),
    );
  }

  /// 全屏对话�?(用于复杂编辑)
  static Future<T?> showFullScreenDialog<T>({
    required BuildContext context,
    required String title,
    required Widget content,
    VoidCallback? onSave,
    String saveText = '保存',
    bool showSaveButton = true,
  }) {
    return showDialog<T>(
      context: context,
      builder: (context) => _FullScreenDialog(
        title: title,
        content: content,
        onSave: onSave,
        saveText: saveText,
        showSaveButton: showSaveButton,
      ),
    );
  }

  /// 输入对话�?
  static Future<String?> showInputDialog({
    required BuildContext context,
    required String title,
    String? initialValue,
    String? hintText,
    String? labelText,
    String confirmText = '确定',
    String cancelText = '取消',
    FormFieldValidator<String>? validator,
    int maxLines = 1,
  }) {
    final controller = TextEditingController(text: initialValue);
    final formKey = GlobalKey<FormState>();
    
    return showDialog<String>(
      context: context,
      builder: (context) {
        final colorScheme = Theme.of(context).colorScheme;
        
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(_cornerRadius),
          ),
          backgroundColor: colorScheme.surfaceContainerHigh,
          surfaceTintColor: colorScheme.surfaceTint,
          title: Text(
            title,
            style: MD3TypographyStyles.headlineSmall(context),
          ),
          content: Form(
            key: formKey,
            child: TextFormField(
              controller: controller,
              decoration: InputDecoration(
                hintText: hintText,
                labelText: labelText,
                border: const OutlineInputBorder(),
              ),
              maxLines: maxLines,
              validator: validator,
              autofocus: true,
            ),
          ),
          contentPadding: _contentPadding,
          actionsPadding: _actionsPadding,
          actionsAlignment: MainAxisAlignment.end,
          actions: [
            MD3ButtonStyles.text(
              onPressed: () => Navigator.of(context).pop(null),
              child: Text(cancelText),
            ),
            const SizedBox(width: 8),
            MD3ButtonStyles.filled(
              onPressed: () {
                if (formKey.currentState?.validate() ?? false) {
                  Navigator.of(context).pop(controller.text);
                }
              },
              child: Text(confirmText),
            ),
          ],
        );
      },
    );
  }

  /// 选择对话�?
  static Future<T?> showSelectionDialog<T>({
    required BuildContext context,
    required String title,
    required List<SelectionDialogItem<T>> items,
    T? selectedValue,
  }) {
    return showDialog<T>(
      context: context,
      builder: (context) {
        final colorScheme = Theme.of(context).colorScheme;
        
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(_cornerRadius),
          ),
          backgroundColor: colorScheme.surfaceContainerHigh,
          surfaceTintColor: colorScheme.surfaceTint,
          title: Text(
            title,
            style: MD3TypographyStyles.headlineSmall(context),
          ),
          contentPadding: const EdgeInsets.symmetric(vertical: 16),
          content: SizedBox(
            width: double.maxFinite,
            child: ListView.builder(
              shrinkWrap: true,
              itemCount: items.length,
              itemBuilder: (context, index) {
                final item = items[index];
                final isSelected = item.value == selectedValue;
                
                return ListTile(
                  leading: item.icon,
                  title: Text(item.title),
                  subtitle: item.subtitle != null ? Text(item.subtitle!) : null,
                  selected: isSelected,
                  selectedTileColor: colorScheme.secondaryContainer,
                  trailing: isSelected
                      ? Icon(Icons.check, color: colorScheme.primary)
                      : null,
                  onTap: () => Navigator.of(context).pop(item.value),
                );
              },
            ),
          ),
        );
      },
    );
  }

  /// 构建带间距的操作按钮列表
  static List<Widget> _buildActionsWithSpacing(List<Widget> actions) {
    if (actions.isEmpty) return actions;
    
    final result = <Widget>[];
    for (var i = 0; i < actions.length; i++) {
      result.add(actions[i]);
      if (i < actions.length - 1) {
        result.add(const SizedBox(width: 8));
      }
    }
    return result;
  }
}

/// 全屏对话框组�?
class _FullScreenDialog extends StatelessWidget {
  final String title;
  final Widget content;
  final VoidCallback? onSave;
  final String saveText;
  final bool showSaveButton;

  const _FullScreenDialog({
    required this.title,
    required this.content,
    this.onSave,
    this.saveText = '保存',
    this.showSaveButton = true,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    
    return Dialog.fullscreen(
      backgroundColor: colorScheme.surface,
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          backgroundColor: colorScheme.surface,
          leading: IconButton(
            icon: const Icon(Icons.close),
            onPressed: () => Navigator.of(context).pop(),
          ),
          title: Text(
            title,
            style: MD3TypographyStyles.titleLarge(context),
          ),
          actions: showSaveButton
              ? [
                  Padding(
                    padding: const EdgeInsets.only(right: 8),
                    child: MD3ButtonStyles.filledTonal(
                      onPressed: onSave ?? () => Navigator.of(context).pop(),
                      child: Text(saveText),
                    ),
                  ),
                ]
              : null,
        ),
        body: content,
      ),
    );
  }
}

/// 选择对话框项
class SelectionDialogItem<T> {
  final T value;
  final String title;
  final String? subtitle;
  final Widget? icon;

  const SelectionDialogItem({
    required this.value,
    required this.title,
    this.subtitle,
    this.icon,
  });
}
