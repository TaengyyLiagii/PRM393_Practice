import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
// import 'firebase_options.dart'; // Uncomment after adding google-services.json and running flutterfire configure
import 'screens/sign_in_screen.dart';
import 'screens/profile_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // TODO: Run `flutterfire configure` to generate firebase_options.dart,
  // then uncomment the line below and the import above:
  // await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  await Firebase.initializeApp(); // Uses google-services.json on Android
  runApp(const Lab10FirebaseApp());
}

class Lab10FirebaseApp extends StatelessWidget {
  const Lab10FirebaseApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Lab10.4 – Firebase Google Sign-In',
      debugShowCheckedModeBanner: false,
      theme: ThemeData.dark().copyWith(
        scaffoldBackgroundColor: const Color(0xFF0C0C14),
        colorScheme: const ColorScheme.dark(
          primary: Color(0xFFFF6B35),
          secondary: Color(0xFFF7C59F),
        ),
      ),
      initialRoute: '/signin',
      routes: {
        '/signin': (context) => const SignInScreen(),
        '/profile': (context) => const ProfileScreen(),
      },
    );
  }
}
