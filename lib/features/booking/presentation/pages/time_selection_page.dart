import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_text_styles.dart';
import '../../../../shared/widgets/custom_app_bar.dart';
import '../../../../shared/widgets/loading_widget.dart';
import '../providers/booking_flow_provider.dart';
import '../widgets/time_slot_card.dart';

class TimeSelectionPage extends ConsumerWidget {
  const TimeSelectionPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final bookingFlow = ref.watch(bookingFlowProvider);
    final selectedService = bookingFlow.selectedService;
    final selectedBarber = bookingFlow.selectedBarber;
    final selectedDate = bookingFlow.selectedDate;

    if (selectedService == null || selectedBarber == null || selectedDate == null) {
      return Scaffold(
        appBar: const CustomAppBar(title: 'Select Time'),
        body: const Center(
          child: Text('Service, barber, and date must be selected first'),
        ),
      );
    }

    return Scaffold(
      appBar: CustomAppBar(
        title: 'Select Time',
        subtitle: _formatDate(selectedDate),
      ),
      body: Column(
        children: [
          // Booking Summary
          _buildBookingSummary(selectedService.name, selectedBarber.name, selectedDate),
          
          // Time Slots
          Expanded(
            child: _buildTimeSlotsList(context, ref, bookingFlow),
          ),
          
          // Continue Button
          if (bookingFlow.canCreateBooking)
            _buildContinueButton(context),
        ],
      ),
    );
  }

  Widget _buildBookingSummary(String serviceName, String barberName, DateTime date) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.primary.withValues(alpha: 0.1),
        border: Border(
          bottom: BorderSide(
            color: AppColors.primary.withValues(alpha: 0.3),
            width: 1,
          ),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Booking Summary',
            style: AppTextStyles.bodySmall.copyWith(
              color: AppColors.textSecondary,
            ),
          ),
          const SizedBox(height: 12),
          
          _buildSummaryRow(Icons.content_cut, 'Service', serviceName),
          const SizedBox(height: 8),
          _buildSummaryRow(Icons.person, 'Barber', barberName),
          const SizedBox(height: 8),
          _buildSummaryRow(Icons.calendar_today, 'Date', _formatDate(date)),
        ],
      ),
    );
  }

  Widget _buildSummaryRow(IconData icon, String label, String value) {
    return Row(
      children: [
        Icon(
          icon,
          size: 16,
          color: AppColors.primary,
        ),
        const SizedBox(width: 8),
        Text(
          '$label: ',
          style: AppTextStyles.bodySmall.copyWith(
            color: AppColors.textSecondary,
          ),
        ),
        Expanded(
          child: Text(
            value,
            style: AppTextStyles.bodyMedium.copyWith(
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildTimeSlotsList(BuildContext context, WidgetRef ref, BookingFlowState bookingFlow) {
    if (bookingFlow.isLoading) {
      return const LoadingWidget();
    }

    if (bookingFlow.error != null) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.error_outline,
              size: 64,
              color: AppColors.error,
            ),
            const SizedBox(height: 16),
            Text(
              'Failed to load time slots',
              style: AppTextStyles.h4.copyWith(
                color: AppColors.error,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              bookingFlow.error!,
              style: AppTextStyles.bodyMedium.copyWith(
                color: AppColors.textSecondary,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                ref.read(bookingFlowProvider.notifier).clearError();
                // Trigger reload by reselecting date
                if (bookingFlow.selectedDate != null) {
                  ref.read(bookingFlowProvider.notifier).selectDate(bookingFlow.selectedDate!);
                }
              },
              child: const Text('Retry'),
            ),
          ],
        ),
      );
    }

    final availableTimeSlots = bookingFlow.availableTimeSlots;

    if (availableTimeSlots.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.schedule_outlined,
              size: 64,
              color: AppColors.textSecondary,
            ),
            const SizedBox(height: 16),
            Text(
              'No available time slots',
              style: AppTextStyles.h4.copyWith(
                color: AppColors.textSecondary,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Please select a different date',
              style: AppTextStyles.bodyMedium.copyWith(
                color: AppColors.textSecondary,
              ),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('Select Different Date'),
            ),
          ],
        ),
      );
    }

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Available Time Slots',
            style: AppTextStyles.h4.copyWith(
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 16),
          
          // Morning slots
          _buildTimeSlotSection(
            'Morning',
            availableTimeSlots.where((slot) => _isMorningSlot(slot)).toList(),
            bookingFlow.selectedTimeSlot,
            ref,
          ),
          
          // Afternoon slots
          _buildTimeSlotSection(
            'Afternoon',
            availableTimeSlots.where((slot) => _isAfternoonSlot(slot)).toList(),
            bookingFlow.selectedTimeSlot,
            ref,
          ),
          
          // Evening slots
          _buildTimeSlotSection(
            'Evening',
            availableTimeSlots.where((slot) => _isEveningSlot(slot)).toList(),
            bookingFlow.selectedTimeSlot,
            ref,
          ),
        ],
      ),
    );
  }

  Widget _buildTimeSlotSection(
    String title,
    List<String> timeSlots,
    String? selectedTimeSlot,
    WidgetRef ref,
  ) {
    if (timeSlots.isEmpty) return const SizedBox.shrink();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: AppTextStyles.h5.copyWith(
            color: AppColors.textPrimary,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 12),
        
        Wrap(
          spacing: 12,
          runSpacing: 12,
          children: timeSlots.map((timeSlot) {
            final isSelected = selectedTimeSlot == timeSlot;
            return TimeSlotCard(
              timeSlot: timeSlot,
              isSelected: isSelected,
              onTap: () {
                ref.read(bookingFlowProvider.notifier).selectTimeSlot(timeSlot);
              },
            );
          }).toList(),
        ),
        
        const SizedBox(height: 24),
      ],
    );
  }

  Widget _buildContinueButton(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      child: SizedBox(
        width: double.infinity,
        child: ElevatedButton(
          onPressed: () {
            Navigator.pushNamed(context, '/booking/confirmation');
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.primary,
            padding: const EdgeInsets.symmetric(vertical: 16),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
          child: Text(
            'Continue to Confirmation',
            style: AppTextStyles.buttonLarge.copyWith(
              color: Colors.white,
            ),
          ),
        ),
      ),
    );
  }

  bool _isMorningSlot(String timeSlot) {
    final hour = int.parse(timeSlot.split(':')[0]);
    return hour >= 9 && hour < 12;
  }

  bool _isAfternoonSlot(String timeSlot) {
    final hour = int.parse(timeSlot.split(':')[0]);
    return hour >= 12 && hour < 17;
  }

  bool _isEveningSlot(String timeSlot) {
    final hour = int.parse(timeSlot.split(':')[0]);
    return hour >= 17 && hour <= 20;
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
