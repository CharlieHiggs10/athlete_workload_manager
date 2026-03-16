import 'package:flutter_test/flutter_test.dart';
import 'package:athlete_workload/theme.dart';
import 'package:flutter/material.dart';

/// Logic Summary:
/// Basic unit tests to verify the core theme palette colors as defined
/// in the requirements for Step 1.1.
void main() {

  // Group() wraps the related tests together.
  group('AppTheme Tests', () {
    // Runs the specific test for each color.

    // The test() function defines a single fact we want to prove about the code.
    test('Athletic color should be red', () {
      // Expect takes the variable from the app (athletic red) and compares it 
      // with the hardcoded value (Color(0xFFD32F2F). If they match, the test passes. 
      expect(AppTheme.athleticRed, const Color(0xFFD32F2F));
    });

    test('Academic color should be blue', () {
      expect(AppTheme.academicBlue, const Color(0xFF1976D2));
    });

    test('Recovery color should be green', () {
      expect(AppTheme.recoveryGreen, const Color(0xFF388E3C));
    });
  });
}
