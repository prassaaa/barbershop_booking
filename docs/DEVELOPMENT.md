# Development Guide

## Getting Started

### Prerequisites
- Flutter SDK (3.19.0+)
- Dart SDK (3.8.1+)
- Firebase account
- IDE (VS Code or Android Studio)
- Git

### Initial Setup

1. **Clone the repository**
   ```bash
   git clone https://github.com/prassaaa/barbershop_booking.git
   cd barbershop_booking
   ```

2. **Install dependencies**
   ```bash
   flutter pub get
   ```

3. **Generate code**
   ```bash
   flutter packages pub run build_runner build
   ```

4. **Setup Firebase** (see [Firebase Setup Guide](FIREBASE_SETUP.md))

5. **Run the application**
   ```bash
   flutter run
   ```

## Development Workflow

### Branch Strategy
- `main`: Production-ready code
- `develop`: Integration branch for features
- `feature/*`: Individual feature development
- `hotfix/*`: Critical bug fixes

### Commit Convention
```
type(scope): description

Types:
- feat: New feature
- fix: Bug fix
- docs: Documentation changes
- style: Code style changes
- refactor: Code refactoring
- test: Adding tests
- chore: Maintenance tasks

Examples:
feat(auth): add Google sign-in functionality
fix(booking): resolve time slot validation issue
docs(readme): update installation instructions
```

### Code Style

#### Dart/Flutter Guidelines
- Follow official [Dart Style Guide](https://dart.dev/guides/language/effective-dart/style)
- Use `flutter format` before committing
- Maximum line length: 80 characters
- Use meaningful variable names
- Add documentation for public APIs

#### File Naming
- Use snake_case for file names
- Use PascalCase for class names
- Use camelCase for variables and functions

#### Directory Structure
```
lib/
├── core/                   # Core functionality
├── features/              # Feature modules
├── shared/               # Shared components
└── main.dart            # Entry point
```

### Code Generation

#### Models
Add `@JsonSerializable()` to model classes:
```dart
@JsonSerializable()
class UserModel {
  // Model implementation
}
```

#### Providers
Use `@riverpod` annotation for auto-generated providers:
```dart
@riverpod
class AuthNotifier extends _$AuthNotifier {
  // Provider implementation
}
```

#### Running Code Generation
```bash
# One-time generation
flutter packages pub run build_runner build

# Watch mode (recommended during development)
flutter packages pub run build_runner watch

# Clean and rebuild
flutter packages pub run build_runner build --delete-conflicting-outputs
```

### Testing

#### Unit Tests
Create test files in `test/` directory:
```dart
void main() {
  group('AuthRepository', () {
    test('should return user when sign in is successful', () async {
      // Test implementation
    });
  });
}
```

#### Widget Tests
```dart
void main() {
  testWidgets('LoginPage should display login form', (tester) async {
    await tester.pumpWidget(MyApp());
    expect(find.byType(LoginPage), findsOneWidget);
  });
}
```

#### Running Tests
```bash
# Run all tests
flutter test

# Run specific test file
flutter test test/features/auth/auth_test.dart

# Run with coverage
flutter test --coverage
```

### State Management

#### Riverpod Best Practices
1. **Provider Naming**: Use descriptive names ending with `Provider`
2. **State Management**: Use appropriate provider types
3. **Dependency Injection**: Inject dependencies through providers
4. **Error Handling**: Handle errors gracefully in providers

#### Example Provider
```dart
@riverpod
class BookingNotifier extends _$BookingNotifier {
  @override
  FutureOr<List<BookingModel>> build() {
    return _loadBookings();
  }

  Future<void> createBooking(BookingModel booking) async {
    state = const AsyncValue.loading();
    try {
      await ref.read(bookingRepositoryProvider).createBooking(booking);
      ref.invalidateSelf();
    } catch (error) {
      state = AsyncValue.error(error, StackTrace.current);
    }
  }
}
```

### UI Development

#### Widget Guidelines
1. **Single Responsibility**: Each widget should have one purpose
2. **Composition**: Prefer composition over inheritance
3. **Stateless**: Use StatelessWidget when possible
4. **Performance**: Minimize rebuilds with proper keys and optimization

#### Custom Widgets
```dart
class CustomButton extends StatelessWidget {
  const CustomButton({
    super.key,
    required this.text,
    this.onPressed,
  });

  final String text;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      child: Text(text),
    );
  }
}
```

#### Theme Usage
```dart
// Use theme colors
color: Theme.of(context).colorScheme.primary

// Use text styles
style: Theme.of(context).textTheme.headlineMedium

// Use custom theme extensions
style: AppTextStyles.h1
```

### Navigation

#### Route Definitions
```dart
class AppRoutes {
  static const String home = '/home';
  static const String profile = '/profile';
  static const String booking = '/booking/:id';
}
```

#### Navigation Usage
```dart
// Navigate to route
context.go(AppRoutes.home);

// Navigate with parameters
context.goNamed('booking', pathParameters: {'id': bookingId});

// Pop current route
context.pop();
```

### Error Handling

#### Custom Exceptions
```dart
class BookingException implements Exception {
  final String message;
  final String? code;
  
  const BookingException(this.message, {this.code});
}
```

#### Error Widgets
```dart
class ErrorWidget extends StatelessWidget {
  const ErrorWidget({super.key, required this.error});
  
  final String error;
  
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        children: [
          Icon(Icons.error_outline),
          Text(error),
          ElevatedButton(
            onPressed: () => context.pop(),
            child: Text('Go Back'),
          ),
        ],
      ),
    );
  }
}
```

### Performance Optimization

#### Best Practices
1. **Use const constructors** when possible
2. **Implement proper keys** for lists
3. **Avoid rebuilds** with Provider.of(listen: false)
4. **Lazy load** expensive operations
5. **Cache images** and data when appropriate

#### Performance Monitoring
```dart
// Use Flutter Inspector
flutter inspector

// Profile performance
flutter run --profile

// Analyze bundle size
flutter build apk --analyze-size
```

### Debugging

#### Debug Tools
1. **Flutter Inspector**: Widget tree visualization
2. **Performance Overlay**: Frame rendering info
3. **Network Inspector**: API call monitoring
4. **Memory Inspector**: Memory usage analysis

#### Logging
```dart
import 'dart:developer' as developer;

// Simple logging
developer.log('User signed in', name: 'auth');

// Structured logging
developer.log(
  'Booking created',
  name: 'booking',
  time: DateTime.now(),
  level: 800,
);
```

### Building for Production

#### Android
```bash
# Debug APK
flutter build apk --debug

# Release APK
flutter build apk --release

# App Bundle (recommended for Play Store)
flutter build appbundle --release
```

#### iOS
```bash
# Debug
flutter build ios --debug

# Release
flutter build ios --release
```

#### Web
```bash
# Development
flutter run -d chrome

# Production build
flutter build web --release
```

### Deployment

#### Android (Play Store)
1. Update version in `pubspec.yaml`
2. Build app bundle: `flutter build appbundle --release`
3. Upload to Play Console
4. Fill store listing details
5. Submit for review

#### iOS (App Store)
1. Update version in `pubspec.yaml`
2. Build for iOS: `flutter build ios --release`
3. Open Xcode and archive
4. Upload to App Store Connect
5. Submit for review

#### Web (Firebase Hosting)
```bash
# Install Firebase CLI
npm install -g firebase-tools

# Login to Firebase
firebase login

# Initialize project
firebase init hosting

# Build and deploy
flutter build web --release
firebase deploy --only hosting
```

### Continuous Integration

#### GitHub Actions Example
```yaml
name: CI/CD

on:
  push:
    branches: [main, develop]
  pull_request:
    branches: [main]

jobs:
  test:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v3
      - uses: subosito/flutter-action@v2
      - run: flutter pub get
      - run: flutter test
      - run: flutter build apk --release
```

### Code Review Guidelines

#### Checklist
- [ ] Code follows style guidelines
- [ ] Tests are included and passing
- [ ] Documentation is updated
- [ ] No debugging code left behind
- [ ] Performance impact considered
- [ ] Security implications reviewed
- [ ] Error handling implemented
- [ ] Accessibility guidelines followed

#### Review Process
1. Create pull request with clear description
2. Self-review code before requesting review
3. Address all feedback comments
4. Ensure CI/CD pipeline passes
5. Squash commits before merging

### Troubleshooting

#### Common Issues

**Build Errors**
```bash
# Clean and rebuild
flutter clean
flutter pub get
flutter packages pub run build_runner build --delete-conflicting-outputs
```

**Firebase Issues**
```bash
# Check Firebase configuration
flutter packages pub run firebase_core:configure
```

**State Management Issues**
```bash
# Clear provider cache
ref.invalidate(providerName);
```

**Performance Issues**
```bash
# Profile the app
flutter run --profile
```

#### Getting Help
- Check [Flutter Documentation](https://docs.flutter.dev/)
- Search [Stack Overflow](https://stackoverflow.com/questions/tagged/flutter)
- Join [Flutter Community](https://flutter.dev/community)
- Review project [GitHub Issues](https://github.com/prassaaa/barbershop_booking/issues)