import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:athlete_workload/main.dart';
import 'package:athlete_workload/models/athlete_mode.dart';

void main() {
  testWidgets('CalendarScreen switches modes correctly', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const ProviderScope(child: MyApp()));

    // Verify initial state is Athletic.
    expect(find.text('Athletic'), findsOneWidget);
    expect(find.text('Athletic Calendar View'), findsOneWidget);
    expect(find.byIcon(Icons.fitness_center), findsAtLeastNWidgets(2)); // One in actions, one in body.

    // Switch to Academic mode.
    await tester.tap(find.byTooltip('ACADEMIC'));
    await tester.pumpAndSettle();

    // Verify UI reflects Academic mode.
    expect(find.text('Academic'), findsOneWidget);
    expect(find.text('Academic Calendar View'), findsOneWidget);
    expect(find.byIcon(Icons.school), findsAtLeastNWidgets(2));

    // Switch to Recovery mode.
    await tester.tap(find.byTooltip('RECOVERY'));
    await tester.pumpAndSettle();

    // Verify UI reflects Recovery mode.
    expect(find.text('Recovery'), findsOneWidget);
    expect(find.text('Recovery Calendar View'), findsOneWidget);
    expect(find.byIcon(Icons.self_improvement), findsAtLeastNWidgets(2));
  });
}
