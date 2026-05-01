import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:athlete_workload/screens/calendar_screen.dart';
import 'package:athlete_workload/providers/activity_provider.dart';
import 'package:athlete_workload/models/activity_model.dart';

/// Logic Summary:
/// Mock notifier that stays in a loading state indefinitely for testing.
class LoadingNotifier extends ActivityNotifier {
  @override
  FutureOr<List<ActivityModel>> build() {
    return Completer<List<ActivityModel>>().future;
  }
}

/// Logic Summary:
/// Mock notifier that immediately throws an error for testing.
class ErrorNotifier extends ActivityNotifier {
  @override
  FutureOr<List<ActivityModel>> build() {
    throw Exception('Simulated network error');
  }
}

void main() {
  group('Calendar Loading and Error State Tests', () {
    testWidgets('Shows CircularProgressIndicator when state is loading', (WidgetTester tester) async {
      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            activityProvider.overrideWith(LoadingNotifier.new),
          ],
          child: const MaterialApp(
            home: CalendarScreen(),
          ),
        ),
      );

      // Assert: Verify that the loading spinner is visible.
      expect(find.byType(CircularProgressIndicator), findsOneWidget);
    });

    testWidgets('Shows error message when state is error', (WidgetTester tester) async {
      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            activityProvider.overrideWith(ErrorNotifier.new),
          ],
          child: const MaterialApp(
            home: CalendarScreen(),
          ),
        ),
      );

      // Need to pump to allow the build to trigger with the error
      await tester.pump();

      // Assert: Verify that the error message is displayed.
      expect(find.text('Failed to load activities. Please try again.'), findsOneWidget);
    });
  });
}
