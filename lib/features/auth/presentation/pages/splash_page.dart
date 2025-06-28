import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_text_styles.dart';
import '../../../../core/constants/app_routes.dart';
import '../../../../core/constants/app_constants.dart';
import '../providers/auth_state_provider.dart';

class SplashPage extends ConsumerStatefulWidget {
  const SplashPage({super.key});

  @override
  ConsumerState<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends ConsumerState<SplashPage> {
  @override
  void initState() {
    super.initState();
    _initializeApp();
  }

  Future<void> _initializeApp() async {
    // Show splash for minimum 2 seconds
    await Future.delayed(const Duration(seconds: 2));
    
    if (!mounted) return;
    
    // Get current user
    final authNotifier = ref.read(authStateProvider.notifier);
    final result = await authNotifier.getCurrentUser();
    
    if (!mounted) return;
    
    result.fold(
      (failure) {
        // User not logged in or error occurred
        context.go(AppRoutes.login);
      },
      (user) {
        if (user != null) {
          // User is logged in, navigate based on role
          _navigateBasedOnRole(user.role);
        } else {
          // User not logged in
          context.go(AppRoutes.login);
        }
      },
    );
  }

  void _navigateBasedOnRole(String role) {
    switch (role) {
      case AppConstants.roleCustomer:
        context.go(AppRoutes.home);
        break;
      case AppConstants.roleBarber:
        context.go(AppRoutes.barberDashboard);
        break;
      case AppConstants.roleAdmin:
      case AppConstants.roleSuperAdmin:
        context.go(AppRoutes.adminDashboard);
        break;
      default:
        context.go(AppRoutes.home);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primary,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // App Logo/Icon
            Container(
              width: 120,
              height: 120,
              decoration: BoxDecoration(
                color: AppColors.white,
                borderRadius: BorderRadius.circular(24),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.black.withValues(alpha: 0.1),
                    blurRadius: 20,
                    offset: const Offset(0, 10),
                  ),
                ],
              ),
              child: const Icon(
                Icons.content_cut,
                size: 64,
                color: AppColors.primary,
              ),
            ),
            const SizedBox(height: 32),
            
            // App Name
            Text(
              'Barbershop Booking',
              style: AppTextStyles.h2.copyWith(
                color: AppColors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            
            // App Tagline
            Text(
              'Book your perfect cut',
              style: AppTextStyles.bodyLarge.copyWith(
                color: AppColors.white.withValues(alpha: 0.8),
              ),
            ),
            const SizedBox(height: 48),
            
            // Loading Indicator
            SizedBox(
              width: 32,
              height: 32,
              child: CircularProgressIndicator(
                strokeWidth: 3,
                valueColor: AlwaysStoppedAnimation<Color>(
                  AppColors.white.withValues(alpha: 0.8),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}