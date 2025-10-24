# WARP.md

This file provides guidance to WARP (warp.dev) when working with code in this repository.

## Project Overview

A Flutter-based task management application with persistent storage and theme customization. Tasks have three states: pending, completed, and cancelled. The app supports light/dark theme modes with system preference detection.

## Development Commands

### Running the App
```bash
# Run on connected device/emulator
flutter run

# Run on specific device
flutter run -d <device-id>

# Run with hot reload (default behavior)
flutter run

# List available devices
flutter devices
```

### Building
```bash
# Build Android APK
flutter build apk

# Build iOS (macOS only)
flutter build ios

# Build for Windows
flutter build windows

# Build for Linux
flutter build linux
```

### Code Quality
```bash
# Run static analysis
flutter analyze

# Format code
dart format .

# Fix formatting issues
dart format --fix .

# Check for outdated dependencies
flutter pub outdated
```

### Dependencies
```bash
# Install dependencies
flutter pub get

# Update dependencies
flutter pub upgrade

# Generate launcher icons
flutter pub run flutter_launcher_icons
```

### Cleaning
```bash
# Clean build artifacts
flutter clean

# Clean and reinstall dependencies
flutter clean && flutter pub get
```

## Architecture

### State Management Pattern
Uses **Provider** pattern for state management with two main providers:
- **TaskProvider**: Manages task CRUD operations, filtering, and statistics with caching optimizations
- **ThemeProvider**: Handles theme mode switching (light/dark/system) with persistent storage

### Data Flow
1. **Task Creation/Update**: Screen → TaskProvider → StorageService → SharedPreferences
2. **Task Loading**: SharedPreferences → StorageService → TaskProvider → Screen
3. **Filtering**: TaskProvider maintains filtered task cache to avoid recomputation on every rebuild

### Key Design Patterns
- **Provider Pattern**: Used for state management and dependency injection
- **Immutable Models**: Task model uses `copyWith()` for creating modified copies
- **Service Layer**: StorageService abstracts SharedPreferences operations
- **Caching Strategy**: 
  - TaskProvider caches filtered tasks and counters
  - ThemeProvider and StorageService cache SharedPreferences instances
  - AppTheme caches built ThemeData objects

### Data Persistence
- **Storage**: SharedPreferences with JSON serialization
- **Key-Value Store**: Tasks stored as JSON array under 'tasks' key
- **Theme**: Theme mode stored as integer index under 'theme_mode' key
- **Error Handling**: Silent fallbacks to empty state on load errors

### Task State Machine
Tasks follow this state flow:
- **pending** → can edit, complete, or cancel
- **completed** → read-only (completed timestamp recorded)
- **cancelled** → read-only

Only pending tasks can be edited. State transitions are one-way (no uncompleting/uncanceling).

### UI Architecture
- **Screens**: Main navigation points (HomeScreen, AddTaskScreen, EditTaskScreen)
- **Widgets**: Reusable components (TaskCard, TaskFilterChips)
- **Theme**: Centralized in AppTheme with separate light/dark configurations

### Dependencies
- `provider ^6.1.1` - State management
- `shared_preferences ^2.2.2` - Local data persistence
- `uuid ^4.3.3` - Unique task ID generation
- `intl ^0.19.0` - Date formatting (if used for display)
- `flutter_launcher_icons ^0.13.1` - App icon generation

## File Structure Highlights

```
lib/
├── main.dart                    # App entry point with MultiProvider setup
├── models/
│   └── task.dart               # Task model with TaskStatus enum
├── providers/
│   ├── task_provider.dart      # Task state management with filtering
│   └── theme_provider.dart     # Theme mode management
├── screens/
│   ├── home_screen.dart        # Main screen with stats and task list
│   ├── add_task_screen.dart    # Task creation form
│   └── edit_task_screen.dart   # Task editing form (pending only)
├── services/
│   └── storage_service.dart    # SharedPreferences abstraction
├── theme/
│   └── app_theme.dart          # Theme definitions and color palette
└── widgets/
    ├── task_card.dart          # Individual task display
    └── task_filter_chips.dart  # Filter UI component
```

## Important Notes

- The app is configured for Android (minSdkVersion 21) and iOS with adaptive icons
- Tasks use UUID for unique identification
- All text is in Spanish (UI strings like "Pendientes", "Completadas", etc.)
- Theme toggling cycles: Light → Dark → System → Light
- No network dependencies - fully offline app
- No test suite currently implemented
