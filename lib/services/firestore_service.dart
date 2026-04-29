import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/user_profile.dart';

/// Logic Summary:
/// FirestoreService handles all direct interactions with the Firebase Firestore database,
/// providing CRUD operations for user profiles and activity logs.
class FirestoreService {
  final FirebaseFirestore _db;

  FirestoreService({FirebaseFirestore? firestore})
      : _db = firestore ?? FirebaseFirestore.instance;

  /// Logic Summary:
  /// Writes the UserProfile to the 'users' collection using the UID as the document ID.
  /// Uses merge: true to ensure existing fields are not overwritten if not provided.
  Future<void> saveUserProfile(UserProfile profile) async {
    await _db
        .collection('users')
        .doc(profile.uid)
        .set(profile.toMap(), SetOptions(merge: true));
  }

  /// Logic Summary:
  /// Fetches a user document from the 'users' collection by UID.
  /// Returns a UserProfile instance if found, otherwise returns null.
  Future<UserProfile?> getUserProfile(String uid) async {
    final doc = await _db.collection('users').doc(uid).get();
    
    if (doc.exists && doc.data() != null) {
      return UserProfile.fromMap(doc.data()!);
    }
    
    return null;
  }
}
