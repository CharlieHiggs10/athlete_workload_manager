import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/athlete_mode.dart';
import '../models/activity_model.dart';
import '../providers/activity_provider.dart';
import '../widgets/activity_card.dart';

/// Logic Summary:
/// A specialized ListView that watches the activityProvider,
/// filters activities based on the current mode and date,
/// and sorts them chronologically for display.
class ActivityListView extends ConsumerWidget {
  final AthleteMode currentMode;
  final DateTime selectedDate;

  const ActivityListView({
    super.key,
    required this.currentMode,
    required this.selectedDate,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final activities = ref.watch(activityProvider);
    final themeData = Theme.of(context);

    // Filter and sort activities
    final filteredActivities = activities.where((activity) {
      // Filter by date
      final isSameDay = DateUtils.isSameDay(activity.date, selectedDate);
      if (!isSameDay) return false;

      // Filter by mode if not in overview
      if (currentMode == AthleteMode.overview) return true;
      return activity.category == currentMode;
    }).toList();

    // Sort chronologically by start time
    filteredActivities.sort((a, b) {
      final aMinutes = a.startTime.hour * 60 + a.startTime.minute;
      final bMinutes = b.startTime.hour * 60 + b.startTime.minute;
      return aMinutes.compareTo(bMinutes);
    });

    if (filteredActivities.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              _getHeroIconForMode(currentMode),
              size: 100,
              color: themeData.primaryColor.withAlpha(100),
            ),
            const SizedBox(height: 20),
            Text(
              'No ${currentMode == AthleteMode.overview ? "" : _getTitleForMode(currentMode)} activities for today.',
              style: themeData.textTheme.titleLarge?.copyWith(
                    color: themeData.primaryColor,
                  ),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.symmetric(vertical: 8),
      itemCount: filteredActivities.length,
      itemBuilder: (context, index) {
        return ActivityCard(activity: filteredActivities[index]);
      },
    );
  }

  /// Provides central icons representing the current mode for the empty state.
  IconData _getHeroIconForMode(AthleteMode mode) {
    switch (mode) {
      case AthleteMode.athletic:
        return Icons.fitness_center;
      case AthleteMode.academic:
        return Icons.school;
      case AthleteMode.recovery:
        return Icons.self_improvement;
      case AthleteMode.overview:
        return Icons.view_agenda;
    }
  }

  /// Provides descriptive titles for the empty state message.
  String _getTitleForMode(AthleteMode mode) {
    switch (mode) {
      case AthleteMode.athletic:
        return 'Athletic';
      case AthleteMode.academic:
        return 'Academic';
      case AthleteMode.recovery:
        return 'Recovery';
      case AthleteMode.overview:
        return 'Overview';
    }
  }
}
