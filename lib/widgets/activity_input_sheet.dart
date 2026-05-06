import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/athlete_mode.dart';
import '../models/activity_model.dart';
import '../providers/athlete_mode_provider.dart';
import 'time_selector.dart';
import 'activity_chip_group.dart';
import 'date_selector.dart';
import 'submit_button.dart';

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
  String? _selectedActivity;
  TimeOfDay? _startTime;
  TimeOfDay? _endTime;
  late DateTime _selectedDate;

  @override
  void initState() {
    super.initState();
    if (widget.existingActivity != null) {
      _selectedDate = widget.existingActivity!.date;
      _startTime = widget.existingActivity!.startTime;
      _endTime = widget.existingActivity!.endTime;
      _selectedActivity = widget.existingActivity!.title;
    } else {
      _selectedDate = widget.initialDate;
    }
  }

  Future<void> _selectDate(BuildContext context) async {
    final now = DateTime.now();
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate.isBefore(now) ? now : _selectedDate,
      firstDate: now,
      lastDate: DateTime(2100),
    );
    if (picked != null && picked != _selectedDate) {
      setState(() => _selectedDate = picked);
    }
  }

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
    final currentMode = ref.watch(athleteModeProvider);
    final theme = Theme.of(context);
    final dateString = "${_selectedDate.month}/${_selectedDate.day}/${_selectedDate.year}";

    return Container(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Select ${currentMode.displayName} Activity',
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
          SubmitButton(
            label: widget.existingActivity != null ? 'Update Activity' : 'Log Activity',
            onPressed: _logActivity,
            backgroundColor: theme.primaryColor,
          ),
        ],
      ),
    );
  }

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

    final payload = {
      'activity': _selectedActivity,
      'startTime': _startTime,
      'endTime': _endTime,
      'date': _selectedDate,
      'mode': ref.read(athleteModeProvider),
    };

    Navigator.pop(context, payload);
  }
}
