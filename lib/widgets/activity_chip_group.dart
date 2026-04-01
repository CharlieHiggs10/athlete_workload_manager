import 'package:flutter/material.dart';

/// Logic Summary:
/// A widget that displays a collection of mode-specific choice chips.
/// Handles selection state and styling based on the active theme.
class ActivityChipGroup extends StatelessWidget {
  final List<String> chips;
  final String? selectedActivity;
  final Color primaryColor;
  final ValueChanged<String?> onSelected;

  const ActivityChipGroup({
    super.key,
    required this.chips,
    required this.selectedActivity,
    required this.primaryColor,
    required this.onSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 8.0,
      runSpacing: 8.0,
      children: chips.map((chipLabel) {
        final isSelected = selectedActivity == chipLabel;
        return ChoiceChip(
          label: Text(chipLabel),
          selected: isSelected,
          selectedColor: primaryColor,
          labelStyle: TextStyle(
            color: isSelected ? Colors.white : primaryColor,
          ),
          onSelected: (selected) {
            onSelected(selected ? chipLabel : null);
          },
        );
      }).toList(),
    );
  }
}