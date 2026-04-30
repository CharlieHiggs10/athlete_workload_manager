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
/// the UI receives a simple List<ActivityModel> while masking AsyncValue complexity.
class ActivityNotifier extends Notifier<List<ActivityModel>> {
  @override
  List<ActivityModel> build() {
    // Watch the stream provider and return the latest data or an empty list.
    // This maintains compatibility with UI components expecting a List.
    return ref.watch(activitiesStreamProvider).valueOrNull ?? [];
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
}

/// Logic Summary:
/// Global provider for accessing and modifying the list of logged activities.
final activityProvider = NotifierProvider<ActivityNotifier, List<ActivityModel>>(
  ActivityNotifier.new,
);
