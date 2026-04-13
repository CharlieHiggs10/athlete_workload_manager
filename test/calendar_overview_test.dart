import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:athlete_workload/main.dart';
import 'package:athlete_workload/models/athlete_mode.dart';
import 'package:athlete_workload/providers/activity_provider.dart';
import 'package:athlete_workload/models/activity_model.dart';
import 'package:athlete_workload/widgets/activity_card.dart';

// Logic Summary:
// Widget tests that validate the CalendarScreen's integration with Riverpod.
// It ensures that the UI accurately reflects the state of the ActivityProvider vault,
// specifically testing the filtering (Overview vs. Modes), chronological sorting, 
// and the fallback empty state.
void main() {
  group('Calendar Overview and Filtering Tests', () {
    testWidgets('Overview tab shows all activities for today', (WidgetTester tester) async {
      final now = DateTime.now();
      
      // Arrange: Boot up the app wrapped in a ProviderScope so Riverpod is active.
      await tester.pumpWidget(
        ProviderScope(
          child: const MyApp(),
        ),
      );

      // Logic block: Bypassing the UI to seed data
      // Instead of forcing the test to tap the FAB (Floating Action Button) and fill out the bottom sheet, 
      // grab direct access to the Riverpod container running inside the test.
      // Then inject two models (one Athletic, one Academic) 
      // directly into the vault to set up the test conditions.
      final container = ProviderScope.containerOf(tester.element(find.byType(MyApp)));
      container.read(activityProvider.notifier).addActivity(
        ActivityModel(
          id: '1',
          title: 'Morning Lift',
          date: now,
          startTime: const TimeOfDay(hour: 8, minute: 0),
          endTime: const TimeOfDay(hour: 9, minute: 0),
          category: AthleteMode.athletic,
        ),
      );
      container.read(activityProvider.notifier).addActivity(
        ActivityModel(
          id: '2',
          title: 'Math Class',
          date: now,
          startTime: const TimeOfDay(hour: 10, minute: 0),
          endTime: const TimeOfDay(hour: 11, minute: 0),
          category: AthleteMode.academic,
        ),
      );

      // Act: Tap the Overview tab and wait for any animations to finish.
      await tester.tap(find.byTooltip('OVERVIEW'));
      await tester.pumpAndSettle();

      // Assert: Verify the Overview tab ignores category filters and shows both items.
      expect(find.text('Overview'), findsOneWidget);
      expect(find.byType(ActivityCard), findsNWidgets(2));
      expect(find.text('Morning Lift'), findsOneWidget);
      expect(find.text('Math Class'), findsOneWidget);
    });

    testWidgets('Athletic tab filters strictly by athletic mode', (WidgetTester tester) async {
      final now = DateTime.now();
      
      await tester.pumpWidget(
        ProviderScope(
          child: const MyApp(),
        ),
      );

      // Arrange: Inject mixed data (Athletic and Academic) into the vault.
      final container = ProviderScope.containerOf(tester.element(find.byType(MyApp)));
      container.read(activityProvider.notifier).addActivity(
        ActivityModel(
          id: '1',
          title: 'Morning Lift',
          date: now,
          startTime: const TimeOfDay(hour: 8, minute: 0),
          endTime: const TimeOfDay(hour: 9, minute: 0),
          category: AthleteMode.athletic,
        ),
      );
      container.read(activityProvider.notifier).addActivity(
        ActivityModel(
          id: '2',
          title: 'Math Class',
          date: now,
          startTime: const TimeOfDay(hour: 10, minute: 0),
          endTime: const TimeOfDay(hour: 11, minute: 0),
          category: AthleteMode.academic,
        ),
      );

      // Act: Navigate specifically to the Athletic tab.
      await tester.tap(find.byTooltip('ATHLETIC'));
      await tester.pumpAndSettle();

      expect(find.text('Athletic'), findsOneWidget);
      expect(find.byType(ActivityCard), findsNWidgets(1));
      expect(find.text('Morning Lift'), findsOneWidget);
      expect(find.text('Math Class'), findsNothing);
    });

    testWidgets('Activities are sorted chronologically', (WidgetTester tester) async {
      final now = DateTime.now();
      
      await tester.pumpWidget(
        ProviderScope(
          child: const MyApp(),
        ),
      );

      // Arrange: Intentionally inject a 2:00 PM activity BEFORE an 8:00 AM activity.
      final container = ProviderScope.containerOf(tester.element(find.byType(MyApp)));
      container.read(activityProvider.notifier).addActivity(
        ActivityModel(
          id: '1',
          title: 'Late Activity',
          date: now,
          startTime: const TimeOfDay(hour: 14, minute: 0),
          endTime: const TimeOfDay(hour: 15, minute: 0),
          category: AthleteMode.athletic,
        ),
      );
      container.read(activityProvider.notifier).addActivity(
        ActivityModel(
          id: '2',
          title: 'Early Activity',
          date: now,
          startTime: const TimeOfDay(hour: 8, minute: 0),
          endTime: const TimeOfDay(hour: 9, minute: 0),
          category: AthleteMode.academic,
        ),
      );

      // Act: Open the overview tab to render the list.
      await tester.tap(find.byTooltip('OVERVIEW'));
      await tester.pumpAndSettle();

      /// `tester.widgetList` extracts the actual widgets currently rendered on the screen.
      /// By converting it to a List, we can check index [0] to prove the UI sorted 
      /// the 8:00 AM activity to the top, regardless of injection order.
      final cardList = tester.widgetList<ActivityCard>(find.byType(ActivityCard)).toList();
      expect(cardList[0].activity.title, 'Early Activity');
      expect(cardList[1].activity.title, 'Late Activity');
    });

    testWidgets('Shows empty state message when no activities exist', (WidgetTester tester) async {
      // Arrange: Boot the app with a completely empty Riverpod vault.
      await tester.pumpWidget(
        ProviderScope(
          child: const MyApp(),
        ),
      );

      // Act: Navigate to the Overview tab.
      await tester.tap(find.byTooltip('OVERVIEW'));
      await tester.pumpAndSettle();

      // Assert: Verify the placeholder text and icon render instead of an empty screen.
      expect(find.text('No  activities for today.'), findsOneWidget);
      expect(find.byIcon(Icons.view_agenda), findsOneWidget);
    });
  });
}
