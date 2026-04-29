import 'package:flutter_test/flutter_test.dart';
import 'package:fake_cloud_firestore/fake_cloud_firestore.dart';
import 'package:athlete_workload/services/firestore_service.dart';
import 'package:athlete_workload/models/user_profile.dart';
import 'package:athlete_workload/models/activity_model.dart';
import 'package:athlete_workload/models/athlete_mode.dart';
import 'package:flutter/material.dart';

void main() {
  group('FirestoreService Tests', () {
    late FakeFirebaseFirestore fakeFirestore;
    late FirestoreService firestoreService;

    setUp(() {
      fakeFirestore = FakeFirebaseFirestore();
      firestoreService = FirestoreService(firestore: fakeFirestore);
    });

    test('saveUserProfile should save profile data to Firestore', () async {
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
      final retrievedProfile = await firestoreService.getUserProfile('non_existent');

      expect(retrievedProfile, isNull);
    });

    test('addActivity should save activity to subcollection', () async {
      final activity = ActivityModel(
        id: 'act_1',
        title: 'Practice',
        date: DateTime(2026, 4, 30),
        startTime: const TimeOfDay(hour: 14, minute: 0),
        endTime: const TimeOfDay(hour: 16, minute: 0),
        category: AthleteMode.athletic,
      );

      await firestoreService.addActivity('test_uid', activity);

      final doc = await fakeFirestore
          .collection('users')
          .doc('test_uid')
          .collection('activities')
          .doc('act_1')
          .get();
      
      expect(doc.exists, isTrue);
      expect(doc.data()?['title'], 'Practice');
    });

    test('activitiesStream should emit list of activities', () async {
      final activity = ActivityModel(
        id: 'act_1',
        title: 'Practice',
        date: DateTime(2026, 4, 30),
        startTime: const TimeOfDay(hour: 14, minute: 0),
        endTime: const TimeOfDay(hour: 16, minute: 0),
        category: AthleteMode.athletic,
      );

      await firestoreService.addActivity('test_uid', activity);

      final stream = firestoreService.activitiesStream('test_uid');
      final firstEmission = await stream.first;

      expect(firstEmission.length, 1);
      expect(firstEmission.first.id, 'act_1');
    });

    test('updateActivity should modify existing data', () async {
      final activity = ActivityModel(
        id: 'act_1',
        title: 'Practice',
        date: DateTime(2026, 4, 30),
        startTime: const TimeOfDay(hour: 14, minute: 0),
        endTime: const TimeOfDay(hour: 16, minute: 0),
        category: AthleteMode.athletic,
      );

      await firestoreService.addActivity('test_uid', activity);
      
      final updatedActivity = activity.copyWith(title: 'Early Practice');
      await firestoreService.updateActivity('test_uid', updatedActivity);

      final doc = await fakeFirestore
          .collection('users')
          .doc('test_uid')
          .collection('activities')
          .doc('act_1')
          .get();
      
      expect(doc.data()?['title'], 'Early Practice');
    });

    test('deleteActivity should remove document', () async {
      final activity = ActivityModel(
        id: 'act_1',
        title: 'Practice',
        date: DateTime(2026, 4, 30),
        startTime: const TimeOfDay(hour: 14, minute: 0),
        endTime: const TimeOfDay(hour: 16, minute: 0),
        category: AthleteMode.athletic,
      );

      await firestoreService.addActivity('test_uid', activity);
      await firestoreService.deleteActivity('test_uid', 'act_1');

      final doc = await fakeFirestore
          .collection('users')
          .doc('test_uid')
          .collection('activities')
          .doc('act_1')
          .get();
      
      expect(doc.exists, isFalse);
    });
  });
}
