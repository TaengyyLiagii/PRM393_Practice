# Lab10_2_RealApiLogin

## Description
Real REST API login using the DummyJSON authentication endpoint.

## How to Run
```bash
cd Lab10_2_RealApiLogin
flutter pub get
flutter run
```

> Requires internet connection.

## Test Account
| Field    | Value        |
|----------|--------------|
| Username | emilys       |
| Password | emilyspass   |

(From https://dummyjson.com/docs/auth — any DummyJSON user works)

## Features
- POST request to `https://dummyjson.com/auth/login`
- Loading spinner during API call
- Parses access token and user profile from response
- Graceful error handling (network errors, wrong credentials)
- Displays user info on Home screen
