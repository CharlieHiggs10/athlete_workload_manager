# Prompts

[x] 1. Provide the exact additions needed for my pubspec.yaml to include: flutter_riverpod, cloud_firestore, firebase_core, firebase_auth, and shared_preferences.

Read @REQUIREMENTS.md and implement Step 1.1 and only step 1.1

[x] 2. Read @REQUIREMENTS.md and implement Step 2.1: Multi-Modal Calendar UI by creating a StateProvider in /providers to manage the three athlete modes (Athletic, Academic, Recovery), developing a CalendarScreen in /screens that dynamically updates its color palette and header icons based on that state, and providing a corresponding widget test to verify the UI correctly reflects the mode change. Follow the Ai assistant guardrails closely in @REQUIREMENTS.md.

[x] 3. Read @REQUIREMENTS.md and implement Step 2.2.1. Global Schedule Action Button by adding a mode-aware FloatingActionButton to the CalendarScreen that triggers a placeholder Modal Bottom Sheet and includes a widget test to verify the button color matches the active theme.
Read @REQUIREMENTS.md and implement Step 2.2.1 and only step 2.2.1. Follow the Ai assistant guardrails closely in @REQUIREMENTS.md.

[x] 4. Read @REQUIREMENTS.md and implement Step 2.2.2.1: Contextual Activity Chips by creating an ActivityInputSheet widget in /widgets that uses Riverpod to display and highlight mode-specific selectable chips (Athletic: Lift, Practice, Game, Film, Travel; Academic: Class, Lab, Study, Exam, Office Hours; Recovery: Injury Rehab, Ice Bath, Stretching, Hydration, Nap) using the active theme color, including a widget test to verify the dynamic chip filtering, while strictly stopping before adding any time pickers or submission buttons to maintain stepwise execution. Read @REQUIREMENTS.md and implement Step 2.2.2.1 and only step 2.2.2.1. Follow the Ai assistant guardrails closely in @REQUIREMENTS.md.

[x] 5. Read @REQUIREMENTS.md and implement Step 2.2.2.2: Date Context & Time Interval Selection by updating the ActivityInputSheet widget to require a DateTime selectedDate parameter passed from the CalendarScreen's FloatingActionButton, and adding 'Start Time' and 'End Time' UI buttons that trigger Flutter's native showTimePicker to store and display the chosen TimeOfDay values in local state, alongside updating the relevant widget tests, while strictly stopping before implementing the 'Log Activity' submission button or any global state saving logic. Read @REQUIREMENTS.md and implement Step 2.2.2.2 and only step 2.2.2.2. Follow the Ai assistant guardrails closely in @REQUIREMENTS.md.