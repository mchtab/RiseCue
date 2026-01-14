# Sunrise Alarm App

A beautiful iOS application that wakes you with the sunrise using system-level alarms powered by AlarmKit.

## Features

- **Multiple Locations Support**: Save and manage multiple locations with custom names
- **Flexible Alarm Timing**: Choose from 4 wake-up options:
  - Nautical Dawn (~60 min before sunrise)
  - Civil Dawn (~30 min before sunrise)
  - Sunrise (at sunrise)
  - After Sunrise (10 min after)
- **Daily Auto-Repeat**: Optionally auto-schedule tomorrow's alarm after each wake-up
- **Current or Manual Location**: Add locations using GPS or manual coordinates
- **System-Level Alarms**: Uses AlarmKit (iOS 26+) for reliable wake-ups even when app is closed
- **Adaptive UI**: Beautiful day/night interface that changes based on time of day
- **Accessibility**: VoiceOver support, Dynamic Type, and Reduce Motion compatibility

## Technical Details

### Architecture

The app follows MVVM (Model-View-ViewModel) architecture:

#### Core Files
- **SunriseApp.swift**: App entry point with AppDelegate for background tasks and AlarmKit authorization
- **ContentView.swift**: Main interface with alarm controls, onboarding, and success feedback
- **SunriseViewModel.swift**: Central state management, coordinates services and alarm scheduling
- **Theme.swift**: Design system with adaptive colors, typography, and accessibility features

#### Models
- **SavedLocation.swift**: Location model + `LocationStore` for UserDefaults persistence + `AlarmTiming` enum

#### Views
- **SettingsView.swift**: Alarm timing configuration (4 options) and daily repeat toggle
- **LocationManagementView.swift**: Location CRUD operations

#### Services
- **LocationManager.swift**: CoreLocation wrapper for GPS access
- **SunriseService.swift**: Fetches all sun times (nautical dawn through nautical dusk) from API
- **AlarmKitManager.swift**: AlarmKit wrapper for system-level alarm scheduling

### API Used

The app uses the free [Sunrise-Sunset.org API](https://sunrise-sunset.org/api):
- All twilight times (astronomical, nautical, civil dawn/dusk)
- No API key required
- ISO 8601 formatted timestamps
- Global coverage

### Permissions Required

- **Location (When In Use)**: For accurate sunrise times at your location
- **Alarms (AlarmKit)**: For system-level alarm scheduling

### How It Works

1. User grants location and alarm permissions
2. User adds one or more locations (GPS or manual coordinates)
3. User selects which location to use for the alarm
4. User chooses alarm timing in Settings (nautical dawn, civil dawn, sunrise, or after sunrise)
5. App fetches sun times from API based on selected location
6. AlarmKit schedules a system-level alarm that fires even when app is closed
7. If daily repeat is enabled, the next day's alarm is automatically scheduled

## Requirements

- iOS 26.0+ (for AlarmKit)
- Xcode 16.0+
- Swift 5.0+

## Setup Instructions

1. Open `Sunrise.xcodeproj` in Xcode 16 or later
2. Select a simulator or connected iOS device (iOS 26.0+)
3. Build and run the project
4. Grant location and alarm permissions when prompted
5. Add your first location via the location icon
6. Configure alarm timing in Settings (optional)
7. Tap "Set Sunrise Alarm" to activate

## Project Structure

```
Sunrise/
├── Sunrise.xcodeproj/
├── Sunrise/
│   ├── SunriseApp.swift
│   ├── ContentView.swift
│   ├── SunriseViewModel.swift
│   ├── Theme.swift
│   ├── Models/
│   │   └── SavedLocation.swift
│   ├── Views/
│   │   ├── SettingsView.swift
│   │   └── LocationManagementView.swift
│   ├── Services/
│   │   ├── LocationManager.swift
│   │   ├── SunriseService.swift
│   │   └── AlarmKitManager.swift
│   └── Assets.xcassets/
├── CLAUDE.md
└── README.md
```

## Notes

- AlarmKit alarms fire reliably even when the app is terminated
- Sunrise times automatically adjust based on location and season
- Background app refresh keeps alarm times current
- Sun times data provided by [sunrise-sunset.org](https://sunrise-sunset.org)
