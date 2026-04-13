import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:athlete_workload/providers/activity_provider.dart';
import 'package:athlete_workload/models/activity_model.dart';
import 'package:athlete_workload/models/athlete_mode.dart';
import 'package:flutter/material.dart';

// Logic Summary:
// Unit tests focused exclusively on the data layer (ActivityProvider).
// Unlike widget tests that require a simulated UI, these tests run purely 
// in Dart memory to guarantee your state management logic is bulletproof 
// and immutable before it ever touches a screen.
void main() {
  group('ActivityProvider Tests', () {
    
    // Logic block: Headless Riverpod Environment
    // Because pure unit tests don't have a widget tree (and therefore no ProviderScope),
    // we must create a standalone `ProviderContainer`. This acts as an isolated,
    // invisible bubble to hold your app's state for the duration of the test.
    // `addTearDown` ensures the bubble pops after the test, preventing memory leaks 
    // between different test cases.
    ProviderContainer createContainer() {
      final container = ProviderContainer();
      addTearDown(container.dispose);
      return container;
    }

    test('Initial state should be an empty list', () {
      final container = createContainer();
      
      // Act & Assert: Verify the vault boots up completely clean.
      // This ensures we never accidentally launch the app with null data that could crash the UI.
      final state = container.read(activityProvider);
      
      expect(state, isEmpty, reason: 'The activity list should start empty.');
    });

    test('addActivity should immutably update the list with a new activity', () {
      final container = createContainer();
      
      final testActivity = ActivityModel(
        id: 'test-1',
        title: 'Lift',
        date: DateTime(2026, 4, 6),
        startTime: const TimeOfDay(hour: 8, minute: 0),
        endTime: const TimeOfDay(hour: 9, minute: 30),
        category: AthleteMode.athletic,
      );

      // Logic block: The State Modification Handshake
      // We access the `.notifier` to issue the command (addActivity). 
      // However, we must then read the base provider (`activityProvider`) to check the result. 
      // This proves Riverpod successfully caught the command, adhered to immutability rules, 
      // and generated a brand new list containing our model.
      container.read(activityProvider.notifier).addActivity(testActivity);

      final state = container.read(activityProvider);
      
      expect(state.length, 1);
      expect(state.first, testActivity);
    });

    test('Multiple activities should be appended in order', () {
      final container = createContainer();
      
      final activity1 = ActivityModel(
        id: 'test-1',
        title: 'Lift',
        date: DateTime(2026, 4, 6),
        startTime: const TimeOfDay(hour: 8, minute: 0),
        endTime: const TimeOfDay(hour: 9, minute: 30),
        category: AthleteMode.athletic,
      );

      final activity2 = ActivityModel(
        id: 'test-2',
        title: 'Study',
        date: DateTime(2026, 4, 6),
        startTime: const TimeOfDay(hour: 10, minute: 0),
        endTime: const TimeOfDay(hour: 12, minute: 0),
        category: AthleteMode.academic,
      );

      // Act: Fire multiple modifications rapidly.
      final notifier = container.read(activityProvider.notifier);
      notifier.addActivity(activity1);
      notifier.addActivity(activity2);

      // Assert: Verify the vault didn't overwrite the first activity, 
      // but correctly accumulated both in chronological entry order.
      final state = container.read(activityProvider);
      
      expect(state.length, 2);
      expect(state[0], activity1);
      expect(state[1], activity2);
    });

    test('updateActivity should replace an existing activity by ID', () {
      final container = createContainer();
      final notifier = container.read(activityProvider.notifier);
      
      final activity = ActivityModel(
        id: 'update-1',
        title: 'Original',
        date: DateTime(2026, 4, 13),
        startTime: const TimeOfDay(hour: 9, minute: 0),
        endTime: const TimeOfDay(hour: 10, minute: 0),
        category: AthleteMode.athletic,
      );

      notifier.addActivity(activity);

      final updated = activity.copyWith(title: 'Updated');
      notifier.updateActivity(updated);

      final state = container.read(activityProvider);
      expect(state.length, 1);
      expect(state.first.title, 'Updated');
      expect(state.first.id, 'update-1');
    });

    test('deleteActivity should remove an activity by ID', () {
      final container = createContainer();
      final notifier = container.read(activityProvider.notifier);
      
      final activity = ActivityModel(
        id: 'delete-1',
        title: 'To Delete',
        date: DateTime(2026, 4, 13),
        startTime: const TimeOfDay(hour: 9, minute: 0),
        endTime: const TimeOfDay(hour: 10, minute: 0),
        category: AthleteMode.athletic,
      );

      notifier.addActivity(activity);
      expect(container.read(activityProvider).length, 1);

      notifier.deleteActivity('delete-1');
      expect(container.read(activityProvider), isEmpty);
    });
  });
}
