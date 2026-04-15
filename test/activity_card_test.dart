import 'package:athlete_workload/models/activity_model.dart';
import 'package:athlete_workload/models/athlete_mode.dart';
import 'package:athlete_workload/widgets/activity_card.dart';
import 'package:athlete_workload/theme.dart';
import 'package:athlete_workload/providers/activity_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

void main() {
  testWidgets('ActivityCard displays all model information correctly', (WidgetTester tester) async {
    final activity = ActivityModel(
      id: 'test-id',
      title: 'Practice',
      date: DateTime(2026, 4, 6),
      startTime: const TimeOfDay(hour: 10, minute: 30),
      endTime: const TimeOfDay(hour: 12, minute: 0),
      category: AthleteMode.athletic,
    );

    await tester.pumpWidget(
      ProviderScope(
        child: MaterialApp(
          home: Scaffold(
            body: ActivityCard(activity: activity),
          ),
        ),
      ),
    );

    // Verify title
    expect(find.text('Practice'), findsOneWidget);

    // Verify time range
    expect(find.text('10:30 AM - 12:00 PM'), findsOneWidget);

    // Verify category icon (Icons.fitness_center for athletic)
    expect(find.byIcon(Icons.fitness_center), findsOneWidget);

    // Verify border color
    final card = tester.widget<Card>(find.byType(Card));
    final shape = card.shape as RoundedRectangleBorder;
    expect(shape.side.color, AppTheme.athleticRed);
    
    // Verify PopupMenuButton exists
    expect(find.byIcon(Icons.more_vert), findsOneWidget);
  });

  testWidgets('ActivityCard delete action triggers provider', (WidgetTester tester) async {
    final activity = ActivityModel(
      id: 'delete-me',
      title: 'Practice',
      date: DateTime(2026, 4, 6),
      startTime: const TimeOfDay(hour: 10, minute: 30),
      endTime: const TimeOfDay(hour: 12, minute: 0),
      category: AthleteMode.athletic,
    );

    final container = ProviderContainer();
    container.read(activityProvider.notifier).addActivity(activity);

    await tester.pumpWidget(
      UncontrolledProviderScope(
        container: container,
        child: MaterialApp(
          home: Scaffold(
            body: ActivityCard(activity: activity),
          ),
        ),
      ),
    );

    // Open menu
    await tester.tap(find.byIcon(Icons.more_vert));
    await tester.pumpAndSettle();

    // Tap delete
    await tester.tap(find.text('Delete'));
    await tester.pumpAndSettle();

    // Verify activity is gone from provider
    expect(container.read(activityProvider), isEmpty);
  });

  testWidgets('ActivityCard edit action opens ActivityInputSheet', (WidgetTester tester) async {
    final activity = ActivityModel(
      id: 'edit-me',
      title: 'Practice',
      date: DateTime(2026, 4, 6),
      startTime: const TimeOfDay(hour: 10, minute: 30),
      endTime: const TimeOfDay(hour: 12, minute: 0),
      category: AthleteMode.athletic,
    );

    await tester.pumpWidget(
      ProviderScope(
        child: MaterialApp(
          home: Scaffold(
            body: ActivityCard(activity: activity),
          ),
        ),
      ),
    );

    // Open menu
    await tester.tap(find.byIcon(Icons.more_vert));
    await tester.pumpAndSettle();

    // Tap edit
    await tester.tap(find.text('Edit'));
    await tester.pumpAndSettle();

    // Verify ActivityInputSheet is shown
    // We can check for "Update Activity" button text which is unique to edit mode
    expect(find.text('Update Activity'), findsOneWidget);
    
    // Verify fields are pre-populated
    expect(find.text('Practice'), findsNWidgets(2)); // One on card, one in sheet
  });

  testWidgets('ActivityCard applies Academic theme colors and icons', (WidgetTester tester) async {
    final activity = ActivityModel(
      id: 'test-id-2',
      title: 'Study',
      date: DateTime(2026, 4, 6),
      startTime: const TimeOfDay(hour: 15, minute: 0),
      endTime: const TimeOfDay(hour: 17, minute: 0),
      category: AthleteMode.academic,
    );

    await tester.pumpWidget(
      ProviderScope(
        child: MaterialApp(
          home: Scaffold(
            body: ActivityCard(activity: activity),
          ),
        ),
      ),
    );

    expect(find.byIcon(Icons.school), findsOneWidget);
    
    final card = tester.widget<Card>(find.byType(Card));
    final shape = card.shape as RoundedRectangleBorder;
    expect(shape.side.color, AppTheme.academicBlue);
  });
}
