REQUIREMENTS.md: Athlete Load Management App
Developer: Charlie Higgins

Description: A centralized dashboard for student-athletes to manage training load, academic stress, and recovery through a triple-modal calendar system and predictive analytics.

AI Assistant Guardrails
Gemini, you are acting as the intern for this project and must follow these rules strictly:

1. Architecture: Use a strict directory structure: /models, /services, /providers, /screens, and /widgets.

2. State Management: Use flutter_riverpod exclusively for all data flow.

3. Database: Use Firebase Firestore for cloud storage.

4. Stepwise Execution: Only implement the specific step requested. Do not jump ahead.

5. Code Quality: No file should exceed 200 lines. Extract complex widgets into separate files.

6. Documentation: Do not comment every line. Instead, provide a brief "Logic Summary" at the top of every new class or provider, and use descriptive variable names. If a logic block is complex, use a single comment above it explaining why it is written that way.

7. Test-Driven Development: Add comprehensive tests (unit tests for providers/models, widget tests for UI) for each requirement that is added to verify functionality before moving to the next step.

Implementation Roadmap
Phase 1: Project Setup & Core Infrastructure
[x] Step 1.1: Dependencies & Global Theme

Purpose: To establish the technical foundation and the red (Athletic), blue (Academic), and green (Recovery) color palette used throughout the app.

Add flutter_riverpod, cloud_firestore, firebase_auth, and shared_preferences to pubspec.yaml. Create a ThemeData class in lib/theme.dart defining the three primary category colors.


[x] Step 1.2: Directory Skeleton

Purpose: To ensure the project follows the mandated "Separation of Concerns" from the start.

Set up the folder structure and wrap MyApp in a ProviderScope.

Phase 2: Milestone 1 - The Triple-Modal Calendar (MVP)

Goal: Implement the core scheduling interface where users can toggle between athletic, academic, and recovery views.

[x] Step 2.1: Multi-Modal Calendar UI

Purpose: To create a responsive calendar interface that switches its theme and labels based on the active category (Red for Athletics, Blue for Academics, Green for Recovery).

Build a CalendarScreen with top-level icons to toggle between the three modes.

[x] Step 2.2.1: Global Schedule Action Button 
Purpose: Implement a persistent FloatingActionButton on the CalendarScreen that adapts its color to the current mode and triggers an empty Modal Bottom Sheet.

[x] Step 2.2.2.1: Contextual Activity Chips
Purpose: Build the ActivityInputSheet in /widgets that detects the active mode and displays the specific activity lists (Athletic: Lift, Practice, Game, Film, Travel; Academic: Class, Lab, Study, Exam, Office Hours; Recovery: Injury Rehab, Ice Bath, Stretching, Hydration, Nap).

[ ] Step 2.2.2.2: Time Interval Selection
Purpose: Integrate start and end time selection using Flutter’s native TimePicker within the ActivityInputSheet to define the duration of an activity.

[ ] Step 2.2.2.3: Log Activity Submission
Purpose: Implement the "Log Activity" button to capture the selected chip and time data, preparing it for local state storage.

[ ] Step 2.2.3: Modal Theme & Interaction Testing
Purpose: Ensure the modal UI matches the AppTheme colors. Implement widget tests to verify that opening the modal in "Academic" mode displays the correct academic options.

[ ] Step 2.3: Local Activity Models & Logging

Purpose: To define the data structure for "Activities" and implement the "Update" button logic to save changes to the local state.

Create a unified ActivityModel and a Riverpod StateNotifier to manage the list of scheduled items before they are synced to the cloud.

Phase 3: Milestone 2 - Full Integration & Analytics

Goal: Connect the app to Firebase and implement the predictive burnout analytics.

[ ] Step 3.1: Firebase Authentication & Profiles

Purpose: To secure user data and store athlete-specific metadata like sport and position.

Implement AuthService with Google Sign-In and a UserProfile model.

[ ] Step 3.2: Firestore Syncing

Purpose: To persist the calendar data across sessions so the athlete's schedule is always available.

Replace local state with DatabaseService to perform CRUD operations on the athlete's schedules.

[ ] Step 3.3: Wellness & Recovery Check-ins

Purpose: To gather daily subjective data like sleep quality, soreness, and stress levels.

Create a daily check-in form and store the results in a WellnessCheck collection.

[ ] Step 3.4: Predictive Burnout Analytics

Purpose: To calculate a cumulative performance metric and highlight "high-risk" weeks based on the intersection of heavy training and exam schedules.

Develop a logic provider that analyzes the training intensity logs and academic markers to generate visual risk indicators.

Phase 4: Polish & Performance
[ ] Step 4.1: Error & Loading States

Purpose: To ensure the app remains stable during network latencies by using Riverpod’s AsyncValue.

Wrap all Firebase listeners in .when(data: ..., loading: ..., error: ...).

[ ] Step 4.2: Final Refactoring

Purpose: To maintain code quality and ensure no file exceeds the 200-line limit before final submission.

Audit all widgets and extract sub-components into the /widgets directory.