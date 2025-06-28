import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_text_styles.dart';
import '../../../../shared/models/barber_model.dart';
import '../../../../shared/widgets/custom_app_bar.dart';
import '../../../../shared/widgets/loading_widget.dart';
import '../../../../shared/widgets/error_widget.dart';
import '../providers/booking_flow_provider.dart';
import '../widgets/barber_selection_card.dart';

class BarberSelectionPage extends ConsumerWidget {
  const BarberSelectionPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final bookingFlow = ref.watch(bookingFlowProvider);
    final selectedService = bookingFlow.selectedService;

    if (selectedService == null) {
      return Scaffold(
        appBar: const CustomAppBar(title: 'Select Barber'),
        body: const Center(
          child: Text('No service selected'),
        ),
      );
    }

    final barbersByServiceAsync = ref.watch(
      barbersByServiceProvider(selectedService.id),
    );

    return Scaffold(
      appBar: CustomAppBar(
        title: 'Select Barber',
        subtitle: selectedService.name,
      ),
      body: Column(
        children: [
          // Selected Service Info
          Container(
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
                  'Selected Service',
                  style: AppTextStyles.bodySmall.copyWith(
                    color: AppColors.textSecondary,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  selectedService.name,
                  style: AppTextStyles.h3.copyWith(
                    color: AppColors.primary,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Rp ${selectedService.price.toStringAsFixed(0)} • ${selectedService.durationMinutes} min',
                  style: AppTextStyles.bodyMedium.copyWith(
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ),
          ),
          
          // Barber List
          Expanded(
            child: barbersByServiceAsync.when(
              data: (barbers) => _buildBarberList(
                context,
                ref,
                barbers,
                bookingFlow.selectedBarber,
              ),
              loading: () => const LoadingWidget(),
              error: (error, stackTrace) => CustomErrorWidget(
                message: error.toString(),
                onRetry: () => ref.invalidate(
                  barbersByServiceProvider(selectedService.id),
                ),
              ),
            ),
          ),
          
          // Continue Button
          if (bookingFlow.canProceedToDateSelection)
            Container(
              padding: const EdgeInsets.all(16),
              child: SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.pushNamed(context, '/booking/date-selection');
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: Text(
                    'Continue to Date Selection',
                    style: AppTextStyles.buttonLarge.copyWith(
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildBarberList(
    BuildContext context,
    WidgetRef ref,
    List<BarberModel> barbers,
    BarberModel? selectedBarber,
  ) {
    if (barbers.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.person_off,
              size: 64,
              color: AppColors.textSecondary,
            ),
            const SizedBox(height: 16),
            Text(
              'No barbers available for this service',
              style: AppTextStyles.bodyLarge.copyWith(
                color: AppColors.textSecondary,
              ),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: barbers.length,
      itemBuilder: (context, index) {
        final barber = barbers[index];
        final isSelected = selectedBarber?.id == barber.id;

        return Padding(
          padding: const EdgeInsets.only(bottom: 12),
          child: BarberSelectionCard(
            barber: barber,
            isSelected: isSelected,
            onTap: () {
              ref.read(bookingFlowProvider.notifier).selectBarber(barber);
            },
          ),
        );
      },
    );
  }
}
