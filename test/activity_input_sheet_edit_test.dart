import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:athlete_workload/models/athlete_mode.dart';
import 'package:athlete_workload/models/activity_model.dart';
import 'package:athlete_workload/providers/athlete_mode_provider.dart';
import 'package:athlete_workload/widgets/activity_input_sheet.dart';
import 'package:athlete_workload/theme.dart';

void main() {
  group('ActivityInputSheet Edit Mode Tests', () {
    final existingActivity = ActivityModel(
      id: 'test-id',
      title: 'Practice',
      date: DateTime(2026, 5, 10),
      startTime: const TimeOfDay(hour: 10, minute: 0),
      endTime: const TimeOfDay(hour: 12, minute: 0),
      category: AthleteMode.athletic,
    );

    testWidgets('Pre-fills form when existingActivity is provided', (tester) async {
      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            athleteModeProvider.overrideWith((ref) => AthleteMode.athletic),
          ],
          child: MaterialApp(
            theme: AppTheme.getThemeForColor(AppTheme.athleticRed),
            home: Scaffold(
              body: ActivityInputSheet(
                initialDate: DateTime(2026, 4, 1),
                existingActivity: existingActivity,
              ),
            ),
          ),
        ),
      );

      // Verify Title matches category
      expect(find.text('Select Athletic Activity'), findsOneWidget);

      // Verify Pre-filled Date
      expect(find.text('5/10/2026'), findsOneWidget);

      // Verify Pre-selected Chip
      final practiceChipFinder = find.byWidgetPredicate(
        (widget) => widget is ChoiceChip && widget.label is Text && (widget.label as Text).data == 'Practice'
      );
      ChoiceChip practiceChip = tester.widget(practiceChipFinder);
      expect(practiceChip.selected, isTrue);

      // Verify Pre-filled Times
      expect(find.text('10:00 AM'), findsOneWidget);
      expect(find.text('12:00 PM'), findsOneWidget);

      // Verify Button Text
      expect(find.text('Update Activity'), findsOneWidget);
    });

    testWidgets('Returns updated payload when in edit mode', (tester) async {
      Map<String, dynamic>? result;

      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            athleteModeProvider.overrideWith((ref) => AthleteMode.athletic),
          ],
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
                        builder: (_) => ActivityInputSheet(
                          initialDate: DateTime(2026, 4, 1),
                          existingActivity: existingActivity,
                        ),
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

      // Change Activity to 'Game'
      await tester.tap(find.text('Game'));
      await tester.pump();

      // Submit
      await tester.tap(find.text('Update Activity'));
      await tester.pumpAndSettle();

      expect(result, isNotNull);
      expect(result!['activity'], equals('Game'));
      expect(result!['date'], equals(DateTime(2026, 5, 10)));
      expect(result!['startTime'], equals(const TimeOfDay(hour: 10, minute: 0)));
      expect(result!['endTime'], equals(const TimeOfDay(hour: 12, minute: 0)));
    });
  });
}
