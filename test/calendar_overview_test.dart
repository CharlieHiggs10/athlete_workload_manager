import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:athlete_workload/main.dart';
import 'package:athlete_workload/models/athlete_mode.dart';
import 'package:athlete_workload/providers/activity_provider.dart';
import 'package:athlete_workload/models/activity_model.dart';
import 'package:athlete_workload/widgets/activity_card.dart';

/// Logic Summary:
/// Verifies that the CalendarScreen correctly renders the Overview tab,
/// sorts activities chronologically, and filters them based on the active mode.
void main() {
  group('Calendar Overview and Filtering Tests', () {
    testWidgets('Overview tab shows all activities for today', (WidgetTester tester) async {
      final now = DateTime.now();
      
      await tester.pumpWidget(
        ProviderScope(
          child: const MyApp(),
        ),
      );

      // Add activities via the provider directly for testing
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

      // Switch to Overview tab
      await tester.tap(find.byTooltip('OVERVIEW'));
      await tester.pumpAndSettle();

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

      // Switch to Athletic tab
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

      await tester.tap(find.byTooltip('OVERVIEW'));
      await tester.pumpAndSettle();

      // Check order
      final cardList = tester.widgetList<ActivityCard>(find.byType(ActivityCard)).toList();
      expect(cardList[0].activity.title, 'Early Activity');
      expect(cardList[1].activity.title, 'Late Activity');
    });

    testWidgets('Shows empty state message when no activities exist', (WidgetTester tester) async {
      await tester.pumpWidget(
        ProviderScope(
          child: const MyApp(),
        ),
      );

      await tester.tap(find.byTooltip('OVERVIEW'));
      await tester.pumpAndSettle();

      expect(find.text('No  activities for today.'), findsOneWidget);
      expect(find.byIcon(Icons.view_agenda), findsOneWidget);
    });
  });
}
