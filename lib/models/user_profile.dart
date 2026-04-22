import 'package:flutter/foundation.dart';

/// Logic Summary:
/// UserProfile is an immutable data model representing a student-athlete's 
/// metadata, including their unique identifier and athletic details. 
/// It provides serialization methods for Firestore integration.
@immutable
class UserProfile {
  final String uid;
  final String? displayName;
  final String? email;
  final String? sport;
  final String? position;

  const UserProfile({
    required this.uid,
    this.displayName,
    this.email,
    this.sport,
    this.position,
  });

  /// Logic Summary:
  /// Converts the UserProfile instance into a Map for Firestore storage.
  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'displayName': displayName,
      'email': email,
      'sport': sport,
      'position': position,
    };
  }

  /// Logic Summary:
  /// Creates a UserProfile instance from a Map retrieved from Firestore.
  factory UserProfile.fromMap(Map<String, dynamic> map) {
    return UserProfile(
      uid: map['uid'] as String,
      displayName: map['displayName'] as String?,
      email: map['email'] as String?,
      sport: map['sport'] as String?,
      position: map['position'] as String?,
    );
  }

  /// Logic Summary:
  /// Creates a copy of this UserProfile with the given fields replaced by the new values.
  UserProfile copyWith({
    String? uid,
    String? displayName,
    String? email,
    String? sport,
    String? position,
  }) {
    return UserProfile(
      uid: uid ?? this.uid,
      displayName: displayName ?? this.displayName,
      email: email ?? this.email,
      sport: sport ?? this.sport,
      position: position ?? this.position,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is UserProfile &&
          runtimeType == other.runtimeType &&
          uid == other.uid &&
          displayName == other.displayName &&
          email == other.email &&
          sport == other.sport &&
          position == other.position;

  @override
  int get hashCode =>
      uid.hashCode ^
      displayName.hashCode ^
      email.hashCode ^
      sport.hashCode ^
      position.hashCode;
}
