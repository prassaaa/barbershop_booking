class AppConstants {
  // App Info
  static const String appName = 'Barbershop Booking';
  static const String appVersion = '1.0.0';
  
  // API & Firebase
  static const String baseUrl = 'https://api.barbershop.com';
  static const int connectTimeout = 30000;
  static const int receiveTimeout = 30000;
  
  // Collections
  static const String usersCollection = 'users';
  static const String barbersCollection = 'barbers';
  static const String bookingsCollection = 'bookings';
  static const String servicesCollection = 'services';
  static const String reviewsCollection = 'reviews';
  static const String adminUsersCollection = 'admin_users';
  static const String settingsCollection = 'settings';
  
  // Shared Preferences Keys
  static const String keyIsFirstTime = 'is_first_time';
  static const String keyUserId = 'user_id';
  static const String keyUserRole = 'user_role';
  static const String keyThemeMode = 'theme_mode';
  static const String keyLanguage = 'language';
  
  // User Roles
  static const String roleCustomer = 'customer';
  static const String roleBarber = 'barber';
  static const String roleAdmin = 'admin';
  static const String roleSuperAdmin = 'super_admin';
  
  // Booking Status
  static const String bookingWaiting = 'waiting';
  static const String bookingConfirmed = 'confirmed';
  static const String bookingCompleted = 'completed';
  static const String bookingCancelled = 'cancelled';
  
  // Service Types
  static const String serviceCut = 'cut';
  static const String serviceShave = 'shave';
  static const String serviceGrooming = 'grooming';
  
  // Business Hours
  static const int openHour = 8;
  static const int closeHour = 21;
  static const int slotDurationMinutes = 30;
  static const int maxAdvanceBookingDays = 30;
  
  // Validation
  static const int minPasswordLength = 6;
  static const int maxNameLength = 50;
  static const int maxPhoneLength = 15;
  
  // File Upload
  static const int maxImageSizeMB = 5;
  static const List<String> allowedImageTypes = ['jpg', 'jpeg', 'png'];
}