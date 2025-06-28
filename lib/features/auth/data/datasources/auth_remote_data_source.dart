import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../../../core/errors/exceptions.dart';
import '../../../../core/constants/app_constants.dart';
import '../../../../shared/models/user_model.dart';

abstract class AuthRemoteDataSource {
  Future<UserModel> signInWithEmailAndPassword({
    required String email,
    required String password,
  });
  
  Future<UserModel> registerWithEmailAndPassword({
    required String email,
    required String password,
    required String name,
    String? phoneNumber,
  });
  
  Future<UserModel> signInWithGoogle();
  
  Future<void> signOut();
  
  Future<void> sendPasswordResetEmail({required String email});
  
  Future<UserModel?> getCurrentUser();
  
  Future<UserModel> updateUserProfile({
    required String userId,
    String? name,
    String? phoneNumber,
    String? photoUrl,
  });
  
  Stream<UserModel?> get authStateChanges;
  
  bool get isLoggedIn;
}

class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  final FirebaseAuth firebaseAuth;
  final GoogleSignIn googleSignIn;
  final FirebaseFirestore firestore;
  
  AuthRemoteDataSourceImpl({
    required this.firebaseAuth,
    required this.googleSignIn,
    required this.firestore,
  });
  
  @override
  Future<UserModel> signInWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    try {
      final credential = await firebaseAuth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      
      if (credential.user == null) {
        throw const AuthException('Sign in failed');
      }
      
      return await _getUserFromFirestore(credential.user!.uid) 
          ?? (throw const AuthException('User profile not found'));
    } on FirebaseAuthException catch (e) {
      throw AuthException(_getErrorMessage(e));
    } catch (e) {
      throw AuthException(e.toString());
    }
  }  
  @override
  Future<UserModel> registerWithEmailAndPassword({
    required String email,
    required String password,
    required String name,
    String? phoneNumber,
  }) async {
    try {
      final credential = await firebaseAuth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      
      if (credential.user == null) {
        throw const AuthException('Registration failed');
      }
      
      // Create user profile in Firestore
      final user = UserModel(
        id: credential.user!.uid,
        email: email,
        name: name,
        phoneNumber: phoneNumber,
        photoUrl: null,
        role: AppConstants.roleCustomer,
        isActive: true,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );
      
      await _createUserInFirestore(user);
      return user;
    } on FirebaseAuthException catch (e) {
      throw AuthException(_getErrorMessage(e));
    } catch (e) {
      throw AuthException(e.toString());
    }
  }
  
  @override
  Future<UserModel> signInWithGoogle() async {
    try {
      final GoogleSignInAccount? googleUser = await googleSignIn.signIn();
      
      if (googleUser == null) {
        throw const AuthException('Google sign in was cancelled');
      }
      
      final GoogleSignInAuthentication googleAuth = 
          await googleUser.authentication;
      
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );
      
      final userCredential = await firebaseAuth.signInWithCredential(credential);
      
      if (userCredential.user == null) {
        throw const AuthException('Google sign in failed');
      }
      
      // Check if user exists in Firestore  
      final existingUser = await _getUserFromFirestore(
        userCredential.user!.uid,
        createIfNotExists: false,
      );
      
      if (existingUser != null) {
        return existingUser;
      }
      
      // Create new user profile
      final user = UserModel(
        id: userCredential.user!.uid,
        email: userCredential.user!.email!,
        name: userCredential.user!.displayName ?? 'Google User',
        phoneNumber: userCredential.user!.phoneNumber,
        photoUrl: userCredential.user!.photoURL,
        role: AppConstants.roleCustomer,
        isActive: true,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );
      
      await _createUserInFirestore(user);
      return user;
    } catch (e) {
      throw AuthException(e.toString());
    }
  }  
  @override
  Future<void> signOut() async {
    try {
      await Future.wait([
        firebaseAuth.signOut(),
        googleSignIn.signOut(),
      ]);
    } catch (e) {
      throw AuthException(e.toString());
    }
  }
  
  @override
  Future<void> sendPasswordResetEmail({required String email}) async {
    try {
      await firebaseAuth.sendPasswordResetEmail(email: email);
    } on FirebaseAuthException catch (e) {
      throw AuthException(_getErrorMessage(e));
    } catch (e) {
      throw AuthException(e.toString());
    }
  }
  
  @override
  Future<UserModel?> getCurrentUser() async {
    try {
      final firebaseUser = firebaseAuth.currentUser;
      if (firebaseUser == null) return null;
      
      return await _getUserFromFirestore(firebaseUser.uid);
    } catch (e) {
      throw AuthException(e.toString());
    }
  }
  
  @override
  Future<UserModel> updateUserProfile({
    required String userId,
    String? name,
    String? phoneNumber,
    String? photoUrl,
  }) async {
    try {
      final updates = <String, dynamic>{
        'updatedAt': FieldValue.serverTimestamp(),
      };
      
      if (name != null) updates['name'] = name;
      if (phoneNumber != null) updates['phoneNumber'] = phoneNumber;
      if (photoUrl != null) updates['photoUrl'] = photoUrl;
      
      await firestore
          .collection(AppConstants.usersCollection)
          .doc(userId)
          .update(updates);
      
      return await _getUserFromFirestore(userId) 
          ?? (throw const AuthException('User profile not found'));
    } catch (e) {
      throw AuthException(e.toString());
    }
  }
  
  @override
  Stream<UserModel?> get authStateChanges {
    return firebaseAuth.authStateChanges().asyncMap((firebaseUser) async {
      if (firebaseUser == null) return null;
      try {
        return await _getUserFromFirestore(firebaseUser.uid);
      } catch (e) {
        return null;
      }
    });
  }
  
  @override
  bool get isLoggedIn => firebaseAuth.currentUser != null;  
  // Helper methods
  Future<UserModel?> _getUserFromFirestore(
    String userId, {
    bool createIfNotExists = true,
  }) async {
    final doc = await firestore
        .collection(AppConstants.usersCollection)
        .doc(userId)
        .get();
    
    if (!doc.exists && !createIfNotExists) {
      return null;
    }
    
    if (!doc.exists) {
      throw const AuthException('User profile not found');
    }
    
    final data = doc.data()!;
    data['id'] = doc.id;
    
    // Convert Timestamp to DateTime
    if (data['createdAt'] is Timestamp) {
      data['createdAt'] = (data['createdAt'] as Timestamp).toDate().toIso8601String();
    }
    if (data['updatedAt'] is Timestamp) {
      data['updatedAt'] = (data['updatedAt'] as Timestamp).toDate().toIso8601String();
    }
    
    return UserModel.fromJson(data);
  }
  
  Future<void> _createUserInFirestore(UserModel user) async {
    final data = user.toJson();
    data.remove('id'); // Remove id as it's used as document ID
    
    await firestore
        .collection(AppConstants.usersCollection)
        .doc(user.id)
        .set(data);
  }
  
  String _getErrorMessage(FirebaseAuthException e) {
    switch (e.code) {
      case 'user-not-found':
        return 'No user found with this email address';
      case 'wrong-password':
        return 'Incorrect password';
      case 'email-already-in-use':
        return 'An account already exists with this email';
      case 'weak-password':
        return 'Password is too weak';
      case 'invalid-email':
        return 'Invalid email address';
      case 'user-disabled':
        return 'This account has been disabled';
      case 'too-many-requests':
        return 'Too many failed attempts. Please try again later';
      case 'network-request-failed':
        return 'Network error. Please check your connection';
      default:
        return e.message ?? 'An unknown error occurred';
    }
  }
}