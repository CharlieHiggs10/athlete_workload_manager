import 'package:flutter/material.dart';

/// Logic Summary:
/// Global ThemeData class defining the three primary category colors:
/// Red (Athletic), Blue (Academic), and Green (Recovery).
class AppTheme {
  // Category Colors
  static const Color athleticRed = Color(0xFFD32F2F);
  static const Color academicBlue = Color(0xFF1976D2);
  static const Color recoveryGreen = Color(0xFF388E3C);

  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      colorScheme: ColorScheme.fromSeed(
        seedColor: athleticRed,
        primary: athleticRed,
        secondary: academicBlue,
        tertiary: recoveryGreen,
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: athleticRed,
        foregroundColor: Colors.white,
      ),
    );
  }
}
