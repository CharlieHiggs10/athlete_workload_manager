import 'package:flutter/material.dart';
import 'athlete_mode.dart';

/// Logic Summary:
/// An immutable data class that represents a single logged event in the athlete's schedule.
/// It contains specific timing, categorization, and identification for each activity.
@immutable
class ActivityModel {
  final String id;
  final String title;
  final DateTime date;
  final TimeOfDay startTime;
  final TimeOfDay endTime;
  final AthleteMode category;

  const ActivityModel({
    required this.id,
    required this.title,
    required this.date,
    required this.startTime,
    required this.endTime,
    required this.category,
  });

  /// Logic Summary:
  /// Creates a copy of this ActivityModel with the given fields replaced by the new values.
  ActivityModel copyWith({
    String? id,
    String? title,
    DateTime? date,
    TimeOfDay? startTime,
    TimeOfDay? endTime,
    AthleteMode? category,
  }) {
    return ActivityModel(
      id: id ?? this.id,
      title: title ?? this.title,
      date: date ?? this.date,
      startTime: startTime ?? this.startTime,
      endTime: endTime ?? this.endTime,
      category: category ?? this.category,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ActivityModel &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          title == other.title &&
          date == other.date &&
          startTime == other.startTime &&
          endTime == other.endTime &&
          category == other.category;

  @override
  int get hashCode =>
      id.hashCode ^
      title.hashCode ^
      date.hashCode ^
      startTime.hashCode ^
      endTime.hashCode ^
      category.hashCode;
}
