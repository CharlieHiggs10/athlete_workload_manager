import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/athlete_mode.dart';

/// Logic Summary:
/// Manages the current active mode (Athletic, Academic, Recovery)
/// for the entire application, allowing screens to update their
/// visual palette and data context.
final athleteModeProvider = StateProvider<AthleteMode>((ref) {
  // Default mode is Athletic.
  return AthleteMode.athletic;
});
