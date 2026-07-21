# Lab10_Full – Integrated Authentication & Notifications

## Description
Full integration of all Lab 10 features: mock login → real API login → session persistence → auto-login → local notifications.

## How to Run
```bash
cd Lab10_Full
flutter pub get
flutter run
```

> Requires internet connection for API login.

## Test Account
| Field    | Value        |
|----------|--------------|
| Username | emilys       |
| Password | emilyspass   |

## Feature Integration
| Feature                          | Implemented |
|----------------------------------|-------------|
| SplashScreen routing             | ✅           |
| Real API Login (DummyJSON)       | ✅           |
| Session persistence (SharedPrefs)| ✅           |
| Auto-login on app restart        | ✅           |
| Local notification on login      | ✅ (LO7)     |
| Local notification on logout     | ✅ (LO7)     |
| Firebase Google Sign-In          | ⚠️ Requires Firebase setup (see Lab10_4 README) |

## How to Test
1. **First launch**: SplashScreen → LoginScreen
2. **Login** with credentials → notification fires → Home screen
3. **Close app**, reopen → SplashScreen → auto-login to Home
4. **Logout** → notification fires → back to LoginScreen
5. **Close app**, reopen → SplashScreen → LoginScreen (session cleared)

## Android Permissions
- `POST_NOTIFICATIONS` — Android 13+
- `RECEIVE_BOOT_COMPLETED`
- `VIBRATE`
