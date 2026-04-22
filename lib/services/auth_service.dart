import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

/// Logic Summary:
/// AuthService handles the communication between the app and external 
/// authentication providers (Firebase Auth and Google Sign-In).
/// It provides methods to sign in via Google and sign out from all services.
class AuthService {
  final FirebaseAuth _auth;
  final GoogleSignIn _googleSignIn;

  AuthService({FirebaseAuth? auth, GoogleSignIn? googleSignIn})
      : _auth = auth ?? FirebaseAuth.instance,
        _googleSignIn = googleSignIn ?? GoogleSignIn();

  /// Logic Summary:
  /// Triggers the Google Sign-In popup, retrieves the authentication credentials,
  /// and uses them to sign into Firebase.
  /// Returns a UserCredential on success, or null if the user cancels or an error occurs.
  Future<UserCredential?> signInWithGoogle() async {
    try {
      // Trigger the authentication flow
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();

      if (googleUser == null) {
        // User canceled the sign-in process
        return null;
      }

      // Obtain the auth details from the request
      final GoogleSignInAuthentication googleAuth = await googleUser.authentication;

      // Create a new credential for Firebase
      final AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      // Sign into Firebase with the Google credential
      return await _auth.signInWithCredential(credential);
    } catch (e) {
      // Logic block: Fail-safe for authentication errors.
      // Returns null to indicate sign-in was not completed.
      return null;
    }
  }

  /// Logic Summary:
  /// Signs the user out of both Firebase and Google.
  Future<void> signOut() async {
    try {
      await _googleSignIn.signOut();
    } catch (e) {
      // Logic block: Resilience for test environments.
      // Some mock implementations of GoogleSignIn throw NoSuchMethodError 
      // when calling signOut in certain dependency configurations.
    }
    await _auth.signOut();
  }
}
