import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fake_cloud_firestore/fake_cloud_firestore.dart';
import 'package:athlete_workload/main.dart';
import 'package:athlete_workload/models/athlete_mode.dart';
import 'package:athlete_workload/providers/auth_provider.dart';
import 'package:athlete_workload/providers/firestore_provider.dart';
import 'package:athlete_workload/models/user_profile.dart';

void main() {
  const testUser = UserProfile(uid: 'test_user', email: 'test@example.com');

  testWidgets('CalendarScreen switches modes correctly', (WidgetTester tester) async {
    final fakeFirestore = FakeFirebaseFirestore();

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          authStateProvider.overrideWith((ref) => Stream.value(testUser)),
          firestoreInstanceProvider.overrideWith((ref) => fakeFirestore),
        ],
        child: const MyApp(),
      ),
    );

    await tester.pumpAndSettle();

    expect(find.text('Athletic'), findsOneWidget);
    expect(find.text('No Athletic activities scheduled.'), findsOneWidget);
    
    expect(find.byIcon(Icons.fitness_center), findsAtLeastNWidgets(2));

    await tester.tap(find.byTooltip('ACADEMIC'));
    await tester.pumpAndSettle();

    expect(find.text('Academic'), findsOneWidget);
    expect(find.text('No Academic activities scheduled.'), findsOneWidget);
    expect(find.byIcon(Icons.school), findsAtLeastNWidgets(2));

    await tester.tap(find.byTooltip('RECOVERY'));
    await tester.pumpAndSettle();

    expect(find.text('Recovery'), findsOneWidget);
    expect(find.text('No Recovery activities scheduled.'), findsOneWidget);
    expect(find.byIcon(Icons.self_improvement), findsAtLeastNWidgets(2));
  });
}
