# API Documentation

## Firebase Integration

This application uses Firebase as the backend service with the following components:

### Authentication API

#### Sign In with Email and Password
```dart
Future<Either<Failure, UserModel>> signInWithEmailAndPassword({
  required String email,
  required String password,
});
```

#### Register with Email and Password
```dart
Future<Either<Failure, UserModel>> registerWithEmailAndPassword({
  required String email,
  required String password,
  required String name,
  String? phoneNumber,
});
```

#### Google Sign In
```dart
Future<Either<Failure, UserModel>> signInWithGoogle();
```

#### Password Reset
```dart
Future<Either<Failure, void>> sendPasswordResetEmail({
  required String email,
});
```

### Firestore Collections

#### Users Collection
**Path**: `/users/{userId}`

```json
{
  "id": "string",
  "email": "string",
  "name": "string",
  "phoneNumber": "string?",
  "photoUrl": "string?",
  "role": "customer | barber | admin | super_admin",
  "isActive": "boolean",
  "createdAt": "timestamp",
  "updatedAt": "timestamp"
}
```

**Indexes Required**:
- `email` (ascending)
- `role` (ascending)
- `isActive` (ascending)

#### Barbers Collection
**Path**: `/barbers/{barberId}`

```json
{
  "id": "string",
  "userId": "string",
  "name": "string",
  "photoUrl": "string?",
  "bio": "string?",
  "rating": "number",
  "totalReviews": "number",
  "isActive": "boolean",
  "weeklyShifts": {
    "monday": {
      "isWorking": "boolean",
      "startTime": "string",
      "endTime": "string",
      "breakTimes": ["string"]
    },
    "tuesday": "...",
    "wednesday": "...",
    "thursday": "...",
    "friday": "...",
    "saturday": "...",
    "sunday": "..."
  },
  "specialties": ["string"],
  "createdAt": "timestamp",
  "updatedAt": "timestamp"
}
```

**Indexes Required**:
- `userId` (ascending)
- `isActive` (ascending)
- `rating` (descending)

#### Services Collection
**Path**: `/services/{serviceId}`

```json
{
  "id": "string",
  "name": "string",
  "description": "string",
  "price": "number",
  "durationMinutes": "number",
  "category": "cut | shave | grooming",
  "imageUrl": "string?",
  "isActive": "boolean",
  "availableFor": ["string"], // barber IDs
  "createdAt": "timestamp",
  "updatedAt": "timestamp"
}
```

**Indexes Required**:
- `category` (ascending)
- `isActive` (ascending)
- `price` (ascending)

#### Bookings Collection
**Path**: `/bookings/{bookingId}`

```json
{
  "id": "string",
  "customerId": "string",
  "barberId": "string",
  "serviceId": "string",
  "bookingDate": "timestamp",
  "timeSlot": "string", // "HH:mm" format
  "status": "waiting | confirmed | completed | cancelled",
  "totalPrice": "number",
  "notes": "string?",
  "cancelReason": "string?",
  "createdAt": "timestamp",
  "updatedAt": "timestamp"
}
```

**Indexes Required**:
- `customerId` (ascending), `createdAt` (descending)
- `barberId` (ascending), `bookingDate` (ascending)
- `status` (ascending), `bookingDate` (ascending)
- `bookingDate` (ascending), `timeSlot` (ascending)

#### Reviews Collection
**Path**: `/reviews/{reviewId}`

```json
{
  "id": "string",
  "bookingId": "string",
  "customerId": "string",
  "barberId": "string",
  "serviceId": "string",
  "rating": "number",
  "comment": "string?",
  "photos": ["string"],
  "createdAt": "timestamp",
  "updatedAt": "timestamp"
}
```

**Indexes Required**:
- `barberId` (ascending), `createdAt` (descending)
- `serviceId` (ascending), `rating` (descending)
- `customerId` (ascending), `createdAt` (descending)

### Security Rules

#### Authentication Rules
- All operations require authentication
- Users can only access their own data
- Admins have elevated permissions

#### Data Access Rules
```javascript
// Users can read/write their own profile
match /users/{userId} {
  allow read, write: if request.auth != null && request.auth.uid == userId;
}

// Barbers can read/write their own profile
match /barbers/{barberId} {
  allow read: if request.auth != null;
  allow write: if request.auth != null && 
    (request.auth.uid == resource.data.userId || 
     isAdmin(request.auth.uid));
}

// Bookings access control
match /bookings/{bookingId} {
  allow read, write: if request.auth != null && 
    (request.auth.uid == resource.data.customerId || 
     request.auth.uid == getBarberUserId(resource.data.barberId) ||
     isAdmin(request.auth.uid));
}
```

### Cloud Functions (Future Implementation)

#### Booking Notifications
```javascript
exports.sendBookingNotification = functions.firestore
  .document('bookings/{bookingId}')
  .onWrite((change, context) => {
    // Send notification to customer and barber
  });
```

#### Rating Updates
```javascript
exports.updateBarberRating = functions.firestore
  .document('reviews/{reviewId}')
  .onWrite((change, context) => {
    // Update barber's average rating
  });
```

### Storage Structure

#### User Profile Images
**Path**: `/users/{userId}/profile.jpg`

#### Barber Portfolio Images
**Path**: `/barbers/{barberId}/portfolio/{imageId}.jpg`

#### Review Photos
**Path**: `/reviews/{reviewId}/{photoId}.jpg`

### Real-time Updates

#### Booking Status Updates
```dart
Stream<List<BookingModel>> getBookingsStream(String customerId) {
  return firestore
    .collection('bookings')
    .where('customerId', isEqualTo: customerId)
    .orderBy('createdAt', descending: true)
    .snapshots()
    .map((snapshot) => snapshot.docs
        .map((doc) => BookingModel.fromJson(doc.data()))
        .toList());
}
```

#### Barber Availability Updates
```dart
Stream<List<BarberModel>> getAvailableBarbersStream() {
  return firestore
    .collection('barbers')
    .where('isActive', isEqualTo: true)
    .snapshots()
    .map((snapshot) => snapshot.docs
        .map((doc) => BarberModel.fromJson(doc.data()))
        .toList());
}
```

### Error Codes

#### Authentication Errors
- `AUTH001`: Invalid credentials
- `AUTH002`: User not found
- `AUTH003`: Email already in use
- `AUTH004`: Weak password
- `AUTH005`: Network error

#### Booking Errors
- `BOOK001`: Time slot not available
- `BOOK002`: Barber not available
- `BOOK003`: Service not found
- `BOOK004`: Invalid booking date
- `BOOK005`: Cancellation not allowed

#### General Errors
- `GEN001`: Network connection error
- `GEN002`: Permission denied
- `GEN003`: Resource not found
- `GEN004`: Validation error
- `GEN005`: Server error

### Rate Limiting

#### Firebase Limitations
- Firestore: 1 write per second per document
- Cloud Functions: 1000 concurrent executions
- Authentication: 100 requests per second

#### Best Practices
- Implement client-side caching
- Use batch operations for multiple writes
- Implement retry mechanisms with exponential backoff