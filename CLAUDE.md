# Sunrise Alarm App - Development Context

## Overview

Sunrise is a SwiftUI iOS app that wakes users with the sunrise. It features a calm, meditative UI with a day/night cycle that adapts the entire interface based on the time of day.

## Architecture

**Pattern:** MVVM (Model-View-ViewModel)

### Core Files

| File | Purpose |
|------|---------|
| `SunriseApp.swift` | App entry point, AppDelegate for background tasks |
| `ContentView.swift` | Main home screen with alarm controls |
| `SunriseViewModel.swift` | Central state management, coordinates services |
| `Theme.swift` | Design system: colors, typography, components, day/night cycle |

### Models (`Models/`)

- `SavedLocation.swift` - Location model + `LocationStore` (UserDefaults persistence) + `AlarmTiming` enum

### Views (`Views/`)

- `SettingsView.swift` - Alarm timing configuration (before/after sunrise)
- `LocationManagementView.swift` - Location CRUD + `AddLocationView`

### Services (`Services/`)

- `LocationManager.swift` - CoreLocation wrapper
- `SunriseService.swift` - Fetches from sunrise-sunset.org API
- `NotificationManager.swift` - Local notification scheduling

## Design System (Theme.swift)

### Adaptive Day/Night Cycle

The app uses `TimePhase` enum to detect current time:
- **Night** (9 PM - 5 AM): Dark indigo sky, stars, crescent moon, soft white text
- **Dawn** (5 AM - 8 AM): Peach/lavender gradient, golden sun glow
- **Day** (8 AM - 6 PM): Light blue sky, warm accents
- **Dusk** (6 PM - 9 PM): Purple/orange sunset, fading stars

### Adaptive Colors

All UI elements use adaptive color properties:
```swift
Color.adaptiveText           // Primary text
Color.adaptiveTextSecondary  // Muted text
Color.adaptiveAccent         // Accent (coral by day, violet by night)
Color.adaptiveCardBackground // Card surfaces
Color.adaptiveCardBorder     // Borders (visible at night)
Color.adaptiveShadow         // Shadow intensity
```

### Typography (DawnTypography)

- **Display fonts:** SF Serif (light weight) for headlines
- **UI fonts:** SF Pro Rounded for body text
- Modifiers: `.dawnDisplayLarge()`, `.dawnHeadline()`, `.dawnCaption()`, etc.

### Key Components

- `DawnSkyBackground` - Animated celestial background with stars/moon/sun
- `BreathingSun` - Animated sun visualization
- `CalmCardModifier` - Glass-morphic card style (`.calmCard()`)
- `SoftButtonStyle` - Gradient buttons
- `TimeDisplay` - Time card component

## API

Uses [sunrise-sunset.org/api](https://sunrise-sunset.org/api):
- No API key required
- Returns ISO 8601 timestamps
- Endpoint: `https://api.sunrise-sunset.org/json?lat={lat}&lng={lng}&formatted=0&date={date}`

## Key Implementation Details

### Date Parsing

`SunriseService.swift` includes `parseISO8601Date()` that handles multiple date formats since the API response format can vary.

### Alarm Sound

Custom alarm sound at `alarm.caf` (converted from MP3, under 30 seconds for iOS limit).

### Notifications

Uses `UNUserNotificationCenter` with:
- Calendar-based triggers for daily repeating alarms
- Time-sensitive interruption level
- Custom sound file

## Build Requirements

- iOS 16.0+
- Xcode 15.0+
- Swift 5.0+

## Testing Night Mode

To test night mode in simulator:
1. Settings > General > Date & Time
2. Turn off "Set Automatically"
3. Set time to 10:00 PM or later

## Common Tasks

### Adding a new adaptive color
1. Add cases to each `TimePhase` in the computed property in `Theme.swift` Color extension

### Updating a view for night mode
1. Add `private let timePhase = TimePhase.current()`
2. Use `Color.adaptive*` properties
3. Add borders for night: `.stroke(Color.adaptiveCardBorder, lineWidth: isNightMode ? 1 : 0)`

### Adding a new screen
1. Create in `Views/` folder
2. Use `DawnSkyBackground()` or `adaptiveBackground` for background
3. Use dawn typography modifiers for text
4. Use `SoftButtonStyle` for buttons
5. Use `.calmCard()` for card containers
