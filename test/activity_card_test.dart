import 'package:athlete_workload/models/activity_model.dart';
import 'package:athlete_workload/models/athlete_mode.dart';
import 'package:athlete_workload/widgets/activity_card.dart';
import 'package:athlete_workload/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

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
      MaterialApp(
        home: Scaffold(
          body: ActivityCard(activity: activity),
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
      MaterialApp(
        home: Scaffold(
          body: ActivityCard(activity: activity),
        ),
      ),
    );

    expect(find.byIcon(Icons.school), findsOneWidget);
    
    final card = tester.widget<Card>(find.byType(Card));
    final shape = card.shape as RoundedRectangleBorder;
    expect(shape.side.color, AppTheme.academicBlue);
  });

  testWidgets('ActivityCard applies Recovery theme colors and icons', (WidgetTester tester) async {
    final activity = ActivityModel(
      id: 'test-id-3',
      title: 'Stretching',
      date: DateTime(2026, 4, 6),
      startTime: const TimeOfDay(hour: 20, minute: 0),
      endTime: const TimeOfDay(hour: 21, minute: 0),
      category: AthleteMode.recovery,
    );

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: ActivityCard(activity: activity),
        ),
      ),
    );

    expect(find.byIcon(Icons.self_improvement), findsOneWidget);
    
    final card = tester.widget<Card>(find.byType(Card));
    final shape = card.shape as RoundedRectangleBorder;
    expect(shape.side.color, AppTheme.recoveryGreen);
  });
}
