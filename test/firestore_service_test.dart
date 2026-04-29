import 'package:flutter_test/flutter_test.dart';
import 'package:fake_cloud_firestore/fake_cloud_firestore.dart';
import 'package:athlete_workload/services/firestore_service.dart';
import 'package:athlete_workload/models/user_profile.dart';

void main() {
  group('FirestoreService Tests', () {
    late FakeFirebaseFirestore fakeFirestore;
    late FirestoreService firestoreService;

    setUp(() {
      fakeFirestore = FakeFirebaseFirestore();
      firestoreService = FirestoreService(firestore: fakeFirestore);
    });

    test('saveUserProfile should save profile data to Firestore', () async {
      // Logic Summary:
      // Verifies that the saveUserProfile method correctly writes the UserProfile
      // data to the 'users' collection with the correct document ID.
      const profile = UserProfile(
        uid: 'test_uid',
        displayName: 'Test Athlete',
        email: 'test@example.com',
        sport: 'Basketball',
        position: 'Guard',
      );

      await firestoreService.saveUserProfile(profile);

      final doc = await fakeFirestore.collection('users').doc('test_uid').get();
      expect(doc.exists, isTrue);
      expect(doc.data()?['displayName'], 'Test Athlete');
      expect(doc.data()?['uid'], 'test_uid');
    });

    test('getUserProfile should retrieve profile data from Firestore', () async {
      // Logic Summary:
      // Verifies that getUserProfile correctly fetches and maps document data
      // from the 'users' collection into a UserProfile instance.
      final userData = {
        'uid': 'test_uid',
        'displayName': 'Test Athlete',
        'email': 'test@example.com',
        'sport': 'Basketball',
        'position': 'Guard',
      };
      
      await fakeFirestore.collection('users').doc('test_uid').set(userData);

      final retrievedProfile = await firestoreService.getUserProfile('test_uid');

      expect(retrievedProfile, isNotNull);
      expect(retrievedProfile?.uid, 'test_uid');
      expect(retrievedProfile?.displayName, 'Test Athlete');
    });

    test('getUserProfile should return null if user does not exist', () async {
      // Logic Summary:
      // Ensures that the service handles non-existent users by returning null
      // instead of throwing an error.
      final retrievedProfile = await firestoreService.getUserProfile('non_existent');

      expect(retrievedProfile, isNull);
    });
  });
}
