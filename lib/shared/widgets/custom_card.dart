import 'package:flutter/material.dart';
import '../../core/constants/app_colors.dart';

class CustomCard extends StatelessWidget {
  final Widget child;
  final EdgeInsets? padding;
  final EdgeInsets? margin;
  final double? borderRadius;
  final Color? color;
  final double? elevation;
  final VoidCallback? onTap;
  final Border? border;
  
  const CustomCard({
    super.key,
    required this.child,
    this.padding,
    this.margin,
    this.borderRadius,
    this.color,
    this.elevation,
    this.onTap,
    this.border,
  });
  
  @override
  Widget build(BuildContext context) {
    Widget cardContent = Container(
      padding: padding ?? const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: color ?? AppColors.white,
        borderRadius: BorderRadius.circular(borderRadius ?? 12),
        border: border,
        boxShadow: [
          BoxShadow(
            color: AppColors.black.withValues(alpha: 0.08),
            blurRadius: elevation ?? 4,
            offset: Offset(0, (elevation ?? 4) / 2),
          ),
        ],
      ),
      child: child,
    );
    
    if (onTap != null) {
      cardContent = InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(borderRadius ?? 12),
        child: cardContent,
      );
    }
    
    return Container(
      margin: margin ?? const EdgeInsets.all(8),
      child: cardContent,
    );
  }
}