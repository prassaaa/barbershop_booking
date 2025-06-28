import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_text_styles.dart';
import '../../../../shared/widgets/custom_app_bar.dart';
import '../../../../shared/widgets/cached_network_image_widget.dart';
import '../providers/booking_flow_provider.dart';

class BookingConfirmationPage extends ConsumerStatefulWidget {
  const BookingConfirmationPage({super.key});

  @override
  ConsumerState<BookingConfirmationPage> createState() => _BookingConfirmationPageState();
}

class _BookingConfirmationPageState extends ConsumerState<BookingConfirmationPage> {
  final TextEditingController _notesController = TextEditingController();
  bool _isCreatingBooking = false;

  @override
  void initState() {
    super.initState();
    // Pre-fill notes if available
    final currentNotes = ref.read(bookingFlowProvider).notes;
    if (currentNotes != null) {
      _notesController.text = currentNotes;
    }
  }

  @override
  void dispose() {
    _notesController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final bookingFlow = ref.watch(bookingFlowProvider);
    final selectedService = bookingFlow.selectedService;
    final selectedBarber = bookingFlow.selectedBarber;
    final selectedDate = bookingFlow.selectedDate;
    final selectedTimeSlot = bookingFlow.selectedTimeSlot;

    if (!bookingFlow.canCreateBooking) {
      return Scaffold(
        appBar: const CustomAppBar(title: 'Booking Confirmation'),
        body: const Center(
          child: Text('Incomplete booking information'),
        ),
      );
    }

    return Scaffold(
      appBar: const CustomAppBar(title: 'Booking Confirmation'),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Booking Summary Card
                  _buildBookingSummaryCard(
                    selectedService!,
                    selectedBarber!,
                    selectedDate!,
                    selectedTimeSlot!,
                  ),
                  
                  const SizedBox(height: 24),
                  
                  // Notes Section
                  _buildNotesSection(),
                  
                  const SizedBox(height: 24),
                  
                  // Price Breakdown
                  _buildPriceBreakdown(selectedService),
                  
                  const SizedBox(height: 24),
                  
                  // Terms and Conditions
                  _buildTermsAndConditions(),
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

  Widget _buildBookingSummaryCard(
    dynamic selectedService,
    dynamic selectedBarber,
    DateTime selectedDate,
    String selectedTimeSlot,
  ) {
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
                  Icons.event_available,
                  color: AppColors.success,
                  size: 24,
                ),
                const SizedBox(width: 12),
                Text(
                  'Booking Summary',
                  style: AppTextStyles.h4.copyWith(
                    color: AppColors.textPrimary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
            
            const SizedBox(height: 20),
            
            // Service Info
            _buildSummaryRow(
              Icons.content_cut,
              'Service',
              selectedService.name,
              subtitle: 'Duration: ${selectedService.durationMinutes} minutes',
            ),
            
            const SizedBox(height: 16),
            
            // Barber Info
            Row(
              children: [
                Icon(
                  Icons.person,
                  color: AppColors.primary,
                  size: 20,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Barber',
                        style: AppTextStyles.bodySmall.copyWith(
                          color: AppColors.textSecondary,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          ClipOval(
                            child: CachedNetworkImageWidget(
                              imageUrl: selectedBarber.profileImage ?? '',
                              width: 32,
                              height: 32,
                              placeholder: Container(
                                width: 32,
                                height: 32,
                                color: AppColors.surface,
                                child: Icon(
                                  Icons.person,
                                  size: 20,
                                  color: AppColors.textSecondary,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  selectedBarber.name,
                                  style: AppTextStyles.bodyMedium.copyWith(
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                Row(
                                  children: [
                                    Icon(
                                      Icons.star,
                                      size: 14,
                                      color: AppColors.warning,
                                    ),
                                    const SizedBox(width: 4),
                                    Text(
                                      selectedBarber.rating.toStringAsFixed(1),
                                      style: AppTextStyles.bodySmall.copyWith(
                                        color: AppColors.textSecondary,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
            
            const SizedBox(height: 16),
            
            // Date & Time
            _buildSummaryRow(
              Icons.calendar_today,
              'Date & Time',
              '${_formatDate(selectedDate)} at $selectedTimeSlot',
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSummaryRow(
    IconData icon,
    String label,
    String value, {
    String? subtitle,
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
                style: AppTextStyles.bodyMedium.copyWith(
                  fontWeight: FontWeight.w500,
                ),
              ),
              if (subtitle != null) ...[
                const SizedBox(height: 2),
                Text(
                  subtitle,
                  style: AppTextStyles.bodySmall.copyWith(
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildNotesSection() {
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
              'Additional Notes',
              style: AppTextStyles.h5.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _notesController,
              maxLines: 3,
              decoration: InputDecoration(
                hintText: 'Add any special requests or notes...',
                hintStyle: AppTextStyles.bodyMedium.copyWith(
                  color: AppColors.textSecondary,
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide(color: Colors.grey.shade300),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide(color: AppColors.primary),
                ),
              ),
              onChanged: (value) {
                ref.read(bookingFlowProvider.notifier).setNotes(value);
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPriceBreakdown(dynamic selectedService) {
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
              'Price Breakdown',
              style: AppTextStyles.h5.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 16),
            
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  selectedService.name,
                  style: AppTextStyles.bodyMedium,
                ),
                Text(
                  'Rp ${selectedService.price.toStringAsFixed(0)}',
                  style: AppTextStyles.bodyMedium,
                ),
              ],
            ),
            
            const SizedBox(height: 8),
            
            const Divider(),
            
            const SizedBox(height: 8),
            
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Total',
                  style: AppTextStyles.h5.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Text(
                  'Rp ${selectedService.price.toStringAsFixed(0)}',
                  style: AppTextStyles.h5.copyWith(
                    fontWeight: FontWeight.w600,
                    color: AppColors.primary,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTermsAndConditions() {
    return Card(
      elevation: 1,
      color: AppColors.warning.withOpacity(0.1),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(
          color: AppColors.warning.withOpacity(0.3),
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
                  Icons.info_outline,
                  color: AppColors.warning,
                  size: 20,
                ),
                const SizedBox(width: 8),
                Text(
                  'Important Information',
                  style: AppTextStyles.bodyMedium.copyWith(
                    fontWeight: FontWeight.w600,
                    color: AppColors.warning,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            
            _buildInfoPoint('Please arrive 5 minutes before your appointment'),
            _buildInfoPoint('Cancellation must be made at least 2 hours in advance'),
            _buildInfoPoint('Late arrivals may result in shortened service time'),
            _buildInfoPoint('Payment can be made after the service'),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoPoint(String text) {
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
              color: AppColors.warning,
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
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: OutlinedButton(
              onPressed: _isCreatingBooking ? null : () {
                Navigator.pop(context);
              },
              style: OutlinedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 16),
                side: BorderSide(color: AppColors.primary),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: Text(
                'Back',
                style: AppTextStyles.buttonLarge.copyWith(
                  color: AppColors.primary,
                ),
              ),
            ),
          ),
          
          const SizedBox(width: 16),
          
          Expanded(
            flex: 2,
            child: ElevatedButton(
              onPressed: _isCreatingBooking ? null : _createBooking,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: _isCreatingBooking
                  ? const SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(
                        color: Colors.white,
                        strokeWidth: 2,
                      ),
                    )
                  : Text(
                      'Confirm Booking',
                      style: AppTextStyles.buttonLarge.copyWith(
                        color: Colors.white,
                      ),
                    ),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _createBooking() async {
    setState(() {
      _isCreatingBooking = true;
    });

    try {
      // TODO: Get actual customer ID from authentication
      const customerId = 'temp_customer_id';
      
      final result = await ref.read(bookingFlowProvider.notifier).createBooking(customerId);
      
      result.fold(
        (failure) {
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('Failed to create booking: ${failure.message}'),
                backgroundColor: AppColors.error,
              ),
            );
          }
        },
        (booking) {
          if (mounted) {
            // Navigate to success page
            Navigator.pushNamedAndRemoveUntil(
              context,
              '/booking/success',
              (route) => route.settings.name == '/home',
              arguments: booking,
            );
          }
        },
      );
    } finally {
      if (mounted) {
        setState(() {
          _isCreatingBooking = false;
        });
      }
    }
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
