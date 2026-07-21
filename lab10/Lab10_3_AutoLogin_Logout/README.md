# Lab10_3_AutoLogin_Logout

## Description
Session persistence using SharedPreferences. Supports auto-login across app restarts and logout.

## How to Run
```bash
cd Lab10_3_AutoLogin_Logout
flutter pub get
flutter run
```

> Requires internet connection for initial login.

## Test Account
| Field    | Value        |
|----------|--------------|
| Username | emilys       |
| Password | emilyspass   |

## How to Test Auto-Login
1. Open the app → SplashScreen → LoginScreen
2. Login with the credentials above
3. Close the app completely
4. Reopen the app → SplashScreen will detect the saved token and skip login → Home directly

## How to Test Logout
1. On the Home screen, tap "Logout & Clear Session"
2. Close and reopen the app → SplashScreen → LoginScreen (token cleared)

## Features
- SplashScreen routing based on saved session
- Token + user data saved in SharedPreferences after login
- Auto-login when token exists
- Logout clears all session data
