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

Step 2.2: The Dynamic Scheduling Interface

    [x] Step 2.2.1: Global Schedule Action Button 
    Purpose: Implement a persistent FloatingActionButton on the CalendarScreen that adapts its color to the current mode and triggers an empty Modal Bottom Sheet.

    [x] Step 2.2.2.1: Contextual Activity Chips
    Purpose: Build the ActivityInputSheet in /widgets that detects the active mode and displays the specific activity lists (Athletic: Lift, Practice, Game, Film, Travel; Academic: Class, Lab, Study, Exam, Office Hours; Recovery: Injury Rehab, Ice Bath, Stretching, Hydration, Nap).

    [x] Step 2.2.2.2: Date Context & Time Interval Selection
    Purpose: Update the ActivityInputSheet to accept a selected DateTime parameter from the CalendarScreen. Integrate start and end time selection using Flutter’s native TimePicker within the sheet to define the exact day and duration of an activity.

    [x] Step 2.2.2.3: Log Activity Submission
    Purpose: Implement the "Log Activity" button to capture the complete data payload (selected date, time interval, and activity chip), preparing it for local state storage.

    [x] Step 2.2.3: Modal Theme & Interaction Testing
    Purpose: Ensure the modal UI matches the AppTheme colors and implement widget tests to verify that the selection logic correctly filters activities by mode.

    [x] Step 2.2.4: Date UI Polish & Future Validation
    Purpose: To ensure data integrity for the predictive burnout analytics and improve user experience. Convert the Date display in the ActivityInputSheet into an OutlinedButton (matching the TimeSelectors) so it is visually obvious it can be edited. Restrict the native showDatePicker to only allow the current day or future dates by setting firstDate to DateTime.now(), preventing athletes from skewing the predictive algorithm with past data.

Step 2.3: Local Activity Models & Logging
Purpose: To define the data structure for "Activities," establish a global memory vault to store them, and wire up the calendar to catch and save the user's input.

    [x] Step 2.3.1: The ActivityModel Data Class
    Purpose: Create a strictly typed Dart class in your /models folder to replace the raw Map payload. This class acts as the blueprint, ensuring every logged event has an id, title (the chip string), date, startTime, endTime, and category (AthleteMode).

    [x] Step 2.3.2: The Local State Vault (ActivityProvider)
    Purpose: Create a Riverpod StateNotifier (or Notifier) in your /providers folder. This acts as the app's short-term memory before Firebase is introduced. It will hold a List<ActivityModel> and contain the addActivity(ActivityModel activity) logic to safely update the global schedule.

    [x] Step 2.3.3: The Save Pipeline (Calendar Integration)
    Purpose: Update the CalendarScreen's Floating Action Button logic. When the showModalBottomSheet finishes and returns the raw data payload, this step converts that payload into a formal ActivityModel and passes it to the ActivityProvider's add method, officially saving the data.

Step 2.4: Activity Rendering & The Overview Tab
Purpose: To complete Milestone 1 by rendering saved activities as dynamic UI cards and adding a global "Overview" mode to see the entire day's schedule at a glance.

    [x] Step 2.4.1: The Activity Card Widget
    Purpose: Create a reusable UI component (`ActivityCard`) in `/widgets` that cleanly displays the title, time interval, and an icon for a single `ActivityModel`, inheriting its colors from the active `AthleteMode`.

    [x] Step 2.4.2: The Overview Tab & Calendar Rendering
    Purpose: Update the `CalendarScreen` header to include a fourth "Overview" (Home) icon. Update the body to `ref.watch` the `activityProvider` and render a `ListView.builder` of `ActivityCard`s. If the "Overview" tab is selected, display all activities for the day in chronological order; otherwise, filter by the active `AthleteMode`.

Step 2.5: Activity Modification (Edit & Delete)
Purpose: To allow users to correct mistakes by editing or removing existing activities from their schedule.

    [x] Step 2.5.1: Vault Modification Methods
    Purpose: Update the `ActivityProvider` to include `updateActivity(ActivityModel updated)` and `deleteActivity(String id)` methods, ensuring the state remains immutable during these operations.

    [x] Step 2.5.2: The Edit Sheet State
    Purpose: Update the `ActivityInputSheet` to accept an optional `ActivityModel? existingActivity`. If provided, pre-fill the form with its data and change the submit button text to "Update Activity".

    [x] Step 2.5.3: Card Interaction & Context Menu
    Purpose: Update the `ActivityCard` to include a trailing `PopupMenuButton` (three dots). The menu should contain two options: "Edit" (which opens the `ActivityInputSheet` and passes the model into it) and "Delete" (which directly calls the `deleteActivity` method on the `activityProvider`).

Step 2.6: Advanced Time Filtering & Grouping
Purpose: To distinguish between today's immediate schedule and future planning, and to restrict where activities can be logged.

    [x] Step 2.6.1: The "Today Only" Overview
    Purpose: Update the `ref.watch` logic in `CalendarScreen`. When the "Overview" tab is active, strictly filter the list so `activity.date` matches today's date. 

    [x] Step 2.6.2: FAB Visibility Control
    Purpose: Update the `CalendarScreen` to conditionally hide the FloatingActionButton when the Overview tab is active, forcing users to select a specific category tab before adding new activities.

    [x] Step 2.6.3: Future Grouping on Mode Tabs
    Purpose: For the Athletic, Academic, and Recovery tabs, allow all future dates to pass through the filter. Update the `ListView` rendering logic to visually group activities by day (e.g., inserting a "Tomorrow" or "Oct 25" header above future cards) so the user knows they aren't looking at today's schedule.

Phase 3: Milestone 2 - Full Integration & Analytics

Goal: Connect the app to Firebase and implement the predictive burnout analytics.

Step 3.1: Firebase Authentication & Profiles
Purpose: To establish the cloud connection, secure user data, and store athlete-specific metadata like sport and position.

    [ ] Step 3.1.1: Firebase CLI & Initialization
    Purpose: Install the Firebase CLI, run `flutterfire configure` to generate the native configurations, and initialize Firebase inside `main.dart`.

    [ ] Step 3.1.2: The UserProfile Model
    Purpose: Create a data class to hold athlete metadata (e.g., uid, name, sport, position).

    [ ] Step 3.1.3: The AuthService
    Purpose: Create a dedicated service class to handle Google Sign-In and Firebase Auth communication.

    [ ] Step 3.1.4: The Auth State Provider
    Purpose: Create a Riverpod provider to listen to Firebase Auth state changes and expose the current `UserProfile` to the rest of the app.

    [ ] Step 3.1.5: The Login Gateway UI
    Purpose: Build a simple Login Screen and update `main.dart` to automatically route users to either the Calendar Screen or the Login Screen based on their Riverpod auth state.

Step 3.2: Firestore Syncing
Purpose: To persist the calendar data across sessions so the athlete's schedule is always available and backed up in the cloud.

    [ ] Step 3.2.1: The DatabaseService
    Purpose: Create a service class dedicated to executing Firestore CRUD operations (Create, Read, Update, Delete) on a `users/{uid}/activities` collection.

    [ ] Step 3.2.2: Cloud-Syncing the Vault (ActivityProvider)
    Purpose: Refactor the `ActivityProvider` so that instead of managing a local list, it reads from and writes to the new `DatabaseService`, ensuring all UI changes are immediately synced to the cloud.

    [ ] Step 3.2.3: The Loading & Error States
    Purpose: Update the `CalendarScreen` to gracefully handle network delays by using Riverpod's `AsyncValue` to show loading spinners and error messages while fetching Firestore data.

[ ] Step 3.3: Wellness & Recovery Check-ins

Purpose: To gather daily subjective data like sleep quality, soreness, and stress levels.

Create a daily check-in form and store the results in a WellnessCheck collection.

[ ] Step 3.4: Predictive Burnout Analytics (Rolling 7-Day Window)
Purpose: To calculate a cumulative performance metric and highlight "high-risk" periods based on the intersection of heavy training and exam schedules.
Develop a logic provider that queries the `WellnessCheck` and `ActivityModel` data. Establish a rolling 7-day window (Today + previous 6 days) for workload calculations, ensuring the algorithm continuously measures cumulative load without an arbitrary weekly reset.

Phase 4: Polish & Performance
[ ] Step 4.1: Error & Loading States

Purpose: To ensure the app remains stable during network latencies by using Riverpod’s AsyncValue.

Wrap all Firebase listeners in .when(data: ..., loading: ..., error: ...).

[ ] Step 4.2: Final Refactoring

Purpose: To maintain code quality and ensure no file exceeds the 200-line limit before final submission.

Audit all widgets and extract sub-components into the /widgets directory.