import 'package:flutter/material.dart';
import 'package:my_app/pages/authpage.dart';
import 'package:my_app/onboarding_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      initialRoute: '/onboarding',  // Set initial route
      routes: {
        '/onboarding': (context) => const OnboardingScreen(),
        '/auth': (context) => const Authpage(),
      },
    );
  }
}