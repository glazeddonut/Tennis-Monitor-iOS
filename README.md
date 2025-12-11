# Tennis Monitor iOS App

A native iOS app for monitoring and controlling the Tennis Monitor backend from your iPhone.

## Features

- **Monitor Control**: Start/stop the monitor from your phone
- **Real-time Status**: Check monitor status, checks performed, and slots found
- **Configuration**: Adjust monitor preferences (courts, time slots, check interval)
- **Live Logs**: View monitor logs in real-time
- **Persistent Storage**: Saves API credentials locally on device

## Project Structure

```
Sources/
├── TennisMonitorApp/
│   └── TennisMonitorApp.swift          # App entry point and tab navigation
├── Networking/
│   └── APIClient.swift                 # REST API client for backend
├── Models/
│   └── APIModels.swift                 # Data models and Codable structures
└── Views/
    ├── HomeView.swift                  # Monitor status and control
    ├── HomeViewModel.swift             # Home view state management
    ├── SettingsView.swift              # Configuration and preferences
    ├── SettingsViewModel.swift         # Settings state management
    ├── LogsView.swift                  # Monitor logs viewer
    └── LogsViewModel.swift             # Logs state management
```

## Getting Started

### Prerequisites

- Xcode 15.0 or later
- iOS 17.0 or later
- Running Tennis Monitor backend

### Installation

1. **Clone the repository:**
   ```bash
   git clone https://github.com/glazeddonut/Tennis-Monitor-iOS
   cd Tennis-Monitor-iOS
   ```

2. **Open in Xcode:**
   ```bash
   open . -a Xcode
   ```

3. **Build and Run:**
   - Select your target device/simulator
   - Press Cmd+R or Product → Run

### Setup Instructions

1. **Launch the app** on your iPhone or simulator

2. **Navigate to Settings tab**
   - Enter your backend URL: `http://192.168.1.100:8000` (or your server IP)
   - Enter your API Key (from Tennis Monitor `API_KEY` environment variable)

3. **Test Connection**
   - Click "Test Connection" button
   - If successful, you'll see "Connection OK"

4. **Configure Preferences**
   - Set preferred courts (e.g., "Court11, Court12")
   - Set preferred time slots (e.g., "18:00, 19:00, 20:00")
   - Adjust check interval in seconds (default: 300)
   - Set alive check hour (0-23, default: 10)

5. **Save Changes**
   - Click "Save Changes" to apply settings

## Usage

### Monitor Tab
- View current monitor status (Running/Stopped)
- See number of checks performed today
- See number of available slots found
- Start/Stop the monitor with one tap
- Auto-refreshes every 10 seconds

### Settings Tab
- Configure backend connection details
- Manage monitor preferences
- Test API connectivity
- View current configuration

### Logs Tab
- View real-time monitor logs
- Filter by number of lines (20, 50, or 100)
- Auto-refreshes every 5 seconds
- Copy log lines with tap & hold

## Architecture

### APIClient
- Handles all HTTP communication with backend
- Manages authentication (X-Token header)
- Provides async/await methods for all endpoints
- Custom error types for better error handling

### Data Models
- Codable structs matching backend API responses
- Helper models (MonitorStatus, MonitorConfig) for easier UI binding
- Automatic JSON decoding/encoding

### ViewModels
- MVVM pattern for reactive state management
- Published properties for SwiftUI binding
- Async/await for network operations
- Auto-refresh timers where appropriate

### Views
- SwiftUI-based UI components
- Responsive design with proper error handling
- Loading states and user feedback
- Light/dark mode support

## Configuration

API credentials are stored locally in `UserDefaults`:
- `apiKey` - Your Tennis Monitor API key
- `baseURL` - Backend server URL

## License

MIT License
