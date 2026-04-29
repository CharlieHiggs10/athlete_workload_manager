import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/auth_provider.dart';
import 'calendar_screen.dart';
import 'login_screen.dart';

/// Logic Summary:
/// AuthGate serves as the primary routing controller for the application.
/// It listens to the authentication stream and dynamically switches between
/// the CalendarScreen and LoginScreen based on the user's session status.
class AuthGate extends ConsumerWidget {
  const AuthGate({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authStateProvider);

    return authState.when(
      data: (user) {
        if (user != null) {
          return const CalendarScreen();
        }
        return const LoginScreen();
      },
      loading: () => const Scaffold(
        body: Center(
          child: CircularProgressIndicator(),
        ),
      ),
      error: (err, stack) => Scaffold(
        body: Center(
          child: Text('Error: $err'),
        ),
      ),
    );
  }
}
