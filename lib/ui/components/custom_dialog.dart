import 'package:flutter/material.dart';
import '../styles/app_styles.dart';
import 'custom_button.dart';

class CustomDialog extends StatelessWidget {
  final String title;
  final Widget content;
  final List<Widget>? actions;
  final bool showCloseButton;
  final VoidCallback? onClose;
  final double? width;
  final double? maxHeight;
  final EdgeInsetsGeometry contentPadding;
  final EdgeInsetsGeometry titlePadding;
  final EdgeInsetsGeometry actionsPadding;
  final Color? backgroundColor;
  final IconData? icon;
  final Color? iconColor;
  final bool barrierDismissible;

  const CustomDialog({
    Key? key,
    required this.title,
    required this.content,
    this.actions,
    this.showCloseButton = true,
    this.onClose,
    this.width,
    this.maxHeight,
    this.contentPadding = const EdgeInsets.fromLTRB(24, 8, 24, 24),
    this.titlePadding = const EdgeInsets.fromLTRB(24, 24, 24, 8),
    this.actionsPadding = const EdgeInsets.fromLTRB(24, 8, 24, 24),
    this.backgroundColor,
    this.icon,
    this.iconColor,
    this.barrierDismissible = true,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      elevation: 0,
      backgroundColor: Colors.transparent,
      child: Container(
        width: width,
        constraints: BoxConstraints(
          maxWidth: width ?? 500,
          maxHeight: maxHeight ?? MediaQuery.of(context).size.height * 0.8,
        ),
        decoration: BoxDecoration(
          color: backgroundColor ?? AppStyles.bgCard,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.2),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
              padding: titlePadding,
              child: Row(
                children: [
                  if (icon != null) ...[
                    Icon(
                      icon,
                      color: iconColor ?? AppStyles.primaryColor,
                      size: 24,
                    ),
                    const SizedBox(width: 12),
                  ],
                  Expanded(
                    child: Text(
                      title,
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: AppStyles.textPrimary,
                      ),
                    ),
                  ),
                  if (showCloseButton)
                    IconButton(
                      icon: Icon(Icons.close, color: AppStyles.textSecondary),
                      onPressed: () {
                        if (onClose != null) {
                          onClose!();
                        } else {
                          Navigator.of(context).pop();
                        }
                      },
                    ),
                ],
              ),
            ),
            const Divider(height: 1),
            Flexible(
              child: SingleChildScrollView(
                padding: contentPadding,
                child: content,
              ),
            ),
            if (actions != null && actions!.isNotEmpty) ...[
              const Divider(height: 1),
              Padding(
                padding: actionsPadding,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children:
                      actions!.map((action) {
                        return Padding(
                          padding: const EdgeInsets.only(left: 8),
                          child: action,
                        );
                      }).toList(),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  // Helper method to show a confirmation dialog
  static Future<bool> showConfirmation({
    required BuildContext context,
    required String title,
    required String message,
    String confirmText = 'Ya',
    String cancelText = 'Batal',
    IconData? icon = Icons.help_outline,
    Color? iconColor,
    Color? confirmColor,
    bool barrierDismissible = true,
  }) async {
    final result = await showDialog<bool>(
      context: context,
      barrierDismissible: barrierDismissible,
      builder:
          (context) => CustomDialog(
            title: title,
            icon: icon,
            iconColor: iconColor ?? AppStyles.warningColor,
            content: Text(
              message,
              style: TextStyle(color: AppStyles.textPrimary),
            ),
            actions: [
              CustomButton(
                text: cancelText,
                onPressed: () => Navigator.of(context).pop(false),
                isOutlined: true,
                size: ButtonSize.small,
              ),
              CustomButton(
                text: confirmText,
                onPressed: () => Navigator.of(context).pop(true),
                backgroundColor: confirmColor ?? AppStyles.primaryColor,
                size: ButtonSize.small,
              ),
            ],
            barrierDismissible: barrierDismissible,
          ),
    );

    return result ?? false;
  }

  // Helper method to show a success dialog
  static Future<void> showSuccess({
    required BuildContext context,
    required String title,
    required String message,
    String buttonText = 'OK',
    VoidCallback? onPressed,
  }) async {
    await showDialog(
      context: context,
      builder:
          (context) => CustomDialog(
            title: title,
            icon: Icons.check_circle,
            iconColor: AppStyles.statusSuccess,
            content: Text(
              message,
              style: TextStyle(color: AppStyles.textPrimary),
            ),
            actions: [
              CustomButton(
                text: buttonText,
                onPressed: () {
                  Navigator.of(context).pop();
                  if (onPressed != null) {
                    onPressed();
                  }
                },
                backgroundColor: AppStyles.statusSuccess,
                size: ButtonSize.small,
              ),
            ],
          ),
    );
  }

  // Helper method to show an error dialog
  static Future<void> showError({
    required BuildContext context,
    required String title,
    required String message,
    String buttonText = 'OK',
  }) async {
    await showDialog(
      context: context,
      builder:
          (context) => CustomDialog(
            title: title,
            icon: Icons.error_outline,
            iconColor: AppStyles.statusError,
            content: Text(
              message,
              style: TextStyle(color: AppStyles.textPrimary),
            ),
            actions: [
              CustomButton(
                text: buttonText,
                onPressed: () => Navigator.of(context).pop(),
                backgroundColor: AppStyles.statusError,
                size: ButtonSize.small,
              ),
            ],
          ),
    );
  }
}
