import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:athlete_workload/models/athlete_mode.dart';
import 'package:athlete_workload/providers/athlete_mode_provider.dart';
import 'package:athlete_workload/widgets/activity_input_sheet.dart';

void main() {
  /// Logic Summary:
  /// This test verifies that the ActivityInputSheet correctly filters 
  /// its selection chips based on the active Riverpod state, and that 
  /// the user can successfully select a chip.
  group('ActivityInputSheet Widget Tests', () {
    
    testWidgets('Displays Athletic chips when in Athletic mode', (tester) async {
      // tester.pumpWidget builds the UI in a virtual testing environment.
      await tester.pumpWidget(
        // We wrap the widget in a ProviderScope to give it access to Riverpod.
        ProviderScope(
          // overrides: 
          //We force the athleteModeProvider to be 'athletic' without having to click 
          // any buttons in the app first.
          overrides: [
            athleteModeProvider.overrideWith((ref) => AthleteMode.athletic),
          ],
          child: const MaterialApp(
            home: Scaffold(
              body: ActivityInputSheet(),
            ),
          ),
        ),
      );

      // expect() acts as our assertion. We look for the exact text strings 
      // you defined in your requirements to ensure they rendered on screen.
      expect(find.text('Select Athletic Activity'), findsOneWidget);
      expect(find.text('Lift'), findsOneWidget);
      expect(find.text('Practice'), findsOneWidget);
      expect(find.text('Game'), findsOneWidget);
      expect(find.text('Film'), findsOneWidget);
      expect(find.text('Travel'), findsOneWidget);
      
      // Negative Test: We explicitly check that an academic option does NOT 
      // appear. This proves our "Context-Aware" logic is actually working.
      expect(find.text('Class'), findsNothing);
    });

    testWidgets('Displays Academic chips when in Academic mode', (tester) async {
      await tester.pumpWidget(
        ProviderScope(
          // Here we override the state to 'academic' to test the next view.
          overrides: [
            athleteModeProvider.overrideWith((ref) => AthleteMode.academic),
          ],
          child: const MaterialApp(
            home: Scaffold(
              body: ActivityInputSheet(),
            ),
          ),
        ),
      );

      expect(find.text('Select Academic Activity'), findsOneWidget);
      expect(find.text('Class'), findsOneWidget);
      expect(find.text('Lab'), findsOneWidget);
      expect(find.text('Study'), findsOneWidget);
      expect(find.text('Exam'), findsOneWidget);
      expect(find.text('Office Hours'), findsOneWidget);
      
      // Proving athletic chips don't bleed into the academic view.
      expect(find.text('Lift'), findsNothing);
    });

    testWidgets('Displays Recovery chips when in Recovery mode', (tester) async {
      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            athleteModeProvider.overrideWith((ref) => AthleteMode.recovery),
          ],
          child: const MaterialApp(
            home: Scaffold(
              body: ActivityInputSheet(),
            ),
          ),
        ),
      );

      expect(find.text('Select Recovery Activity'), findsOneWidget);
      expect(find.text('Injury Rehab'), findsOneWidget);
      expect(find.text('Ice Bath'), findsOneWidget);
      expect(find.text('Stretching'), findsOneWidget);
      expect(find.text('Hydration'), findsOneWidget);
      expect(find.text('Nap'), findsOneWidget);
      
      expect(find.text('Class'), findsNothing);
    });

    testWidgets('Chip selection updates UI', (tester) async {
      await tester.pumpWidget(
        const ProviderScope(
          child: MaterialApp(
            home: Scaffold(
              body: ActivityInputSheet(),
            ),
          ),
        ),
      );

      // Instead of just looking for the word 'Lift' anywhere on the screen,
      // tell the test to find a widget that meets three strict rules:
      // 1. It must be a ChoiceChip widget.
      // 2. Its label must be a Text widget.
      // 3. That text must say exactly 'Lift'.
      final liftChip = find.byWidgetPredicate(
        (widget) => widget is ChoiceChip && widget.label is Text && (widget.label as Text).data == 'Lift'
      );
      
      expect(liftChip, findsOneWidget);
      
      // We grab the actual widget from the tester to check its properties.
      // Initial state should be unselected (isFalse).
      ChoiceChip liftChipWidget = tester.widget(liftChip);
      expect(liftChipWidget.selected, isFalse);

      // tester.tap simulates the user physically touching the screen.
      await tester.tap(liftChip);
      // tester.pump forces Flutter to redraw the screen after the tap. 
      // If we don't pump, the UI won't update in the test environment.
      await tester.pump();

      // We grab the widget again after the redraw to verify the state 
      // successfully flipped to true.
      liftChipWidget = tester.widget(liftChip);
      expect(liftChipWidget.selected, isTrue);
    });
  });
}
