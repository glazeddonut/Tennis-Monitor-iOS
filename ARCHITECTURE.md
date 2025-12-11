# Architecture Documentation

## High-Level Overview

```
┌─────────────────────────────────────────────────────────┐
│                    iOS Device (iPhone)                   │
├─────────────────────────────────────────────────────────┤
│                                                           │
│  ┌──────────────────────────────────────────────────┐   │
│  │              SwiftUI Views Layer                  │   │
│  │  ┌──────────────┐  ┌──────────────────────────┐  │   │
│  │  │  HomeView    │  │  SettingsView            │  │   │
│  │  │  - Status    │  │  - API Config            │  │   │
│  │  │  - Controls  │  │  - Preferences           │  │   │
│  │  │  - Stats     │  │  - Connection Test       │  │   │
│  │  └──────────────┘  └──────────────────────────┘  │   │
│  │  ┌──────────────┐                                 │   │
│  │  │  LogsView    │                                 │   │
│  │  │  - Log lines │                                 │   │
│  │  │  - Filter    │                                 │   │
│  │  │  - Refresh   │                                 │   │
│  │  └──────────────┘                                 │   │
│  └──────────────────────────────────────────────────┘   │
│                          ▲                                │
│                          │                                │
│  ┌──────────────────────────────────────────────────┐   │
│  │           ViewModel Layer (MVVM)                  │   │
│  │  ┌──────────────┐  ┌──────────────────────────┐  │   │
│  │  │HomeViewModel │  │SettingsViewModel        │  │   │
│  │  │- @Published  │  │- @Published             │  │   │
│  │  │  status      │  │  config                 │  │   │
│  │  │- async funcs │  │- async funcs            │  │   │
│  │  │- auto refresh│  │- preferences update     │  │   │
│  │  └──────────────┘  └──────────────────────────┘  │   │
│  │  ┌──────────────┐                                 │   │
│  │  │LogsViewModel │                                 │   │
│  │  │- @Published  │                                 │   │
│  │  │  logs        │                                 │   │
│  │  └──────────────┘                                 │   │
│  └──────────────────────────────────────────────────┘   │
│                          ▲                                │
│                          │                                │
│  ┌──────────────────────────────────────────────────┐   │
│  │         APIClient Layer (Networking)              │   │
│  │  ┌──────────────────────────────────────────┐   │   │
│  │  │          APIClient (Singleton)           │   │   │
│  │  │  • configure(baseURL, apiKey)            │   │   │
│  │  │  • getStatus()                           │   │   │
│  │  │  • startMonitor() / stopMonitor()        │   │   │
│  │  │  • getConfig() / updatePreferences()     │   │   │
│  │  │  • getLogs()                             │   │   │
│  │  │  • performAuthenticatedRequest()         │   │   │
│  │  └──────────────────────────────────────────┘   │   │
│  └──────────────────────────────────────────────────┘   │
│                          ▲                                │
│                          │                                │
│  ┌──────────────────────────────────────────────────┐   │
│  │         Data Models (Codable Structs)             │   │
│  │  ┌──────────────┐  ┌──────────────────────────┐  │   │
│  │  │StatusResponse│  │ConfigResponse            │  │   │
│  │  │PreferencesUp │  │HealthResponse            │  │   │
│  │  │ LogsResponse │  │APIError                  │  │   │
│  │  └──────────────┘  └──────────────────────────┘  │   │
│  │  ┌──────────────┐                                 │   │
│  │  │MonitorStatus │ (Helper models)                │   │
│  │  │MonitorConfig │                                 │   │
│  │  └──────────────┘                                 │   │
│  └──────────────────────────────────────────────────┘   │
│                          ▲                                │
│                          │ URLSession                     │
│                          │ HTTP Requests                  │
│                          │ JSON Encoding/Decoding         │
└──────────────────────────────────────────────────────────┘
                           │
                           ▼
              ┌────────────────────────────┐
              │   Network (WiFi/LTE)       │
              └────────────────────────────┘
                           │
                           ▼
              ┌────────────────────────────┐
              │  Tennis Monitor Backend    │
              │  (REST API - FastAPI)      │
              │                            │
              │  /api/status               │
              │  /api/config               │
              │  /api/monitor/start|stop   │
              │  /api/monitor/logs         │
              │  /api/config/preferences   │
              └────────────────────────────┘
```

## Component Architecture

### 1. View Layer (SwiftUI)

**Responsibility:** User interface and user interaction

**Files:**
- `Sources/Views/HomeView.swift` - Monitor status and control UI
- `Sources/Views/SettingsView.swift` - Configuration UI
- `Sources/Views/LogsView.swift` - Logs display UI

**Key Concepts:**
- SwiftUI declarative UI
- @State for local state
- @StateObject for ViewModel binding
- Reactive updates through @Published properties
- NavigationStack for routing

### 2. ViewModel Layer (MVVM Pattern)

**Responsibility:** Business logic, state management, API interaction coordination

**Files:**
- `Sources/Views/HomeViewModel.swift` - Manages monitor status state
- `Sources/Views/SettingsViewModel.swift` - Manages settings state
- `Sources/Views/LogsViewModel.swift` - Manages logs state

**Key Concepts:**
- @MainActor for UI thread safety
- @Published properties for reactive updates
- async/await for asynchronous operations
- Auto-refresh timers
- Error handling and user feedback

**Example ViewModel Flow:**
```swift
HomeViewModel:
  1. View calls viewModel.refreshStatus()
  2. ViewModel sets @Published isLoading = true
  3. ViewModel calls apiClient.getStatus()
  4. APIClient makes HTTP request
  5. ViewModel updates @Published status with response
  6. View re-renders with new data
  7. ViewModel sets isLoading = false
```

### 3. Networking Layer (APIClient)

**Responsibility:** HTTP communication with backend, request/response handling

**Files:**
- `Sources/Networking/APIClient.swift`

**Key Methods:**
```swift
// Configuration
configure(baseURL:apiKey:)
isConfigured() -> Bool

// Monitor Control
getStatus() async throws -> MonitorStatus
startMonitor() async throws
stopMonitor() async throws

// Configuration
getConfig() async throws -> MonitorConfig
updatePreferences(...) async throws

// Logs
getLogs(lines:) async throws -> [String]

// Health Check
healthCheck() async throws -> HealthResponse
```

**Key Concepts:**
- Singleton pattern for global API access
- Async/await for async operations
- URLSession for HTTP requests
- Automatic JSON encoding/decoding
- X-Token authentication header
- Custom error types (APIError enum)

**Authentication Flow:**
```swift
1. APIClient.configure() stores baseURL and apiKey
2. Each authenticated request adds:
   - "X-Token: \(apiKey)" header
   - "Content-Type: application/json"
3. Response parsed and decoded
4. Errors caught and converted to APIError
```

### 4. Data Model Layer

**Responsibility:** Data structure definitions and transformations

**Files:**
- `Sources/Models/APIModels.swift`

**API Response Models:**
- `StatusResponse` - Raw API response for /api/status
- `ConfigResponse` - Raw API response for /api/config
- `HealthResponse` - Raw API response for /health
- `LogsResponse` - Raw API response for /api/monitor/logs
- `PreferencesUpdate` - Request body for preferences update

**Helper Models:**
- `MonitorStatus` - User-friendly status with Date formatting
- `MonitorConfig` - User-friendly config with array handling

**Key Concepts:**
- Codable protocol for JSON encoding/decoding
- Automatic snake_case to camelCase conversion
- Type safety with Swift's strong typing

## Data Flow Diagrams

### Status Update Flow

```
User opens Monitor tab
         │
         ▼
HomeView.onAppear calls
viewModel.loadInitialData()
         │
         ▼
HomeViewModel:
1. Set isLoading = true
2. Call apiClient.getStatus()
         │
         ▼
APIClient:
1. Build URL: baseURL + "/api/status"
2. Create URLRequest with X-Token header
3. URLSession.data(for:) makes HTTP GET
         │
         ▼
Backend processes request
Returns: { "is_running": true, ... }
         │
         ▼
APIClient:
1. Decode JSON to StatusResponse
2. Transform to MonitorStatus
3. Return to ViewModel
         │
         ▼
HomeViewModel:
1. Update @Published status property
2. Set isLoading = false
3. Start 10-second auto-refresh timer
         │
         ▼
SwiftUI detects @Published change
View re-renders automatically
HomeView displays new status
```

### Settings Update Flow

```
User enters API key and clicks "Test Connection"
         │
         ▼
SettingsView.testConnection() calls
viewModel.testConnection()
         │
         ▼
SettingsViewModel:
1. Save credentials to UserDefaults
2. Configure APIClient
3. Call apiClient.healthCheck()
         │
         ▼
APIClient:
1. Make GET request to /health
2. Decode response
3. Return HealthResponse
         │
         ▼
SettingsViewModel:
1. If successful: Set connectionTestPassed = true
2. Load full config with loadConfig()
3. Display success message
         │
         ▼
View updates with success state
```

### Preferences Save Flow

```
User changes courts and clicks "Save Changes"
         │
         ▼
SettingsView.savePreferences() calls
viewModel.savePreferences()
         │
         ▼
SettingsViewModel:
1. Parse input strings (split by comma, trim)
2. Build PreferencesUpdate request body
3. Call apiClient.updatePreferences()
         │
         ▼
APIClient:
1. Build URL: /api/config/preferences
2. JSON encode PreferencesUpdate body
3. Create URLRequest (POST, X-Token header)
4. URLSession.data() makes request
         │
         ▼
Backend:
1. Validate input
2. Update preferences in config
3. Return updated ConfigResponse
         │
         ▼
APIClient:
1. Decode response to ConfigResponse
2. Transform to MonitorConfig
         │
         ▼
SettingsViewModel:
1. Update @Published config
2. Show success message
3. UI re-renders with new values
```

## Error Handling Strategy

### Error Types

```swift
enum APIError: LocalizedError {
    case invalidURL
    case invalidResponse
    case decodingError(String)
    case networkError(String)
    case authenticationError
    case serverError(Int)
    case unknownError
}
```

### Error Flow

```
API Request fails
         │
         ▼
Catch URLSession error
         │
         ▼
Convert to appropriate APIError
         │
         ▼
Throw to ViewModel
         │
         ▼
ViewModel catches
         │
         ▼
Set @Published errorMessage
         │
         ▼
View displays error to user
```

## State Management

### HomeViewModel State

```swift
@Published var status: MonitorStatus?
@Published var isLoading: Bool
@Published var errorMessage: String?
```

### SettingsViewModel State

```swift
@Published var apiKey: String
@Published var baseURL: String
@Published var config: MonitorConfig?
@Published var preferredCourts: String
@Published var preferredTimeSlots: String
@Published var checkInterval: String
@Published var aliveCheckHour: String
@Published var isLoading: Bool
@Published var errorMessage: String?
@Published var successMessage: String?
@Published var connectionTestPassed: Bool
```

### LogsViewModel State

```swift
@Published var logs: [String]
@Published var isLoading: Bool
@Published var errorMessage: String?
@Published var lineCount: Int
```

## Async/Await Pattern

All network operations use Swift's async/await:

```swift
// ViewModel calls async function
Task {
    await viewModel.refreshStatus()
}

// ViewModel implementation
func refreshStatus() async {
    do {
        status = try await apiClient.getStatus()
        errorMessage = nil
    } catch {
        errorMessage = error.localizedDescription
    }
}

// APIClient implementation
func getStatus() async throws -> MonitorStatus {
    let response: StatusResponse = try await performAuthenticatedRequest(...)
    return MonitorStatus(from: response)
}
```

## Storage

### UserDefaults (Local Storage)

Credentials stored locally:
```swift
UserDefaults.standard.string(forKey: "apiKey")
UserDefaults.standard.string(forKey: "baseURL")
```

**Note:** For production, use iOS Keychain instead.

### In-Memory (During Session)

ViewModels hold state during app session:
- Current status
- Current configuration
- Logs
- Error messages

## Scalability Considerations

### Current Design Supports:

- ✅ Multiple backends (by changing URL/API key)
- ✅ Real-time updates (auto-refresh timers)
- ✅ Offline detection (error messages)
- ✅ Custom error messages

### Future Enhancements:

- Add Keychain for secure credential storage
- Add offline caching with local storage
- Add custom notification handling
- Add app widget support
- Add Siri shortcuts integration

## Testing Strategy

### Current Implementation

No unit tests yet, but architecture supports:

```swift
// Mock APIClient for testing
class MockAPIClient: APIClientProtocol {
    func getStatus() async throws -> MonitorStatus {
        // Return test data
    }
}

// Inject into ViewModel for testing
@StateObject var viewModel = HomeViewModel(apiClient: MockAPIClient())
```

### Test Areas:

1. **ViewModels:** State management, API calls
2. **APIClient:** HTTP requests, error handling, JSON decoding
3. **Views:** UI state, button interactions
4. **Models:** JSON encoding/decoding roundtrips

## Performance Optimization

### Current Optimizations:

1. **Lazy Loading:** Views load only when needed
2. **Auto-Refresh Timers:** Don't refresh on background
3. **Error Early:** Validate API key before making requests
4. **Singleton APIClient:** Reuse across app

### Potential Improvements:

1. Cache responses with TTL
2. Implement request debouncing
3. Add image optimization
4. Use lazy view loading
5. Profile with Xcode Instruments

## Security Considerations

### Current Implementation:

- ✅ API key sent in secure HTTP header (X-Token)
- ✅ Supports HTTPS connections
- ✅ No API key shown in logs

### Recommendations:

- 🔒 Use iOS Keychain for credential storage (not UserDefaults)
- 🔒 Implement certificate pinning for HTTPS
- 🔒 Add request signing/HMAC
- 🔒 Implement session timeout
- 🔒 Add rate limiting

---

**Version:** 1.0  
**Last Updated:** December 2025
