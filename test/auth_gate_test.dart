import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_auth_mocks/firebase_auth_mocks.dart';
import 'package:athlete_workload/screens/auth_gate.dart';
import 'package:athlete_workload/screens/calendar_screen.dart';
import 'package:athlete_workload/screens/login_screen.dart';
import 'package:athlete_workload/providers/auth_provider.dart';

void main() {
  testWidgets('AuthGate shows LoginScreen when unauthenticated', (WidgetTester tester) async {
    final mockAuth = MockFirebaseAuth(signedIn: false);

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          firebaseAuthProvider.overrideWithValue(mockAuth),
        ],
        child: const MaterialApp(
          home: AuthGate(),
        ),
      ),
    );

    // Initial state is loading (CircularProgressIndicator)
    expect(find.byType(CircularProgressIndicator), findsOneWidget);

    // Wait for the stream to emit
    await tester.pumpAndSettle();

    expect(find.byType(LoginScreen), findsOneWidget);
    expect(find.byType(CalendarScreen), findsNothing);
  });

  testWidgets('AuthGate shows CalendarScreen when authenticated', (WidgetTester tester) async {
    final mockUser = MockUser(
      uid: 'athlete-123',
      email: 'athlete@university.edu',
      displayName: 'Test Athlete',
    );
    final mockAuth = MockFirebaseAuth(mockUser: mockUser, signedIn: true);

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          firebaseAuthProvider.overrideWithValue(mockAuth),
        ],
        child: const MaterialApp(
          home: AuthGate(),
        ),
      ),
    );

    await tester.pumpAndSettle();

    expect(find.byType(CalendarScreen), findsOneWidget);
    expect(find.byType(LoginScreen), findsNothing);
  });
}
