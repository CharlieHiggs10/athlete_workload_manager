import 'package:flutter_test/flutter_test.dart';
import 'package:athlete_workload/models/user_profile.dart';

void main() {
  group('UserProfile Model Tests', () {
    const testUid = 'user123';
    const testDisplayName = 'John Doe';
    const testEmail = 'john@example.com';
    const testSport = 'Football';
    const testPosition = 'Quarterback';

    test('should correctly initialize with all fields', () {
      const user = UserProfile(
        uid: testUid,
        displayName: testDisplayName,
        email: testEmail,
        sport: testSport,
        position: testPosition,
      );

      expect(user.uid, testUid);
      expect(user.displayName, testDisplayName);
      expect(user.email, testEmail);
      expect(user.sport, testSport);
      expect(user.position, testPosition);
    });

    test('toMap should return a valid Map', () {
      const user = UserProfile(
        uid: testUid,
        displayName: testDisplayName,
        email: testEmail,
        sport: testSport,
        position: testPosition,
      );

      final map = user.toMap();

      expect(map['uid'], testUid);
      expect(map['displayName'], testDisplayName);
      expect(map['email'], testEmail);
      expect(map['sport'], testSport);
      expect(map['position'], testPosition);
    });

    test('fromMap should return a valid UserProfile instance', () {
      final map = {
        'uid': testUid,
        'displayName': testDisplayName,
        'email': testEmail,
        'sport': testSport,
        'position': testPosition,
      };

      final user = UserProfile.fromMap(map);

      expect(user.uid, testUid);
      expect(user.displayName, testDisplayName);
      expect(user.email, testEmail);
      expect(user.sport, testSport);
      expect(user.position, testPosition);
    });

    test('copyWith should return a new instance with updated fields', () {
      const user = UserProfile(
        uid: testUid,
        displayName: testDisplayName,
      );

      final updatedUser = user.copyWith(sport: 'Basketball');

      expect(updatedUser.uid, testUid);
      expect(updatedUser.displayName, testDisplayName);
      expect(updatedUser.sport, 'Basketball');
      expect(updatedUser.email, isNull);
    });

    test('equality and hashCode should work correctly', () {
      const user1 = UserProfile(uid: testUid, displayName: testDisplayName);
      const user2 = UserProfile(uid: testUid, displayName: testDisplayName);
      const user3 = UserProfile(uid: 'other', displayName: testDisplayName);

      expect(user1, equals(user2));
      expect(user1.hashCode, equals(user2.hashCode));
      expect(user1, isNot(equals(user3)));
    });
  });
}
