import 'package:flutter_test/flutter_test.dart';
import 'package:athlete_workload/theme.dart';
import 'package:flutter/material.dart';

/// Logic Summary:
/// Basic unit tests to verify the core theme palette colors as defined
/// in the requirements for Step 1.1.
void main() {
  group('AppTheme Tests', () {
    test('Athletic color should be red', () {
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
