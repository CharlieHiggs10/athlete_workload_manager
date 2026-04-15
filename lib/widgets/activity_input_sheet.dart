import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/athlete_mode.dart';
import '../models/activity_model.dart';
import '../providers/athlete_mode_provider.dart';
import 'time_selector.dart';
import 'activity_chip_group.dart';
import 'date_selector.dart';

// Logic Summary:
// Bottom sheet that displays mode-specific activity chips
// (Athletic, Academic, Recovery) for the user to select.
// Uses the current global athlete mode to filter available options.
// Also allows selecting a start and end time for the activity.
class ActivityInputSheet extends ConsumerStatefulWidget {
  final DateTime initialDate;
  final ActivityModel? existingActivity;

  const ActivityInputSheet({
    super.key,
    required this.initialDate,
    this.existingActivity,
  });

  @override
  ConsumerState<ActivityInputSheet> createState() => _ActivityInputSheetState();
}

class _ActivityInputSheetState extends ConsumerState<ActivityInputSheet> {
  // Local state variables. These are nullable (?) because the user 
  // hasn't selected anything when the modal first pops up.
  String? _selectedActivity;
  TimeOfDay? _startTime;
  TimeOfDay? _endTime;

  // 'late' tells Flutter: "I promise to give this a value before it's used."
  // We do this because we need to grab widget.initialDate in initState.
  late DateTime _selectedDate;

  @override
  void initState() {
    super.initState();
    // If we're editing an existing activity, pre-populate the local state.
    if (widget.existingActivity != null) {
      _selectedDate = widget.existingActivity!.date;
      _startTime = widget.existingActivity!.startTime;
      _endTime = widget.existingActivity!.endTime;
      _selectedActivity = widget.existingActivity!.title;
    } else {
      // Initialize our local tracking date with the date passed down from the calendar.
      _selectedDate = widget.initialDate;
    }
  }

  // Triggers the native Flutter DatePicker.
  // This is an 'async' function because we have to pause and wait for the user 
  // to physically tap a date on the screen before continuing.
  Future<void> _selectDate(BuildContext context) async {
    final now = DateTime.now();
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate.isBefore(now) ? now : _selectedDate,
      firstDate: now,
      lastDate: DateTime(2100),
    );

    // Only update the state if they actually picked a new date (didn't hit cancel)
    if (picked != null && picked != _selectedDate) {
      setState(() => _selectedDate = picked);
    }
  }

  /// Triggers the native Flutter TimePicker.
  Future<void> _selectTime(BuildContext context, bool isStartTime) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      // Smart default: If they already picked a time, show that time. 
      // Otherwise, default to the exact current time.
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
    final currentMode = ref.watch(athleteModeProvider);
    final theme = Theme.of(context);
    // Embed variable values into string to format the date for the UI.
    final dateString = "${_selectedDate.month}/${_selectedDate.day}/${_selectedDate.year}";

    return Container(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Select ${currentMode.name[0].toUpperCase()}${currentMode.name.substring(1)} Activity',
            style: theme.textTheme.titleLarge?.copyWith(
              color: theme.primaryColor,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          
          DateSelector(
            label: 'Date',
            dateString: dateString,
            onTap: () => _selectDate(context),
            color: theme.primaryColor,
          ),
          const SizedBox(height: 16),
          
          ActivityChipGroup(
            chips: currentMode.activityChips,
            selectedActivity: _selectedActivity,
            primaryColor: theme.primaryColor,
            onSelected: (val) => setState(() => _selectedActivity = val),
          ),
          const SizedBox(height: 24),

          Row(
            children: [
              Expanded(
                child: TimeSelector(
                  label: 'Start Time',
                  time: _startTime,
                  onTap: () => _selectTime(context, true),
                  color: theme.primaryColor,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: TimeSelector(
                  label: 'End Time',
                  time: _endTime,
                  onTap: () => _selectTime(context, false),
                  color: theme.primaryColor,
                ),
              ),
            ],
          ),
          const SizedBox(height: 32),

          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: _logActivity,
              style: ElevatedButton.styleFrom(
                backgroundColor: theme.primaryColor,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
              child: Text(
                widget.existingActivity != null ? 'Update Activity' : 'Log Activity',
                style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Handles the validation and submission logic when the user taps "Log Activity"
  void _logActivity() {
    if (_selectedActivity == null || _startTime == null || _endTime == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Please select an activity and time interval.'),
          backgroundColor: Theme.of(context).primaryColor,
          behavior: SnackBarBehavior.floating,
        ),
      );
      return;
    }

    // Packaging: Bundle all the local state into a single Map.
    final payload = {
      'activity': _selectedActivity,
      'startTime': _startTime,
      'endTime': _endTime,
      'date': _selectedDate,
      'mode': ref.read(athleteModeProvider),
    };

    // Handoff: Close the bottom sheet and pass the payload back to whoever opened it.
    Navigator.pop(context, payload);
  }
}