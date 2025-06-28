import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_text_styles.dart';
import '../../../../core/constants/app_routes.dart';
import '../../../../core/utils/validators.dart';
import '../../../../shared/widgets/widgets.dart';
import '../providers/auth_state_provider.dart';

class LoginPage extends ConsumerStatefulWidget {
  const LoginPage({super.key});

  @override
  ConsumerState<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends ConsumerState<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _handleLogin() async {
    if (!_formKey.currentState!.validate()) return;

    final authNotifier = ref.read(authStateProvider.notifier);
    
    final result = await authNotifier.signInWithEmailAndPassword(
      email: _emailController.text.trim(),
      password: _passwordController.text,
    );

    if (mounted) {
      result.fold(
        (failure) {
          CustomDialog.showError(
            context: context,
            title: 'Login Failed',
            message: failure.message,
          );
        },
        (user) {
          // Navigate based on user role
          _navigateBasedOnRole(user.role);
        },
      );
    }
  }

  Future<void> _handleGoogleSignIn() async {
    final authNotifier = ref.read(authStateProvider.notifier);
    
    final result = await authNotifier.signInWithGoogle();

    if (mounted) {
      result.fold(
        (failure) {
          CustomDialog.showError(
            context: context,
            title: 'Google Sign In Failed',
            message: failure.message,
          );
        },
        (user) {
          // Navigate based on user role
          _navigateBasedOnRole(user.role);
        },
      );
    }
  }

  void _navigateBasedOnRole(String role) {
    switch (role) {
      case 'customer':
        context.go(AppRoutes.home);
        break;
      case 'barber':
        context.go(AppRoutes.barberDashboard);
        break;
      case 'admin':
      case 'super_admin':
        context.go(AppRoutes.adminDashboard);
        break;
      default:
        context.go(AppRoutes.home);
    }
  }

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authStateProvider);
    final isLoading = authState.isLoading;

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 40),
                
                // Header
                Center(
                  child: Column(
                    children: [
                      Container(
                        width: 80,
                        height: 80,
                        decoration: BoxDecoration(
                          color: AppColors.primary,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: const Icon(
                          Icons.content_cut,
                          size: 40,
                          color: AppColors.white,
                        ),
                      ),
                      const SizedBox(height: 24),
                      Text(
                        'Welcome Back',
                        style: AppTextStyles.h2,
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Sign in to continue',
                        style: AppTextStyles.bodyMedium.copyWith(
                          color: AppColors.textSecondary,
                        ),
                      ),
                    ],
                  ),
                ),
                
                const SizedBox(height: 48),                
                // Email Field
                CustomTextField(
                  label: 'Email',
                  hint: 'Enter your email',
                  controller: _emailController,
                  keyboardType: TextInputType.emailAddress,
                  validator: Validators.validateEmail,
                  prefixIcon: const Icon(Icons.email_outlined),
                  enabled: !isLoading,
                ),
                
                const SizedBox(height: 20),
                
                // Password Field
                CustomTextField(
                  label: 'Password',
                  hint: 'Enter your password',
                  controller: _passwordController,
                  obscureText: true,
                  validator: Validators.validatePassword,
                  prefixIcon: const Icon(Icons.lock_outlined),
                  enabled: !isLoading,
                ),
                
                const SizedBox(height: 16),
                
                // Forgot Password
                Align(
                  alignment: Alignment.centerRight,
                  child: TextButton(
                    onPressed: isLoading ? null : () {
                      _showForgotPasswordDialog();
                    },
                    child: Text(
                      'Forgot Password?',
                      style: AppTextStyles.bodyMedium.copyWith(
                        color: AppColors.primary,
                      ),
                    ),
                  ),
                ),
                
                const SizedBox(height: 32),
                
                // Login Button
                CustomButton(
                  text: 'Sign In',
                  onPressed: isLoading ? null : _handleLogin,
                  isLoading: isLoading,
                ),
                
                const SizedBox(height: 24),
                
                // Divider
                Row(
                  children: [
                    const Expanded(child: Divider()),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: Text(
                        'or',
                        style: AppTextStyles.bodyMedium.copyWith(
                          color: AppColors.textSecondary,
                        ),
                      ),
                    ),
                    const Expanded(child: Divider()),
                  ],
                ),
                
                const SizedBox(height: 24),
                
                // Google Sign In
                CustomButton(
                  text: 'Continue with Google',
                  onPressed: isLoading ? null : _handleGoogleSignIn,
                  type: ButtonType.outline,
                  icon: const Icon(Icons.g_mobiledata, size: 24),
                ),
                
                const SizedBox(height: 32),
                
                // Sign Up Link
                Center(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "Don't have an account? ",
                        style: AppTextStyles.bodyMedium,
                      ),
                      TextButton(
                        onPressed: isLoading ? null : () => context.push(AppRoutes.register),
                        child: Text(
                          'Sign Up',
                          style: AppTextStyles.bodyMedium.copyWith(
                            color: AppColors.primary,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
  void _showForgotPasswordDialog() {
    final emailController = TextEditingController();
    
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Reset Password'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text('Enter your email address to receive a password reset link.'),
            const SizedBox(height: 16),
            CustomTextField(
              controller: emailController,
              hint: 'Enter your email',
              keyboardType: TextInputType.emailAddress,
              validator: Validators.validateEmail,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () async {
              if (emailController.text.trim().isEmpty) {
                CustomDialog.showError(
                  context: context,
                  title: 'Error',
                  message: 'Please enter your email address',
                );
                return;
              }
              
              Navigator.pop(context);
              
              final authNotifier = ref.read(authStateProvider.notifier);
              final result = await authNotifier.sendPasswordResetEmail(
                emailController.text.trim(),
              );
              
              if (mounted) {
                result.fold(
                  (failure) {
                    CustomDialog.showError(
                      context: context,
                      title: 'Error',
                      message: failure.message,
                    );
                  },
                  (_) {
                    CustomDialog.showSuccess(
                      context: context,
                      title: 'Success',
                      message: 'Password reset email sent! Check your inbox.',
                    );
                  },
                );
              }
            },
            child: const Text('Send'),
          ),
        ],
      ),
    );
  }
}