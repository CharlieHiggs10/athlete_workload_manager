import 'package:flutter/material.dart';

/// Logic Summary:
/// A stateless widget that displays a label and an OutlinedButton 
/// for selecting a date. It uses the theme's primary color for styling.
class DateSelector extends StatelessWidget {
  final String label;
  final String dateString;
  final VoidCallback onTap;
  final Color color;

  const DateSelector({
    super.key,
    required this.label,
    required this.dateString,
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
            padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 12),
            side: BorderSide(color: color),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.calendar_today, size: 16, color: color),
              const SizedBox(width: 8),
              Text(
                dateString,
                style: TextStyle(
                  color: color,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
