import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_text_styles.dart';
import '../../../../shared/widgets/widgets.dart';
import '../../../../shared/models/service_model.dart';
import '../providers/booking_providers.dart';
import '../providers/booking_flow_provider.dart';
import '../widgets/service_selection_card.dart';

class ServiceSelectionPage extends ConsumerWidget {
  const ServiceSelectionPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final servicesAsync = ref.watch(servicesProvider);
    final bookingFlow = ref.watch(bookingFlowProvider);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: CustomAppBar(
        title: 'Choose Service',
        backgroundColor: AppColors.primary,
        foregroundColor: AppColors.white,
      ),
      body: servicesAsync.when(
        data: (services) => _buildServicesList(context, ref, services, bookingFlow),
        loading: () => const CustomLoading(message: 'Loading services...'),
        error: (error, stack) => EmptyState(
          title: 'Error Loading Services',
          message: error.toString(),
          icon: const Icon(Icons.error_outline, size: 64, color: AppColors.error),
          buttonText: 'Retry',
          onButtonPressed: () => ref.invalidate(servicesProvider),
        ),
      ),
      bottomNavigationBar: _buildBottomBar(context, ref, bookingFlow),
    );
  }

  Widget _buildServicesList(
    BuildContext context,
    WidgetRef ref,
    List<ServiceModel> services,
    BookingFlowState bookingFlow,
  ) {
    if (services.isEmpty) {
      return const EmptyState(
        title: 'No Services Available',
        message: 'There are no services available at the moment.',
        icon: Icon(Icons.content_cut_outlined, size: 64, color: AppColors.grey),
      );
    }

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Text(
            'What service would you like?',
            style: AppTextStyles.h4.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Choose from our professional services',
            style: AppTextStyles.bodyMedium.copyWith(
              color: AppColors.textSecondary,
            ),
          ),
          const SizedBox(height: 24),

          // Services Grid
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              childAspectRatio: 0.8,
              crossAxisSpacing: 16,
              mainAxisSpacing: 16,
            ),
            itemCount: services.length,
            itemBuilder: (context, index) {
              final service = services[index];
              final isSelected = bookingFlow.selectedService?.id == service.id;
              
              return ServiceSelectionCard(
                service: service,
                isSelected: isSelected,
                onTap: () {
                  ref.read(bookingFlowProvider.notifier).selectService(service);
                },
              );
            },
          ),
          
          const SizedBox(height: 100), // Bottom padding for FAB
        ],
      ),
    );
  }

  Widget _buildBottomBar(BuildContext context, WidgetRef ref, BookingFlowState bookingFlow) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.white,
        boxShadow: [
          BoxShadow(
            color: AppColors.black.withValues(alpha: 0.1),
            blurRadius: 8,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: SafeArea(
        child: CustomButton(
          text: 'Continue',
          onPressed: bookingFlow.canProceedToBarberSelection
              ? () => _navigateToBarberSelection(context)
              : null,
        ),
      ),
    );
  }

  void _navigateToBarberSelection(BuildContext context) {
    // Navigate to barber selection page
    context.push('/booking/barber-selection');
  }
}