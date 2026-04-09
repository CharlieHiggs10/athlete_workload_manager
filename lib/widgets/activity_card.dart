import 'package:flutter/material.dart';
import '../models/activity_model.dart';
import '../models/athlete_mode.dart';
import '../theme.dart';

/// Logic Summary:
/// A reusable, stateless widget that displays the details of an ActivityModel.
/// It dynamically adjusts its border color and icon based on the activity's category.
class ActivityCard extends StatelessWidget {
  final ActivityModel activity;

  const ActivityCard({
    super.key,
    required this.activity,
  });

  @override
  Widget build(BuildContext context) {
    final Color categoryColor = _getCategoryColor(activity.category);
    final IconData categoryIcon = _getCategoryIcon(activity.category);

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: categoryColor, width: 2),
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        leading: CircleAvatar(
          backgroundColor: categoryColor.withAlpha(40),
          child: Icon(categoryIcon, color: categoryColor),
        ),
        title: Text(
          activity.title,
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
        ),
        subtitle: Padding(
          padding: const EdgeInsets.only(top: 4),
          child: Row(
            children: [
              const Icon(Icons.access_time, size: 16, color: Colors.grey),
              const SizedBox(width: 4),
              Text(
                '${activity.startTime.format(context)} - ${activity.endTime.format(context)}',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: Colors.grey[700],
                    ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// Maps the AthleteMode to its corresponding color from AppTheme.
  Color _getCategoryColor(AthleteMode mode) {
    switch (mode) {
      case AthleteMode.athletic:
        return AppTheme.athleticRed;
      case AthleteMode.academic:
        return AppTheme.academicBlue;
      case AthleteMode.recovery:
        return AppTheme.recoveryGreen;
      case AthleteMode.overview:
        return Colors.blueGrey;
    }
  }

  /// Maps the AthleteMode to a representative IconData.
  IconData _getCategoryIcon(AthleteMode mode) {
    switch (mode) {
      case AthleteMode.athletic:
        return Icons.fitness_center;
      case AthleteMode.academic:
        return Icons.school;
      case AthleteMode.recovery:
        return Icons.self_improvement;
      case AthleteMode.overview:
        return Icons.home;
    }
  }
}
