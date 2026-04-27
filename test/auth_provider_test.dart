import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_auth_mocks/firebase_auth_mocks.dart';
import 'package:athlete_workload/providers/auth_provider.dart';
import 'package:athlete_workload/services/auth_service.dart';

/// Logic Summary:
/// Unit tests for the AuthProvider. These tests verify that the 
/// authentication state stream correctly transforms Firebase Users 
/// into our internal UserProfile model, and that the AuthService 
/// is correctly injected.
void main() {
  group('AuthProvider Tests', () {
    
    test('authServiceProvider should provide an instance of AuthService', () {
      final mockAuth = MockFirebaseAuth();
      final container = ProviderContainer(
        overrides: [
          firebaseAuthProvider.overrideWithValue(mockAuth),
        ],
      );
      addTearDown(container.dispose);

      final authService = container.read(authServiceProvider);
      expect(authService, isA<AuthService>());
    });

    test('authStateProvider should emit null when user is not authenticated', () async {
      // Setup: Mock Firebase in a signed-out state
      final mockAuth = MockFirebaseAuth(signedIn: false);
      
      final container = ProviderContainer(
        overrides: [
          firebaseAuthProvider.overrideWithValue(mockAuth),
        ],
      );
      addTearDown(container.dispose);

      // Act: Read the future value of the stream provider
      final userProfile = await container.read(authStateProvider.future);

      // Assert: Verify it maps to null
      expect(userProfile, isNull);
    });

    test('authStateProvider should emit UserProfile when user is authenticated', () async {
      // Setup: Mock Firebase in a signed-in state
      final mockUser = MockUser(
        uid: 'athlete-123',
        email: 'athlete@university.edu',
        displayName: 'Test Athlete',
      );
      final mockAuth = MockFirebaseAuth(mockUser: mockUser, signedIn: true);
      
      final container = ProviderContainer(
        overrides: [
          firebaseAuthProvider.overrideWithValue(mockAuth),
        ],
      );
      addTearDown(container.dispose);

      // Act: Read the future value of the stream provider
      final userProfile = await container.read(authStateProvider.future);

      // Assert: Verify it correctly maps the Firebase User properties
      expect(userProfile, isNotNull);
      expect(userProfile!.uid, 'athlete-123');
      expect(userProfile.email, 'athlete@university.edu');
      expect(userProfile.displayName, 'Test Athlete');
    });
  });
}
