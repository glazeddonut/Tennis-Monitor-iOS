# Installation Guide - Tennis Monitor iOS App

## System Requirements

- **Mac OS**: macOS 12.0 or later
- **Xcode**: 15.0 or later
- **Target Device**: iPhone running iOS 17.0 or later
- **Tennis Monitor Backend**: Running and accessible over network

## Step 1: Clone the Repository

```bash
cd ~/Documents
git clone https://github.com/glazeddonut/Tennis-Monitor-iOS
cd Tennis-Monitor-iOS
```

## Step 2: Open in Xcode

```bash
open . -a Xcode
```

Or manually:
1. Open Xcode
2. File → Open
3. Navigate to Tennis-Monitor-iOS folder
4. Click Open

## Step 3: Configure Build Settings

### Select Target
In Xcode top toolbar, ensure "TennisMonitorApp" is selected as the target.

### Select Device/Simulator
Click the device selector (next to TennisMonitorApp dropdown):
- **Physical iPhone**: Select your device (must be connected)
- **Simulator**: Select any iPhone simulator (recommended for testing)

## Step 4: Build the Project

### Option A: Using Xcode UI
1. Product → Build (or Cmd+B)
2. Wait for build to complete
3. Should see "Build Succeeded" at bottom

### Option B: Using Terminal
```bash
cd /Users/thomastolborg/Documents/Tennis-Monitor-iOS
xcodebuild build -scheme TennisMonitorApp
```

## Step 5: Run the App

### Option A: Using Xcode UI
1. Product → Run (or Cmd+R)
2. App will launch on selected device/simulator
3. Wait for "Tennis Monitor" app to appear

### Option B: Using Terminal
```bash
xcodebuild run -scheme TennisMonitorApp
```

## Step 6: Configure Backend Connection

Once the app launches:

1. **Tap the Settings tab** (gear icon at bottom)

2. **Enter Backend URL**
   - Find your Tennis Monitor server IP address
   - Example: `http://192.168.1.100:8000`
   - Or: `http://10.0.0.5:8000` (adjust for your network)

3. **Enter API Key**
   - Go to Tennis Monitor backend
   - Check your `.env` file for `API_KEY` value
   - Paste into app's API Key field

4. **Test Connection**
   - Click "Test Connection" button
   - Should see ✓ "Connection OK"

If connection fails, troubleshoot:
```bash
# From your Mac terminal, test backend directly
curl -I http://192.168.1.100:8000/health

# Or with API key
curl -H "X-Token: your-api-key" http://192.168.1.100:8000/api/status
```

## Step 7: Configure Monitor Preferences

Still in Settings tab:

1. **Preferred Courts**
   - Example: `Court11, Court12, Court4`
   - Use exact court names from your booking system

2. **Preferred Times**
   - Example: `18:00, 19:00, 20:00`
   - Use HH:MM format

3. **Check Interval**
   - Default: `300` seconds
   - Adjust based on how frequently you want to check

4. **Alive Check Hour**
   - Default: `10` (10:00 AM)
   - Set to 0-23 for 24-hour format

## Step 8: Save Settings

Click **"Save Changes"** button.

You should see: ✓ "Settings saved successfully!"

## Step 9: Start Monitoring

1. **Tap Monitor tab** (first tab, play icon)
2. **Click "Start Monitor"** button (green)
3. Status should change to **"🟢 Running"**

The app will now:
- Check monitor status every 10 seconds
- Display real-time statistics
- Show logs in the Logs tab

## Deployment Options

### Option 1: Simulator (Easiest for Testing)
Already done above - app runs in iOS simulator on your Mac.

### Option 2: Physical iPhone

**Requirements:**
- Apple Developer account ($99/year)
- iPhone connected via USB to Mac
- Or wireless connection enabled

**Steps:**
1. Connect iPhone to Mac with USB cable
2. Select your iPhone in Xcode device selector
3. Press Cmd+R to run

**First time only:**
1. You'll see "Untrusted Developer" prompt on iPhone
2. Go to iPhone Settings → General → Device Management
3. Trust the developer certificate
4. Go back to Xcode and run again

### Option 3: TestFlight Distribution (For Others)

To share app with others:

1. Create Apple Developer account
2. Set up App ID and provisioning profile
3. Upload build via Xcode or Transporter
4. Invite testers via TestFlight
5. Testers can download from TestFlight app

(Details: https://developer.apple.com/testflight/)

## Building for Release

If you want to distribute:

```bash
# Archive for distribution
xcodebuild archive -scheme TennisMonitorApp \
  -archivePath build/TennisMonitorApp.xcarchive

# Export for TestFlight
xcodebuild -exportArchive \
  -archivePath build/TennisMonitorApp.xcarchive \
  -exportPath build/TennisMonitorApp.ipa \
  -exportOptionsPlist exportOptions.plist
```

## Troubleshooting Installation

### Build Fails with "Swift version mismatch"

**Solution:**
1. Xcode → Preferences → Locations
2. Check "Command Line Tools" version matches Xcode
3. If different, download matching tools version

### "Cannot find module" errors

**Solution:**
1. Product → Clean Build Folder (Cmd+Shift+K)
2. Product → Build (Cmd+B)
3. Delete Derived Data:
   ```bash
   rm -rf ~/Library/Developer/Xcode/DerivedData/*
   ```

### Simulator won't start

**Solution:**
1. Quit simulator: Press Cmd+Q
2. Restart: Product → Run again
3. Or reset simulator:
   ```bash
   xcrun simctl erase all
   ```

### App crashes on launch

**Check logs:**
1. Xcode → View → Debug Area → Show Console
2. Read error messages
3. Common issues:
   - Missing API key/URL in Settings
   - Backend not running
   - Network connectivity

## Next Steps

After successful installation:

1. Check GETTING_STARTED.md for usage guide
2. Try starting/stopping monitor from app
3. View logs in real-time
4. Adjust preferences as needed

## Development

If you want to modify or extend the app:

1. **Main app code**: `Sources/TennisMonitorApp/TennisMonitorApp.swift`
2. **API client**: `Sources/Networking/APIClient.swift`
3. **Data models**: `Sources/Models/APIModels.swift`
4. **UI views**: `Sources/Views/`

### Making Changes

1. Edit files in Xcode
2. Cmd+B to rebuild
3. Cmd+R to run
4. Changes apply immediately with live preview

### Running Tests

Currently no tests, but you can add:
```bash
xcodebuild test -scheme TennisMonitorApp
```

## Support

- For iOS app issues: See README.md in this repo
- For backend issues: See Tennis Monitor repo
- For Xcode help: https://developer.apple.com/

---

**Version:** 1.0  
**Last Updated:** December 2025
