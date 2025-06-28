import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../constants/app_routes.dart';
import '../../features/auth/presentation/pages/splash_page.dart';
import '../../features/auth/presentation/pages/login_page.dart';
import '../../features/auth/presentation/pages/register_page.dart';
import '../../features/customer/presentation/pages/customer_home_page.dart';
import '../../features/booking/presentation/pages/booking_flow_page.dart';
import '../../features/booking/presentation/pages/service_selection_page.dart';
import '../../features/booking/presentation/pages/barber_selection_page.dart';
import '../../features/booking/presentation/pages/date_selection_page.dart';
import '../../features/booking/presentation/pages/time_selection_page.dart';
import '../../features/booking/presentation/pages/booking_confirmation_page.dart';
import '../../features/booking/presentation/pages/booking_success_page.dart';
import '../../shared/models/booking_model.dart';
import '../services/firebase_service.dart';

class AppRouter {
  static final GoRouter _router = GoRouter(
    initialLocation: AppRoutes.splash,
    redirect: _handleRedirect,
    routes: [
      // Auth Routes
      GoRoute(
        path: AppRoutes.splash,
        name: 'splash',
        builder: (context, state) => const SplashPage(),
      ),
      GoRoute(
        path: AppRoutes.login,
        name: 'login',
        builder: (context, state) => const LoginPage(),
      ),
      GoRoute(
        path: AppRoutes.register,
        name: 'register',
        builder: (context, state) => const RegisterPage(),
      ),
      
      // Customer Routes
      GoRoute(
        path: AppRoutes.home,
        name: 'home',
        builder: (context, state) => const CustomerHomePage(),
      ),
      
      // Booking Routes
      GoRoute(
        path: AppRoutes.bookingFlow,
        name: 'booking-flow',
        builder: (context, state) => const BookingFlowPage(),
      ),
      
      GoRoute(
        path: AppRoutes.serviceSelection,
        name: 'service-selection',
        builder: (context, state) => const ServiceSelectionPage(),
      ),
      
      GoRoute(
        path: AppRoutes.barberSelection,
        name: 'barber-selection',
        builder: (context, state) => const BarberSelectionPage(),
      ),
      
      GoRoute(
        path: AppRoutes.dateSelection,
        name: 'date-selection',
        builder: (context, state) => const DateSelectionPage(),
      ),
      
      GoRoute(
        path: AppRoutes.timeSelection,
        name: 'time-selection',
        builder: (context, state) => const TimeSelectionPage(),
      ),
      
      GoRoute(
        path: AppRoutes.bookingConfirmation,
        name: 'booking-confirmation',
        builder: (context, state) => const BookingConfirmationPage(),
      ),
      
      GoRoute(
        path: AppRoutes.bookingSuccess,
        name: 'booking-success',
        builder: (context, state) {
          final booking = state.extra as BookingModel?;
          if (booking == null) {
            return const ErrorPage();
          }
          return BookingSuccessPage(booking: booking);
        },
      ),
      
      // Placeholder pages (will be created later)
      GoRoute(
        path: AppRoutes.booking,
        name: 'booking',
        builder: (context, state) => const PlaceholderPage(title: 'Booking'),
      ),
      
      GoRoute(
        path: AppRoutes.profile,
        name: 'profile',
        builder: (context, state) => const PlaceholderPage(title: 'Profile'),
      ),
      
      // Barber Routes
      GoRoute(
        path: AppRoutes.barberDashboard,
        name: 'barber-dashboard',
        builder: (context, state) => const PlaceholderPage(title: 'Barber Dashboard'),
      ),
      
      // Admin Routes
      GoRoute(
        path: AppRoutes.adminDashboard,
        name: 'admin-dashboard',
        builder: (context, state) => const PlaceholderPage(title: 'Admin Dashboard'),
      ),
    ],
    errorBuilder: (context, state) => const ErrorPage(),
  );
  
  static GoRouter get router => _router;  
  static String? _handleRedirect(BuildContext context, GoRouterState state) {
    final isLoggedIn = FirebaseService.isUserLoggedIn;
    final currentPath = state.uri.path;
    
    // Define auth-required routes
    final authRequiredRoutes = [
      AppRoutes.home,
      AppRoutes.booking,
      AppRoutes.bookingFlow,
      AppRoutes.serviceSelection,
      AppRoutes.barberSelection,
      AppRoutes.dateSelection,
      AppRoutes.timeSelection,
      AppRoutes.bookingConfirmation,
      AppRoutes.bookingSuccess,
      AppRoutes.profile,
      AppRoutes.barberDashboard,
      AppRoutes.adminDashboard,
    ];
    
    // Define public routes (no auth required)
    final publicRoutes = [
      AppRoutes.splash,
      AppRoutes.login,
      AppRoutes.register,
      AppRoutes.forgotPassword,
    ];
    
    // If user is not logged in and trying to access protected route
    if (!isLoggedIn && authRequiredRoutes.any((route) => currentPath.startsWith(route))) {
      return AppRoutes.login;
    }
    
    // If user is logged in and on auth pages, redirect to appropriate dashboard
    if (isLoggedIn && publicRoutes.contains(currentPath) && currentPath != AppRoutes.splash) {
      // TODO: Redirect based on user role
      return AppRoutes.home; // Default to customer home for now
    }
    
    return null; // No redirect needed
  }
}

// Placeholder Pages (will be replaced with actual pages)
class PlaceholderPage extends StatelessWidget {
  final String title;
  
  const PlaceholderPage({super.key, required this.title});
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(title)),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.construction, size: 64, color: Colors.grey),
            const SizedBox(height: 16),
            Text(
              '$title Page',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: 8),
            Text(
              'This page is under construction',
              style: Theme.of(context).textTheme.bodyMedium,
            ),
          ],
        ),
      ),
    );
  }
}
class ErrorPage extends StatelessWidget {
  const ErrorPage({super.key});
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Error')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.error_outline, size: 64, color: Colors.red),
            const SizedBox(height: 16),
            Text(
              'Page Not Found',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: 8),
            const Text(
              'The page you are looking for does not exist.',
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: () => context.go(AppRoutes.home),
              child: const Text('Go to Home'),
            ),
          ],
        ),
      ),
    );
  }
}

