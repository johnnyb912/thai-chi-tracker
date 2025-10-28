# Tai Chi Tracker - Setup Guide

This guide will walk you through setting up the Tai Chi Tracker iOS app in Xcode.

## Prerequisites

- macOS with Xcode 15.0 or later installed
- iOS 17.0+ device or simulator
- Basic familiarity with Xcode

## Step-by-Step Setup

### 1. Create a New Xcode Project

1. Open Xcode
2. Select **File → New → Project** (or press ⌘⇧N)
3. In the template chooser:
   - Select **iOS** at the top
   - Choose **App** template
   - Click **Next**

### 2. Configure Project Settings

On the project configuration screen, enter:

- **Product Name**: `TaiChiTracker`
- **Team**: Select your development team (or leave as "None" for simulator only)
- **Organization Identifier**: `com.yourname` (or your preferred identifier)
- **Bundle Identifier**: Will auto-generate (e.g., `com.yourname.TaiChiTracker`)
- **Interface**: **SwiftUI**
- **Language**: **Swift**
- **Storage**: None (we're using UserDefaults)
- **Include Tests**: Optional (you can uncheck these for now)

Click **Next**, choose a location to save the project, and click **Create**.

### 3. Organize the Project Structure

Now we'll create the proper folder structure:

1. In Xcode's Project Navigator (left sidebar), right-click on the `TaiChiTracker` folder
2. Create the following groups (folders):
   - **App**
   - **Models**
   - **Views**
   - **ViewModels**
   - **Utilities**
   - **Resources**

### 4. Add Source Files

Now copy the source files from the repository into your Xcode project:

#### A. App Files

Move the existing `TaiChiTrackerApp.swift` to the **App** group.

From the repository, add these files to the **App** group:
- `TaiChiTracker/TaiChiTracker/App/ContentView.swift`

#### B. Models

Add all files from `TaiChiTracker/TaiChiTracker/Models/` to the **Models** group:
- `Exercise.swift`
- `Session.swift`
- `CompletedSession.swift`
- `VideoResource.swift`

#### C. Views

Add all files from `TaiChiTracker/TaiChiTracker/Views/` to the **Views** group:
- `HomeView.swift`
- `SessionDetailView.swift`
- `ActiveSessionView.swift`
- `CalendarView.swift`
- `ProgressView.swift`
- `LibraryView.swift`
- `SettingsView.swift`

#### D. ViewModels

Add all files from `TaiChiTracker/TaiChiTracker/ViewModels/` to the **ViewModels** group:
- `SessionManager.swift`
- `ProgressTracker.swift`

### 5. Configure Info.plist

1. Locate the existing `Info.plist` in your project
2. Replace its contents with the one from `TaiChiTracker/TaiChiTracker/Info.plist`

Alternatively, you can manually add these keys:
- **CFBundleDisplayName**: `Tai Chi Tracker`
- **NSUserActivityTypes**: Array with one item: `com.taichitracker.session`

### 6. Set Minimum Deployment Target

1. Click on the project name in the Project Navigator
2. Select the **TaiChiTracker** target
3. In the **General** tab, find **Minimum Deployments**
4. Set **iOS** to **17.0**

### 7. Enable Required Capabilities (Optional)

If you want to add notifications later:

1. Select your target
2. Go to **Signing & Capabilities** tab
3. Click **+ Capability**
4. Add **Push Notifications**

### 8. Build and Run

1. Select a target device or simulator from the scheme menu (top-left, next to the play/stop buttons)
   - For testing: Choose iPhone 15 Pro (or any iOS 17+ simulator)
2. Click the **Play** button (▶) or press ⌘R
3. Wait for the build to complete

The app should launch in the simulator!

## Common Issues and Solutions

### Issue: Build Errors

**Problem**: Multiple errors about missing types or undefined symbols

**Solution**:
- Make sure all files are added to the target (check the file inspector on the right)
- Clean the build folder: **Product → Clean Build Folder** (⌘⇧K)
- Rebuild: **Product → Build** (⌘B)

### Issue: Charts Not Working

**Problem**: `Cannot find 'Chart' in scope`

**Solution**:
The app uses SwiftUI Charts which requires iOS 16+. Make sure your deployment target is set to iOS 17.0.

### Issue: "No such module 'AVFoundation'"

**Problem**: AVFoundation import error in ActiveSessionView

**Solution**:
AVFoundation should be available by default. Try:
- Clean build folder
- Restart Xcode
- Check that the file is added to the correct target

### Issue: Previews Not Working

**Problem**: SwiftUI previews crash or don't load

**Solution**:
- Make sure you're using Xcode 15+
- Try: **Editor → Canvas** to toggle preview on/off
- Click **Resume** in the preview panel
- If still not working, just run on simulator instead

## Testing the App

### Initial Setup

1. When the app first launches, go to **Settings** tab
2. Enter your profile information:
   - Name
   - Age: 43
   - Height: 5'11"
   - Weight: 188 lbs
3. Go back to **Home** tab

### Test a Session

1. On the **Home** tab, tap on **Session A**
2. Review the exercises listed
3. Tap **Start Session**
4. The timer will start with the warm-up phase
5. You can:
   - **Pause** the timer
   - **Skip** to next phase
6. When complete, rate your effort (RPE 1-10)
7. Add optional notes
8. Tap **Save & Complete**

### View Progress

1. Go to **Calendar** tab to see your completed session
2. Go to **Progress** tab to view statistics
3. Tap **Add Metric** to record performance metrics

### Explore Videos

1. Go to **Library** tab
2. Browse different categories
3. Tap on a video to view details

## Next Steps

### Customization

You can customize:
- **Session exercises**: Edit `SessionManager.swift`
- **Video resources**: Edit the `setupVideoResources()` method in `SessionManager.swift`
- **Colors and styling**: Modify the color schemes in individual views
- **Exercise cues**: Update the exercise data in `SessionManager.swift`

### Adding Real Videos

To integrate actual video playback:

1. Add video URLs to the `VideoResource` objects in `SessionManager.swift`
2. In `LibraryView.swift`, implement AVPlayer in the `VideoPlayerView`
3. Example:
```swift
import AVKit

struct VideoPlayerView: View {
    let video: VideoResource
    @State private var player: AVPlayer?

    var body: some View {
        VideoPlayer(player: player)
            .onAppear {
                player = AVPlayer(url: URL(string: video.url)!)
            }
    }
}
```

### Adding Notifications

To implement practice reminders:

1. Import UserNotifications framework
2. Request authorization in `TaiChiTrackerApp.swift`
3. Schedule notifications based on the user's reminder time in Settings
4. See Apple's documentation on [Local Notifications](https://developer.apple.com/documentation/usernotifications)

## Deploying to a Physical Device

1. Connect your iPhone/iPad via USB
2. In Xcode, select your device from the scheme menu
3. Make sure you have a development team selected in **Signing & Capabilities**
4. Click **Run** (⌘R)
5. On your device, go to **Settings → General → VPN & Device Management**
6. Trust your developer certificate
7. Launch the app

## Resources

- [SwiftUI Documentation](https://developer.apple.com/documentation/swiftui/)
- [SwiftUI Charts](https://developer.apple.com/documentation/charts)
- [Apple Human Interface Guidelines](https://developer.apple.com/design/human-interface-guidelines/)
- [Tai Chi for Beginners - Dr. Paul Lam](https://taichiforhealthinstitute.org/)

## Support

If you encounter any issues not covered here:
1. Check the [README.md](README.md) for general information
2. Review the code comments in each file
3. Open an issue on GitHub

---

Happy coding and happy practicing! 🧘‍♂️
