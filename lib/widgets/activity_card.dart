import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/activity_model.dart';
import '../models/athlete_mode.dart';
import '../theme.dart';
import '../providers/activity_provider.dart';
import '../widgets/activity_input_sheet.dart';

/// Logic Summary:
/// A reusable widget that displays the details of an ActivityModel.
/// It dynamically adjusts its border color and icon based on the activity's category.
/// Now a ConsumerWidget to handle "Edit" and "Delete" actions via PopupMenuButton.
class ActivityCard extends ConsumerWidget {
  final ActivityModel activity;

  const ActivityCard({
    super.key,
    required this.activity,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
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
        trailing: PopupMenuButton<String>(
          icon: const Icon(Icons.more_vert),
          onSelected: (value) {
            if (value == 'edit') {
              _handleEdit(context, ref);
            } else if (value == 'delete') {
              ref.read(activityProvider.notifier).deleteActivity(activity.id);
            }
          },
          itemBuilder: (context) => [
            const PopupMenuItem(
              value: 'edit',
              child: ListTile(
                leading: Icon(Icons.edit),
                title: Text('Edit'),
                contentPadding: EdgeInsets.zero,
              ),
            ),
            const PopupMenuItem(
              value: 'delete',
              child: ListTile(
                leading: Icon(Icons.delete, color: Colors.red),
                title: Text('Delete', style: TextStyle(color: Colors.red)),
                contentPadding: EdgeInsets.zero,
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Logic Summary:
  /// Triggers the ActivityInputSheet in edit mode by passing the existing activity.
  /// If result is returned, updates the activity in the global provider.
  Future<void> _handleEdit(BuildContext context, WidgetRef ref) async {
    final result = await showModalBottomSheet<Map<String, dynamic>>(
      context: context,
      isScrollControlled: true,
      builder: (context) {
        return Theme(
          data: AppTheme.getThemeForColor(_getCategoryColor(activity.category)),
          child: ActivityInputSheet(
            initialDate: activity.date,
            existingActivity: activity,
          ),
        );
      },
    );

    if (result != null) {
      final updatedActivity = ActivityModel(
        id: activity.id,
        title: result['activity'] as String,
        date: result['date'] as DateTime,
        startTime: result['startTime'] as TimeOfDay,
        endTime: result['endTime'] as TimeOfDay,
        category: result['mode'] as AthleteMode,
      );

      ref.read(activityProvider.notifier).updateActivity(updatedActivity);
    }
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
