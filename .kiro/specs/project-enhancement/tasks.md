# Implementation Plan

- [x] 1. Set up testing infrastructure and add property testing framework

  - [x] 1.1 Add glados dependency to pubspec.yaml for property-based testing


    - Add `glados: ^0.0.5` to dev_dependencies
    - Run `flutter pub get`
    - _Requirements: 8.1, 8.2_

  - [x] 1.2 Create test directory structure

    - Create `test/models/`, `test/services/`, `test/property_tests/` directories
    - _Requirements: 8.1_

- [x] 2. Implement Settings Module
  - [x] 2.1 Create AppSettings model with JSON serialization


    - Create `lib/models/settings_model.dart`
    - Implement toJson() and fromJson() methods
    - Implement defaultSettings() factory
    - _Requirements: 3.1, 3.2, 3.3_

  - [x] 2.2 Write property test for AppSettings serialization round trip

    - **Property 4: Settings Persistence Round Trip**
    - **Validates: Requirements 3.2**

  - [-] 2.3 Implement SettingsService for persistence

    - Create `lib/services/settings_service.dart`
    - Implement loadSettings(), saveSettings(), resetToDefaults()
    - _Requirements: 3.2, 3.3, 3.4_

  - [x] 2.4 Write property test for settings reset

    - **Property 5: Settings Reset Restores Defaults**
    - **Validates: Requirements 3.3**

  - [x] 2.5 Create SettingsScreen UI

    - Create `lib/screens/settings_screen.dart`
    - Implement theme selector, API URL input, notification toggle
    - Add semester start date picker
    - _Requirements: 3.1_

- [x] 3. Implement Week Calculation Module
  - [x] 3.1 Create WeekService with week calculation logic


    - Create `lib/services/week_service.dart`
    - Implement calculateWeekNumber(), isOddWeek(), filterCoursesByWeekType()
    - _Requirements: 6.1, 6.2, 6.3, 6.4_

  - [x] 3.2 Write property test for week number calculation

    - **Property 9: Week Number Calculation**
    - **Validates: Requirements 6.1, 6.3**

  - [x] 3.3 Write property test for odd/even week classification
    - **Property 10: Odd/Even Week Classification**

    - **Validates: Requirements 6.2**
  - [x] 3.4 Write property test for course filtering by week type
    - **Property 11: Course Filtering by Week Type**

    - **Validates: Requirements 6.4**
  - [x] 3.5 Update HomeScreen to display week number and filter courses

    - Add week number display widget
    - Integrate course filtering based on current week
    - _Requirements: 6.1, 6.2, 6.4_

- [x] 4. Checkpoint - Ensure all tests pass


  - Ensure all tests pass, ask the user if questions arise.

- [x] 5. Implement Countdown Management Module
  - [x] 5.1 Create CountdownStorageService for multiple events


    - Create `lib/services/countdown_storage_service.dart`
    - Implement loadAllCountdowns(), saveCountdown(), updateCountdown(), deleteCountdown()
    - _Requirements: 2.1, 2.3, 2.4_

  - [x] 5.2 Write property test for countdown persistence round trip

    - **Property 1: Countdown Event Persistence Round Trip**
    - **Validates: Requirements 2.1, 2.3**
  - [x] 5.3 Write property test for countdown list sorting

    - **Property 2: Countdown List Sorting**
    - **Validates: Requirements 2.2**
  - [x] 5.4 Write property test for countdown deletion

    - **Property 3: Countdown Deletion Removes Event**

    - **Validates: Requirements 2.4**
  - [x] 5.5 Create CountdownListScreen for managing multiple countdowns

    - Create `lib/screens/countdown_list_screen.dart`
    - Display sorted list of countdown events
    - Add navigation to add/edit/delete events
    - _Requirements: 2.2_


  - [x] 5.6 Create CountdownEditDialog for adding/editing events
    - Create `lib/widgets/countdown_edit_dialog.dart`
    - Implement form for title, description, target date, category

    - _Requirements: 2.1, 2.3_
  - [x] 5.7 Update CountdownWidget to support multiple events

    - Modify to display primary countdown with option to view all
    - Add indicator for approaching events
    - _Requirements: 2.2, 2.5_

- [x] 6. Implement Export/Import Enhancement

  - [x] 6.1 Create TimetableExportService with validation

    - Create `lib/services/timetable_export_service.dart`
    - Implement exportToJson(), importFromJson(), validateJson()
    - Implement exportToFile(), importFromFile()
    - _Requirements: 4.1, 4.2, 4.3_

  - [x] 6.2 Write property test for timetable JSON round trip

    - **Property 6: Timetable JSON Round Trip**
    - **Validates: Requirements 4.1, 4.2, 4.5**

  - [x] 6.3 Write property test for invalid JSON validation
    - **Property 7: Invalid JSON Validation**
    - **Validates: Requirements 4.3**

  - [x] 6.4 Update TimetableEditScreen with export/import buttons

    - Add export button with file save dialog
    - Add import button with file picker
    - Display validation errors on import failure
    - _Requirements: 4.1, 4.2, 4.3, 4.4_

- [x] 7. Checkpoint - Ensure all tests pass

  - Ensure all tests pass, ask the user if questions arise.

- [x] 8. Implement Error Handling Module


  - [x] 8.1 Create ErrorHandler utility class
    - Create `lib/utils/error_handler.dart`
    - Implement AppError class with code, message, userMessage, resolution
    - Implement handleNetworkError(), handleStorageError(), handleValidationError()

    - _Requirements: 5.1, 5.2, 5.3, 5.4_

  - [x] 8.2 Write property test for cache fallback on error
    - **Property 8: Cache Fallback on Error**

    - **Validates: Requirements 5.2**
  - [x] 8.3 Update ApiService to use ErrorHandler

    - Wrap API calls with error handling
    - Implement cache fallback logic
    - _Requirements: 5.1, 5.2_

  - [x] 8.4 Create enhanced ErrorDisplayWidget

    - Update `lib/widgets/error_widget.dart`
    - Display user-friendly messages with retry option
    - Show resolution guidance
    - _Requirements: 5.1, 5.4_

- [x] 9. Implement Navigation Enhancement


  - [x] 9.1 Add current time slot highlighting logic
    - Create utility function to determine current time slot

    - _Requirements: 7.2_
  - [x] 9.2 Write property test for current time slot highlighting

    - **Property 12: Current Time Slot Highlighting**
    - **Validates: Requirements 7.2**

  - [x] 9.3 Update TimetableWidget to highlight current class

    - Apply visual highlighting to current time slot
    - _Requirements: 7.2_

  - [x] 9.4 Add global navigation to today's schedule

    - Add floating action button or app bar action for quick navigation
    - Implement auto-scroll to current time slot
    - _Requirements: 7.1_

- [x] 10. Checkpoint - Ensure all tests pass

  - Ensure all tests pass, ask the user if questions arise.

- [x] 11. Update README Documentation


  - [x] 11.1 Write comprehensive README.md
    - Add project description and features list
    - Add installation instructions
    - Add usage guide with screenshots
    - Add configuration guide
    - Add contribution guidelines
    - _Requirements: 1.1, 1.2, 1.3_


- [x] 12. Final Integration and Polish

  - [x] 12.1 Integrate SettingsScreen into app navigation
    - Add settings icon to app bar
    - Connect settings to app behavior

    - _Requirements: 3.1_
  - [x] 12.2 Add countdown list access from home screen


    - Add navigation to countdown list
    - _Requirements: 2.2_
  - [x] 12.3 Ensure all components work together


    - Test week-based course filtering with settings
    - Test countdown management flow
    - Test export/import with validation
    - _Requirements: All_

- [x] 13. Final Checkpoint - Ensure all tests pass

  - Ensure all tests pass, ask the user if questions arise.

- [x] 14. Implement Material Design 3 Theme System


  - [x] 14.1 Create ThemeSettings model with JSON serialization


    - Create `lib/models/theme_settings_model.dart`
    - Implement toJson() and fromJson() methods
    - Implement defaultSettings() factory with default seed color
    - _Requirements: 9.5_



  - [x] 14.2 Write property test for ThemeSettings serialization round trip


    - **Property 13: Theme Settings Persistence Round Trip**
    - **Validates: Requirements 9.5**

  - [x] 14.3 Create ThemeService for dynamic color management


    - Create `lib/services/theme_service.dart`



    - Implement getSeedColor(), setSeedColor()


    - Implement generateLightTheme(), generateDarkTheme()
    - Implement generateColorScheme() using Material 3 color utilities
    - _Requirements: 9.2, 9.3_





  - [ ] 14.4 Write property test for color scheme generation consistency
    - **Property 14: Color Scheme Generation Consistency**


    - **Validates: Requirements 9.2**

  - [x] 14.5 Update AppSettings to include theme settings



    - Add ThemeSettings field to AppSettings model


    - Update serialization methods
    - _Requirements: 9.5_

  - [ ] 14.6 Create DynamicColorBuilder widget
    - Create `lib/widgets/dynamic_color_builder.dart`
    - Implement builder that generates themes from seed color
    - Support real-time theme updates
    - _Requirements: 9.2, 9.3_

- [x] 15. Update UI Components to Follow MD3 Guidelines
  - [x] 15.1 Update all Card widgets to use MD3 specifications
    - Apply proper elevation, shape, and padding
    - Use surface container colors
    - _Requirements: 9.1, 9.4_

  - [x] 15.2 Update all Button widgets to use MD3 components

    - Replace old buttons with FilledButton, OutlinedButton, TextButton
    - Apply proper shapes and states
    - _Requirements: 9.1, 9.4_

  - [x] 15.3 Update Typography to use MD3 text styles

    - Apply displayLarge, headlineMedium, bodyLarge, etc.
    - Ensure proper text scaling and accessibility
    - _Requirements: 9.1, 9.4_


  - [x] 15.4 Update Navigation components to use MD3 patterns
    - Use NavigationBar, NavigationRail as appropriate
    - Apply proper color roles
    - _Requirements: 9.1, 9.4_



  - [x] 15.5 Write property test for theme mode application
    - **Property 15: Theme Mode Application**
    - **Validates: Requirements 9.1, 9.3, 9.4**

- [x] 16. Add Theme Customization to Settings
  - [x] 16.1 Add seed color picker to SettingsScreen
    - Create color picker widget with 18 preset Material 3 colors
    - Display current seed color with hex code
    - Allow user to select custom color with real-time preview
    - _Requirements: 9.2, 9.5_

  - [x] 16.2 Add theme mode selector to SettingsScreen
    - Add dropdown for Light/Dark/System selection
    - Apply selection immediately with live preview
    - _Requirements: 9.3_

  - [x] 16.3 Add dynamic color toggle to SettingsScreen
    - Add switch to enable/disable dynamic color
    - Show live preview of current theme (light/dark)
    - _Requirements: 9.2_

  - [x] 16.4 Update main.dart to use DynamicColorBuilder
    - Wrap MaterialApp with DynamicColorBuilder
    - Load theme settings on startup with StreamBuilder
    - Support real-time theme switching
    - _Requirements: 9.1, 9.2, 9.3_



- [x] 17. Checkpoint - Ensure all MD3 tests pass
  - All 89 tests pass successfully, including all MD3 theme system tests.



- [ ] 18. Final Integration and Testing
  - [x] 18.1 Test theme changes across all screens


    - Verify all screens respond to theme changes
    - Check color contrast and accessibility
    - _Requirements: 9.1, 9.3, 9.4_



  - [ ] 18.2 Test seed color persistence
    - Verify seed color is saved and restored
    - Test with different colors


    - _Requirements: 9.5_

  - [ ] 18.3 Update README with theme customization guide
    - Document how to change seed color


    - Document theme mode options
    - _Requirements: 9.1_



- [ ] 19. Implement System Tray Functionality
  - [ ] 19.1 Add system tray dependencies to pubspec.yaml
    - Add `system_tray: ^2.0.3` dependency


    - Run `flutter pub get`
    - _Requirements: 10.1_

  - [x] 19.2 Create SystemTrayService for tray management


    - Create `lib/services/system_tray_service.dart`
    - Implement initializeSystemTray(), showTrayMenu(), toggleMainWindow()
    - Implement onTrayMenuItemSelected() with Chinese menu items
    - _Requirements: 10.1, 10.2, 10.3, 10.4, 10.5, 10.6_



  - [x] 19.3 Write property test for window visibility toggle

    - **Property 16: Window Visibility Toggle**
    - **Validates: Requirements 10.5**


  - [ ] 19.4 Update main.dart to initialize system tray
    - Initialize SystemTrayService on app startup
    - Set up tray icon and menu with Chinese labels

    - Handle window close to hide instead of exit
    - _Requirements: 10.1, 10.2_

  - [x] 19.5 Add tray icon assets

    - Add app icon to assets/icons/ for system tray
    - Update pubspec.yaml to include tray icon assets
    - _Requirements: 10.1_


- [ ] 20. Implement Chinese Localization
  - [ ] 20.1 Create LocalizationService with Chinese strings
    - Create `lib/services/localization_service.dart`
    - Implement comprehensive Chinese string mappings

    - Add date/time formatting functions for Chinese conventions
    - _Requirements: 11.1, 11.2, 11.3, 11.4, 11.5_

  - [x] 20.2 Write property test for Chinese UI text display

    - **Property 17: Chinese UI Text Display**
    - **Validates: Requirements 11.1**

  - [x] 20.3 Write property test for Chinese error messages

    - **Property 18: Chinese Error Messages**
    - **Validates: Requirements 11.2**

  - [ ] 20.4 Write property test for Chinese date time formatting
    - **Property 19: Chinese Date Time Formatting**

    - **Validates: Requirements 11.3**

  - [ ] 20.5 Write property test for Chinese dialog content
    - **Property 20: Chinese Dialog Content**

    - **Validates: Requirements 11.5**

- [ ] 21. Update All UI Components to Use Chinese Text
  - [x] 21.1 Update HomeScreen with Chinese labels

    - Replace all English text with LocalizationService.getString() calls
    - Update date/time displays to use Chinese formatting
    - _Requirements: 11.1, 11.3_


  - [ ] 21.2 Update SettingsScreen with Chinese labels
    - Replace all settings labels and descriptions with Chinese text
    - Update validation messages to Chinese
    - _Requirements: 11.1, 11.2_


  - [ ] 21.3 Update TimetableEditScreen with Chinese labels
    - Replace all form labels and buttons with Chinese text

    - Update error messages for validation failures
    - _Requirements: 11.1, 11.2_

  - [x] 21.4 Update CountdownListScreen with Chinese labels

    - Replace all countdown-related text with Chinese
    - Update date formatting for countdown displays
    - _Requirements: 11.1, 11.3_

  - [x] 21.5 Update all dialog boxes and error widgets

    - Replace all dialog titles and messages with Chinese
    - Update error display widget to use Chinese error messages
    - _Requirements: 11.2, 11.5_

- [x] 22. Update System Tray Menu Integration


  - [ ] 22.1 Connect tray menu to settings screen
    - Implement navigation from tray "设置" to SettingsScreen
    - Ensure settings screen opens in foreground
    - _Requirements: 10.3_

  - [ ] 22.2 Connect tray menu to timetable editing
    - Implement navigation from tray "课表编辑" to TimetableEditScreen
    - Ensure timetable edit screen opens in foreground
    - _Requirements: 10.4_

  - [ ] 22.3 Implement window show/hide functionality
    - Handle main window visibility toggle from tray menu
    - Preserve window state and position when hiding/showing
    - _Requirements: 10.5_

  - [ ] 22.4 Implement proper application exit
    - Handle exit from tray menu to completely close application
    - Clean up system tray resources on exit
    - _Requirements: 10.6_

- [ ] 23. Checkpoint - Ensure all system tray and localization tests pass
  - Ensure all tests pass, ask the user if questions arise.

- [ ] 24. Final Integration and Testing
  - [ ] 24.1 Test system tray functionality across all screens
    - Verify tray menu works from any application state
    - Test window show/hide behavior
    - _Requirements: 10.1, 10.2, 10.5_

  - [ ] 24.2 Test Chinese localization completeness
    - Verify all UI text is properly localized
    - Test error messages in Chinese
    - Test date/time formatting
    - _Requirements: 11.1, 11.2, 11.3, 11.5_

  - [ ] 24.3 Update README with Chinese interface documentation
    - Document system tray functionality
    - Document Chinese interface features
    - Add screenshots showing Chinese UI
    - _Requirements: 11.1_

- [ ] 25. Final Checkpoint - Complete Project Enhancement with Tray and Localization
  - Ensure all tests pass, ask the user if questions arise.
