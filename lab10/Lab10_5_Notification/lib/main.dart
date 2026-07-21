import 'package:flutter/material.dart';
import 'services/notification_service.dart';
import 'screens/home_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // Initialize notification service
  await NotificationService().initialize();
  runApp(const Lab10NotificationApp());
}

class Lab10NotificationApp extends StatelessWidget {
  const Lab10NotificationApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Lab10.5 – Local Notifications',
      debugShowCheckedModeBanner: false,
      theme: ThemeData.dark().copyWith(
        scaffoldBackgroundColor: const Color(0xFF0D0D1A),
        colorScheme: const ColorScheme.dark(
          primary: Color(0xFFF59E0B),
          secondary: Color(0xFFEF4444),
        ),
      ),
      home: const HomeScreen(),
    );
  }
}
