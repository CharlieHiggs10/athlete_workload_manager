import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:athlete_workload/providers/activity_provider.dart';
import 'package:athlete_workload/models/activity_model.dart';
import 'package:athlete_workload/models/athlete_mode.dart';
import 'package:flutter/material.dart';

/// Logic Summary:
/// Unit tests for ActivityProvider and ActivityNotifier to ensure
/// correct state management and immutability.
void main() {
  group('ActivityProvider Tests', () {
    
    // Helper function to create a ProviderContainer for testing.
    ProviderContainer createContainer() {
      final container = ProviderContainer();
      addTearDown(container.dispose);
      return container;
    }

    test('Initial state should be an empty list', () {
      final container = createContainer();
      
      // Read the current state of activityProvider.
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

      // Add the activity via the notifier.
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

      final notifier = container.read(activityProvider.notifier);
      notifier.addActivity(activity1);
      notifier.addActivity(activity2);

      final state = container.read(activityProvider);
      
      expect(state.length, 2);
      expect(state[0], activity1);
      expect(state[1], activity2);
    });
  });
}
