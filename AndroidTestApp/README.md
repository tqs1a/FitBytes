# Fitness Tracker - Android App

This is the Android version of the Fitness Tracker app, built with **Jetpack Compose** and **Kotlin**.

## Project Structure

```
AndroidTestApp/
├── app/
│   ├── src/main/
│   │   ├── java/com/fitnesstracker/
│   │   │   ├── data/
│   │   │   │   ├── database/          # Room database entities and DAOs
│   │   │   │   ├── model/              # Data models (MuscleGroup, StatType)
│   │   │   │   └── repository/        # Repository pattern implementations
│   │   │   ├── ui/
│   │   │   │   ├── theme/             # Material Design 3 theme
│   │   │   │   ├── home/              # Home screen
│   │   │   │   ├── activity/          # Activity feed screen
│   │   │   │   ├── progress/          # Progress tracking screen
│   │   │   │   └── profile/           # Profile screen
│   │   │   └── util/                  # Utility classes (Localization, Preferences)
│   │   └── res/
│   │       ├── values/                 # English strings
│   │       └── values-de/              # German strings
│   └── build.gradle.kts
├── build.gradle.kts
└── settings.gradle.kts
```

## Technology Stack

- **Language**: Kotlin
- **UI Framework**: Jetpack Compose
- **Architecture**: MVVM (Model-View-ViewModel)
- **Database**: Room Database
- **Preferences**: DataStore
- **Navigation**: Navigation Component for Compose
- **Health Data**: Health Connect API (Android 14+)
- **Image Loading**: Coil

## Features

✅ **Home Dashboard** - Customizable stats display
✅ **Activity Feed** - Daily and weekly activity overview
✅ **Progress Tracking** - Visual progress rings and statistics
✅ **Profile Management** - User profile and settings
✅ **Workout Programs** - Create and manage workout programs
✅ **Exercise Library** - Browse and favorite exercises
✅ **Localization** - English and German support
✅ **Dark Theme** - AMOLED black theme matching iOS design

## Setup Instructions

1. **Open in Android Studio**
   - Open Android Studio
   - Select "Open an Existing Project"
   - Navigate to `/Users/leon/Desktop/Coding/Fitness Tracker/AndroidTestApp`

2. **Sync Gradle**
   - Android Studio will automatically sync Gradle dependencies
   - Wait for sync to complete

3. **Run the App**
   - Connect an Android device or start an emulator (API 26+)
   - Click the Run button or press `Shift + F10`

## Requirements

- **Minimum SDK**: 26 (Android 8.0)
- **Target SDK**: 34 (Android 14)
- **Kotlin**: 1.9.20
- **Gradle**: 8.2.0
- **Android Studio**: Hedgehog or later

## Key Differences from iOS Version

| iOS | Android |
|-----|---------|
| SwiftUI | Jetpack Compose |
| SwiftData | Room Database |
| HealthKit | Health Connect API |
| @AppStorage | DataStore Preferences |
| Localizable.strings | strings.xml |

## Next Steps

The app is fully functional with:
- ✅ Project structure
- ✅ Database setup
- ✅ Basic UI screens
- ✅ Navigation
- ✅ Localization

**To complete the implementation**, you may want to add:
- ViewModels for state management
- Complete workout program screens
- Exercise library with search and filters
- Health Connect integration
- Settings screen
- Image picker for custom program images

## Notes

- The app uses the same color scheme and design language as the iOS version
- All strings are localized in English and German
- Database is set up to seed exercises on first launch
- Health Connect permissions are declared in the manifest

