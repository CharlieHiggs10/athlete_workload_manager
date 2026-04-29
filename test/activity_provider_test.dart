import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fake_cloud_firestore/fake_cloud_firestore.dart';
import 'package:athlete_workload/providers/activity_provider.dart';
import 'package:athlete_workload/providers/auth_provider.dart';
import 'package:athlete_workload/providers/firestore_provider.dart';
import 'package:athlete_workload/models/activity_model.dart';
import 'package:athlete_workload/models/athlete_mode.dart';
import 'package:athlete_workload/models/user_profile.dart';
import 'package:flutter/material.dart';

void main() {
  group('ActivityProvider Tests (Cloud Sync)', () {
    late FakeFirebaseFirestore fakeFirestore;
    const testUser = UserProfile(uid: 'test_user', email: 'test@example.com');

    setUp(() {
      fakeFirestore = FakeFirebaseFirestore();
    });

    /// Logic Summary:
    /// Creates a ProviderContainer with necessary overrides for Firebase and Auth.
    /// This allows us to test the provider in an isolated, controlled environment.
    ProviderContainer createContainer() {
      final container = ProviderContainer(
        overrides: [
          // Mock the auth state to simulate a logged-in user.
          authStateProvider.overrideWith((ref) => Stream.value(testUser)),
          // Mock the Firestore instance with a fake one for in-memory testing.
          firestoreInstanceProvider.overrideWith((ref) => fakeFirestore),
        ],
      );
      addTearDown(container.dispose);
      return container;
    }

    test('Initial state should be empty while stream is loading', () {
      final container = createContainer();
      final state = container.read(activityProvider);
      expect(state, isEmpty);
    });

    test('should reflect activities added to Firestore', () async {
      final container = createContainer();
      
      // Ensure auth is ready
      await container.read(authStateProvider.future);
      
      final activity = ActivityModel(
        id: 'act_1',
        title: 'Lift',
        date: DateTime(2026, 4, 30),
        startTime: const TimeOfDay(hour: 8, minute: 0),
        endTime: const TimeOfDay(hour: 9, minute: 0),
        category: AthleteMode.athletic,
      );

      // Add activity directly to Firestore
      await fakeFirestore
          .collection('users')
          .doc(testUser.uid)
          .collection('activities')
          .doc(activity.id)
          .set(activity.toMap());

      // Wait for the stream provider to emit
      final activities = await container.read(activitiesStreamProvider.future);
      
      expect(activities.length, 1);
      expect(activities.first.title, 'Lift');
      expect(container.read(activityProvider), activities);
    });

    test('addActivity should write to Firestore', () async {
      final container = createContainer();
      
      // Ensure auth is ready
      await container.read(authStateProvider.future);
      
      final activity = ActivityModel(
        id: 'act_2',
        title: 'Study',
        date: DateTime(2026, 4, 30),
        startTime: const TimeOfDay(hour: 10, minute: 0),
        endTime: const TimeOfDay(hour: 11, minute: 0),
        category: AthleteMode.academic,
      );

      await container.read(activityProvider.notifier).addActivity(activity);

      final doc = await fakeFirestore
          .collection('users')
          .doc(testUser.uid)
          .collection('activities')
          .doc('act_2')
          .get();
      
      expect(doc.exists, isTrue);
      expect(doc.data()?['title'], 'Study');
    });

    test('updateActivity should modify Firestore document', () async {
      final container = createContainer();
      
      // Ensure auth is ready
      await container.read(authStateProvider.future);
      
      final activity = ActivityModel(
        id: 'act_1',
        title: 'Lift',
        date: DateTime(2026, 4, 30),
        startTime: const TimeOfDay(hour: 8, minute: 0),
        endTime: const TimeOfDay(hour: 9, minute: 0),
        category: AthleteMode.athletic,
      );

      await container.read(activityProvider.notifier).addActivity(activity);
      
      final updated = activity.copyWith(title: 'Heavy Lift');
      await container.read(activityProvider.notifier).updateActivity(updated);

      final doc = await fakeFirestore
          .collection('users')
          .doc(testUser.uid)
          .collection('activities')
          .doc('act_1')
          .get();
      
      expect(doc.data()?['title'], 'Heavy Lift');
    });

    test('deleteActivity should remove Firestore document', () async {
      final container = createContainer();
      
      // Ensure auth is ready
      await container.read(authStateProvider.future);
      
      final activity = ActivityModel(
        id: 'act_1',
        title: 'Lift',
        date: DateTime(2026, 4, 30),
        startTime: const TimeOfDay(hour: 8, minute: 0),
        endTime: const TimeOfDay(hour: 9, minute: 0),
        category: AthleteMode.athletic,
      );

      await container.read(activityProvider.notifier).addActivity(activity);
      await container.read(activityProvider.notifier).deleteActivity('act_1');

      final doc = await fakeFirestore
          .collection('users')
          .doc(testUser.uid)
          .collection('activities')
          .doc('act_1')
          .get();
      
      expect(doc.exists, isFalse);
    });
  });
}
