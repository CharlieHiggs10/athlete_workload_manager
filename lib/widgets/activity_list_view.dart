import 'package:flutter/material.dart';
import '../models/athlete_mode.dart';
import '../models/activity_model.dart';
import '../widgets/activity_card.dart';

/// Logic Summary:
/// A specialized ListView that renders a pre-filtered list of activities,
/// handling the empty state visualization based on the active mode.
class ActivityListView extends StatelessWidget {
  final List<ActivityModel> activities;
  final AthleteMode currentMode;

  const ActivityListView({
    super.key,
    required this.activities,
    required this.currentMode,
  });

  @override
  Widget build(BuildContext context) {
    final themeData = Theme.of(context);

    if (activities.isEmpty) {
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
      itemCount: activities.length,
      itemBuilder: (context, index) {
        return ActivityCard(activity: activities[index]);
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
