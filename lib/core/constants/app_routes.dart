class AppRoutes {
  // Auth Routes
  static const String splash = '/';
  static const String login = '/login';
  static const String register = '/register';
  static const String forgotPassword = '/forgot-password';
  
  // Customer Routes
  static const String home = '/home';
  static const String booking = '/booking';
  static const String bookingDetails = '/booking/:id';
  static const String services = '/services';
  static const String barbers = '/barbers';
  static const String barberDetails = '/barber/:id';
  static const String profile = '/profile';
  static const String editProfile = '/profile/edit';
  static const String bookingHistory = '/booking-history';
  static const String reviews = '/reviews';
  static const String writeReview = '/write-review/:bookingId';
  
  // Barber Routes
  static const String barberDashboard = '/barber/dashboard';
  static const String barberSchedule = '/barber/schedule';
  static const String barberBookings = '/barber/bookings';
  static const String barberProfile = '/barber/profile';
  static const String barberShifts = '/barber/shifts';
  
  // Admin Routes
  static const String adminDashboard = '/admin/dashboard';
  static const String adminBookings = '/admin/bookings';
  static const String adminBarbers = '/admin/barbers';
  static const String adminServices = '/admin/services';
  static const String adminReports = '/admin/reports';
  static const String adminUsers = '/admin/users';
  static const String adminSettings = '/admin/settings';
  
  // Common Routes
  static const String notifications = '/notifications';
  static const String settings = '/settings';
  static const String about = '/about';
  static const String help = '/help';
}