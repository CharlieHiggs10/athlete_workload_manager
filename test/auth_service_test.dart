import 'package:flutter_test/flutter_test.dart';
import 'package:firebase_auth_mocks/firebase_auth_mocks.dart';
import 'package:google_sign_in_mocks/google_sign_in_mocks.dart';
import 'package:athlete_workload/services/auth_service.dart';

void main() {
  group('AuthService Tests', () {
    late MockGoogleSignIn googleSignIn;
    late MockFirebaseAuth auth;
    late AuthService authService;

    setUp(() {
      googleSignIn = MockGoogleSignIn();
      auth = MockFirebaseAuth();
      authService = AuthService(auth: auth, googleSignIn: googleSignIn);
    });

    test('signInWithGoogle returns UserCredential on success', () async {
      // Logic Summary:
      // Verifies that a successful Google sign-in flow returns a valid 
      // UserCredential from Firebase.
      final userCredential = await authService.signInWithGoogle();
      
      expect(userCredential, isNotNull);
      expect(userCredential?.user, isNotNull);
    });

    test('signInWithGoogle returns null when user cancels', () async {
      // Logic Summary:
      // Simulates a user canceling the Google sign-in popup and ensures 
      // the service handles it gracefully by returning null.
      googleSignIn.setIsCancelled(true);
      
      final userCredential = await authService.signInWithGoogle();
      
      expect(userCredential, isNull);
    });

    test('signOut should clear currentUser', () async {
      // Logic Summary:
      // Verifies that the signOut method clears the current user state 
      // in Firebase.
      
      // Setup: Sign in first
      await authService.signInWithGoogle();
      expect(auth.currentUser, isNotNull);

      // Act: Sign out
      await authService.signOut();
      
      // Assert: Verify currentUser is now null
      expect(auth.currentUser, isNull);
    });
  });
}
