import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class NotificationService {
  static final NotificationService _instance = NotificationService._internal();
  factory NotificationService() => _instance;
  NotificationService._internal();

  final FlutterLocalNotificationsPlugin _plugin =
      FlutterLocalNotificationsPlugin();

  /// Initialize local notifications. Skipped on web (not supported).
  Future<void> initialize() async {
    if (kIsWeb) return;

    const AndroidInitializationSettings androidSettings =
        AndroidInitializationSettings('@mipmap/ic_launcher');
    const DarwinInitializationSettings iosSettings =
        DarwinInitializationSettings(
      requestAlertPermission: true,
      requestBadgePermission: true,
      requestSoundPermission: true,
    );
    const InitializationSettings initSettings = InitializationSettings(
      android: androidSettings,
      iOS: iosSettings,
    );
    await _plugin.initialize(initSettings);
  }

  /// Request permission on Android 13+ (API 33+).
  Future<bool> requestPermission() async {
    if (kIsWeb) return false;
    final androidPlugin = _plugin.resolvePlatformSpecificImplementation<
        AndroidFlutterLocalNotificationsPlugin>();
    if (androidPlugin != null) {
      final granted = await androidPlugin.requestNotificationsPermission();
      return granted ?? false;
    }
    return true;
  }

  /// Show a simple notification. On web, prints a console message instead.
  Future<void> showNotification({
    int id = 0,
    required String title,
    required String body,
    String? payload,
  }) async {
    if (kIsWeb) {
      // Web does not support flutter_local_notifications.
      // In a real app you would use browser push notifications (web_push).
      print('[Notification] $title: $body');
      return;
    }
    const AndroidNotificationDetails androidDetails =
        AndroidNotificationDetails(
      'lab10_channel',
      'Lab10 Notifications',
      channelDescription: 'Notifications for Lab 10 authentication events',
      importance: Importance.high,
      priority: Priority.high,
      showWhen: true,
      icon: '@mipmap/ic_launcher',
    );
    const NotificationDetails details = NotificationDetails(
      android: androidDetails,
      iOS: DarwinNotificationDetails(
        presentAlert: true,
        presentBadge: true,
        presentSound: true,
      ),
    );
    await _plugin.show(id, title, body, details, payload: payload);
  }

  Future<void> showLoginSuccessNotification(String userName) async {
    await showNotification(
      id: 1,
      title: '🎉 Login Successful!',
      body: 'Welcome back, $userName! You are now signed in.',
      payload: 'login_success',
    );
  }

  Future<void> showLogoutNotification() async {
    await showNotification(
      id: 2,
      title: '👋 Signed Out',
      body: 'You have been successfully logged out.',
      payload: 'logout',
    );
  }

  Future<void> cancelAll() async {
    if (kIsWeb) return;
    await _plugin.cancelAll();
  }
}
