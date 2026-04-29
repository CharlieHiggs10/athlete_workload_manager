import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mockito/mockito.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:athlete_workload/screens/login_screen.dart';
import 'package:athlete_workload/services/auth_service.dart';
import 'package:athlete_workload/providers/auth_provider.dart';

class MockAuthService extends Mock implements AuthService {
  @override
  Future<UserCredential?> signInWithGoogle() => super.noSuchMethod(
        Invocation.method(#signInWithGoogle, []),
        returnValue: Future<UserCredential?>.value(null),
      );
}

void main() {
  testWidgets('LoginScreen calls signInWithGoogle when button is pressed', (WidgetTester tester) async {
    final mockAuthService = MockAuthService();
    // Pre-setup the mock to return null (simulating user cancel or success without needing the object)
    when(mockAuthService.signInWithGoogle()).thenAnswer((_) async => null);

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          authServiceProvider.overrideWithValue(mockAuthService),
        ],
        child: const MaterialApp(
          home: LoginScreen(),
        ),
      ),
    );

    expect(find.text('Sign in with Google'), findsOneWidget);

    await tester.tap(find.byType(ElevatedButton));
    await tester.pump();

    verify(mockAuthService.signInWithGoogle()).called(1);
  });
}
