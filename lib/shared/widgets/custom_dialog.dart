import 'package:flutter/material.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_text_styles.dart';
import 'custom_button.dart';

class CustomDialog {
  static Future<void> showInfo({
    required BuildContext context,
    required String title,
    required String message,
    String buttonText = 'OK',
    VoidCallback? onConfirm,
  }) {
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          title: Text(
            title,
            style: AppTextStyles.h5,
          ),
          content: Text(
            message,
            style: AppTextStyles.bodyMedium,
          ),
          actions: [
            CustomButton(
              text: buttonText,
              onPressed: () {
                Navigator.of(context).pop();
                onConfirm?.call();
              },
              type: ButtonType.primary,
              size: ButtonSize.small,
            ),
          ],
        );
      },
    );
  }
  
  static Future<bool?> showConfirmation({
    required BuildContext context,
    required String title,
    required String message,
    String confirmText = 'Yes',
    String cancelText = 'Cancel',
    ButtonType confirmType = ButtonType.primary,
  }) {
    return showDialog<bool>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          title: Text(
            title,
            style: AppTextStyles.h5,
          ),
          content: Text(
            message,
            style: AppTextStyles.bodyMedium,
          ),
          actions: [
            CustomButton(
              text: cancelText,
              onPressed: () => Navigator.of(context).pop(false),
              type: ButtonType.outline,
              size: ButtonSize.small,
              fullWidth: false,
            ),
            const SizedBox(width: 8),
            CustomButton(
              text: confirmText,
              onPressed: () => Navigator.of(context).pop(true),
              type: confirmType,
              size: ButtonSize.small,
              fullWidth: false,
            ),
          ],
        );
      },
    );
  }  
  static Future<void> showError({
    required BuildContext context,
    required String title,
    required String message,
    String buttonText = 'OK',
  }) {
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          title: Row(
            children: [
              const Icon(
                Icons.error_outline,
                color: AppColors.error,
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  title,
                  style: AppTextStyles.h5.copyWith(color: AppColors.error),
                ),
              ),
            ],
          ),
          content: Text(
            message,
            style: AppTextStyles.bodyMedium,
          ),
          actions: [
            CustomButton(
              text: buttonText,
              onPressed: () => Navigator.of(context).pop(),
              type: ButtonType.primary,
              size: ButtonSize.small,
            ),
          ],
        );
      },
    );
  }
  
  static Future<void> showSuccess({
    required BuildContext context,
    required String title,
    required String message,
    String buttonText = 'OK',
    VoidCallback? onConfirm,
  }) {
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          title: Row(
            children: [
              const Icon(
                Icons.check_circle_outline,
                color: AppColors.success,
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  title,
                  style: AppTextStyles.h5.copyWith(color: AppColors.success),
                ),
              ),
            ],
          ),
          content: Text(
            message,
            style: AppTextStyles.bodyMedium,
          ),
          actions: [
            CustomButton(
              text: buttonText,
              onPressed: () {
                Navigator.of(context).pop();
                onConfirm?.call();
              },
              type: ButtonType.primary,
              size: ButtonSize.small,
            ),
          ],
        );
      },
    );
  }
}