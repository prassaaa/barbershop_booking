import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_text_styles.dart';
import '../../../../shared/widgets/custom_card.dart';
import '../../../../shared/widgets/custom_button.dart';

class QuickBookingCard extends StatelessWidget {
  const QuickBookingCard({super.key});

  @override
  Widget build(BuildContext context) {
    return CustomCard(
      color: AppColors.secondary.withValues(alpha: 0.05),
      border: Border.all(
        color: AppColors.secondary.withValues(alpha: 0.2),
        width: 1,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 56,
                height: 56,
                decoration: BoxDecoration(
                  color: AppColors.secondary.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: const Icon(
                  Icons.flash_on,
                  color: AppColors.secondary,
                  size: 28,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Quick Booking',
                      style: AppTextStyles.h6.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Book your favorite service in just 2 taps',
                      style: AppTextStyles.bodyMedium.copyWith(
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          
          const SizedBox(height: 20),
          
          Row(
            children: [
              Expanded(
                child: CustomButton(
                  text: 'Hair Cut',
                  onPressed: () {
                    // Quick book hair cut
                  },
                  type: ButtonType.outline,
                  size: ButtonSize.small,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: CustomButton(
                  text: 'Full Service',
                  onPressed: () {
                    // Navigate to booking page
                  },
                  size: ButtonSize.small,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}