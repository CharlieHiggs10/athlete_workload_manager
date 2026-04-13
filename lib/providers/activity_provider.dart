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

  /// Logic Summary:
  /// Updates an existing activity by mapping over the current list and replacing 
  /// the model with a matching ID, ensuring a new list is assigned to state.
  void updateActivity(ActivityModel updatedActivity) {
    state = [
      for (final activity in state)
        if (activity.id == updatedActivity.id) updatedActivity else activity
    ];
  }

  /// Logic Summary:
  /// Deletes an activity by filtering out the ID, ensuring a brand new list is assigned 
  /// to state to maintain Riverpod immutability.
  void deleteActivity(String id) {
    state = state.where((activity) => activity.id != id).toList();
  }
}

/// Logic Summary:
/// Global provider for accessing the list of logged activities.
final activityProvider = NotifierProvider<ActivityNotifier, List<ActivityModel>>(
  ActivityNotifier.new,
);
