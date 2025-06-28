import 'package:flutter/material.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_text_styles.dart';
import '../../../../shared/models/barber_model.dart';
import '../../../../shared/widgets/cached_network_image_widget.dart';

class BarberSelectionCard extends StatelessWidget {
  final BarberModel barber;
  final bool isSelected;
  final VoidCallback onTap;

  const BarberSelectionCard({
    super.key,
    required this.barber,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: isSelected ? 8 : 2,
      color: isSelected ? AppColors.primary.withValues(alpha: 0.1) : Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(
          color: isSelected ? AppColors.primary : Colors.grey.shade300,
          width: isSelected ? 2 : 1,
        ),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              // Barber Avatar
              Container(
                width: 60,
                height: 60,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: isSelected ? AppColors.primary : Colors.grey.shade300,
                    width: 2,
                  ),
                ),
                child: ClipOval(
                  child: CachedNetworkImageWidget(
                    imageUrl: barber.profileImage ?? '',
                    width: 56,
                    height: 56,
                    placeholder: Container(
                      color: AppColors.surface,
                      child: Icon(
                        Icons.person,
                        size: 32,
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ),
                ),
              ),
              
              const SizedBox(width: 16),
              
              // Barber Info
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      barber.name,
                      style: AppTextStyles.h4.copyWith(
                        color: isSelected ? AppColors.primary : AppColors.textPrimary,
                        fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                      ),
                    ),
                    
                    const SizedBox(height: 4),
                    
                    if (barber.specialties.isNotEmpty)
                      Text(
                        barber.specialties.join(', '),
                        style: AppTextStyles.bodySmall.copyWith(
                          color: AppColors.textSecondary,
                        ),
                      ),
                    
                    const SizedBox(height: 8),
                    
                    // Rating and Experience
                    Row(
                      children: [
                        Icon(
                          Icons.star,
                          size: 16,
                          color: AppColors.warning,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          barber.rating.toStringAsFixed(1),
                          style: AppTextStyles.bodySmall.copyWith(
                            color: AppColors.textPrimary,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        
                        const SizedBox(width: 16),
                        
                        Icon(
                          Icons.work_outline,
                          size: 16,
                          color: AppColors.textSecondary,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          '${barber.experienceYears} years',
                          style: AppTextStyles.bodySmall.copyWith(
                            color: AppColors.textSecondary,
                          ),
                        ),
                      ],
                    ),
                    
                    // Availability indicator
                    if (barber.isAvailable)
                      Padding(
                        padding: const EdgeInsets.only(top: 8),
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: AppColors.success.withValues(alpha: 0.1),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text(
                            'Available',
                            style: AppTextStyles.bodySmall.copyWith(
                              color: AppColors.success,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ),
                  ],
                ),
              ),
              
              // Selection Indicator
              if (isSelected)
                Container(
                  width: 24,
                  height: 24,
                  decoration: BoxDecoration(
                    color: AppColors.primary,
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.check,
                    color: Colors.white,
                    size: 16,
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
