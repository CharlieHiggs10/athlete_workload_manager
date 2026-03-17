import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/athlete_mode.dart';
import '../providers/athlete_mode_provider.dart';

// Logic Summary:
// Bottom sheet that displays mode-specific activity chips
// (Athletic, Academic, Recovery) for the user to select.
// Uses the current global athlete mode to filter available options.
// Use a ConsumerStatefulWidget here because there needs to be types of state:
// 1. Global State (Riverpod): To know which mode we are in (Red, Blue, Green).
// 2. Local State (Flutter): To track which specific chip the user just tapped.
class ActivityInputSheet extends ConsumerStatefulWidget {
  const ActivityInputSheet({super.key});

  @override
  ConsumerState<ActivityInputSheet> createState() => _ActivityInputSheetState();
}

class _ActivityInputSheetState extends ConsumerState<ActivityInputSheet> {
  // Local state variable to hold the currently selected chip.
  // It is nullable (String?) because when the sheet first opens, nothing is selected.
  String? _selectedActivity;

  // A Map that links your specific SLU activity lists 
  // to their corresponding Riverpod mode.
  final Map<AthleteMode, List<String>> _modeChips = {
    AthleteMode.athletic: ['Lift', 'Practice', 'Game', 'Film', 'Travel'],
    AthleteMode.academic: ['Class', 'Lab', 'Study', 'Exam', 'Office Hours'],
    AthleteMode.recovery: ['Injury Rehab', 'Ice Bath', 'Stretching', 'Hydration', 'Nap'],
  };

  @override
  Widget build(BuildContext context) {
    // 1. THE WATCHER: Listen to the global mode. If the user changes modes
    // in the background, this sheet will instantly rebuild with the new mode's data.
    final currentMode = ref.watch(athleteModeProvider);
    
    // 2. THE FILTER: Grab only the list of strings that matches the current mode.
    final chips = _modeChips[currentMode] ?? [];
    
    // 3. THE THEME: Grab the context theme so our chips automatically match 
    // the Red, Blue, or Green styling defined in your CalendarScreen.
    final theme = Theme.of(context);

    return Container(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Dynamic title that capitalizes the first letter of the mode name.
          Text(
            'Select ${currentMode.name[0].toUpperCase()}${currentMode.name.substring(1)} Activity',
            style: theme.textTheme.titleLarge?.copyWith(
              color: theme.primaryColor,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          
          // Wrap is like a Row, but if it runs out of horizontal space, 
          // it automatically drops the next item to a new line. Perfect for chips.
          Wrap(
            spacing: 8.0,
            runSpacing: 8.0,
            // We map over our list of strings and turn each one into a ChoiceChip widget.
            children: chips.map((chipLabel) {
              
              // Check if THIS specific chip is the one the user selected.
              final isSelected = _selectedActivity == chipLabel;
              
              return ChoiceChip(
                label: Text(chipLabel),
                selected: isSelected,
                selectedColor: theme.primaryColor,
                labelStyle: TextStyle(
                  color: isSelected ? Colors.white : theme.primaryColor,
                ),
                onSelected: (selected) {
                  // setState triggers a rebuild of just this widget so the 
                  // chip physically changes color on the screen.
                  setState(() {
                    // If tapped while unselected, save its name. 
                    // If tapped while already selected, deselect it (set to null).
                    _selectedActivity = selected ? chipLabel : null;
                  });
                },
              );
            }).toList(),
          ),
          const SizedBox(height: 32), 
        ],
      ),
    );
  }
}