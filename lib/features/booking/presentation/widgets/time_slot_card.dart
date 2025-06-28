import 'package:flutter/material.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_text_styles.dart';

class TimeSlotCard extends StatelessWidget {
  final String timeSlot;
  final bool isSelected;
  final VoidCallback onTap;

  const TimeSlotCard({
    super.key,
    required this.timeSlot,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      elevation: isSelected ? 4 : 1,
      borderRadius: BorderRadius.circular(12),
      color: isSelected ? AppColors.primary : Colors.white,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Container(
          padding: const EdgeInsets.symmetric(
            horizontal: 20,
            vertical: 16,
          ),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: isSelected ? AppColors.primary : Colors.grey.shade300,
              width: isSelected ? 2 : 1,
            ),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.access_time,
                size: 18,
                color: isSelected ? Colors.white : AppColors.textSecondary,
              ),
              const SizedBox(width: 8),
              Text(
                timeSlot,
                style: AppTextStyles.bodyMedium.copyWith(
                  color: isSelected ? Colors.white : AppColors.textPrimary,
                  fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
