import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_text_styles.dart';
import '../../../../shared/models/booking_model.dart';
import '../../../../shared/widgets/custom_app_bar.dart';

class BookingSuccessPage extends ConsumerWidget {
  final BookingModel booking;

  const BookingSuccessPage({
    super.key,
    required this.booking,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: const CustomAppBar(
        title: 'Booking Confirmed',
        showBackButton: false,
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(24),
              child: Column(
                children: [
                  const SizedBox(height: 40),
                  
                  // Success Animation/Icon
                  _buildSuccessIcon(),
                  
                  const SizedBox(height: 32),
                  
                  // Success Message
                  _buildSuccessMessage(),
                  
                  const SizedBox(height: 32),
                  
                  // Booking Details Card
                  _buildBookingDetailsCard(),
                  
                  const SizedBox(height: 24),
                  
                  // Next Steps
                  _buildNextStepsCard(),
                ],
              ),
            ),
          ),
          
          // Action Buttons
          _buildActionButtons(context),
        ],
      ),
    );
  }

  Widget _buildSuccessIcon() {
    return Container(
      width: 120,
      height: 120,
      decoration: BoxDecoration(
        color: AppColors.success,
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
            color: AppColors.success.withValues(alpha: 0.3),
            blurRadius: 20,
            spreadRadius: 5,
          ),
        ],
      ),
      child: const Icon(
        Icons.check,
        color: Colors.white,
        size: 60,
      ),
    );
  }

  Widget _buildSuccessMessage() {
    return Column(
      children: [
        Text(
          'Booking Confirmed!',
          style: AppTextStyles.h2.copyWith(
            color: AppColors.success,
            fontWeight: FontWeight.bold,
          ),
          textAlign: TextAlign.center,
        ),
        
        const SizedBox(height: 12),
        
        Text(
          'Your appointment has been successfully booked.\nWe\'ve sent a confirmation to your email.',
          style: AppTextStyles.bodyLarge.copyWith(
            color: AppColors.textSecondary,
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  Widget _buildBookingDetailsCard() {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  Icons.receipt_long,
                  color: AppColors.primary,
                  size: 24,
                ),
                const SizedBox(width: 12),
                Text(
                  'Booking Details',
                  style: AppTextStyles.h4.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
            
            const SizedBox(height: 20),
            
            // Booking ID
            _buildDetailRow(
              'Booking ID',
              booking.id.length > 8 ? booking.id.substring(0, 8).toUpperCase() : booking.id.toUpperCase(),
              Icons.confirmation_number,
            ),
            
            const SizedBox(height: 16),
            
            // Service
            _buildDetailRow(
              'Service',
              'Hair Cut', // TODO: Get from service model
              Icons.content_cut,
            ),
            
            const SizedBox(height: 16),
            
            // Barber
            _buildDetailRow(
              'Barber',
              'John Doe', // TODO: Get from barber model
              Icons.person,
            ),
            
            const SizedBox(height: 16),
            
            // Date & Time
            _buildDetailRow(
              'Date & Time',
              '${_formatDate(booking.bookingDate)} at ${booking.timeSlot}',
              Icons.schedule,
            ),
            
            const SizedBox(height: 16),
            
            // Total Price
            _buildDetailRow(
              'Total Price',
              'Rp ${booking.totalPrice.toStringAsFixed(0)}',
              Icons.payment,
              isPrice: true,
            ),
            
            const SizedBox(height: 16),
            
            // Status
            _buildStatusRow(),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailRow(
    String label,
    String value,
    IconData icon, {
    bool isPrice = false,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(
          icon,
          color: AppColors.primary,
          size: 20,
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: AppTextStyles.bodySmall.copyWith(
                  color: AppColors.textSecondary,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                value,
                style: isPrice 
                    ? AppTextStyles.h5.copyWith(
                        fontWeight: FontWeight.w600,
                        color: AppColors.primary,
                      )
                    : AppTextStyles.bodyMedium.copyWith(
                        fontWeight: FontWeight.w500,
                      ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildStatusRow() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(
          Icons.hourglass_empty,
          color: AppColors.warning,
          size: 20,
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Status',
                style: AppTextStyles.bodySmall.copyWith(
                  color: AppColors.textSecondary,
                ),
              ),
              const SizedBox(height: 4),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: AppColors.warning.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: AppColors.warning.withValues(alpha: 0.3),
                  ),
                ),
                child: Text(
                  booking.status.toUpperCase(),
                  style: AppTextStyles.bodySmall.copyWith(
                    fontWeight: FontWeight.w600,
                    color: AppColors.warning,
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildNextStepsCard() {
    return Card(
      elevation: 2,
      color: AppColors.info.withValues(alpha: 0.1),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(
          color: AppColors.info.withValues(alpha: 0.3),
          width: 1,
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  Icons.lightbulb_outline,
                  color: AppColors.info,
                  size: 20,
                ),
                const SizedBox(width: 8),
                Text(
                  'What\'s Next?',
                  style: AppTextStyles.bodyMedium.copyWith(
                    fontWeight: FontWeight.w600,
                    color: AppColors.info,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            
            _buildNextStepPoint(
              'You will receive a confirmation email shortly',
            ),
            _buildNextStepPoint(
              'Please arrive 5 minutes before your appointment',
            ),
            _buildNextStepPoint(
              'The barber will contact you if there are any changes',
            ),
            _buildNextStepPoint(
              'You can manage your booking from the "My Bookings" section',
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNextStepPoint(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 4,
            height: 4,
            margin: const EdgeInsets.only(top: 8, right: 12),
            decoration: BoxDecoration(
              color: AppColors.info,
              shape: BoxShape.circle,
            ),
          ),
          Expanded(
            child: Text(
              text,
              style: AppTextStyles.bodySmall.copyWith(
                color: AppColors.textSecondary,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionButtons(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.1),
            blurRadius: 10,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: Column(
        children: [
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () {
                Navigator.pushNamedAndRemoveUntil(
                  context,
                  '/home',
                  (route) => false,
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: Text(
                'Back to Home',
                style: AppTextStyles.buttonLarge.copyWith(
                  color: Colors.white,
                ),
              ),
            ),
          ),
          
          const SizedBox(height: 12),
          
          SizedBox(
            width: double.infinity,
            child: OutlinedButton(
              onPressed: () {
                Navigator.pushNamed(context, '/bookings');
              },
              style: OutlinedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 16),
                side: BorderSide(color: AppColors.primary),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: Text(
                'View My Bookings',
                style: AppTextStyles.buttonLarge.copyWith(
                  color: AppColors.primary,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  String _formatDate(DateTime date) {
    const months = [
      'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
      'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'
    ];
    
    const weekdays = [
      'Monday', 'Tuesday', 'Wednesday', 'Thursday', 
      'Friday', 'Saturday', 'Sunday'
    ];
    
    final weekday = weekdays[date.weekday - 1];
    final month = months[date.month - 1];
    
    return '$weekday, ${date.day} $month ${date.year}';
  }
}
