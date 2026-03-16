import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/athlete_mode.dart';
import '../providers/athlete_mode_provider.dart';
import '../theme.dart';

/// Logic Summary:
/// Primary scheduling screen for student-athletes.
/// Dynamically updates its visual style and icons based on
/// the active mode (Athletic, Academic, Recovery).
class CalendarScreen extends ConsumerWidget {
  const CalendarScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentMode = ref.watch(athleteModeProvider);
    final themeData = _getThemeForMode(currentMode);

    return Theme(
      data: themeData,
      child: Scaffold(
        appBar: AppBar(
          title: Text(_getTitleForMode(currentMode)),
          actions: [
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
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                _getHeroIconForMode(currentMode),
                size: 100,
                color: themeData.primaryColor,
              ),
              const SizedBox(height: 20),
              Text(
                '${_getTitleForMode(currentMode)} Calendar View',
                style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                      color: themeData.primaryColor,
                    ),
              ),
              const SizedBox(height: 10),
              const Text('Activities for today will appear here.'),
            ],
          ),
        ),
      ),
    );
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
    }
  }

  /// Provides central icons representing the current mode.
  IconData _getHeroIconForMode(AthleteMode mode) {
    switch (mode) {
      case AthleteMode.athletic:
        return Icons.fitness_center;
      case AthleteMode.academic:
        return Icons.school;
      case AthleteMode.recovery:
        return Icons.self_improvement;
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
