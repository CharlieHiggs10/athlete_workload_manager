/// Logic Summary:
/// Defines the three primary operational modes of the application:
/// Athletic (Training/Lift), Academic (Studies), and Recovery (Rest).
enum AthleteMode {
  athletic,
  academic,
  recovery,
}

/// Logic Summary:
/// Provides the specific list of activities (chips) for each athlete mode.
extension AthleteModeChips on AthleteMode {
  List<String> get activityChips {
    switch (this) {
      case AthleteMode.athletic:
        return ['Lift', 'Practice', 'Game', 'Film', 'Travel'];
      case AthleteMode.academic:
        return ['Class', 'Lab', 'Study', 'Exam', 'Office Hours'];
      case AthleteMode.recovery:
        return ['Injury Rehab', 'Ice Bath', 'Stretching', 'Hydration', 'Nap'];
    }
  }
}
