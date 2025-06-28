import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_text_styles.dart';

class ScheduleQuickActions extends ConsumerWidget {
  const ScheduleQuickActions({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
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
            
            // Quick Action Buttons
            GridView.count(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              crossAxisCount: 2,
              crossAxisSpacing: 12,
              mainAxisSpacing: 12,
              childAspectRatio: 2.5,
              children: [
                _buildQuickActionButton(
                  icon: Icons.toggle_on,
                  title: 'Toggle Today',
                  subtitle: 'Turn work ON/OFF for today',
                  color: AppColors.primary,
                  onTap: () => _toggleToday(context),
                ),
                
                _buildQuickActionButton(
                  icon: Icons.coffee,
                  title: 'Take Break',
                  subtitle: 'Start/end break time',
                  color: AppColors.warning,
                  onTap: () => _takeBreak(context),
                ),
                
                _buildQuickActionButton(
                  icon: Icons.calendar_view_week,
                  title: 'Copy Week',
                  subtitle: 'Duplicate this week\'s schedule',
                  color: AppColors.info,
                  onTap: () => _copyWeekSchedule(context),
                ),
                
                _buildQuickActionButton(
                  icon: Icons.refresh,
                  title: 'Reset',
                  subtitle: 'Reset to default schedule',
                  color: AppColors.error,
                  onTap: () => _resetSchedule(context),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildQuickActionButton({
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
              Row(
                children: [
                  Icon(
                    icon,
                    color: color,
                    size: 20,
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      title,
                      style: AppTextStyles.bodyMedium.copyWith(
                        fontWeight: FontWeight.w600,
                        color: AppColors.textPrimary,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 4),
              Text(
                subtitle,
                style: AppTextStyles.bodySmall.copyWith(
                  color: AppColors.textSecondary,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _toggleToday(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Toggle Today\'s Schedule'),
        content: const Text(
          'Do you want to turn your work status ON or OFF for today?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              // TODO: Set today to OFF
              Navigator.pop(context);
              _showSnackBar(context, 'Today set to OFF', AppColors.error);
            },
            child: Text(
              'Turn OFF',
              style: TextStyle(color: AppColors.error),
            ),
          ),
          ElevatedButton(
            onPressed: () {
              // TODO: Set today to ON
              Navigator.pop(context);
              _showSnackBar(context, 'Today set to ON', AppColors.success);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.success,
            ),
            child: const Text('Turn ON'),
          ),
        ],
      ),
    );
  }

  void _takeBreak(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Break Time'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text('What would you like to do?'),
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: () {
                  Navigator.pop(context);
                  _showBreakStartDialog(context);
                },
                icon: const Icon(Icons.play_arrow),
                label: const Text('Start Break'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.warning,
                ),
              ),
            ),
            const SizedBox(height: 8),
            SizedBox(
              width: double.infinity,
              child: OutlinedButton.icon(
                onPressed: () {
                  Navigator.pop(context);
                  // TODO: End current break
                  _showSnackBar(context, 'Break ended', AppColors.success);
                },
                icon: const Icon(Icons.stop),
                label: const Text('End Break'),
                style: OutlinedButton.styleFrom(
                  foregroundColor: AppColors.success,
                  side: BorderSide(color: AppColors.success),
                ),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
        ],
      ),
    );
  }

  void _showBreakStartDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Start Break'),
        content: const Text('How long will your break be?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              // TODO: Start 15 min break
              _showSnackBar(context, '15 minute break started', AppColors.warning);
            },
            child: const Text('15 min'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              // TODO: Start 30 min break
              _showSnackBar(context, '30 minute break started', AppColors.warning);
            },
            child: const Text('30 min'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              // TODO: Start 60 min break
              _showSnackBar(context, '1 hour break started', AppColors.warning);
            },
            child: const Text('1 hour'),
          ),
        ],
      ),
    );
  }

  void _copyWeekSchedule(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Copy Week Schedule'),
        content: const Text(
          'This will copy your current week\'s schedule to next week. Continue?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              // TODO: Implement copy week logic
              _showSnackBar(context, 'Schedule copied to next week', AppColors.success);
            },
            child: const Text('Copy'),
          ),
        ],
      ),
    );
  }

  void _resetSchedule(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Reset Schedule'),
        content: const Text(
          'This will reset your schedule to the default (Monday-Saturday, 9AM-5PM). This action cannot be undone.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              // TODO: Implement reset logic
              _showSnackBar(context, 'Schedule reset to default', AppColors.info);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.error,
            ),
            child: const Text('Reset'),
          ),
        ],
      ),
    );
  }

  void _showSnackBar(BuildContext context, String message, Color color) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: color,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }
}
