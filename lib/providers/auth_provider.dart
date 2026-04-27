import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../services/auth_service.dart';
import '../models/user_profile.dart';

/// Logic Summary:
/// Provides the FirebaseAuth instance. This internal provider allows us 
/// to override the Firebase instance during unit testing.
final firebaseAuthProvider = Provider<FirebaseAuth>((ref) => FirebaseAuth.instance);

/// Logic Summary:
/// Provides the AuthService instance to the dependency injection tree.
/// This ensures a single source of truth for authentication actions.
final authServiceProvider = Provider<AuthService>((ref) {
  final auth = ref.watch(firebaseAuthProvider);
  return AuthService(auth: auth);
});

/// Logic Summary:
/// Monitors the Firebase authentication stream and converts the raw 
/// Firebase User into our domain-specific UserProfile model.
/// This allows the UI to reactively update based on login status.
final authStateProvider = StreamProvider<UserProfile?>((ref) {
  final auth = ref.watch(firebaseAuthProvider);
  return auth.authStateChanges().map((User? user) {
    if (user == null) {
      return null;
    }
    
    return UserProfile(
      uid: user.uid,
      displayName: user.displayName,
      email: user.email,
    );
  });
});
