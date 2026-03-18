import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/athlete_mode.dart';
import '../providers/athlete_mode_provider.dart';

// Logic Summary:
// Bottom sheet that displays mode-specific activity chips
// (Athletic, Academic, Recovery) for the user to select.
// Uses the current global athlete mode to filter available options.
// Also allows selecting a start and end time for the activity.
// Use a ConsumerStatefulWidget here because there needs to be types of state:
// 1. Global State (Riverpod): To know which mode we are in (Red, Blue, Green).
// 2. Local State (Flutter): To track which specific chip the user just tapped,
//    and to store the selected start and end times.
class ActivityInputSheet extends ConsumerStatefulWidget {
  final DateTime selectedDate;
  const ActivityInputSheet({super.key, required this.selectedDate});

  @override
  ConsumerState<ActivityInputSheet> createState() => _ActivityInputSheetState();
}

class _ActivityInputSheetState extends ConsumerState<ActivityInputSheet> {
  // Local state variable to hold the currently selected chip.
  // It is nullable (String?) because when the sheet first opens, nothing is selected.
  String? _selectedActivity;

  // Local state variables for the time interval of the activity.
  TimeOfDay? _startTime;
  TimeOfDay? _endTime;

  // A Map that links your specific SLU activity lists 
  // to their corresponding Riverpod mode.
  final Map<AthleteMode, List<String>> _modeChips = {
    AthleteMode.athletic: ['Lift', 'Practice', 'Game', 'Film', 'Travel'],
    AthleteMode.academic: ['Class', 'Lab', 'Study', 'Exam', 'Office Hours'],
    AthleteMode.recovery: ['Injury Rehab', 'Ice Bath', 'Stretching', 'Hydration', 'Nap'],
  };

  /// Triggers the native Flutter TimePicker to select a start or end time.
  Future<void> _selectTime(BuildContext context, bool isStartTime) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: (isStartTime ? _startTime : _endTime) ?? TimeOfDay.now(),
    );
    if (picked != null) {
      setState(() {
        if (isStartTime) {
          _startTime = picked;
        } else {
          _endTime = picked;
        }
      });
    }
  }

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

    // Format selected date for display
    final dateString = "${widget.selectedDate.month}/${widget.selectedDate.day}/${widget.selectedDate.year}";

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
          const SizedBox(height: 8),
          Text(
            'Date: $dateString',
            style: theme.textTheme.bodyMedium?.copyWith(
              color: Colors.grey[600],
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
          const SizedBox(height: 24),

          // Time Selection Section
          Row(
            children: [
              Expanded(
                child: _TimeSelector(
                  label: 'Start Time',
                  time: _startTime,
                  onTap: () => _selectTime(context, true),
                  color: theme.primaryColor,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: _TimeSelector(
                  label: 'End Time',
                  time: _endTime,
                  onTap: () => _selectTime(context, false),
                  color: theme.primaryColor,
                ),
              ),
            ],
          ),
          const SizedBox(height: 32), 
        ],
      ),
    );
  }
}

/// Logic Summary:
/// A helper widget to display a time selection button with a label.
class _TimeSelector extends StatelessWidget {
  final String label;
  final TimeOfDay? time;
  final VoidCallback onTap;
  final Color color;

  const _TimeSelector({
    required this.label,
    required this.time,
    required this.onTap,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            color: Colors.grey[600],
            fontSize: 12,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 8),
        OutlinedButton(
          onPressed: onTap,
          style: OutlinedButton.styleFrom(
            padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
            side: BorderSide(color: color),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
          child: Text(
            time?.format(context) ?? 'Select Time',
            style: TextStyle(color: color),
          ),
        ),
      ],
    );
  }
}