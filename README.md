# Sunrise Alarm App

A beautiful iOS application that sets daily alarms based on sunrise times at your chosen locations.

## Features

- **Multiple Locations Support**: Save and manage multiple locations with custom names
- **Flexible Alarm Timing**: Choose to wake up 10 minutes **before** OR **after** sunrise
- **Current or Manual Location**: Add locations using GPS or manual coordinates
- **Apple Default Alarm Sound**: Uses authentic iOS alarm sound for reliable wake-ups
- **Sunrise API Integration**: Fetches accurate sunrise times from sunrise-sunset.org API
- **Daily Alarm Scheduling**: Automatically schedules repeating notifications
- **User-Friendly Interface**: Clean SwiftUI interface with location and settings management
- **Background Updates**: iOS background tasks keep alarm times current

## Technical Details

### Architecture

The app follows MVVM (Model-View-ViewModel) architecture with the following components:

#### Core Files
- **SunriseApp.swift**: Main app entry point with AppDelegate for background tasks
- **ContentView.swift**: Main SwiftUI interface with location/settings access
- **SunriseViewModel.swift**: Manages app state and coordinates between services

#### Models
- **SavedLocation.swift**: Location data model with name, coordinates, and selection state
- **LocationStore**: Manages saved locations and alarm timing preferences with UserDefaults persistence
- **AlarmTiming**: Enum for before/after sunrise preference

#### Views
- **SettingsView.swift**: Alarm timing configuration (before/after sunrise)
- **LocationManagementView.swift**: Add, delete, and select locations
- **AddLocationView**: Add new locations via GPS or manual coordinates

#### Services
- **LocationManager.swift**: CoreLocation wrapper for GPS access
- **SunriseService.swift**: Fetches sunrise/sunset data from API
- **NotificationManager.swift**: Schedules local notifications with Apple alarm sound

### API Used

The app uses the free [Sunrise-Sunset.org API](https://sunrise-sunset.org/api) which provides:
- Sunrise and sunset times
- No API key required
- ISO 8601 formatted timestamps
- Global coverage

### Permissions Required

- **Location (When In Use)**: To determine your geographical location for accurate sunrise times
- **Notifications**: To send daily alarm notifications

### How It Works

1. User grants location and notification permissions
2. User adds one or more locations (GPS or manual coordinates)
3. User selects which location to use for the alarm
4. User chooses alarm timing: before or after sunrise (Settings)
5. App fetches sunrise time from API based on selected location
6. A daily repeating notification is scheduled for 10 minutes before/after sunrise
7. Background tasks update the alarm to account for changing sunrise times throughout the year

### New in This Version

#### Multiple Locations
- Save unlimited locations with custom names (e.g., "Home", "Office", "Vacation House")
- Quickly switch between locations by tapping to select
- Delete locations with swipe gesture
- Selected location shows with a checkmark

#### Before/After Sunrise Options
- **Before Sunrise**: Alarm rings 10 minutes before sunrise (default)
- **After Sunrise**: Alarm rings 10 minutes after sunrise
- Easily toggle in Settings
- Preference is saved and persists

#### Apple Alarm Sound
- Uses `alarm.caf` - the authentic iOS alarm sound
- Time-sensitive notification priority for prominence
- Reliable wake-up experience

## Setup Instructions

1. Open `Sunrise.xcodeproj` in Xcode 15 or later
2. Select a simulator or connected iOS device (iOS 16.0+)
3. Build and run the project
4. Grant location and notification permissions when prompted
5. Add your first location:
   - Tap the location icon (📍) in the top-right
   - Tap the + button
   - Enter a name for the location
   - Choose "Use Current Location" or enter coordinates manually
   - Tap "Save"
6. (Optional) Configure alarm timing:
   - Tap the settings icon (⚙️) in the top-right
   - Choose "Before Sunrise" or "After Sunrise"
7. Tap "Set Daily Alarm" to activate the sunrise alarm

## Project Structure

```
Sunrise/
├── Sunrise.xcodeproj/
│   └── project.pbxproj
├── Sunrise/
│   ├── SunriseApp.swift
│   ├── ContentView.swift
│   ├── SunriseViewModel.swift
│   ├── Models/
│   │   └── SavedLocation.swift
│   ├── Views/
│   │   ├── SettingsView.swift
│   │   └── LocationManagementView.swift
│   ├── Services/
│   │   ├── LocationManager.swift
│   │   ├── SunriseService.swift
│   │   └── NotificationManager.swift
│   ├── Assets.xcassets/
│   ├── Preview Content/
│   └── Info.plist
└── README.md
```

## Requirements

- iOS 16.0+
- Xcode 15.0+
- Swift 5.0+

## Notes

- The app uses repeating calendar-based notifications that trigger daily at the calculated time
- Sunrise times automatically adjust based on your location and the time of year
- Background app refresh should be enabled for optimal alarm updates
- The alarm will continue to trigger daily even if the app is closed
