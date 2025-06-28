import 'package:flutter/material.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_text_styles.dart';
import 'custom_button.dart';

class EmptyState extends StatelessWidget {
  final String title;
  final String message;
  final Widget? icon;
  final String? buttonText;
  final VoidCallback? onButtonPressed;
  final double iconSize;
  
  const EmptyState({
    super.key,
    required this.title,
    required this.message,
    this.icon,
    this.buttonText,
    this.onButtonPressed,
    this.iconSize = 64,
  });
  
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            icon ?? Icon(
              Icons.inbox_outlined,
              size: iconSize,
              color: AppColors.grey,
            ),
            const SizedBox(height: 24),
            Text(
              title,
              style: AppTextStyles.h4.copyWith(
                color: AppColors.textSecondary,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(
              message,
              style: AppTextStyles.bodyMedium.copyWith(
                color: AppColors.textSecondary,
              ),
              textAlign: TextAlign.center,
            ),
            if (buttonText != null && onButtonPressed != null) ...[
              const SizedBox(height: 24),
              CustomButton(
                text: buttonText!,
                onPressed: onButtonPressed,
                type: ButtonType.outline,
                size: ButtonSize.medium,
                fullWidth: false,
              ),
            ],
          ],
        ),
      ),
    );
  }
}