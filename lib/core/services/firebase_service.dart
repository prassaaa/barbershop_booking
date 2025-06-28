import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:firebase_storage/firebase_storage.dart';
import '../../firebase_options.dart';

class FirebaseService {
  static FirebaseAuth get auth => FirebaseAuth.instance;
  static FirebaseFirestore get firestore => FirebaseFirestore.instance;
  static FirebaseMessaging get messaging => FirebaseMessaging.instance;
  static FirebaseStorage get storage => FirebaseStorage.instance;
  
  static Future<void> initialize() async {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
    await _setupFirebaseMessaging();
  }
  
  static Future<void> _setupFirebaseMessaging() async {
    // Request permission for notifications
    await messaging.requestPermission(
      alert: true,
      badge: true,
      sound: true,
      provisional: false,
    );
    
    // Get FCM token
    String? token = await messaging.getToken();
    if (token != null) {
      // TODO: Send token to server for push notifications
    }
    
    // Listen to token refresh
    messaging.onTokenRefresh.listen((String token) {
      // TODO: Send refreshed token to server
    });
  }
  
  // Auth Helper Methods
  static User? get currentUser => auth.currentUser;
  static bool get isUserLoggedIn => currentUser != null;
  static String? get currentUserId => currentUser?.uid;
  
  // Firestore Helper Methods
  static CollectionReference users = firestore.collection('users');
  static CollectionReference barbers = firestore.collection('barbers');
  static CollectionReference bookings = firestore.collection('bookings');
  static CollectionReference services = firestore.collection('services');
  static CollectionReference reviews = firestore.collection('reviews');
  static CollectionReference adminUsers = firestore.collection('admin_users');
  static CollectionReference settings = firestore.collection('settings');
}