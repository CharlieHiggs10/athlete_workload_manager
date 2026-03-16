import 'package:flutter/material.dart';

/// Logic Summary:
/// Global ThemeData class defining the three primary category colors:
/// Red (Athletic), Blue (Academic), and Green (Recovery).
class AppTheme {
  // Category Colors
  static const Color athleticRed = Color(0xFFD32F2F);
  static const Color academicBlue = Color(0xFF1976D2);
  static const Color recoveryGreen = Color(0xFF388E3C);

  /// Default light theme using Athletic Red as the seed.
  static ThemeData get lightTheme => getThemeForColor(athleticRed);

  /// Generates a ThemeData based on a specific category color.
  static ThemeData getThemeForColor(Color seedColor) {
    return ThemeData(
      useMaterial3: true,
      colorScheme: ColorScheme.fromSeed(
        seedColor: seedColor,
        primary: seedColor,
      ),
      appBarTheme: AppBarTheme(
        backgroundColor: seedColor,
        foregroundColor: Colors.white,
      ),
    );
  }
}
