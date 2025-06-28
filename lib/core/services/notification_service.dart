import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:timezone/timezone.dart' as tz;

class NotificationService {
  static final FlutterLocalNotificationsPlugin _localNotifications =
      FlutterLocalNotificationsPlugin();
  
  static const AndroidNotificationChannel _channel = AndroidNotificationChannel(
    'barbershop_booking_channel',
    'Barbershop Booking Notifications',
    description: 'Notifications for booking updates and reminders',
    importance: Importance.high,
  );
  
  static Future<void> initialize() async {
    // Initialize local notifications
    const AndroidInitializationSettings androidSettings =
        AndroidInitializationSettings('@mipmap/ic_launcher');
    
    const DarwinInitializationSettings iosSettings =
        DarwinInitializationSettings(
      requestAlertPermission: true,
      requestBadgePermission: true,
      requestSoundPermission: true,
    );
    
    const InitializationSettings settings = InitializationSettings(
      android: androidSettings,
      iOS: iosSettings,
    );
    
    await _localNotifications.initialize(
      settings,
      onDidReceiveNotificationResponse: _onNotificationTapped,
    );
    
    // Create notification channel for Android
    await _localNotifications
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(_channel);
    
    // Setup Firebase messaging handlers
    _setupFirebaseMessaging();
  }
  
  static void _setupFirebaseMessaging() {
    // Handle foreground messages
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      _showLocalNotification(message);
    });
    
    // Handle background message taps
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      _handleNotificationTap(message);
    });
  }
  
  static Future<void> _showLocalNotification(RemoteMessage message) async {
    const AndroidNotificationDetails androidDetails =
        AndroidNotificationDetails(
      'barbershop_booking_channel',
      'Barbershop Booking Notifications',
      channelDescription: 'Notifications for booking updates and reminders',
      importance: Importance.high,
      priority: Priority.high,
    );
    
    const NotificationDetails details = NotificationDetails(
      android: androidDetails,
      iOS: DarwinNotificationDetails(),
    );
    
    await _localNotifications.show(
      message.hashCode,
      message.notification?.title,
      message.notification?.body,
      details,
      payload: message.data.toString(),
    );
  }  
  static void _onNotificationTapped(NotificationResponse response) {
    // Handle local notification tap
    // TODO: Navigate to appropriate screen based on payload
  }
  
  static void _handleNotificationTap(RemoteMessage message) {
    // Handle Firebase notification tap  
    // TODO: Navigate to appropriate screen based on message data
  }
  
  // Send local notification manually
  static Future<void> showBookingReminder({
    required String title,
    required String body,
    DateTime? scheduledDate,
  }) async {
    const AndroidNotificationDetails androidDetails =
        AndroidNotificationDetails(
      'barbershop_booking_channel',
      'Barbershop Booking Notifications',
      channelDescription: 'Notifications for booking updates and reminders',
      importance: Importance.high,
      priority: Priority.high,
      icon: '@mipmap/ic_launcher',
    );
    
    const NotificationDetails details = NotificationDetails(
      android: androidDetails,
      iOS: DarwinNotificationDetails(),
    );
    
    if (scheduledDate != null) {
      // Convert DateTime to TZDateTime
      final tz.TZDateTime scheduledTZDate = tz.TZDateTime.from(
        scheduledDate.isAfter(DateTime.now()) 
            ? scheduledDate 
            : DateTime.now().add(const Duration(seconds: 1)),
        tz.local,
      );
      
      await _localNotifications.zonedSchedule(
        DateTime.now().millisecondsSinceEpoch.remainder(100000),
        title,
        body,
        scheduledTZDate,
        details,
        androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
        uiLocalNotificationDateInterpretation:
            UILocalNotificationDateInterpretation.absoluteTime,
      );
    } else {
      await _localNotifications.show(
        DateTime.now().millisecondsSinceEpoch.remainder(100000),
        title,
        body,
        details,
      );
    }
  }
  
  // Cancel all notifications
  static Future<void> cancelAllNotifications() async {
    await _localNotifications.cancelAll();
  }
  
  // Cancel specific notification
  static Future<void> cancelNotification(int id) async {
    await _localNotifications.cancel(id);
  }
}