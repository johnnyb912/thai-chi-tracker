# Tai Chi Tracker

A comprehensive iOS app for learning and tracking your Tai Chi practice journey. This app features a 12-week beginner-friendly program with guided sessions, progress tracking, video resources, and personalized metrics.

## Features

### 🎯 12-Week Structured Program
- Three distinct session types (A, B, C)
- Progressive difficulty from weeks 1-12
- 30-minute sessions, 3 times per week (Mon/Wed/Fri)
- Rest days built into the schedule

### ⏱️ Guided Sessions with Timer
- Built-in timer for each exercise
- Warm-up (5 min) → Main Practice (20 min) → Cool-down (5 min)
- Visual and audio cues for transitions
- Set and rest period tracking
- Pause/resume functionality

### 📊 Progress Tracking
- Track completed sessions with RPE (Rate of Perceived Exertion)
- Monitor your training streak
- View session history with charts
- Track multiple metrics:
  - Single-leg balance hold time
  - Continuous practice duration
  - Moves learned
  - Resting heart rate
  - Body weight
  - Sleep quality

### 📅 Calendar & Scheduling
- Visual calendar showing completed sessions
- Weekly progress overview
- Recommended schedule display
- Session completion history

### 📚 Video Library
- Curated video resources organized by category:
  - Foundations (basic movements)
  - Warm-up routines
  - 8-Form short set
  - 24-Form extended practice
- Video descriptions and practice tips
- Duration and category indicators

### ⚙️ Settings & Profile
- Personal profile information
- Training preferences
- Practice reminders (notifications)
- Data management

## Session Types

### Session A: Foundations, Balance & Footwork
- Feet-timing & weight shift drill
- Commencing form (opening)
- Parting Wild Horse's Mane
- Single Whip basic posture

### Session B: Flow & Walking, Balance Holds
- Tai Chi walking
- Repulse Monkey / Brush Knee
- Golden Rooster / Single-leg balance
- Short continuous flow

### Session C: Short Form Integration + Mobility/Core
- 8-Form practice (Blocks 1-3)
- Core gentle isometrics
- Mobility finish

## Requirements

- iOS 17.0+
- Xcode 15.0+
- Swift 5.9+

## Installation

### Option 1: Open in Xcode

1. Clone the repository:
```bash
git clone https://github.com/johnnyb912/thai-chi-tracker.git
cd thai-chi-tracker
```

2. Open the Xcode project:
```bash
open TaiChiTracker/TaiChiTracker.xcodeproj
```
*Note: If there's no .xcodeproj file, you'll need to create one in Xcode (see Option 2)*

3. Select your target device or simulator

4. Build and run (⌘+R)

### Option 2: Create New Xcode Project

If you need to set up the project from scratch:

1. Open Xcode
2. Create a new project: File → New → Project
3. Choose "App" template under iOS
4. Configure the project:
   - Product Name: TaiChiTracker
   - Interface: SwiftUI
   - Language: Swift
   - Minimum iOS Version: 17.0
5. Copy all source files from `TaiChiTracker/TaiChiTracker/` into the project:
   - App/
   - Models/
   - Views/
   - ViewModels/
   - Resources/
6. Add the Info.plist to the project
7. Build and run

## Project Structure

```
TaiChiTracker/
├── TaiChiTracker/
│   ├── App/
│   │   ├── TaiChiTrackerApp.swift      # Main app entry point
│   │   └── ContentView.swift            # Tab navigation
│   ├── Models/
│   │   ├── Exercise.swift               # Exercise data model
│   │   ├── Session.swift                # Session types and data
│   │   ├── CompletedSession.swift       # Progress tracking models
│   │   └── VideoResource.swift          # Video library models
│   ├── Views/
│   │   ├── HomeView.swift               # Dashboard
│   │   ├── SessionDetailView.swift      # Session details
│   │   ├── ActiveSessionView.swift      # Timer and workout view
│   │   ├── CalendarView.swift           # Schedule and calendar
│   │   ├── ProgressView.swift           # Charts and metrics
│   │   ├── LibraryView.swift            # Video library
│   │   └── SettingsView.swift           # Settings and profile
│   ├── ViewModels/
│   │   ├── SessionManager.swift         # Session data management
│   │   └── ProgressTracker.swift        # Progress tracking logic
│   ├── Resources/
│   │   └── Assets.xcassets/
│   └── Info.plist
└── README.md
```

## Usage Guide

### Starting Your Journey

1. **Setup Profile**: Go to Settings and enter your personal information
2. **Review Plan**: Check the Home screen for your current week and recommended sessions
3. **Choose a Session**: Tap on Session A, B, or C to view details
4. **Start Practice**:
   - Review the exercises and cues
   - Tap "Start Session"
   - Follow the timer through warm-up, exercises, and cool-down
   - Rate your effort (RPE) when complete

### Tracking Progress

1. **Calendar**: View your training history and schedule
2. **Progress Tab**:
   - See your overall statistics
   - View session history charts
   - Track performance metrics
   - Add new metric measurements

### Video Library

1. Navigate to the Library tab
2. Browse by category (Foundations, Warm-up, 8-Form, 24-Form)
3. Tap any video to view details and practice tips
4. Use videos to learn proper technique before sessions

## Training Plan Details

### Weekly Schedule
- **Monday**: Session A (Foundations, balance & footwork)
- **Wednesday**: Session B (Flow & walking, balance holds)
- **Friday**: Session C (Short form integration + mobility/core)

### Progression (12 Weeks)

**Weeks 1-2**: Learn basic stance, weight-shift, 3-4 moves
- Focus on 1-2 techniques per session
- Build foundation

**Weeks 3-4**: Increase continuous practice time
- Aim for 2 minutes continuous movement
- Add +5-10s to balance holds

**Weeks 5-8**: Learn/link full 8-form short set
- Extend continuous flow to 4-6 minutes
- Add extra hold sets
- Consider 4/week if recovery is good

**Weeks 9-12**: Begin working toward 24-form sections
- 10-minute extra practice sessions
- Add mild speed variations

### Safety Notes

- Keep knees soft, never locked
- Stop if sharp pain occurs
- Use chair/wall for balance support
- Maintain 1-2 rest days between sessions
- Increase difficulty slowly

## Data Persistence

The app uses UserDefaults for local data storage:
- Completed sessions
- Progress metrics
- User preferences
- Profile information

All data is stored locally on the device and can be reset in Settings.

## Future Enhancements

Potential features for future versions:
- Video integration with AVPlayer
- Push notifications for reminders
- Apple Health integration
- Social features (share progress)
- Custom session builder
- Advanced analytics
- Audio-only guidance mode
- Multiple language support

## Contributing

This is a personal project, but suggestions and feedback are welcome! Feel free to open issues or submit pull requests.

## License

This project is licensed under the MIT License - see the LICENSE file for details.

## Acknowledgments

- Training plan based on Dr. Paul Lam's Tai Chi for Beginners program
- SF Symbols for all app iconography
- SwiftUI Charts framework for data visualization

## Support

For questions or support, please open an issue on GitHub.

---

**Start your Tai Chi journey today! 🧘‍♂️**