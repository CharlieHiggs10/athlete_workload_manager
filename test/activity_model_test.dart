import 'package:athlete_workload/models/activity_model.dart';
import 'package:athlete_workload/models/athlete_mode.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('ActivityModel', () {
    final testDate = DateTime(2026, 4, 1);
    const testStartTime = TimeOfDay(hour: 10, minute: 0);
    const testEndTime = TimeOfDay(hour: 11, minute: 0);

    test('should create ActivityModel with correct properties', () {
      final activity = ActivityModel(
        id: '1',
        title: 'Lift',
        date: testDate,
        startTime: testStartTime,
        endTime: testEndTime,
        category: AthleteMode.athletic,
        weight: 2,
      );

      expect(activity.id, '1');
      expect(activity.title, 'Lift');
      expect(activity.date, testDate);
      expect(activity.startTime, testStartTime);
      expect(activity.endTime, testEndTime);
      expect(activity.category, AthleteMode.athletic);
      expect(activity.weight, 2);
    });

    test('should have default weight of 0', () {
      final activity = ActivityModel(
        id: '1',
        title: 'Lift',
        date: testDate,
        startTime: testStartTime,
        endTime: testEndTime,
        category: AthleteMode.athletic,
      );

      expect(activity.weight, 0);
    });

    test('copyWith should return a new instance with updated values', () {
      final activity = ActivityModel(
        id: '1',
        title: 'Lift',
        date: testDate,
        startTime: testStartTime,
        endTime: testEndTime,
        category: AthleteMode.athletic,
        weight: 1,
      );

      final updatedActivity = activity.copyWith(title: 'Updated Lift', weight: 3);

      expect(updatedActivity.title, 'Updated Lift');
      expect(updatedActivity.weight, 3);
      expect(updatedActivity.id, activity.id); // Should stay the same
      expect(updatedActivity.date, activity.date); // Should stay the same
      expect(updatedActivity.startTime, activity.startTime);
      expect(updatedActivity.endTime, activity.endTime);
      expect(updatedActivity.category, activity.category);
    });

    test('equality test', () {
      final activity1 = ActivityModel(
        id: '1',
        title: 'Lift',
        date: testDate,
        startTime: testStartTime,
        endTime: testEndTime,
        category: AthleteMode.athletic,
      );

      final activity2 = ActivityModel(
        id: '1',
        title: 'Lift',
        date: testDate,
        startTime: testStartTime,
        endTime: testEndTime,
        category: AthleteMode.athletic,
      );

      expect(activity1, activity2);
    });

    test('toMap and fromMap should handle weight correctly', () {
      final activity = ActivityModel(
        id: '1',
        title: 'Lift',
        date: testDate,
        startTime: testStartTime,
        endTime: testEndTime,
        category: AthleteMode.athletic,
        weight: 3,
      );

      final map = activity.toMap();
      expect(map['weight'], 3);

      final fromMap = ActivityModel.fromMap(map);
      expect(fromMap.weight, 3);
      expect(fromMap.id, '1');
    });

    test('fromMap should default weight to 0 if missing', () {
      final map = {
        'id': '1',
        'title': 'Lift',
        'date': Timestamp.fromDate(testDate),
        'startTime': {'hour': 10, 'minute': 0},
        'endTime': {'hour': 11, 'minute': 0},
        'category': 'athletic',
      };

      final activity = ActivityModel.fromMap(map);
      expect(activity.weight, 0);
    });
  });
}
