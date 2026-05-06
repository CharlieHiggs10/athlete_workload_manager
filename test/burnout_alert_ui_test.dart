import 'package:athlete_workload/providers/activity_provider.dart';
import 'package:athlete_workload/widgets/burnout_alert_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('BurnoutAlertCard shows Optimal status when workload <= 25', (tester) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          workloadProvider.overrideWithValue(25),
        ],
        child: const MaterialApp(
          home: Scaffold(
            body: BurnoutAlertCard(),
          ),
        ),
      ),
    );

    expect(find.text('Status: Optimal'), findsOneWidget);
    expect(find.text('Burnout Alert'), findsNothing);
  });

  testWidgets('BurnoutAlertCard shows Burnout Alert when workload > 25', (tester) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          workloadProvider.overrideWithValue(26),
        ],
        child: const MaterialApp(
          home: Scaffold(
            body: BurnoutAlertCard(),
          ),
        ),
      ),
    );

    expect(find.text('Burnout Alert'), findsOneWidget);
    expect(find.textContaining('High workload detected'), findsOneWidget);
    expect(find.text('Status: Optimal'), findsNothing);
  });

  testWidgets('BurnoutAlertCard does not display the numerical score', (tester) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          workloadProvider.overrideWithValue(30),
        ],
        child: const MaterialApp(
          home: Scaffold(
            body: BurnoutAlertCard(),
          ),
        ),
      ),
    );

    expect(find.textContaining('30'), findsNothing);
  });
}
