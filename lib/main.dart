import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'theme.dart';
import 'screens/calendar_screen.dart';

/// Logic Summary:
/// Entry point for the application.
/// Initializes Firebase and wraps MyApp in ProviderScope as mandated by Step 3.1.1.
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(
    const ProviderScope(
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Athlete Workload',
      theme: AppTheme.lightTheme,
      home: const CalendarScreen(),
    );
  }
}
