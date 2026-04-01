import 'package:flutter/material.dart';

/// Logic Summary:
/// A reusable helper widget to display a time selection button with a label.
/// Used within input sheets to maintain consistent styling for time intervals.
class TimeSelector extends StatelessWidget {
  final String label;
  final TimeOfDay? time;
  final VoidCallback onTap;
  final Color color;

  const TimeSelector({
    super.key,
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
        // Triggers the callback provided by the parent widget.
        OutlinedButton(
          onPressed: onTap,
          style: OutlinedButton.styleFrom(
            padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
            side: BorderSide(color: color),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
          // The '?.' is used to safely check if 'time' is null. If it has a value, it formats it 
            // based on the device's local settings (e.g., "3:00 PM" or "15:00").
            // The '??' is the null-coalescing operator; it provides the fallback 
            // string ("Select Time") if 'time' is indeed null.
          child: Text(
            time?.format(context) ?? 'Select Time',
            style: TextStyle(color: color),
          ),
        ),
      ],
    );
  }
}