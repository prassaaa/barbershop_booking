import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_text_styles.dart';
import '../../../../shared/widgets/custom_app_bar.dart';
import '../widgets/dashboard_stats_card.dart';
import '../widgets/today_schedule_card.dart';
import '../widgets/quick_actions_card.dart';
import '../widgets/upcoming_bookings_card.dart';

class BarberDashboardPage extends ConsumerWidget {
  const BarberDashboardPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // TODO: Get current barber from auth
    // final currentBarberId = 'temp_barber_id';

    return Scaffold(
      appBar: const CustomAppBar(
        title: 'Barber Dashboard',
        showBackButton: false,
        actions: [
          IconButton(
            onPressed: null, // TODO: Navigate to notifications
            icon: Icon(Icons.notifications_outlined),
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          // TODO: Refresh dashboard data
        },
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Welcome Section
              _buildWelcomeSection(),
              
              const SizedBox(height: 24),
              
              // Today's Schedule Card
              const TodayScheduleCard(),
              
              const SizedBox(height: 16),
              
              // Quick Actions
              const QuickActionsCard(),
              
              const SizedBox(height: 16),
              
              // Dashboard Stats
              const DashboardStatsCard(),
              
              const SizedBox(height: 16),
              
              // Upcoming Bookings
              const UpcomingBookingsCard(),
              
              const SizedBox(height: 16),
              
              // Weekly Schedule Overview
              _buildWeeklyScheduleSection(context),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildWelcomeSection() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            AppColors.primary,
            AppColors.primary.withValues(alpha: 0.8),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withValues(alpha: 0.3),
            blurRadius: 10,
            spreadRadius: 2,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Welcome back!',
            style: AppTextStyles.bodyMedium.copyWith(
              color: Colors.white.withValues(alpha: 0.9),
            ),
          ),
          const SizedBox(height: 4),
          Text(
            'John Doe', // TODO: Get barber name from auth
            style: AppTextStyles.h3.copyWith(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Icon(
                Icons.today,
                color: Colors.white.withValues(alpha: 0.9),
                size: 16,
              ),
              const SizedBox(width: 8),
              Text(
                _getTodayDateString(),
                style: AppTextStyles.bodySmall.copyWith(
                  color: Colors.white.withValues(alpha: 0.9),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildWeeklyScheduleSection(BuildContext context) {
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
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Weekly Schedule',
                  style: AppTextStyles.h5.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                TextButton.icon(
                  onPressed: () {
                    Navigator.pushNamed(context, '/barber/schedule');
                  },
                  icon: const Icon(Icons.edit, size: 16),
                  label: const Text('Manage'),
                ),
              ],
            ),
            
            const SizedBox(height: 16),
            
            // Weekly Schedule Grid
            _buildWeeklyScheduleGrid(context),
          ],
        ),
      ),
    );
  }

  Widget _buildWeeklyScheduleGrid(BuildContext context) {
    final days = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
    
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 7,
        crossAxisSpacing: 8,
        mainAxisSpacing: 8,
        childAspectRatio: 0.8,
      ),
      itemCount: days.length,
      itemBuilder: (context, index) {
        final day = days[index];
        final isToday = _isToday(index);
        final isWorking = _isWorkingDay(index); // TODO: Get from barber schedule
        
        return Container(
          decoration: BoxDecoration(
            color: isToday 
                ? AppColors.primary.withValues(alpha: 0.1)
                : Colors.transparent,
            border: Border.all(
              color: isToday 
                  ? AppColors.primary
                  : Colors.grey.shade300,
              width: isToday ? 2 : 1,
            ),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                day,
                style: AppTextStyles.bodySmall.copyWith(
                  fontWeight: FontWeight.w500,
                  color: isToday ? AppColors.primary : AppColors.textSecondary,
                ),
              ),
              const SizedBox(height: 4),
              Container(
                width: 8,
                height: 8,
                decoration: BoxDecoration(
                  color: isWorking ? AppColors.success : AppColors.error,
                  shape: BoxShape.circle,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                isWorking ? 'ON' : 'OFF',
                style: AppTextStyles.bodySmall.copyWith(
                  fontSize: 10,
                  fontWeight: FontWeight.w500,
                  color: isWorking ? AppColors.success : AppColors.error,
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  String _getTodayDateString() {
    final now = DateTime.now();
    const months = [
      'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
      'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'
    ];
    
    const weekdays = [
      'Monday', 'Tuesday', 'Wednesday', 'Thursday', 
      'Friday', 'Saturday', 'Sunday'
    ];
    
    final weekday = weekdays[now.weekday - 1];
    final month = months[now.month - 1];
    
    return '$weekday, ${now.day} $month ${now.year}';
  }

  bool _isToday(int dayIndex) {
    final today = DateTime.now().weekday - 1; // Monday = 0
    return dayIndex == today;
  }

  bool _isWorkingDay(int dayIndex) {
    // TODO: Get from actual barber schedule
    // For now, return working days Monday-Saturday
    return dayIndex < 6; // Sunday (index 6) is off
  }
}
