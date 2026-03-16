import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'theme.dart';
import 'screens/calendar_screen.dart';

/// Logic Summary:
/// Entry point for the application.
/// Wraps MyApp in ProviderScope as mandated by Step 1.2.
void main() {
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
