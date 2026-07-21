# Lab10_5_Notification

## Description
Local notifications integration using `flutter_local_notifications`. Satisfies **LO7**.

## How to Run
```bash
cd Lab10_5_Notification
flutter pub get
flutter run
```

> Run on Android API 33+ (or a physical device with Android 13+) for full notification permission flow.

## Features
- Notification permission request on Android 13+ (POST_NOTIFICATIONS)
- Manual notification trigger buttons
- Notification channel setup (`lab10_channel`)
- Four notification types:
  - Basic notification
  - Login success notification
  - Logout notification
  - Cancel all notifications
- Status indicator showing whether permission was granted

## Test Steps
1. Launch app on Android 13+ emulator/device
2. Grant notification permission when prompted
3. Tap any "Send Notification" button
4. Verify notification appears in the system tray

## Permissions (AndroidManifest.xml)
- `POST_NOTIFICATIONS` — required on Android 13+
- `RECEIVE_BOOT_COMPLETED` — for scheduled notifications
- `VIBRATE` — for vibration on notification
