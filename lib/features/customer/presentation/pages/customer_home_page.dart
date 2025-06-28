import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_text_styles.dart';
import '../../../../shared/widgets/widgets.dart';
import '../../../auth/presentation/providers/auth_state_provider.dart';
import '../widgets/service_card.dart';
import '../widgets/quick_booking_card.dart';
import '../widgets/upcoming_booking_card.dart';

class CustomerHomePage extends ConsumerWidget {
  const CustomerHomePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authStateProvider);
    final user = authState.user;

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              // Header Section
              _buildHeader(context, user?.name ?? 'User'),
              
              // Quick Booking Section
              _buildQuickBookingSection(context),
              
              // Services Section
              _buildServicesSection(context),
              
              // Upcoming Bookings Section
              _buildUpcomingBookingsSection(context),
              
              // Recent Activity Section
              _buildRecentActivitySection(context),
              
              const SizedBox(height: 100), // Bottom padding for FAB
            ],
          ),
        ),
      ),
      
      // Bottom Navigation
      bottomNavigationBar: _buildBottomNavigation(context),
      
      // Floating Action Button for Quick Booking
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          // Navigate to booking page
        },
        icon: const Icon(Icons.add),
        label: const Text('Book Now'),
        backgroundColor: AppColors.secondary,
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }

  Widget _buildHeader(BuildContext context, String userName) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            AppColors.primary,
            AppColors.primary.withValues(alpha: 0.8),
          ],
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Hello,',
                    style: AppTextStyles.bodyLarge.copyWith(
                      color: AppColors.white.withValues(alpha: 0.8),
                    ),
                  ),
                  Text(
                    userName,
                    style: AppTextStyles.h3.copyWith(
                      color: AppColors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              Row(
                children: [
                  IconButton(
                    onPressed: () {
                      // Navigate to notifications
                    },
                    icon: const Icon(
                      Icons.notifications_outlined,
                      color: AppColors.white,
                    ),
                  ),
                  IconButton(
                    onPressed: () {
                      // Navigate to profile
                    },
                    icon: const Icon(
                      Icons.person_outlined,
                      color: AppColors.white,
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 16),
          Text(
            'Ready for your next haircut?',
            style: AppTextStyles.bodyMedium.copyWith(
              color: AppColors.white.withValues(alpha: 0.9),
            ),
          ),
        ],
      ),
    );
  }
  Widget _buildQuickBookingSection(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Quick Booking',
            style: AppTextStyles.h5.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          const QuickBookingCard(),
        ],
      ),
    );
  }

  Widget _buildServicesSection(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Our Services',
                style: AppTextStyles.h5.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              TextButton(
                onPressed: () {
                  // Navigate to all services
                },
                child: Text(
                  'View All',
                  style: AppTextStyles.bodyMedium.copyWith(
                    color: AppColors.primary,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          SizedBox(
            height: 160,
            child: ListView(
              scrollDirection: Axis.horizontal,
              children: const [
                ServiceCard(
                  title: 'Hair Cut',
                  price: 'Rp 50,000',
                  duration: '30 min',
                  icon: Icons.content_cut,
                ),
                ServiceCard(
                  title: 'Beard Trim',
                  price: 'Rp 25,000',
                  duration: '15 min',
                  icon: Icons.face_retouching_natural,
                ),
                ServiceCard(
                  title: 'Hair Wash',
                  price: 'Rp 15,000',
                  duration: '10 min',
                  icon: Icons.wash,
                ),
                ServiceCard(
                  title: 'Full Grooming',
                  price: 'Rp 100,000',
                  duration: '60 min',
                  icon: Icons.spa,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildUpcomingBookingsSection(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Upcoming Bookings',
                style: AppTextStyles.h5.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              TextButton(
                onPressed: () {
                  // Navigate to booking history
                },
                child: Text(
                  'View All',
                  style: AppTextStyles.bodyMedium.copyWith(
                    color: AppColors.primary,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          // Mock upcoming booking
          const UpcomingBookingCard(
            serviceName: 'Hair Cut & Styling',
            barberName: 'John Doe',
            date: 'Today, 2:00 PM',
            status: 'Confirmed',
          ),
        ],
      ),
    );
  }
  Widget _buildRecentActivitySection(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Recent Activity',
            style: AppTextStyles.h5.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          CustomCard(
            child: Column(
              children: [
                _buildActivityItem(
                  icon: Icons.check_circle,
                  iconColor: AppColors.success,
                  title: 'Booking Completed',
                  subtitle: 'Hair cut with Mike - Yesterday',
                  trailing: 'Rate',
                ),
                const Divider(),
                _buildActivityItem(
                  icon: Icons.schedule,
                  iconColor: AppColors.warning,
                  title: 'Booking Confirmed',
                  subtitle: 'Beard trim with Alex - Tomorrow',
                  trailing: 'View',
                ),
                const Divider(),
                _buildActivityItem(
                  icon: Icons.star,
                  iconColor: AppColors.accent,
                  title: 'Review Posted',
                  subtitle: 'You rated Mike 5 stars',
                  trailing: '5★',
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActivityItem({
    required IconData icon,
    required Color iconColor,
    required String title,
    required String subtitle,
    required String trailing,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: iconColor.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(
              icon,
              color: iconColor,
              size: 20,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: AppTextStyles.bodyMedium.copyWith(
                    fontWeight: FontWeight.w500,
                  ),
                ),
                Text(
                  subtitle,
                  style: AppTextStyles.bodySmall.copyWith(
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ),
          ),
          Text(
            trailing,
            style: AppTextStyles.labelMedium.copyWith(
              color: AppColors.primary,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBottomNavigation(BuildContext context) {
    return BottomNavigationBar(
      type: BottomNavigationBarType.fixed,
      selectedItemColor: AppColors.primary,
      unselectedItemColor: AppColors.grey,
      currentIndex: 0,
      items: const [
        BottomNavigationBarItem(
          icon: Icon(Icons.home_outlined),
          activeIcon: Icon(Icons.home),
          label: 'Home',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.calendar_today_outlined),
          activeIcon: Icon(Icons.calendar_today),
          label: 'Bookings',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.content_cut_outlined),
          activeIcon: Icon(Icons.content_cut),
          label: 'Services',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.person_outlined),
          activeIcon: Icon(Icons.person),
          label: 'Profile',
        ),
      ],
      onTap: (index) {
        // Handle navigation
        switch (index) {
          case 0:
            // Already on home
            break;
          case 1:
            // Navigate to bookings
            break;
          case 2:
            // Navigate to services
            break;
          case 3:
            // Navigate to profile
            break;
        }
      },
    );
  }
}