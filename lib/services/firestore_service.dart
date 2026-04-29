import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/user_profile.dart';
import '../models/activity_model.dart';

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

  /// Logic Summary:
  /// Returns a real-time stream of all activities for a specific athlete.
  /// Maps each document into an ActivityModel instance.
  Stream<List<ActivityModel>> activitiesStream(String uid) {
    return _db
        .collection('users')
        .doc(uid)
        .collection('activities')
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => ActivityModel.fromMap(doc.data()))
            .toList());
  }

  /// Logic Summary:
  /// Persists a new activity to the athlete's sub-collection in Firestore.
  Future<void> addActivity(String uid, ActivityModel activity) async {
    await _db
        .collection('users')
        .doc(uid)
        .collection('activities')
        .doc(activity.id)
        .set(activity.toMap());
  }

  /// Logic Summary:
  /// Updates an existing activity document in Firestore with new data.
  Future<void> updateActivity(String uid, ActivityModel activity) async {
    await _db
        .collection('users')
        .doc(uid)
        .collection('activities')
        .doc(activity.id)
        .update(activity.toMap());
  }

  /// Logic Summary:
  /// Permanently removes an activity document from the athlete's cloud collection.
  Future<void> deleteActivity(String uid, String activityId) async {
    await _db
        .collection('users')
        .doc(uid)
        .collection('activities')
        .doc(activityId)
        .delete();
  }
}
