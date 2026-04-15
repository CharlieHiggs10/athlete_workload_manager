import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:athlete_workload/main.dart';
import 'package:athlete_workload/models/athlete_mode.dart';

void main() {
  testWidgets('CalendarScreen switches modes correctly', (WidgetTester tester) async {
    // tester.pumpWidget: "Inflates" the widget tree. 
    // Think of this as opening the app to the first screen.
    await tester.pumpWidget(const ProviderScope(child: MyApp()));

    // expect: An assertion. 
    // findsOneWidget: Checks that exactly one instance of this text exists.
    expect(find.text('Athletic'), findsOneWidget);
    expect(find.text('No Athletic activities scheduled.'), findsOneWidget);
    
    // findsAtLeastNWidgets(2): Confirms the icon is visible in at least two places.
    expect(find.byIcon(Icons.fitness_center), findsAtLeastNWidgets(2));

    // tester.tap: Tells the tester to "click" the widget with the specific tooltip.
    // await: We wait for the tap gesture to be registered.
    await tester.tap(find.byTooltip('ACADEMIC'));

    // tester.pumpAndSettle: The most important part after a tap. 
    // It waits for all animations (like a screen fade or slide) to finish 
    // so the "Academic" view is fully visible before we test it.
    await tester.pumpAndSettle();

    expect(find.text('Academic'), findsOneWidget);
    expect(find.text('No Academic activities scheduled.'), findsOneWidget);
    expect(find.byIcon(Icons.school), findsAtLeastNWidgets(2));

    await tester.tap(find.byTooltip('RECOVERY'));
    
    // Without this pumpAndSettle, the test would fail because it would 
    // look for "Recovery" while the app is still mid-animation.
    await tester.pumpAndSettle();

    expect(find.text('Recovery'), findsOneWidget);
    expect(find.text('No Recovery activities scheduled.'), findsOneWidget);
    expect(find.byIcon(Icons.self_improvement), findsAtLeastNWidgets(2));
  });
}