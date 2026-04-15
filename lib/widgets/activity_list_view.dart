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
              'No ${currentMode == AthleteMode.overview ? "" : _getTitleForMode(currentMode)} activities ${currentMode == AthleteMode.overview ? "for today" : "scheduled"}.',
              style: themeData.textTheme.titleLarge?.copyWith(
                    color: themeData.primaryColor,
                  ),
            ),
          ],
        ),
      );
    }

    final List<Widget> listItems = [];
    DateTime? lastDate;

    for (final activity in activities) {
      if (lastDate == null || !DateUtils.isSameDay(lastDate, activity.date)) {
        listItems.add(_buildDateHeader(context, activity.date));
        lastDate = activity.date;
      }
      listItems.add(ActivityCard(activity: activity));
    }

    return ListView(
      padding: const EdgeInsets.symmetric(vertical: 8),
      children: listItems,
    );
  }

  /// Builds a visual header with the date string (e.g., "Today", "Tomorrow", "Oct 25").
  Widget _buildDateHeader(BuildContext context, DateTime date) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final tomorrow = today.add(const Duration(days: 1));

    String label;
    if (DateUtils.isSameDay(date, today)) {
      label = 'Today';
    } else if (DateUtils.isSameDay(date, tomorrow)) {
      label = 'Tomorrow';
    } else {
      label = '${_getMonthName(date.month)} ${date.day}';
    }

    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
      child: Text(
        label,
        style: Theme.of(context).textTheme.titleSmall?.copyWith(
              color: Theme.of(context).primaryColor,
              fontWeight: FontWeight.bold,
              letterSpacing: 1.2,
            ),
      ),
    );
  }

  /// Simple manual month name mapper.
  String _getMonthName(int month) {
    const months = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec'
    ];
    return months[month - 1];
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
