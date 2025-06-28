import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:table_calendar/table_calendar.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_text_styles.dart';
import '../../../../shared/widgets/custom_app_bar.dart';
import '../providers/booking_flow_provider.dart';

class DateSelectionPage extends ConsumerStatefulWidget {
  const DateSelectionPage({super.key});

  @override
  ConsumerState<DateSelectionPage> createState() => _DateSelectionPageState();
}

class _DateSelectionPageState extends ConsumerState<DateSelectionPage> {
  late DateTime _focusedDay;
  DateTime? _selectedDay;

  @override
  void initState() {
    super.initState();
    _focusedDay = DateTime.now();
    
    // Get currently selected date from booking flow
    final currentSelection = ref.read(bookingFlowProvider).selectedDate;
    if (currentSelection != null) {
      _selectedDay = currentSelection;
      _focusedDay = currentSelection;
    }
  }

  @override
  Widget build(BuildContext context) {
    final bookingFlow = ref.watch(bookingFlowProvider);
    final selectedService = bookingFlow.selectedService;
    final selectedBarber = bookingFlow.selectedBarber;

    if (selectedService == null || selectedBarber == null) {
      return Scaffold(
        appBar: const CustomAppBar(title: 'Select Date'),
        body: const Center(
          child: Text('Service and barber must be selected first'),
        ),
      );
    }

    return Scaffold(
      appBar: CustomAppBar(
        title: 'Select Date',
        subtitle: '${selectedService.name} with ${selectedBarber.name}',
      ),
      body: Column(
        children: [
          // Service & Barber Info
          _buildBookingInfo(selectedService.name, selectedBarber.name),
          
          // Calendar
          Expanded(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    _buildCalendar(),
                    
                    const SizedBox(height: 24),
                    
                    if (_selectedDay != null)
                      _buildSelectedDateInfo(),
                  ],
                ),
              ),
            ),
          ),
          
          // Continue Button
          if (bookingFlow.canProceedToTimeSelection)
            _buildContinueButton(context),
        ],
      ),
    );
  }

  Widget _buildBookingInfo(String serviceName, String barberName) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.primary.withOpacity(0.1),
        border: Border(
          bottom: BorderSide(
            color: AppColors.primary.withOpacity(0.3),
            width: 1,
          ),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Booking Details',
            style: AppTextStyles.bodySmall.copyWith(
              color: AppColors.textSecondary,
            ),
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              Icon(
                Icons.content_cut,
                size: 16,
                color: AppColors.primary,
              ),
              const SizedBox(width: 8),
              Text(
                serviceName,
                style: AppTextStyles.bodyMedium.copyWith(
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),
          Row(
            children: [
              Icon(
                Icons.person,
                size: 16,
                color: AppColors.primary,
              ),
              const SizedBox(width: 8),
              Text(
                barberName,
                style: AppTextStyles.bodyMedium.copyWith(
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildCalendar() {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: TableCalendar<Event>(
          firstDay: DateTime.now(),
          lastDay: DateTime.now().add(const Duration(days: 90)),
          focusedDay: _focusedDay,
          calendarFormat: CalendarFormat.month,
          selectedDayPredicate: (day) {
            return isSameDay(_selectedDay, day);
          },
          enabledDayPredicate: (day) {
            // Disable past dates and Sundays (barbershop closed)
            if (day.isBefore(DateTime.now().subtract(const Duration(days: 1)))) {
              return false;
            }
            if (day.weekday == DateTime.sunday) {
              return false;
            }
            return true;
          },
          onDaySelected: (selectedDay, focusedDay) {
            if (!isSameDay(_selectedDay, selectedDay)) {
              setState(() {
                _selectedDay = selectedDay;
                _focusedDay = focusedDay;
              });
              
              // Update booking flow
              ref.read(bookingFlowProvider.notifier).selectDate(selectedDay);
            }
          },
          onPageChanged: (focusedDay) {
            _focusedDay = focusedDay;
          },
          calendarStyle: CalendarStyle(
            outsideDaysVisible: false,
            selectedDecoration: BoxDecoration(
              color: AppColors.primary,
              shape: BoxShape.circle,
            ),
            todayDecoration: BoxDecoration(
              color: AppColors.primary.withOpacity(0.5),
              shape: BoxShape.circle,
            ),
            disabledDecoration: BoxDecoration(
              color: Colors.grey.shade300,
              shape: BoxShape.circle,
            ),
            weekendTextStyle: TextStyle(
              color: Colors.grey.shade400,
            ),
            disabledTextStyle: TextStyle(
              color: Colors.grey.shade400,
            ),
          ),
          headerStyle: HeaderStyle(
            formatButtonVisible: false,
            titleCentered: true,
            leftChevronIcon: Icon(
              Icons.chevron_left,
              color: AppColors.primary,
            ),
            rightChevronIcon: Icon(
              Icons.chevron_right,
              color: AppColors.primary,
            ),
            titleTextStyle: AppTextStyles.h4.copyWith(
              color: AppColors.textPrimary,
            ),
          ),
          daysOfWeekStyle: DaysOfWeekStyle(
            weekdayStyle: AppTextStyles.bodySmall.copyWith(
              fontWeight: FontWeight.w500,
            ),
            weekendStyle: AppTextStyles.bodySmall.copyWith(
              fontWeight: FontWeight.w500,
              color: Colors.grey.shade400,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSelectedDateInfo() {
    if (_selectedDay == null) return const SizedBox.shrink();
    
    return Card(
      elevation: 2,
      color: AppColors.success.withOpacity(0.1),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(
          color: AppColors.success.withOpacity(0.3),
          width: 1,
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: AppColors.success,
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.calendar_today,
                color: Colors.white,
                size: 24,
              ),
            ),
            
            const SizedBox(width: 16),
            
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Selected Date',
                    style: AppTextStyles.bodySmall.copyWith(
                      color: AppColors.textSecondary,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    _formatSelectedDate(_selectedDay!),
                    style: AppTextStyles.h4.copyWith(
                      color: AppColors.success,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildContinueButton(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      child: SizedBox(
        width: double.infinity,
        child: ElevatedButton(
          onPressed: () {
            Navigator.pushNamed(context, '/booking/time-selection');
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.primary,
            padding: const EdgeInsets.symmetric(vertical: 16),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
          child: Text(
            'Continue to Time Selection',
            style: AppTextStyles.buttonLarge.copyWith(
              color: Colors.white,
            ),
          ),
        ),
      ),
    );
  }

  String _formatSelectedDate(DateTime date) {
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

// Event class for calendar (can be extended later for barber schedules)
class Event {
  final String title;
  
  const Event(this.title);
  
  @override
  String toString() => title;
}
