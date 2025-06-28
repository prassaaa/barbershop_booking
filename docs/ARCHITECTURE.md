# Architecture Documentation

## Overview

Barbershop Booking follows **Clean Architecture** principles with **Feature-Driven Development** to ensure maintainability, testability, and scalability.

## Architecture Layers

### 1. Presentation Layer
- **Pages**: UI screens for different features
- **Widgets**: Reusable UI components
- **Providers**: State management with Riverpod
- **Controllers**: UI logic and user interactions

### 2. Domain Layer
- **Entities**: Core business objects
- **Use Cases**: Business logic operations
- **Repositories**: Abstract data contracts
- **Interfaces**: Contracts for external services

### 3. Data Layer
- **Repositories**: Concrete implementations
- **Data Sources**: External data providers (Firebase, API)
- **Models**: Data transfer objects
- **Mappers**: Data transformation utilities

## Feature Structure

Each feature follows this structure:
```
features/
├── feature_name/
│   ├── data/
│   │   ├── datasources/
│   │   ├── models/
│   │   └── repositories/
│   ├── domain/
│   │   ├── entities/
│   │   ├── repositories/
│   │   └── usecases/
│   └── presentation/
│       ├── pages/
│       ├── providers/
│       └── widgets/
```

## State Management

**Riverpod** is used for state management with the following patterns:

### Providers
- **Provider**: For simple, immutable objects
- **StateProvider**: For simple mutable state
- **StateNotifierProvider**: For complex state management
- **FutureProvider**: For async operations
- **StreamProvider**: For reactive data streams

### State Flow
```
UI Event → Provider → Use Case → Repository → Data Source
    ↑                                              ↓
UI Update ← State Notifier ← Result ← Response ← External API
```

## Dependency Injection

Dependencies are injected using Riverpod providers:

```dart
// Data Source
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

// Use Case
final signInUseCaseProvider = Provider<SignInWithEmailAndPassword>((ref) {
  return SignInWithEmailAndPassword(ref.read(authRepositoryProvider));
});
```

## Error Handling

### Custom Exceptions
```dart
// Domain Layer
abstract class Failure extends Equatable {
  final String message;
  final String? code;
}

// Data Layer
class AuthException implements Exception {
  final String message;
  final String? code;
}
```

### Either Pattern
Using `dartz` package for functional error handling:

```dart
Future<Either<Failure, User>> signIn() async {
  try {
    final user = await dataSource.signIn();
    return Right(user);
  } on AuthException catch (e) {
    return Left(AuthFailure(e.message));
  }
}
```

## Navigation

**GoRouter** is used for declarative navigation:

```dart
final router = GoRouter(
  initialLocation: '/splash',
  redirect: _handleRedirect,
  routes: [
    GoRoute(
      path: '/login',
      builder: (context, state) => LoginPage(),
    ),
    // More routes...
  ],
);
```

## Code Generation

**build_runner** is used for code generation:

```bash
# Generate code
flutter packages pub run build_runner build

# Watch for changes
flutter packages pub run build_runner watch
```

### Generated Files
- **JSON Serialization**: `*.g.dart` files for model serialization
- **Riverpod**: Provider generation for type safety

## Testing Strategy

### Unit Tests
- Test use cases with mocked repositories
- Test repositories with mocked data sources
- Test providers with mocked dependencies

### Widget Tests
- Test individual widgets in isolation
- Test widget interactions and state changes
- Test navigation flows

### Integration Tests
- Test complete user flows
- Test Firebase integration
- Test performance and memory usage

## Performance Optimization

### Best Practices
1. **Lazy Loading**: Use providers that create instances only when needed
2. **Caching**: Implement caching strategies for frequently accessed data
3. **Image Optimization**: Use cached network images and proper sizing
4. **State Management**: Minimize widget rebuilds with proper provider scoping
5. **Code Splitting**: Split features into separate modules

### Memory Management
- Dispose controllers and streams properly
- Use `autoDispose` for temporary providers
- Implement proper lifecycle management

## Security Considerations

### Firebase Security Rules
- Implement proper authentication checks
- Use role-based access control
- Validate data on server side
- Sanitize user inputs

### Data Validation
- Client-side validation for UX
- Server-side validation for security
- Input sanitization for XSS prevention

## Scalability

### Horizontal Scaling
- Feature-based code organization
- Modular architecture for easy team collaboration
- Consistent naming conventions
- Shared component library

### Vertical Scaling
- Efficient database queries
- Proper indexing strategies
- Caching mechanisms
- Background processing for heavy operations

## Monitoring and Analytics

### Error Tracking
- Firebase Crashlytics integration
- Custom error reporting
- User behavior analytics

### Performance Monitoring
- Firebase Performance Monitoring
- Custom performance metrics
- Real-time monitoring dashboards