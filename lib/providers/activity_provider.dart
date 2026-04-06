import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/activity_model.dart';

/// Logic Summary:
/// Manages the local collection of logged activities for the athlete.
/// This provider serves as the app's short-term memory before persisting to Firestore.
/// It provides an immutable list of [ActivityModel] and methods to update that list.
class ActivityNotifier extends Notifier<List<ActivityModel>> {
  @override
  List<ActivityModel> build() {
    // Initialize with an empty list.
    return [];
  }

  /// Logic Summary:
  /// Adds a new activity to the state by creating a new list with the appended activity.
  /// This ensures immutability, which triggers Riverpod listeners to update the UI.
  void addActivity(ActivityModel activity) {
    state = [...state, activity];
  }
}

/// Logic Summary:
/// Global provider for accessing the list of logged activities.
final activityProvider = NotifierProvider<ActivityNotifier, List<ActivityModel>>(
  ActivityNotifier.new,
);
