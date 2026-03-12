# POTSTracker — iOS Build & Submission Guide

## Prerequisites
- macOS with Xcode 15+ installed
- Apple Developer Account ($99/year)
- Node.js 18+
- CocoaPods (`sudo gem install cocoapods`)

## Step 1: Install Dependencies
```bash
cd POTSTracker
npm install
```

## Step 2: Build the Web App
```bash
npm run build
```
This generates the static export in the `/out` directory.

## Step 3: Initialize Capacitor iOS
```bash
npx cap add ios
npx cap sync ios
```

## Step 4: Open in Xcode
```bash
npx cap open ios
```

## Step 5: Configure in Xcode

### Info.plist
Add these keys (from `ios/App/Info.plist.additions`):
- `NSFaceIDUsageDescription`: "Used to protect your private health data"
- `NSHealthShareUsageDescription`: "Used to read heart rate data from Apple Health"
- `NSHealthUpdateUsageDescription`: "Used to write symptom data to Apple Health"

### Signing & Capabilities
1. Select your Development Team
2. Add **HealthKit** capability
3. Add **Background Modes** → Background Processing

### Privacy Manifest
Copy `ios/App/PrivacyInfo.xcprivacy` into the Xcode project navigator under `App/App/`.

### Entitlements
Copy `ios/App/App.entitlements` and add it to the project.

### Deployment Target
Set minimum iOS deployment target to **16.0** in:
- Project settings → General → Minimum Deployments
- Both App and Pods targets

### App Icons
Generate app icons (1024x1024 source) and add to Assets.xcassets/AppIcon.

### Launch Screen
Configure `LaunchScreen.storyboard`:
- Set background color to #0D7377 (primary teal)
- Add centered app name label "POTSTracker" in white

## Step 6: Test on Simulator / Device
```bash
# Build and run on simulator
npx cap run ios

# Or use Xcode: Product → Run
```

## Step 7: Archive for TestFlight
1. In Xcode: Product → Archive
2. Distribute App → App Store Connect
3. Upload to TestFlight
4. Add testers in App Store Connect

## Step 8: App Store Submission Metadata

### App Information
- **App Name**: POTSTracker – Dysautonomia Diary
- **Category**: Medical
- **Subcategory**: Health & Fitness
- **Age Rating**: 4+
- **Price**: Free

### App Description
```
Track. Understand. Thrive.

POTSTracker is your personal dysautonomia diary designed specifically for people
living with POTS (Postural Orthostatic Tachycardia Syndrome), orthostatic
hypotension, vasovagal syncope, and other forms of dysautonomia.

DAILY LOGGING
• Record lying, sitting, and standing heart rates with automatic orthostatic
  delta calculation
• Track blood pressure changes between positions
• Log 14+ common dysautonomia symptoms with severity ratings
• Monitor hydration, salt intake, sleep, and activity levels
• Track medications and menstrual cycle phases

SMART INSIGHTS
• Automatic pattern detection identifies your personal triggers
• Correlation analysis between sleep, activity, and symptom severity
• Hydration goal tracking and reminders

DOCTOR VISIT PREP
• One-tap generation of comprehensive summary reports
• Export as PDF or CSV for your medical team
• Includes averages, trends, and top symptoms

DESIGNED FOR DYSAUTONOMIA
• Built with input from the POTS community
• Orthostatic HR criteria alerts (≥30 BPM increase)
• Orthostatic hypotension detection
• Recumbent exercise tracking options

PRIVACY FIRST
• All data stored locally on your device
• No accounts or cloud services required
• Face ID / Touch ID protection
• No ads, no tracking, no data collection

Apple Health integration available for automatic heart rate and step count import.
```

### Keywords
POTS, dysautonomia, tachycardia, orthostatic, symptom tracker, health diary,
heart rate, chronic illness, vasovagal, blood pressure

### Support URL
[Your support URL]

### Privacy Policy URL
[Your privacy policy URL — required for Medical category]
