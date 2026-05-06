import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/athlete_mode.dart';
import '../models/activity_model.dart';
import '../providers/athlete_mode_provider.dart';
import '../providers/activity_provider.dart';
import '../providers/auth_provider.dart';
import '../widgets/activity_input_sheet.dart';
import '../widgets/activity_list_view.dart';
import '../widgets/burnout_alert_card.dart';
import '../widgets/mode_toggle_icon.dart';
import '../theme.dart';

/// Logic Summary:
/// Primary scheduling screen for student-athletes.
/// Dynamically updates its visual style and icons based on
/// the active mode (Athletic, Academic, Recovery, Overview).
/// It generates a filtered and sorted list of activities for display.
class CalendarScreen extends ConsumerWidget {
  const CalendarScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentMode = ref.watch(athleteModeProvider);
    final activitiesAsync = ref.watch(activityProvider);
    final themeData = AppTheme.getThemeForMode(currentMode);

    return Theme(
      data: themeData,
      child: Scaffold(
        appBar: AppBar(
          leading: IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () => ref.read(authServiceProvider).signOut(),
            tooltip: 'Sign Out',
          ),
          title: Text(currentMode.displayName),
          actions: [
            ModeToggleIcon(
              mode: AthleteMode.overview,
              icon: Icons.home,
              isActive: currentMode == AthleteMode.overview,
              onPressed: () => _setMode(ref, AthleteMode.overview),
            ),
            ModeToggleIcon(
              mode: AthleteMode.athletic,
              icon: Icons.fitness_center,
              isActive: currentMode == AthleteMode.athletic,
              onPressed: () => _setMode(ref, AthleteMode.athletic),
            ),
            ModeToggleIcon(
              mode: AthleteMode.academic,
              icon: Icons.school,
              isActive: currentMode == AthleteMode.academic,
              onPressed: () => _setMode(ref, AthleteMode.academic),
            ),
            ModeToggleIcon(
              mode: AthleteMode.recovery,
              icon: Icons.self_improvement,
              isActive: currentMode == AthleteMode.recovery,
              onPressed: () => _setMode(ref, AthleteMode.recovery),
            ),
          ],
        ),
        body: activitiesAsync.when(
          data: (activities) {
            final now = DateTime.now();
            final today = DateTime(now.year, now.month, now.day);
            
            final filteredActivities = activities.where((activity) {
              final isSameDay = DateUtils.isSameDay(activity.date, today);
              final isFuture = activity.date.isAfter(today);

              if (currentMode == AthleteMode.overview) {
                return isSameDay;
              }
              return activity.category == currentMode && (isSameDay || isFuture);
            }).toList();

            filteredActivities.sort((a, b) {
              final dateComparison = a.date.compareTo(b.date);
              if (dateComparison != 0) return dateComparison;
              final aMinutes = a.startTime.hour * 60 + a.startTime.minute;
              final bMinutes = b.startTime.hour * 60 + b.startTime.minute;
              return aMinutes.compareTo(bMinutes);
            });

            return Column(
              children: [
                const BurnoutAlertCard(),
                Expanded(
                  child: ActivityListView(
                    activities: filteredActivities,
                    currentMode: currentMode,
                  ),
                ),
              ],
            );
          },
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (err, stack) => Center(
            child: Text(
              'Failed to load activities. Please try again.',
              style: TextStyle(color: themeData.colorScheme.error),
            ),
          ),
        ),
        floatingActionButton: currentMode == AthleteMode.overview
            ? null
            : FloatingActionButton(
                onPressed: () => _showActivityBottomSheet(context, ref, currentMode),
                tooltip: 'Add Activity',
                backgroundColor: themeData.primaryColor,
                foregroundColor: Colors.white,
                child: const Icon(Icons.add),
              ),
      ),
    );
  }

  /// Displays the ActivityInputSheet within a Modal Bottom Sheet.
  Future<void> _showActivityBottomSheet(BuildContext context, WidgetRef ref, AthleteMode mode) async {
    // If in overview, default to athletic for new activities.
    final logMode = mode == AthleteMode.overview ? AthleteMode.athletic : mode;

    final result = await showModalBottomSheet<Map<String, dynamic>>(
      context: context,
      isScrollControlled: true,
      builder: (context) {
        return Theme(
          data: AppTheme.getThemeForMode(logMode),
          child: ActivityInputSheet(
            initialDate: DateTime.now(),
          ),
        );
      },
    );

    if (result != null) {
      final activity = ActivityModel(
        id: DateTime.now().toString(),
        title: result['activity'] as String,
        date: result['date'] as DateTime,
        startTime: result['startTime'] as TimeOfDay,
        endTime: result['endTime'] as TimeOfDay,
        category: result['mode'] as AthleteMode,
      );

      ref.read(activityProvider.notifier).addActivity(activity);
    }
  }

  /// Updates the global state with the selected athlete mode.
  void _setMode(WidgetRef ref, AthleteMode mode) {
    ref.read(athleteModeProvider.notifier).state = mode;
  }
}
