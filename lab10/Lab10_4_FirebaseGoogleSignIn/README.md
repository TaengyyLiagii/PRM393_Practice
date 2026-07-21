# Lab10_4_FirebaseGoogleSignIn

## Description
Firebase Authentication with Google Sign-In integration.

## ⚠️ Firebase Setup Required

Before running this project, complete the following steps:

### 1. Create Firebase Project
1. Go to https://console.firebase.google.com
2. Create a new project (or use existing)
3. Click "Add app" → Android
4. Register with package name: `com.lab10.lab10_4_firebase`

### 2. Enable Google Sign-In
1. In Firebase Console → Authentication → Sign-in method
2. Enable "Google" provider
3. Save

### 3. Download google-services.json
1. Download `google-services.json` from Firebase Console
2. Place it in: `android/app/google-services.json`

### 4. Get SHA-1 Key
Run this command and copy the SHA-1 value into Firebase Console → Project Settings → Your Apps:
```bash
keytool -list -v -keystore "%USERPROFILE%\.android\debug.keystore" -alias androiddebugkey -storepass android -keypass android
```

### 5. Configure Android Gradle
The `android/app/build.gradle` and `android/build.gradle` files need the Google Services plugin.
See: https://firebase.google.com/docs/android/setup

## How to Run (after setup)
```bash
cd Lab10_4_FirebaseGoogleSignIn
flutter pub get
flutter run
```

## Features
- Google Sign-In via Firebase Authentication
- Displays user profile (photo, name, email, UID)
- Logout from Firebase + Google
