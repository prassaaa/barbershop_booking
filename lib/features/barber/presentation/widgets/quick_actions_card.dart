import 'package:flutter/material.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_text_styles.dart';

class QuickActionsCard extends StatelessWidget {
  const QuickActionsCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Quick Actions',
              style: AppTextStyles.h5.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
            
            const SizedBox(height: 16),
            
            // Actions Grid
            GridView.count(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              crossAxisCount: 2,
              crossAxisSpacing: 12,
              mainAxisSpacing: 12,
              childAspectRatio: 1.8,
              children: [
                _buildActionItem(
                  icon: Icons.schedule,
                  title: 'Manage Schedule',
                  subtitle: 'Edit working hours',
                  color: AppColors.primary,
                  onTap: () {
                    Navigator.pushNamed(context, '/barber/schedule');
                  },
                ),
                
                _buildActionItem(
                  icon: Icons.list_alt,
                  title: 'View Bookings',
                  subtitle: 'Today\'s appointments',
                  color: AppColors.info,
                  onTap: () {
                    Navigator.pushNamed(context, '/barber/bookings');
                  },
                ),
                
                _buildActionItem(
                  icon: Icons.person,
                  title: 'Profile',
                  subtitle: 'Update bio & photo',
                  color: AppColors.success,
                  onTap: () {
                    Navigator.pushNamed(context, '/barber/profile');
                  },
                ),
                
                _buildActionItem(
                  icon: Icons.analytics,
                  title: 'Performance',
                  subtitle: 'View analytics',
                  color: AppColors.warning,
                  onTap: () {
                    // TODO: Navigate to analytics
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildActionItem({
    required IconData icon,
    required String title,
    required String subtitle,
    required Color color,
    required VoidCallback onTap,
  }) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(8),
        child: Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: color.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(8),
            border: Border.all(
              color: color.withValues(alpha: 0.3),
              width: 1,
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                icon,
                color: color,
                size: 24,
              ),
              const SizedBox(height: 8),
              Text(
                title,
                style: AppTextStyles.bodyMedium.copyWith(
                  fontWeight: FontWeight.w600,
                  color: AppColors.textPrimary,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                subtitle,
                style: AppTextStyles.bodySmall.copyWith(
                  color: AppColors.textSecondary,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
