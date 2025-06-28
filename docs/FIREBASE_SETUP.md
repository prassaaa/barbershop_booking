# Firebase Setup Guide

## Prerequisites
1. Google account
2. Firebase CLI installed (optional)

## Step 1: Create Firebase Project

1. Go to [Firebase Console](https://console.firebase.google.com/)
2. Click "Create a project"
3. Enter project name: `barbershop-booking`
4. Enable Google Analytics (recommended)
5. Select Analytics account or create new one
6. Click "Create project"

## Step 2: Setup Authentication

1. In Firebase Console, go to **Authentication**
2. Click "Get started"
3. Go to **Sign-in method** tab
4. Enable the following providers:
   - **Email/Password**: Click and toggle "Enable"
   - **Google**: Click, toggle "Enable", add support email

## Step 3: Setup Firestore Database

1. Go to **Firestore Database**
2. Click "Create database"
3. Choose "Start in test mode" (for development)
4. Select location (closest to your users)
5. Click "Done"

## Step 4: Setup Cloud Messaging

1. Go to **Cloud Messaging**
2. No additional setup required for now

## Step 5: Add Android App

1. Click "Add app" and select Android
2. Enter package name: `com.example.barbershop_booking`
3. Enter app nickname: `Barbershop Booking Android`
4. Download `google-services.json`
5. Place file in `android/app/` directory

## Step 6: Add iOS App (if targeting iOS)

1. Click "Add app" and select iOS
2. Enter bundle ID: `com.example.barbershopBooking`
3. Enter app nickname: `Barbershop Booking iOS`
4. Download `GoogleService-Info.plist`
5. Place file in `ios/Runner/` directory

## Step 7: Add Web App

1. Click "Add app" and select Web
2. Enter app nickname: `Barbershop Booking Web`
3. Copy the Firebase config object
4. Replace config in `web/index.html`

## Step 8: Security Rules (Production Ready)

### Firestore Rules
```javascript
rules_version = '2';
service cloud.firestore {
  match /databases/{database}/documents {
    // Users can read/write their own profile
    match /users/{userId} {
      allow read, write: if request.auth != null && request.auth.uid == userId;
    }
    
    // Barbers can read/write their own profile
    match /barbers/{barberId} {
      allow read: if request.auth != null;
      allow write: if request.auth != null && 
        (request.auth.uid == resource.data.userId || 
         get(/databases/$(database)/documents/users/$(request.auth.uid)).data.role in ['admin', 'super_admin']);
    }
    
    // Anyone can read services
    match /services/{serviceId} {
      allow read: if request.auth != null;
      allow write: if request.auth != null && 
        get(/databases/$(database)/documents/users/$(request.auth.uid)).data.role in ['admin', 'super_admin'];
    }
    
    // Bookings: customers can CRUD their own, barbers can read theirs, admins can do all
    match /bookings/{bookingId} {
      allow read, write: if request.auth != null && 
        (request.auth.uid == resource.data.customerId || 
         request.auth.uid == get(/databases/$(database)/documents/barbers/$(resource.data.barberId)).data.userId ||
         get(/databases/$(database)/documents/users/$(request.auth.uid)).data.role in ['admin', 'super_admin']);
    }
    
    // Reviews: customers can write their own, everyone can read
    match /reviews/{reviewId} {
      allow read: if request.auth != null;
      allow write: if request.auth != null && request.auth.uid == resource.data.customerId;
    }
  }
}
```

### Storage Rules
```javascript
rules_version = '2';
service firebase.storage {
  match /b/{bucket}/o {
    match /users/{userId}/{allPaths=**} {
      allow read, write: if request.auth != null && request.auth.uid == userId;
    }
    
    match /barbers/{barberId}/{allPaths=**} {
      allow read: if request.auth != null;
      allow write: if request.auth != null && 
        (request.auth.uid == userId || 
         get(/databases/$(database)/documents/users/$(request.auth.uid)).data.role in ['admin', 'super_admin']);
    }
  }
}
```

## Environment Variables (Optional)

Create `.env` file in project root:
```
FIREBASE_PROJECT_ID=your-project-id
FIREBASE_API_KEY=your-api-key
FIREBASE_APP_ID=your-app-id
```