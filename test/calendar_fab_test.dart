import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:athlete_workload/main.dart';
import 'package:athlete_workload/theme.dart';
import 'package:athlete_workload/providers/activity_provider.dart';

void main() {
  testWidgets('FloatingActionButton should trigger a placeholder ModalBottomSheet', (WidgetTester tester) async {
    await tester.pumpWidget(const ProviderScope(child: MyApp()));

    // Find the FAB. (FLOATING ACTION BUTTON)
    final fabFinder = find.byType(FloatingActionButton);
    expect(fabFinder, findsOneWidget);

    // Tap the FAB to open the bottom sheet.
    await tester.tap(fabFinder);
    await tester.pumpAndSettle();

    // Verify bottom sheet is shown with correctly filtered activity chips.
    expect(find.text('Select Athletic Activity'), findsOneWidget);
  });

  testWidgets('FloatingActionButton color should match the active mode theme', (WidgetTester tester) async {
    await tester.pumpWidget(const ProviderScope(child: MyApp()));

    // Helper function to get FAB color.
    Color? getFabColor(WidgetTester tester) {
      final fab = tester.widget<FloatingActionButton>(find.byType(FloatingActionButton));
      return fab.backgroundColor;
    }

    // Default mode is Athletic (Red).
    expect(getFabColor(tester), AppTheme.athleticRed);

    // Switch to Academic mode.
    await tester.tap(find.byTooltip('ACADEMIC'));
    await tester.pumpAndSettle();
    expect(getFabColor(tester), AppTheme.academicBlue);
    
    // Switch to Recovery mode.
    await tester.tap(find.byTooltip('RECOVERY'));
    await tester.pumpAndSettle();
    expect(getFabColor(tester), AppTheme.recoveryGreen);

    // Switch back to Athletic mode.
    await tester.tap(find.byTooltip('ATHLETIC'));
    await tester.pumpAndSettle();
    expect(getFabColor(tester), AppTheme.athleticRed);
  });

  testWidgets('Logging an activity updates the activityProvider', (WidgetTester tester) async {
    final container = ProviderContainer();
    await tester.pumpWidget(UncontrolledProviderScope(
      container: container,
      child: const MyApp(),
    ));

    // Open Bottom Sheet
    await tester.tap(find.byType(FloatingActionButton));
    await tester.pumpAndSettle();

    // Select an activity chip (e.g., 'Practice')
    await tester.tap(find.text('Practice'));
    await tester.pumpAndSettle();

    // Select Start Time - Tap the "Select Time" text inside the first TimeSelector
    await tester.tap(find.text('Select Time').first);
    await tester.pumpAndSettle();
    
    // Tap "OK" on the TimePicker. Use a more robust finder.
    final okFinder = find.text('OK');
    if (okFinder.evaluate().isNotEmpty) {
      await tester.tap(okFinder);
    } else {
      // Fallback: tap the last TextButton if OK is not found by text
      await tester.tap(find.byType(TextButton).last);
    }
    await tester.pumpAndSettle();

    // Select End Time - Tap the "Select Time" text that remains
    await tester.tap(find.text('Select Time'));
    await tester.pumpAndSettle();
    
    if (okFinder.evaluate().isNotEmpty) {
      await tester.tap(okFinder);
    } else {
      await tester.tap(find.byType(TextButton).last);
    }
    await tester.pumpAndSettle();

    // Tap Log Activity
    await tester.tap(find.text('Log Activity'));
    await tester.pumpAndSettle();

    // Verify Bottom Sheet is closed
    expect(find.byType(BottomSheet), findsNothing);

    // Verify the activity is added to the provider
    final activities = container.read(activityProvider);
    expect(activities.length, 1);
    expect(activities[0].title, 'Practice');
  });
}
