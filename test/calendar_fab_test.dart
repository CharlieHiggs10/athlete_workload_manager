import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:athlete_workload/main.dart';
import 'package:athlete_workload/theme.dart';

void main() {
  testWidgets('FloatingActionButton should trigger a placeholder ModalBottomSheet', (WidgetTester tester) async {
    await tester.pumpWidget(const ProviderScope(child: MyApp()));

    // Find the FAB. (FLOATING ACTION BUTTON)
    final fabFinder = find.byType(FloatingActionButton);
    expect(fabFinder, findsOneWidget);

    // Tap the FAB to open the bottom sheet.
    await tester.tap(fabFinder);
    await tester.pumpAndSettle();

    // Verify bottom sheet is shown with placeholder text.
    expect(find.text('Add Activity Placeholder'), findsOneWidget);
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
}
