import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/athlete_mode.dart';
import '../models/activity_model.dart';
import '../providers/athlete_mode_provider.dart';
import '../providers/activity_provider.dart';
import '../widgets/activity_input_sheet.dart';
import '../widgets/activity_list_view.dart';
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
    final activities = ref.watch(activityProvider);
    final themeData = _getThemeForMode(currentMode);
    final now = DateTime.now();

    // Filter activities based on the active tab and date requirements.
    // Overview tab is strictly today only; other tabs currently show today's 
    // activities for their specific category.
    final filteredActivities = activities.where((activity) {
      if (currentMode == AthleteMode.overview) {
        return DateUtils.isSameDay(activity.date, now);
      }
      return activity.category == currentMode && DateUtils.isSameDay(activity.date, now);
    }).toList();

    // Sort chronologically by start time.
    filteredActivities.sort((a, b) {
      final aMinutes = a.startTime.hour * 60 + a.startTime.minute;
      final bMinutes = b.startTime.hour * 60 + b.startTime.minute;
      return aMinutes.compareTo(bMinutes);
    });

    return Theme(
      data: themeData,
      child: Scaffold(
        appBar: AppBar(
          title: Text(_getTitleForMode(currentMode)),
          actions: [
            _ModeToggleIcon(
              mode: AthleteMode.overview,
              icon: Icons.home,
              isActive: currentMode == AthleteMode.overview,
              onPressed: () => _setMode(ref, AthleteMode.overview),
            ),
            _ModeToggleIcon(
              mode: AthleteMode.athletic,
              icon: Icons.fitness_center,
              isActive: currentMode == AthleteMode.athletic,
              onPressed: () => _setMode(ref, AthleteMode.athletic),
            ),
            _ModeToggleIcon(
              mode: AthleteMode.academic,
              icon: Icons.school,
              isActive: currentMode == AthleteMode.academic,
              onPressed: () => _setMode(ref, AthleteMode.academic),
            ),
            _ModeToggleIcon(
              mode: AthleteMode.recovery,
              icon: Icons.self_improvement,
              isActive: currentMode == AthleteMode.recovery,
              onPressed: () => _setMode(ref, AthleteMode.recovery),
            ),
          ],
        ),
        body: ActivityListView(
          activities: filteredActivities,
          currentMode: currentMode,
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
          data: _getThemeForMode(logMode),
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

  /// Returns the specific ThemeData for each mode based on AppTheme constants.
  ThemeData _getThemeForMode(AthleteMode mode) {
    switch (mode) {
      case AthleteMode.athletic:
        return AppTheme.getThemeForColor(AppTheme.athleticRed);
      case AthleteMode.academic:
        return AppTheme.getThemeForColor(AppTheme.academicBlue);
      case AthleteMode.recovery:
        return AppTheme.getThemeForColor(AppTheme.recoveryGreen);
      case AthleteMode.overview:
        return AppTheme.getThemeForColor(Colors.blueGrey);
    }
  }

  /// Provides descriptive titles for the AppBar.
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

/// Logic Summary:
/// Specialized IconButton that indicates if its mode is currently active.
class _ModeToggleIcon extends StatelessWidget {
  final AthleteMode mode;
  final IconData icon;
  final bool isActive;
  final VoidCallback onPressed;

  const _ModeToggleIcon({
    required this.mode,
    required this.icon,
    required this.isActive,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: Icon(icon),
      color: isActive ? Colors.white : Colors.white.withAlpha(150),
      onPressed: onPressed,
      tooltip: mode.name.toUpperCase(),
    );
  }
}
