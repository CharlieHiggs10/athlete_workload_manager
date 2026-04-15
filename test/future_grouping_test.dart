import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:athlete_workload/main.dart';
import 'package:athlete_workload/models/athlete_mode.dart';
import 'package:athlete_workload/providers/activity_provider.dart';
import 'package:athlete_workload/models/activity_model.dart';
import 'package:athlete_workload/widgets/activity_card.dart';

void main() {
  group('Future Grouping and Mode Filtering Tests', () {
    testWidgets('Mode tabs show today and future activities with headers', (WidgetTester tester) async {
      final now = DateTime.now();
      final today = DateTime(now.year, now.month, now.day);
      final tomorrow = today.add(const Duration(days: 1));
      final nextWeek = today.add(const Duration(days: 7));
      
      await tester.pumpWidget(
        ProviderScope(
          child: const MyApp(),
        ),
      );

      final container = ProviderScope.containerOf(tester.element(find.byType(MyApp)));
      
      // Today
      container.read(activityProvider.notifier).addActivity(
        ActivityModel(
          id: '1',
          title: 'Today Lift',
          date: today,
          startTime: const TimeOfDay(hour: 8, minute: 0),
          endTime: const TimeOfDay(hour: 9, minute: 0),
          category: AthleteMode.athletic,
        ),
      );

      // Tomorrow
      container.read(activityProvider.notifier).addActivity(
        ActivityModel(
          id: '2',
          title: 'Tomorrow Practice',
          date: tomorrow,
          startTime: const TimeOfDay(hour: 15, minute: 0),
          endTime: const TimeOfDay(hour: 17, minute: 0),
          category: AthleteMode.athletic,
        ),
      );

      // Future
      container.read(activityProvider.notifier).addActivity(
        ActivityModel(
          id: '3',
          title: 'Future Game',
          date: nextWeek,
          startTime: const TimeOfDay(hour: 19, minute: 0),
          endTime: const TimeOfDay(hour: 21, minute: 0),
          category: AthleteMode.athletic,
        ),
      );

      // Act: Navigate to Athletic tab
      await tester.tap(find.byTooltip('ATHLETIC'));
      await tester.pumpAndSettle();

      // Assert: Verify all three activities are shown
      expect(find.text('Today Lift'), findsOneWidget);
      expect(find.text('Tomorrow Practice'), findsOneWidget);
      expect(find.text('Future Game'), findsOneWidget);
      expect(find.byType(ActivityCard), findsNWidgets(3));

      // Assert: Verify headers
      expect(find.text('Today'), findsOneWidget);
      expect(find.text('Tomorrow'), findsOneWidget);
      
      // Manual month name for next week
      const months = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'];
      final expectedFutureHeader = '${months[nextWeek.month - 1]} ${nextWeek.day}';
      expect(find.text(expectedFutureHeader), findsOneWidget);
    });

    testWidgets('Mode tabs sort activities by date then time', (WidgetTester tester) async {
      final now = DateTime.now();
      final today = DateTime(now.year, now.month, now.day);
      final tomorrow = today.add(const Duration(days: 1));
      
      await tester.pumpWidget(
        ProviderScope(
          child: const MyApp(),
        ),
      );

      final container = ProviderScope.containerOf(tester.element(find.byType(MyApp)));
      
      // Inject out of order: Tomorrow early, then Today late, then Today early
      container.read(activityProvider.notifier).addActivity(
        ActivityModel(
          id: '1',
          title: 'Tomorrow Early',
          date: tomorrow,
          startTime: const TimeOfDay(hour: 6, minute: 0),
          endTime: const TimeOfDay(hour: 7, minute: 0),
          category: AthleteMode.athletic,
        ),
      );
      container.read(activityProvider.notifier).addActivity(
        ActivityModel(
          id: '2',
          title: 'Today Late',
          date: today,
          startTime: const TimeOfDay(hour: 20, minute: 0),
          endTime: const TimeOfDay(hour: 21, minute: 0),
          category: AthleteMode.athletic,
        ),
      );
      container.read(activityProvider.notifier).addActivity(
        ActivityModel(
          id: '3',
          title: 'Today Early',
          date: today,
          startTime: const TimeOfDay(hour: 8, minute: 0),
          endTime: const TimeOfDay(hour: 9, minute: 0),
          category: AthleteMode.athletic,
        ),
      );

      await tester.tap(find.byTooltip('ATHLETIC'));
      await tester.pumpAndSettle();

      final cardList = tester.widgetList<ActivityCard>(find.byType(ActivityCard)).toList();
      expect(cardList[0].activity.title, 'Today Early');
      expect(cardList[1].activity.title, 'Today Late');
      expect(cardList[2].activity.title, 'Tomorrow Early');
    });

    testWidgets('Mode tab empty state message is "scheduled"', (WidgetTester tester) async {
      await tester.pumpWidget(
        ProviderScope(
          child: const MyApp(),
        ),
      );

      await tester.tap(find.byTooltip('ATHLETIC'));
      await tester.pumpAndSettle();

      expect(find.text('No Athletic activities scheduled.'), findsOneWidget);
    });
   group('Overview Specific Filter Rule', () {
      testWidgets('Overview tab still strictly shows only today', (WidgetTester tester) async {
        final now = DateTime.now();
        final today = DateTime(now.year, now.month, now.day);
        final tomorrow = today.add(const Duration(days: 1));
        
        await tester.pumpWidget(
          ProviderScope(
            child: const MyApp(),
          ),
        );

        final container = ProviderScope.containerOf(tester.element(find.byType(MyApp)));
        
        container.read(activityProvider.notifier).addActivity(
          ActivityModel(
            id: '1',
            title: 'Today Item',
            date: today,
            startTime: const TimeOfDay(hour: 10, minute: 0),
            endTime: const TimeOfDay(hour: 11, minute: 0),
            category: AthleteMode.athletic,
          ),
        );
        container.read(activityProvider.notifier).addActivity(
          ActivityModel(
            id: '2',
            title: 'Future Item',
            date: tomorrow,
            startTime: const TimeOfDay(hour: 10, minute: 0),
            endTime: const TimeOfDay(hour: 11, minute: 0),
            category: AthleteMode.athletic,
          ),
        );

        await tester.tap(find.byTooltip('OVERVIEW'));
        await tester.pumpAndSettle();

        expect(find.text('Today Item'), findsOneWidget);
        expect(find.text('Future Item'), findsNothing);
      });
    });
  });
}
