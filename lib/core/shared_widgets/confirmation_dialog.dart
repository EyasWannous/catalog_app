import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

class ConfirmationDialog extends StatelessWidget {
  final String title;
  final String message;
  final String? confirmText;
  final String? cancelText;
  final VoidCallback? onConfirm;
  final VoidCallback? onCancel;
  final Color? confirmButtonColor;
  final Color? cancelButtonColor;
  final IconData? icon;
  final Color? iconColor;
  final bool isDestructive;

  const ConfirmationDialog({
    super.key,
    required this.title,
    required this.message,
    this.confirmText,
    this.cancelText,
    this.onConfirm,
    this.onCancel,
    this.confirmButtonColor,
    this.cancelButtonColor,
    this.icon,
    this.iconColor,
    this.isDestructive = false,
  });

  static Future<bool?> show({
    required BuildContext context,
    required String title,
    required String message,
    String? confirmText,
    String? cancelText,
    Color? confirmButtonColor,
    IconData? icon,
    Color? iconColor,
    bool isDestructive = false,
  }) {
    return showDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return ConfirmationDialog(
          title: title,
          message: message,
          confirmText: confirmText,
          cancelText: cancelText,
          confirmButtonColor: confirmButtonColor,
          icon: icon,
          iconColor: iconColor,
          isDestructive: isDestructive,
          onConfirm: () => Navigator.of(context).pop(true),
          onCancel: () => Navigator.of(context).pop(false),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final effectiveConfirmButtonColor = confirmButtonColor ??
        (isDestructive ? Colors.red : theme.primaryColor);

    return AlertDialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      title: Row(
        children: [
          if (icon != null) ...[
            Icon(
              icon,
              color: iconColor ?? 
                  (isDestructive ? Colors.red : theme.primaryColor),
              size: 28,
            ),
            const SizedBox(width: 12),
          ],
          Expanded(
            child: Text(
              title.tr(),
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: Colors.grey[800],
              ),
            ),
          ),
        ],
      ),
      content: Text(
        message.tr(),
        style: TextStyle(
          fontSize: 16,
          color: Colors.grey[700],
          height: 1.4,
        ),
      ),
      actions: [
        TextButton(
          onPressed: onCancel ?? () => Navigator.of(context).pop(false),
          style: TextButton.styleFrom(
            foregroundColor: cancelButtonColor ?? Colors.grey[600],
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
          ),
          child: Text(
            cancelText?.tr() ?? 'Cancel'.tr(),
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
        ElevatedButton(
          onPressed: onConfirm ?? () => Navigator.of(context).pop(true),
          style: ElevatedButton.styleFrom(
            backgroundColor: effectiveConfirmButtonColor,
            foregroundColor: Colors.white,
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
          child: Text(
            confirmText?.tr() ?? 'Confirm'.tr(),
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ],
    );
  }
}

class ConfirmationDialogVariants {
  static Future<bool?> delete({
    required BuildContext context,
    required String itemName,
    String? message,
  }) {
    return ConfirmationDialog.show(
      context: context,
      title: 'Delete $itemName',
      message: message ?? 'Are you sure you want to delete this $itemName? This action cannot be undone.',
      confirmText: 'Delete',
      icon: Icons.delete_outline,
      isDestructive: true,
    );
  }

  static Future<bool?> save({
    required BuildContext context,
    String? title,
    String? message,
  }) {
    return ConfirmationDialog.show(
      context: context,
      title: title ?? 'Save Changes',
      message: message ?? 'Do you want to save your changes?',
      confirmText: 'Save',
      icon: Icons.save_outlined,
    );
  }

  static Future<bool?> discard({
    required BuildContext context,
    String? title,
    String? message,
  }) {
    return ConfirmationDialog.show(
      context: context,
      title: title ?? 'Discard Changes',
      message: message ?? 'Are you sure you want to discard your changes? All unsaved changes will be lost.',
      confirmText: 'Discard',
      icon: Icons.close,
      isDestructive: true,
    );
  }

  static Future<bool?> logout({
    required BuildContext context,
    String? message,
  }) {
    return ConfirmationDialog.show(
      context: context,
      title: 'Logout',
      message: message ?? 'Are you sure you want to logout?',
      confirmText: 'Logout',
      icon: Icons.logout,
    );
  }

  static Future<bool?> clear({
    required BuildContext context,
    required String itemName,
    String? message,
  }) {
    return ConfirmationDialog.show(
      context: context,
      title: 'Clear $itemName',
      message: message ?? 'Are you sure you want to clear all $itemName?',
      confirmText: 'Clear',
      icon: Icons.clear_all,
      isDestructive: true,
    );
  }

  static Future<bool?> custom({
    required BuildContext context,
    required String title,
    required String message,
    String? confirmText,
    String? cancelText,
    IconData? icon,
    bool isDestructive = false,
  }) {
    return ConfirmationDialog.show(
      context: context,
      title: title,
      message: message,
      confirmText: confirmText,
      cancelText: cancelText,
      icon: icon,
      isDestructive: isDestructive,
    );
  }
}
