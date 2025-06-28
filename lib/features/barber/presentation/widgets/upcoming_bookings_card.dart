import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_text_styles.dart';

class UpcomingBookingsCard extends ConsumerWidget {
  const UpcomingBookingsCard({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // TODO: Get actual upcoming bookings
    final upcomingBookings = _getMockBookings();

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
                  'Next Appointments',
                  style: AppTextStyles.h5.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                TextButton(
                  onPressed: () {
                    Navigator.pushNamed(context, '/barber/bookings');
                  },
                  child: const Text('View All'),
                ),
              ],
            ),
            
            const SizedBox(height: 12),
            
            if (upcomingBookings.isEmpty) 
              _buildEmptyState()
            else 
              ..._buildBookingList(upcomingBookings),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      child: Column(
        children: [
          Icon(
            Icons.event_available,
            size: 48,
            color: AppColors.textSecondary,
          ),
          const SizedBox(height: 12),
          Text(
            'No upcoming appointments',
            style: AppTextStyles.bodyMedium.copyWith(
              color: AppColors.textSecondary,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Enjoy your free time!',
            style: AppTextStyles.bodySmall.copyWith(
              color: AppColors.textSecondary,
            ),
          ),
        ],
      ),
    );
  }

  List<Widget> _buildBookingList(List<MockBooking> bookings) {
    return bookings.take(3).map((booking) => 
      _buildBookingItem(booking)
    ).toList();
  }

  Widget _buildBookingItem(MockBooking booking) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: Colors.grey.shade300,
          width: 1,
        ),
      ),
      child: Row(
        children: [
          // Time
          Container(
            width: 60,
            padding: const EdgeInsets.symmetric(vertical: 8),
            decoration: BoxDecoration(
              color: AppColors.primary.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(6),
            ),
            child: Column(
              children: [
                Text(
                  booking.time.split(':')[0],
                  style: AppTextStyles.h5.copyWith(
                    fontWeight: FontWeight.bold,
                    color: AppColors.primary,
                  ),
                ),
                Text(
                  booking.time.split(':')[1],
                  style: AppTextStyles.bodySmall.copyWith(
                    color: AppColors.primary,
                  ),
                ),
              ],
            ),
          ),
          
          const SizedBox(width: 12),
          
          // Customer & Service Info
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  booking.customerName,
                  style: AppTextStyles.bodyMedium.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  booking.serviceName,
                  style: AppTextStyles.bodySmall.copyWith(
                    color: AppColors.textSecondary,
                  ),
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    Icon(
                      Icons.access_time,
                      size: 12,
                      color: AppColors.textSecondary,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      '${booking.duration} min',
                      style: AppTextStyles.bodySmall.copyWith(
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          
          // Status
          Container(
            padding: const EdgeInsets.symmetric(
              horizontal: 8,
              vertical: 4,
            ),
            decoration: BoxDecoration(
              color: _getStatusColor(booking.status).withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text(
              booking.status,
              style: AppTextStyles.bodySmall.copyWith(
                color: _getStatusColor(booking.status),
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Color _getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'confirmed':
        return AppColors.success;
      case 'waiting':
        return AppColors.warning;
      case 'in progress':
        return AppColors.info;
      default:
        return AppColors.textSecondary;
    }
  }

  List<MockBooking> _getMockBookings() {
    // TODO: Replace with actual data from provider
    return [
      MockBooking(
        id: '1',
        customerName: 'John Smith',
        serviceName: 'Hair Cut & Wash',
        time: '14:00',
        duration: 45,
        status: 'Confirmed',
      ),
      MockBooking(
        id: '2',
        customerName: 'David Wilson',
        serviceName: 'Beard Trim',
        time: '15:30',
        duration: 30,
        status: 'Waiting',
      ),
      MockBooking(
        id: '3',
        customerName: 'Mike Johnson',
        serviceName: 'Full Grooming',
        time: '16:30',
        duration: 60,
        status: 'Confirmed',
      ),
    ];
  }
}

class MockBooking {
  final String id;
  final String customerName;
  final String serviceName;
  final String time;
  final int duration;
  final String status;

  MockBooking({
    required this.id,
    required this.customerName,
    required this.serviceName,
    required this.time,
    required this.duration,
    required this.status,
  });
}
