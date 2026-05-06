import 'package:flutter/material.dart';

/// Logic Summary:
/// A full-width ElevatedButton used for logging or updating activities.
/// Inherits the primary color from the current theme.
class SubmitButton extends StatelessWidget {
  final String label;
  final VoidCallback onPressed;
  final Color backgroundColor;

  const SubmitButton({
    super.key,
    required this.label,
    required this.onPressed,
    required this.backgroundColor,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: backgroundColor,
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(vertical: 16),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        ),
        child: Text(
          label,
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}
