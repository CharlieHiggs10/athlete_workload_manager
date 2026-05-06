import 'package:flutter/material.dart';
import '../models/athlete_mode.dart';

/// Logic Summary:
/// Specialized IconButton that indicates if its mode is currently active.
/// Used in the CalendarScreen AppBar to toggle between athlete modes.
class ModeToggleIcon extends StatelessWidget {
  final AthleteMode mode;
  final IconData icon;
  final bool isActive;
  final VoidCallback onPressed;

  const ModeToggleIcon({
    super.key,
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
