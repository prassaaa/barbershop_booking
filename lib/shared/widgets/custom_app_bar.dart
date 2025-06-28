import 'package:flutter/material.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_text_styles.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final String? subtitle;
  final List<Widget>? actions;
  final Widget? leading;
  final bool centerTitle;
  final bool showBackButton;
  final Color? backgroundColor;
  final Color? foregroundColor;
  final double elevation;
  final VoidCallback? onBackPressed;
  
  const CustomAppBar({
    super.key,
    required this.title,
    this.subtitle,
    this.actions,
    this.leading,
    this.centerTitle = true,
    this.showBackButton = true,
    this.backgroundColor,
    this.foregroundColor,
    this.elevation = 0,
    this.onBackPressed,
  });
  
  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: subtitle != null
          ? Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  title,
                  style: AppTextStyles.h5.copyWith(
                    color: foregroundColor ?? AppColors.white,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  subtitle!,
                  style: AppTextStyles.bodySmall.copyWith(
                    color: (foregroundColor ?? AppColors.white).withValues(alpha: 0.8),
                  ),
                ),
              ],
            )
          : Text(
              title,
              style: AppTextStyles.h5.copyWith(
                color: foregroundColor ?? AppColors.white,
              ),
            ),
      centerTitle: centerTitle,
      backgroundColor: backgroundColor ?? AppColors.primary,
      foregroundColor: foregroundColor ?? AppColors.white,
      elevation: elevation,
      actions: actions,
      leading: leading ?? (showBackButton && Navigator.canPop(context) 
          ? IconButton(
              icon: const Icon(Icons.arrow_back_ios),
              onPressed: onBackPressed ?? () => Navigator.pop(context),
            )
          : null),
    );
  }
  
  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}