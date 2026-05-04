import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/activity_model.dart';
import 'auth_provider.dart';
import 'firestore_provider.dart';

/// Logic Summary:
/// Reactive stream of activities fetched from Firestore for the currently authenticated user.
/// It automatically updates whenever the data in Firestore changes.
final activitiesStreamProvider = StreamProvider<List<ActivityModel>>((ref) {
  final user = ref.watch(authStateProvider).valueOrNull;
  if (user == null) return Stream.value([]);
  
  return ref.watch(firestoreServiceProvider).activitiesStream(user.uid);
});

/// Logic Summary:
/// Manages the collection of logged activities by syncing with Firestore.
/// It acts as a bridge between the Firestore stream and the UI, ensuring
/// the UI receives an AsyncValue<List<ActivityModel>> to handle loading and error states.
class ActivityNotifier extends AsyncNotifier<List<ActivityModel>> {
  @override
  FutureOr<List<ActivityModel>> build() {
    // Watch the stream provider and return the latest future.
    return ref.watch(activitiesStreamProvider.future);
  }

  /// Logic Summary:
  /// Adds a new activity to Firestore. The UI will update automatically 
  /// when the Firestore stream emits the new collection.
  Future<void> addActivity(ActivityModel activity) async {
    final user = ref.read(authStateProvider).valueOrNull;
    if (user != null) {
      await ref.read(firestoreServiceProvider).addActivity(user.uid, activity);
    }
  }

  /// Logic Summary:
  /// Updates an existing activity in Firestore.
  Future<void> updateActivity(ActivityModel activity) async {
    final user = ref.read(authStateProvider).valueOrNull;
    if (user != null) {
      await ref.read(firestoreServiceProvider).updateActivity(user.uid, activity);
    }
  }

  /// Logic Summary:
  /// Deletes an activity from Firestore based on its unique ID.
  Future<void> deleteActivity(String id) async {
    final user = ref.read(authStateProvider).valueOrNull;
    if (user != null) {
      await ref.read(firestoreServiceProvider).deleteActivity(user.uid, id);
    }
  }

  /// Logic Summary:
  /// Maps an activity name to its corresponding workload weight.
  /// Used for calculating stress and recovery analytics.
  int getActivityWeight(String activityName) {
    const weights = {
      'Game': 4,
      'Practice': 3,
      'Study': 3,
      'Class': 3,
      'Lift': 2,
      'Travel': 2,
      'Lab': 2,
      'Film': 1,
      'Office Hours': 1,
      'Stretching': -1,
      'Injury Rehab': -2,
      'Hydration': -2,
      'Ice Bath': -2,
      'Nap': -3,
    };
    return weights[activityName] ?? 0;
  }
}

/// Logic Summary:
/// Global provider for accessing and modifying the list of logged activities.
final activityProvider = AsyncNotifierProvider<ActivityNotifier, List<ActivityModel>>(
  ActivityNotifier.new,
);
