import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_text_styles.dart';
import '../../../../shared/widgets/custom_app_bar.dart';
import '../providers/booking_flow_provider.dart';
import 'service_selection_page.dart';
import 'barber_selection_page.dart';
import 'date_selection_page.dart';
import 'time_selection_page.dart';
import 'booking_confirmation_page.dart';

class BookingFlowPage extends ConsumerStatefulWidget {
  const BookingFlowPage({super.key});

  @override
  ConsumerState<BookingFlowPage> createState() => _BookingFlowPageState();
}

class _BookingFlowPageState extends ConsumerState<BookingFlowPage> {
  int _currentStep = 0;
  final PageController _pageController = PageController();

  final List<BookingStep> _steps = [
    BookingStep(
      title: 'Select Service',
      subtitle: 'Choose your desired service',
      icon: Icons.content_cut,
    ),
    BookingStep(
      title: 'Select Barber',
      subtitle: 'Choose your preferred barber',
      icon: Icons.person,
    ),
    BookingStep(
      title: 'Select Date',
      subtitle: 'Pick your appointment date',
      icon: Icons.calendar_today,
    ),
    BookingStep(
      title: 'Select Time',
      subtitle: 'Choose available time slot',
      icon: Icons.schedule,
    ),
    BookingStep(
      title: 'Confirmation',
      subtitle: 'Review and confirm booking',
      icon: Icons.check_circle,
    ),
  ];

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final bookingFlow = ref.watch(bookingFlowProvider);

    return Scaffold(
      appBar: CustomAppBar(
        title: 'Book Appointment',
        subtitle: _steps[_currentStep].title,
        actions: [
          if (_currentStep > 0)
            IconButton(
              onPressed: _canGoBack() ? () => _goToStep(_currentStep - 1) : null,
              icon: const Icon(Icons.arrow_back),
            ),
        ],
      ),
      body: Column(
        children: [
          // Progress Indicator
          _buildProgressIndicator(),
          
          // Step Content
          Expanded(
            child: PageView(
              controller: _pageController,
              onPageChanged: (index) {
                setState(() {
                  _currentStep = index;
                });
              },
              children: const [
                ServiceSelectionPage(),
                BarberSelectionPage(),
                DateSelectionPage(),
                TimeSelectionPage(),
                BookingConfirmationPage(),
              ],
            ),
          ),
          
          // Navigation Controls
          _buildNavigationControls(bookingFlow),
        ],
      ),
    );
  }

  Widget _buildProgressIndicator() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          // Step indicators
          Row(
            children: List.generate(_steps.length, (index) {
              final isActive = index == _currentStep;
              final isCompleted = index < _currentStep;
              final isAccessible = _isStepAccessible(index);

              return Expanded(
                child: Row(
                  children: [
                    _buildStepIndicator(
                      index,
                      isActive: isActive,
                      isCompleted: isCompleted,
                      isAccessible: isAccessible,
                    ),
                    if (index < _steps.length - 1)
                      Expanded(
                        child: Container(
                          height: 2,
                          color: isCompleted 
                              ? AppColors.primary 
                              : Colors.grey.shade300,
                        ),
                      ),
                  ],
                ),
              );
            }),
          ),
          
          const SizedBox(height: 12),
          
          // Current step info
          Row(
            children: [
              Icon(
                _steps[_currentStep].icon,
                color: AppColors.primary,
                size: 20,
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      _steps[_currentStep].title,
                      style: AppTextStyles.bodyMedium.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    Text(
                      _steps[_currentStep].subtitle,
                      style: AppTextStyles.bodySmall.copyWith(
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),
              Text(
                '${_currentStep + 1} of ${_steps.length}',
                style: AppTextStyles.bodySmall.copyWith(
                  color: AppColors.textSecondary,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStepIndicator(
    int index, {
    required bool isActive,
    required bool isCompleted,
    required bool isAccessible,
  }) {
    return GestureDetector(
      onTap: isAccessible ? () => _goToStep(index) : null,
      child: Container(
        width: 32,
        height: 32,
        decoration: BoxDecoration(
          color: isCompleted 
              ? AppColors.primary
              : isActive 
                  ? AppColors.primary.withValues(alpha: 0.2)
                  : Colors.grey.shade300,
          shape: BoxShape.circle,
          border: isActive 
              ? Border.all(color: AppColors.primary, width: 2)
              : null,
        ),
        child: Center(
          child: isCompleted
              ? const Icon(
                  Icons.check,
                  color: Colors.white,
                  size: 18,
                )
              : Text(
                  '${index + 1}',
                  style: AppTextStyles.bodySmall.copyWith(
                    color: isActive 
                        ? AppColors.primary
                        : isAccessible
                            ? AppColors.textSecondary
                            : Colors.grey.shade500,
                    fontWeight: FontWeight.w600,
                  ),
                ),
        ),
      ),
    );
  }

  Widget _buildNavigationControls(BookingFlowState bookingFlow) {
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
      child: Row(
        children: [
          // Back Button
          if (_currentStep > 0)
            Expanded(
              child: OutlinedButton(
                onPressed: _canGoBack() ? () => _goToStep(_currentStep - 1) : null,
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
          
          if (_currentStep > 0) const SizedBox(width: 16),
          
          // Next Button
          Expanded(
            flex: _currentStep > 0 ? 2 : 1,
            child: ElevatedButton(
              onPressed: _canProceedToNext(bookingFlow) ? _goToNextStep : null,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: Text(
                _getNextButtonText(),
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

  bool _isStepAccessible(int stepIndex) {
    final bookingFlow = ref.read(bookingFlowProvider);
    
    switch (stepIndex) {
      case 0: // Service Selection
        return true;
      case 1: // Barber Selection
        return bookingFlow.canProceedToBarberSelection;
      case 2: // Date Selection
        return bookingFlow.canProceedToDateSelection;
      case 3: // Time Selection
        return bookingFlow.canProceedToTimeSelection;
      case 4: // Confirmation
        return bookingFlow.canCreateBooking;
      default:
        return false;
    }
  }

  bool _canGoBack() {
    return _currentStep > 0;
  }

  bool _canProceedToNext(BookingFlowState bookingFlow) {
    switch (_currentStep) {
      case 0: // Service Selection
        return bookingFlow.canProceedToBarberSelection;
      case 1: // Barber Selection
        return bookingFlow.canProceedToDateSelection;
      case 2: // Date Selection
        return bookingFlow.canProceedToTimeSelection;
      case 3: // Time Selection
        return bookingFlow.canCreateBooking;
      case 4: // Confirmation
        return false; // No next step from confirmation
      default:
        return false;
    }
  }

  String _getNextButtonText() {
    switch (_currentStep) {
      case 0:
        return 'Select Barber';
      case 1:
        return 'Select Date';
      case 2:
        return 'Select Time';
      case 3:
        return 'Review Booking';
      case 4:
        return 'Confirm Booking';
      default:
        return 'Next';
    }
  }

  void _goToStep(int stepIndex) {
    if (_isStepAccessible(stepIndex)) {
      setState(() {
        _currentStep = stepIndex;
      });
      _pageController.animateToPage(
        stepIndex,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  void _goToNextStep() {
    if (_currentStep < _steps.length - 1) {
      _goToStep(_currentStep + 1);
    }
  }
}

class BookingStep {
  final String title;
  final String subtitle;
  final IconData icon;

  const BookingStep({
    required this.title,
    required this.subtitle,
    required this.icon,
  });
}
