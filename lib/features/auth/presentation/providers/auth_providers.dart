import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../../data/datasources/auth_remote_data_source.dart';
import '../../data/repositories/auth_repository_impl.dart';
import '../../domain/repositories/auth_repository.dart';
import '../../domain/usecases/sign_in_with_email_and_password.dart';
import '../../domain/usecases/auth_usecases.dart';

// Firebase instances
final firebaseAuthProvider = Provider<FirebaseAuth>((ref) {
  return FirebaseAuth.instance;
});

final googleSignInProvider = Provider<GoogleSignIn>((ref) {
  return GoogleSignIn();
});

final firestoreProvider = Provider<FirebaseFirestore>((ref) {
  return FirebaseFirestore.instance;
});

// Data source
final authRemoteDataSourceProvider = Provider<AuthRemoteDataSource>((ref) {
  return AuthRemoteDataSourceImpl(
    firebaseAuth: ref.read(firebaseAuthProvider),
    googleSignIn: ref.read(googleSignInProvider),
    firestore: ref.read(firestoreProvider),
  );
});

// Repository
final authRepositoryProvider = Provider<AuthRepository>((ref) {
  return AuthRepositoryImpl(
    remoteDataSource: ref.read(authRemoteDataSourceProvider),
  );
});

// Use cases
final signInWithEmailAndPasswordProvider = Provider<SignInWithEmailAndPassword>((ref) {
  return SignInWithEmailAndPassword(ref.read(authRepositoryProvider));
});

final registerWithEmailAndPasswordProvider = Provider<RegisterWithEmailAndPassword>((ref) {
  return RegisterWithEmailAndPassword(ref.read(authRepositoryProvider));
});

final signInWithGoogleProvider = Provider<SignInWithGoogle>((ref) {
  return SignInWithGoogle(ref.read(authRepositoryProvider));
});

final signOutProvider = Provider<SignOut>((ref) {
  return SignOut(ref.read(authRepositoryProvider));
});

final getCurrentUserProvider = Provider<GetCurrentUser>((ref) {
  return GetCurrentUser(ref.read(authRepositoryProvider));
});

final sendPasswordResetEmailProvider = Provider<SendPasswordResetEmail>((ref) {
  return SendPasswordResetEmail(ref.read(authRepositoryProvider));
});