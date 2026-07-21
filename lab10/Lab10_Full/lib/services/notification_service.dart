import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class NotificationService {
  static final NotificationService _instance = NotificationService._internal();
  factory NotificationService() => _instance;
  NotificationService._internal();

  final FlutterLocalNotificationsPlugin _plugin =
      FlutterLocalNotificationsPlugin();

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

  Future<void> requestPermission() async {
    if (kIsWeb) return;
    final androidPlugin = _plugin.resolvePlatformSpecificImplementation<
        AndroidFlutterLocalNotificationsPlugin>();
    await androidPlugin?.requestNotificationsPermission();
  }

  Future<void> showNotification({
    int id = 0,
    required String title,
    required String body,
    String? payload,
  }) async {
    if (kIsWeb) {
      print('[Notification] $title: $body');
      return;
    }
    const AndroidNotificationDetails androidDetails =
        AndroidNotificationDetails(
      'lab10_full_channel',
      'Lab10 Full Notifications',
      channelDescription: 'Notifications for Lab10 Full integrated app',
      importance: Importance.high,
      priority: Priority.high,
      showWhen: true,
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
      title: '🎉 Welcome back, $userName!',
      body: 'You have successfully signed in to Lab10 Full.',
      payload: 'login_success',
    );
  }

  Future<void> showLogoutNotification() async {
    await showNotification(
      id: 2,
      title: '👋 Signed Out',
      body: 'You have been logged out. See you next time!',
      payload: 'logout',
    );
  }
}
