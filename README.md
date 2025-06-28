# Barbershop Booking App

Modern barbershop booking application built with Flutter, featuring customer, barber, and admin interfaces.

## 🏗️ Architecture

This project follows **Clean Architecture** principles with **Feature-Driven Development**:

```
lib/
├── core/                   # Core app functionality
│   ├── constants/         # App constants, colors, text styles
│   ├── errors/           # Error handling classes
│   ├── services/         # Core services (Firebase, Navigation, etc.)
│   ├── theme/            # App theme configuration
│   └── utils/            # Utility functions and validators
├── features/             # Feature modules
│   ├── auth/            # Authentication feature
│   ├── booking/         # Booking management
│   ├── profile/         # User profile management
│   ├── admin/           # Admin panel features
│   └── barber/          # Barber-specific features
└── shared/              # Shared components
    ├── models/          # Data models
    └── widgets/         # Reusable UI components
```

## 🚀 Features

### Customer Features
- ✅ User registration and authentication
- ✅ Service browsing and selection
- ✅ Barber selection based on availability
- ✅ Real-time booking system
- ✅ Booking history and status tracking
- ✅ Review and rating system
- ✅ Push notifications for booking updates
- ✅ Profile management

### Barber Features
- ✅ Shift management (ON/OFF per day)
- ✅ Working hours configuration
- ✅ Booking queue management
- ✅ Customer details and booking history
- ✅ Performance analytics
- ✅ Profile and bio management

### Admin Features
- ✅ Dashboard with key metrics
- ✅ Booking management (view, edit, cancel)
- ✅ Barber management (add, edit, remove)
- ✅ Service management (pricing, duration)
- ✅ Reports and analytics
- ✅ User management and role assignment
- ✅ System settings configuration

## 🛠️ Tech Stack

| Category | Technology |
|----------|------------|
| **Framework** | Flutter 3.32.4 |
| **State Management** | Riverpod |
| **Navigation** | GoRouter |
| **Backend** | Firebase (Auth, Firestore, Storage, Messaging) |
| **Authentication** | Firebase Auth + Google Sign-in |
| **Database** | Cloud Firestore |
| **Notifications** | Firebase Cloud Messaging + Local Notifications |
| **Charts** | FL Chart, Syncfusion Charts |
| **File Export** | PDF, Excel (Syncfusion) |
| **Code Generation** | json_serializable, build_runner |

## 📱 Supported Platforms

- ✅ **Android** (Mobile)
- ✅ **iOS** (Mobile) 
- ✅ **Web** (Admin Panel)
- ✅ **Windows** (Desktop - Admin)
- ✅ **macOS** (Desktop - Admin)
- ✅ **Linux** (Desktop - Admin)

## 🔧 Setup Instructions

### Prerequisites

1. **Flutter SDK** (version 3.19.0 or higher)
2. **Dart SDK** (version 3.8.1 or higher)
3. **Firebase Project** (for backend services)
4. **IDE**: VS Code or Android Studio

### Installation Steps

1. **Clone the repository**
   ```bash
   git clone <repository-url>
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

4. **Firebase Setup**
   - Create a new Firebase project
   - Enable Authentication (Email/Password, Google)
   - Create Firestore database
   - Enable Cloud Messaging
   - Download configuration files:
     - `google-services.json` for Android (place in `android/app/`)
     - `GoogleService-Info.plist` for iOS (place in `ios/Runner/`)
     - Web config (update `web/index.html`)

5. **Run the application**
   ```bash
   # For mobile development
   flutter run
   
   # For web (admin panel)
   flutter run -d chrome
   
   # For specific device
   flutter run -d <device-id>
   ```

## 🗄️ Database Structure

### Firestore Collections

```javascript
// Users Collection
users/{userId} {
  id: string,
  email: string,
  name: string,
  phoneNumber: string?,
  photoUrl: string?,
  role: 'customer' | 'barber' | 'admin' | 'super_admin',
  isActive: boolean,
  createdAt: timestamp,
  updatedAt: timestamp
}

// Barbers Collection
barbers/{barberId} {
  id: string,
  userId: string,
  name: string,
  photoUrl: string?,
  bio: string?,
  rating: number,
  totalReviews: number,
  isActive: boolean,
  weeklyShifts: {
    monday: { isWorking: boolean, startTime: string, endTime: string, breakTimes: string[] },
    // ... other days
  },
  specialties: string[],
  createdAt: timestamp,
  updatedAt: timestamp
}

// Services Collection
services/{serviceId} {
  id: string,
  name: string,
  description: string,
  price: number,
  durationMinutes: number,
  category: 'cut' | 'shave' | 'grooming',
  imageUrl: string?,
  isActive: boolean,
  availableFor: string[], // barber IDs
  createdAt: timestamp,
  updatedAt: timestamp
}

// Bookings Collection
bookings/{bookingId} {
  id: string,
  customerId: string,
  barberId: string,
  serviceId: string,
  bookingDate: timestamp,
  timeSlot: string,
  status: 'waiting' | 'confirmed' | 'completed' | 'cancelled',
  totalPrice: number,
  notes: string?,
  cancelReason: string?,
  createdAt: timestamp,
  updatedAt: timestamp
}

// Reviews Collection
reviews/{reviewId} {
  id: string,
  bookingId: string,
  customerId: string,
  barberId: string,
  serviceId: string,
  rating: number,
  comment: string?,
  photos: string[],
  createdAt: timestamp,
  updatedAt: timestamp
}
```

## 🚦 Development Phases

### Phase 1: Foundation ✅
- [x] Project setup and architecture
- [x] Core services and utilities
- [x] Authentication system
- [x] Basic UI components

### Phase 2: Core Features (In Progress)
- [ ] Customer booking flow
- [ ] Barber schedule management
- [ ] Basic admin panel
- [ ] Push notifications

### Phase 3: Advanced Features
- [ ] Advanced analytics and reporting
- [ ] Payment integration
- [ ] Multi-language support
- [ ] Advanced admin features

### Phase 4: Optimization
- [ ] Performance optimization
- [ ] UI/UX improvements
- [ ] Testing and quality assurance
- [ ] Deployment and distribution

## 🧪 Testing

```bash
# Run unit tests
flutter test

# Run integration tests
flutter drive --target=test_driver/app.dart

# Run tests with coverage
flutter test --coverage
```

## 📦 Building for Production

```bash
# Android APK
flutter build apk --release

# Android App Bundle
flutter build appbundle --release

# iOS
flutter build ipa --release

# Web
flutter build web --release

# Windows
flutter build windows --release
```

## 🤝 Contributing

1. Fork the repository
2. Create a feature branch (`git checkout -b feature/amazing-feature`)
3. Commit your changes (`git commit -m 'Add some amazing feature'`)
4. Push to the branch (`git push origin feature/amazing-feature`)
5. Open a Pull Request

## 📄 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

Copyright (c) 2025 Prasetyo Ari Wibowo

## 📞 Support

For support and questions:
- GitHub: [@prassaaa](https://github.com/prassaaa)
- Project Repository: [Barbershop Booking](https://github.com/prassaaa/barbershop_booking)
- Issues: [GitHub Issues](https://github.com/prassaaa/barbershop_booking/issues)

## 👨‍💻 Author

**Prasetyo Ari Wibowo**
- GitHub: [@prassaaa](https://github.com/prassaaa)
- LinkedIn: [Connect with me](https://linkedin.com/in/prasetyo-ari-wibowo)

---

**Made with ❤️ using Flutter**