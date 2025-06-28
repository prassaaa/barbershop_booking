import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../../../../shared/models/user_model.dart';
import '../../domain/usecases/sign_in_with_email_and_password.dart';
import 'auth_providers.dart';

// Auth State
class AuthState {
  final UserModel? user;
  final bool isLoading;
  final String? error;
  final bool isAuthenticated;

  const AuthState({
    this.user,
    this.isLoading = false,
    this.error,
    this.isAuthenticated = false,
  });

  AuthState copyWith({
    UserModel? user,
    bool? isLoading,
    String? error,
    bool? isAuthenticated,
  }) {
    return AuthState(
      user: user ?? this.user,
      isLoading: isLoading ?? this.isLoading,
      error: error,
      isAuthenticated: isAuthenticated ?? this.isAuthenticated,
    );
  }
}

// Auth State Notifier
class AuthStateNotifier extends StateNotifier<AuthState> {
  final Ref ref;

  AuthStateNotifier(this.ref) : super(const AuthState()) {
    _init();
  }

  void _init() {
    // Listen to auth state changes
    ref.read(authRepositoryProvider).authStateChanges.listen((user) {
      if (user != null) {
        state = state.copyWith(
          user: user,
          isAuthenticated: true,
          isLoading: false,
        );
      } else {
        state = const AuthState(isAuthenticated: false);
      }
    });
  }

  Future<Either<Failure, UserModel>> signInWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    state = state.copyWith(isLoading: true, error: null);
    
    final usecase = ref.read(signInWithEmailAndPasswordProvider);
    final result = await usecase(SignInParams(email: email, password: password));
    
    result.fold(
      (failure) {
        state = state.copyWith(
          isLoading: false,
          error: failure.message,
        );
      },
      (user) {
        state = state.copyWith(
          user: user,
          isAuthenticated: true,
          isLoading: false,
          error: null,
        );
      },
    );
    
    return result;
  }

  Future<Either<Failure, UserModel>> registerWithEmailAndPassword({
    required String email,
    required String password,
    required String name,
    String? phoneNumber,
  }) async {
    state = state.copyWith(isLoading: true, error: null);
    
    final usecase = ref.read(registerWithEmailAndPasswordProvider);
    final result = await usecase(RegisterParams(
      email: email,
      password: password,
      name: name,
      phoneNumber: phoneNumber,
    ));
    
    result.fold(
      (failure) {
        state = state.copyWith(
          isLoading: false,
          error: failure.message,
        );
      },
      (user) {
        state = state.copyWith(
          user: user,
          isAuthenticated: true,
          isLoading: false,
          error: null,
        );
      },
    );
    
    return result;
  }

  Future<Either<Failure, UserModel>> signInWithGoogle() async {
    state = state.copyWith(isLoading: true, error: null);
    
    final usecase = ref.read(signInWithGoogleProvider);
    final result = await usecase();
    
    result.fold(
      (failure) {
        state = state.copyWith(
          isLoading: false,
          error: failure.message,
        );
      },
      (user) {
        state = state.copyWith(
          user: user,
          isAuthenticated: true,
          isLoading: false,
          error: null,
        );
      },
    );
    
    return result;
  }

  Future<Either<Failure, void>> signOut() async {
    state = state.copyWith(isLoading: true);
    
    final usecase = ref.read(signOutProvider);
    final result = await usecase();
    
    result.fold(
      (failure) {
        state = state.copyWith(
          isLoading: false,
          error: failure.message,
        );
      },
      (_) {
        state = const AuthState(isAuthenticated: false);
      },
    );
    
    return result;
  }

  Future<Either<Failure, void>> sendPasswordResetEmail(String email) async {
    final usecase = ref.read(sendPasswordResetEmailProvider);
    return await usecase(email);
  }

  Future<Either<Failure, UserModel?>> getCurrentUser() async {
    final usecase = ref.read(getCurrentUserProvider);
    return await usecase();
  }
}

// Provider
final authStateProvider = StateNotifierProvider<AuthStateNotifier, AuthState>((ref) {
  return AuthStateNotifier(ref);
});