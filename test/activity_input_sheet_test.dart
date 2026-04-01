import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:athlete_workload/models/athlete_mode.dart';
import 'package:athlete_workload/providers/athlete_mode_provider.dart';
import 'package:athlete_workload/widgets/activity_input_sheet.dart';
import 'package:athlete_workload/theme.dart';

void main() {
  /// Logic Summary:
  /// This test verifies that the ActivityInputSheet correctly filters 
  /// its selection chips, inherits the correct theme colors, and 
  /// handles date/time interactions as expected.
  group('ActivityInputSheet Widget Tests', () {
    
    testWidgets('Displays Athletic chips and Red theme when in Athletic mode', (tester) async {
      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            athleteModeProvider.overrideWith((ref) => AthleteMode.athletic),
          ],
          child: MaterialApp(
            theme: AppTheme.getThemeForColor(AppTheme.athleticRed),
            home: Scaffold(
              body: ActivityInputSheet(initialDate: DateTime(2026, 3, 18)),
            ),
          ),
        ),
      );

      expect(find.text('Select Athletic Activity'), findsOneWidget);
      expect(find.text('Lift'), findsOneWidget);
      
      // Verify Red Theme
      final titleText = tester.widget<Text>(find.text('Select Athletic Activity'));
      expect(titleText.style?.color, equals(AppTheme.athleticRed));

      final logButton = tester.widget<ElevatedButton>(find.byType(ElevatedButton));
      expect(logButton.style?.backgroundColor?.resolve({}), equals(AppTheme.athleticRed));
    });

    testWidgets('Displays Academic chips and Blue theme when in Academic mode', (tester) async {
      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            athleteModeProvider.overrideWith((ref) => AthleteMode.academic),
          ],
          child: MaterialApp(
            theme: AppTheme.getThemeForColor(AppTheme.academicBlue),
            home: Scaffold(
              body: ActivityInputSheet(initialDate: DateTime(2026, 3, 18)),
            ),
          ),
        ),
      );

      expect(find.text('Select Academic Activity'), findsOneWidget);
      expect(find.text('Class'), findsOneWidget);
      
      // Verify Blue Theme
      final titleText = tester.widget<Text>(find.text('Select Academic Activity'));
      expect(titleText.style?.color, equals(AppTheme.academicBlue));

      final logButton = tester.widget<ElevatedButton>(find.byType(ElevatedButton));
      expect(logButton.style?.backgroundColor?.resolve({}), equals(AppTheme.academicBlue));
    });

    testWidgets('Displays Recovery chips and Green theme when in Recovery mode', (tester) async {
      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            athleteModeProvider.overrideWith((ref) => AthleteMode.recovery),
          ],
          child: MaterialApp(
            theme: AppTheme.getThemeForColor(AppTheme.recoveryGreen),
            home: Scaffold(
              body: ActivityInputSheet(initialDate: DateTime(2026, 3, 18)),
            ),
          ),
        ),
      );

      expect(find.text('Select Recovery Activity'), findsOneWidget);
      expect(find.text('Injury Rehab'), findsOneWidget);
      
      // Verify Green Theme
      final titleText = tester.widget<Text>(find.text('Select Recovery Activity'));
      expect(titleText.style?.color, equals(AppTheme.recoveryGreen));

      final logButton = tester.widget<ElevatedButton>(find.byType(ElevatedButton));
      expect(logButton.style?.backgroundColor?.resolve({}), equals(AppTheme.recoveryGreen));
    });

    testWidgets('Chip selection updates UI and reflects theme', (tester) async {
      await tester.pumpWidget(
        ProviderScope(
          child: MaterialApp(
            theme: AppTheme.getThemeForColor(AppTheme.athleticRed),
            home: Scaffold(
              body: ActivityInputSheet(initialDate: DateTime(2026, 3, 18)),
            ),
          ),
        ),
      );

      final liftChipFinder = find.byWidgetPredicate(
        (widget) => widget is ChoiceChip && widget.label is Text && (widget.label as Text).data == 'Lift'
      );
      
      await tester.tap(liftChipFinder);
      await tester.pump();

      ChoiceChip liftChipWidget = tester.widget(liftChipFinder);
      expect(liftChipWidget.selected, isTrue);
      expect(liftChipWidget.selectedColor, equals(AppTheme.athleticRed));
    });

    testWidgets('Interactive DatePicker updates the displayed date', (tester) async {
      await tester.pumpWidget(
        ProviderScope(
          child: MaterialApp(
            theme: AppTheme.getThemeForColor(AppTheme.athleticRed),
            home: Scaffold(
              body: ActivityInputSheet(initialDate: DateTime(2026, 3, 18)),
            ),
          ),
        ),
      );

      expect(find.text('Date: 3/18/2026'), findsOneWidget);

      // Tap the date to open picker
      await tester.tap(find.text('Date: 3/18/2026'));
      await tester.pumpAndSettle();

      // Select a different date (e.g., 25th)
      await tester.tap(find.text('25'));
      await tester.tap(find.text('OK'));
      await tester.pumpAndSettle();

      expect(find.text('Date: 3/25/2026'), findsOneWidget);
    });

    testWidgets('Validation fails when no activity is selected and shows themed SnackBar', (tester) async {
      await tester.pumpWidget(
        ProviderScope(
          child: MaterialApp(
            theme: AppTheme.getThemeForColor(AppTheme.athleticRed),
            home: Scaffold(
              body: ActivityInputSheet(initialDate: DateTime(2026, 3, 18)),
            ),
          ),
        ),
      );

      await tester.tap(find.text('Log Activity'));
      await tester.pumpAndSettle();

      expect(find.text('Please select an activity and time interval.'), findsOneWidget);
      
      // Verify SnackBar background color matches theme
      final snackBarFinder = find.byType(SnackBar);
      final snackBar = tester.widget<SnackBar>(snackBarFinder);
      expect(snackBar.backgroundColor, equals(AppTheme.athleticRed));
    });

    testWidgets('Returns payload with updated date and times', (tester) async {
      Map<String, dynamic>? result;
      final initialDate = DateTime(2026, 3, 18);

      await tester.pumpWidget(
        ProviderScope(
          child: MaterialApp(
            theme: AppTheme.getThemeForColor(AppTheme.athleticRed),
            home: Scaffold(
              body: Builder(
                builder: (context) {
                  return ElevatedButton(
                    onPressed: () async {
                      result = await showModalBottomSheet<Map<String, dynamic>>(
                        context: context,
                        isScrollControlled: true,
                        builder: (_) => ActivityInputSheet(initialDate: initialDate),
                      );
                    },
                    child: const Text('Open'),
                  );
                },
              ),
            ),
          ),
        ),
      );

      await tester.tap(find.text('Open'));
      await tester.pumpAndSettle();

      // Select Activity
      await tester.tap(find.text('Lift'));
      await tester.pump();

      // Change Date
      await tester.tap(find.text('Date: 3/18/2026'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('25'));
      await tester.tap(find.text('OK'));
      await tester.pumpAndSettle();

      // Select Start Time
      await tester.tap(find.text('Select Time').first);
      await tester.pumpAndSettle();
      await tester.tap(find.text('OK'));
      await tester.pumpAndSettle();

      // Select End Time
      await tester.tap(find.text('Select Time'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('OK'));
      await tester.pumpAndSettle();

      // Submit
      await tester.tap(find.text('Log Activity'));
      await tester.pumpAndSettle();

      expect(result, isNotNull);
      expect(result!['activity'], equals('Lift'));
      expect(result!['date'], equals(DateTime(2026, 3, 25)));
      expect(result!['startTime'], isA<TimeOfDay>());
      expect(result!['endTime'], isA<TimeOfDay>());
    });
  });
}