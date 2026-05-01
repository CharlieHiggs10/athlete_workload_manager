import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fake_cloud_firestore/fake_cloud_firestore.dart';
import 'package:athlete_workload/main.dart';
import 'package:athlete_workload/models/athlete_mode.dart';
import 'package:athlete_workload/providers/activity_provider.dart';
import 'package:athlete_workload/providers/auth_provider.dart';
import 'package:athlete_workload/providers/firestore_provider.dart';
import 'package:athlete_workload/models/activity_model.dart';
import 'package:athlete_workload/models/user_profile.dart';
import 'package:athlete_workload/widgets/activity_card.dart';

// Logic Summary:
// Widget tests that validate the CalendarScreen's integration with Riverpod.
// It ensures that the UI accurately reflects the state of the ActivityProvider vault,
// specifically testing the filtering (Overview vs. Modes), chronological sorting, 
// and the fallback empty state.
void main() {
  const testUser = UserProfile(uid: 'test_user', email: 'test@example.com');

  group('Calendar Overview and Filtering Tests', () {
    late FakeFirebaseFirestore fakeFirestore;

    setUp(() {
      fakeFirestore = FakeFirebaseFirestore();
    });

    testWidgets('Overview tab shows all activities for today', (WidgetTester tester) async {
      final now = DateTime.now();
      
      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            authStateProvider.overrideWith((ref) => Stream.value(testUser)),
            firestoreInstanceProvider.overrideWith((ref) => fakeFirestore),
          ],
          child: const MyApp(),
        ),
      );

      // Wait for auth to resolve and CalendarScreen to load
      await tester.pumpAndSettle();

      final container = ProviderScope.containerOf(tester.element(find.byType(MyApp)));
      
      // Inject two models directly into the vault to set up the test conditions.
      await container.read(activityProvider.notifier).addActivity(
        ActivityModel(
          id: '1',
          title: 'Morning Lift',
          date: now,
          startTime: const TimeOfDay(hour: 8, minute: 0),
          endTime: const TimeOfDay(hour: 9, minute: 0),
          category: AthleteMode.athletic,
        ),
      );
      await container.read(activityProvider.notifier).addActivity(
        ActivityModel(
          id: '2',
          title: 'Math Class',
          date: now,
          startTime: const TimeOfDay(hour: 10, minute: 0),
          endTime: const TimeOfDay(hour: 11, minute: 0),
          category: AthleteMode.academic,
        ),
      );

      // Allow the UI to update after adding activities
      await tester.pumpAndSettle();

      // Act: Tap the Overview tab.
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
          overrides: [
            authStateProvider.overrideWith((ref) => Stream.value(testUser)),
            firestoreInstanceProvider.overrideWith((ref) => fakeFirestore),
          ],
          child: const MyApp(),
        ),
      );

      await tester.pumpAndSettle();

      final container = ProviderScope.containerOf(tester.element(find.byType(MyApp)));
      await container.read(activityProvider.notifier).addActivity(
        ActivityModel(
          id: '1',
          title: 'Morning Lift',
          date: now,
          startTime: const TimeOfDay(hour: 8, minute: 0),
          endTime: const TimeOfDay(hour: 9, minute: 0),
          category: AthleteMode.athletic,
        ),
      );
      await container.read(activityProvider.notifier).addActivity(
        ActivityModel(
          id: '2',
          title: 'Math Class',
          date: now,
          startTime: const TimeOfDay(hour: 10, minute: 0),
          endTime: const TimeOfDay(hour: 11, minute: 0),
          category: AthleteMode.academic,
        ),
      );

      await tester.pumpAndSettle();

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
          overrides: [
            authStateProvider.overrideWith((ref) => Stream.value(testUser)),
            firestoreInstanceProvider.overrideWith((ref) => fakeFirestore),
          ],
          child: const MyApp(),
        ),
      );

      await tester.pumpAndSettle();

      final container = ProviderScope.containerOf(tester.element(find.byType(MyApp)));
      await container.read(activityProvider.notifier).addActivity(
        ActivityModel(
          id: '1',
          title: 'Late Activity',
          date: now,
          startTime: const TimeOfDay(hour: 14, minute: 0),
          endTime: const TimeOfDay(hour: 15, minute: 0),
          category: AthleteMode.athletic,
        ),
      );
      await container.read(activityProvider.notifier).addActivity(
        ActivityModel(
          id: '2',
          title: 'Early Activity',
          date: now,
          startTime: const TimeOfDay(hour: 8, minute: 0),
          endTime: const TimeOfDay(hour: 9, minute: 0),
          category: AthleteMode.academic,
        ),
      );

      await tester.pumpAndSettle();

      await tester.tap(find.byTooltip('OVERVIEW'));
      await tester.pumpAndSettle();

      final cardList = tester.widgetList<ActivityCard>(find.byType(ActivityCard)).toList();
      expect(cardList[0].activity.title, 'Early Activity');
      expect(cardList[1].activity.title, 'Late Activity');
    });

    testWidgets('Shows empty state message when no activities exist', (WidgetTester tester) async {
      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            authStateProvider.overrideWith((ref) => Stream.value(testUser)),
            firestoreInstanceProvider.overrideWith((ref) => fakeFirestore),
          ],
          child: const MyApp(),
        ),
      );

      await tester.pumpAndSettle();

      await tester.tap(find.byTooltip('OVERVIEW'));
      await tester.pumpAndSettle();

      expect(find.text('No  activities for today.'), findsOneWidget);
      expect(find.byIcon(Icons.view_agenda), findsOneWidget);
    });

    testWidgets('Overview strictly filters for today and excludes future activities', (WidgetTester tester) async {
      final now = DateTime.now();
      final tomorrow = now.add(const Duration(days: 1));
      
      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            authStateProvider.overrideWith((ref) => Stream.value(testUser)),
            firestoreInstanceProvider.overrideWith((ref) => fakeFirestore),
          ],
          child: const MyApp(),
        ),
      );

      await tester.pumpAndSettle();

      final container = ProviderScope.containerOf(tester.element(find.byType(MyApp)));
      
      await container.read(activityProvider.notifier).addActivity(
        ActivityModel(
          id: 'today_1',
          title: 'Today Activity',
          date: now,
          startTime: const TimeOfDay(hour: 10, minute: 0),
          endTime: const TimeOfDay(hour: 11, minute: 0),
          category: AthleteMode.athletic,
        ),
      );

      await container.read(activityProvider.notifier).addActivity(
        ActivityModel(
          id: 'tomorrow_1',
          title: 'Future Activity',
          date: tomorrow,
          startTime: const TimeOfDay(hour: 10, minute: 0),
          endTime: const TimeOfDay(hour: 11, minute: 0),
          category: AthleteMode.athletic,
        ),
      );

      await tester.pumpAndSettle();

      await tester.tap(find.byTooltip('OVERVIEW'));
      await tester.pumpAndSettle();

      expect(find.text('Today Activity'), findsOneWidget);
      expect(find.text('Future Activity'), findsNothing);
      expect(find.byType(ActivityCard), findsNWidgets(1));
    });
  });
}
