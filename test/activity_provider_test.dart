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
      expect(state, isA<AsyncLoading>());
    });

    test('should return empty list when user is null', () async {
      final container = ProviderContainer(
        overrides: [
          authStateProvider.overrideWith((ref) => Stream.value(null)),
          firestoreInstanceProvider.overrideWith((ref) => fakeFirestore),
        ],
      );
      addTearDown(container.dispose);

      final activities = await container.read(activityProvider.future);
      expect(activities, isEmpty);
    });

    test('should reflect activities added to Firestore', () async {
      final container = createContainer();
      
      await container.read(authStateProvider.future);
      
      final activity = ActivityModel(
        id: 'act_1',
        title: 'Lift',
        date: DateTime(2026, 4, 30),
        startTime: const TimeOfDay(hour: 8, minute: 0),
        endTime: const TimeOfDay(hour: 9, minute: 0),
        category: AthleteMode.athletic,
      );

      await fakeFirestore
          .collection('users')
          .doc(testUser.uid)
          .collection('activities')
          .doc(activity.id)
          .set(activity.toMap());

      final activities = await container.read(activityProvider.future);
      
      expect(activities.length, 1);
      expect(activities.first.title, 'Lift');
    });

    test('addActivity should write to Firestore', () async {
      final container = createContainer();
      
      // Ensure auth is initialized
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
      
      // Ensure auth is initialized
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
      
      // Ensure auth is initialized
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

    test('addActivity should inject correct weight before saving', () async {
      final container = createContainer();
      await container.read(authStateProvider.future);
      
      final activity = ActivityModel(
        id: 'act_weight_test',
        title: 'Game', // Weight should be 4
        date: DateTime(2026, 4, 30),
        startTime: const TimeOfDay(hour: 10, minute: 0),
        endTime: const TimeOfDay(hour: 11, minute: 0),
        category: AthleteMode.athletic,
      );

      await container.read(activityProvider.notifier).addActivity(activity);

      final doc = await fakeFirestore
          .collection('users')
          .doc(testUser.uid)
          .collection('activities')
          .doc('act_weight_test')
          .get();
      
      expect(doc.data()?['weight'], 4);
    });

    test('updateActivity should inject correct weight before saving', () async {
      final container = createContainer();
      await container.read(authStateProvider.future);
      
      final activity = ActivityModel(
        id: 'act_update_weight_test',
        title: 'Study', // Weight 3
        date: DateTime(2026, 4, 30),
        startTime: const TimeOfDay(hour: 10, minute: 0),
        endTime: const TimeOfDay(hour: 11, minute: 0),
        category: AthleteMode.academic,
      );

      await container.read(activityProvider.notifier).addActivity(activity);
      
      final updated = activity.copyWith(title: 'Nap'); // Weight -3
      await container.read(activityProvider.notifier).updateActivity(updated);

      final doc = await fakeFirestore
          .collection('users')
          .doc(testUser.uid)
          .collection('activities')
          .doc('act_update_weight_test')
          .get();
      
      expect(doc.data()?['weight'], -3);
    });

    test('recentActivitiesProvider should filter activities to strictly the last 7 days', () async {
      final container = createContainer();
      await container.read(authStateProvider.future);

      final now = DateTime.now();
      final today = DateTime(now.year, now.month, now.day);
      
      final activities = [
        // Today
        ActivityModel(
          id: '1',
          title: 'Practice',
          date: today,
          startTime: const TimeOfDay(hour: 10, minute: 0),
          endTime: const TimeOfDay(hour: 12, minute: 0),
          category: AthleteMode.athletic,
        ),
        // 6 days ago (Inclusive)
        ActivityModel(
          id: '2',
          title: 'Lift',
          date: today.subtract(const Duration(days: 6)),
          startTime: const TimeOfDay(hour: 10, minute: 0),
          endTime: const TimeOfDay(hour: 11, minute: 0),
          category: AthleteMode.athletic,
        ),
        // 7 days ago (Exclusive)
        ActivityModel(
          id: '3',
          title: 'Game',
          date: today.subtract(const Duration(days: 7)),
          startTime: const TimeOfDay(hour: 10, minute: 0),
          endTime: const TimeOfDay(hour: 13, minute: 0),
          category: AthleteMode.athletic,
        ),
        // Future date (Exclusive)
        ActivityModel(
          id: '4',
          title: 'Study',
          date: today.add(const Duration(days: 1)),
          startTime: const TimeOfDay(hour: 10, minute: 0),
          endTime: const TimeOfDay(hour: 11, minute: 0),
          category: AthleteMode.academic,
        ),
      ];

      for (var activity in activities) {
        await container.read(activityProvider.notifier).addActivity(activity);
      }

      // Wait for the activityProvider to update and emit data
      final filteredActivities = await container.read(activityProvider.future).then((_) {
        return container.read(recentActivitiesProvider).value!;
      });

      expect(filteredActivities.length, 2);
      expect(filteredActivities.any((a) => a.id == '1'), isTrue);
      expect(filteredActivities.any((a) => a.id == '2'), isTrue);
      expect(filteredActivities.any((a) => a.id == '3'), isFalse);
      expect(filteredActivities.any((a) => a.id == '4'), isFalse);
    });
  });

  group('Weight Mapping Tests', () {
    test('getActivityWeight should return correct values for all activities', () {
      final container = ProviderContainer();
      addTearDown(container.dispose);
      final notifier = container.read(activityProvider.notifier);

      expect(notifier.getActivityWeight('Game'), 4);
      expect(notifier.getActivityWeight('Practice'), 3);
      expect(notifier.getActivityWeight('Study'), 3);
      expect(notifier.getActivityWeight('Class'), 3);
      expect(notifier.getActivityWeight('Lift'), 2);
      expect(notifier.getActivityWeight('Travel'), 2);
      expect(notifier.getActivityWeight('Lab'), 2);
      expect(notifier.getActivityWeight('Film'), 1);
      expect(notifier.getActivityWeight('Office Hours'), 1);
      expect(notifier.getActivityWeight('Stretching'), -1);
      expect(notifier.getActivityWeight('Injury Rehab'), -2);
      expect(notifier.getActivityWeight('Hydration'), -2);
      expect(notifier.getActivityWeight('Ice Bath'), -2);
      expect(notifier.getActivityWeight('Nap'), -3);
    });

    test('getActivityWeight should return 0 for unknown activities', () {
      final container = ProviderContainer();
      addTearDown(container.dispose);
      final notifier = container.read(activityProvider.notifier);

      expect(notifier.getActivityWeight('Exam'), 0);
      expect(notifier.getActivityWeight('Unknown'), 0);
      expect(notifier.getActivityWeight(''), 0);
    });
  });
}
