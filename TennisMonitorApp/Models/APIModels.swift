import Foundation

// MARK: - API Response Models

public struct StatusResponse: Codable {
    public let is_running: Bool
    public let checks_performed_today: Int
    public let slots_found_today: Int
    public let last_update: String
    public let next_check_in_seconds: Int
}

public struct ConfigResponse: Codable {
    public let booking_system_url: String
    public let preferred_courts: [String]
    public let preferred_time_slots: [String]
    public let check_interval_seconds: Int
    public let auto_book_enabled: Bool
    public let alive_check_enabled: Bool
    public let alive_check_hour: Int
}

public struct HealthResponse: Codable {
    public let status: String
    public let timestamp: String
    public let monitor_running: Bool
}

public struct LogsResponse: Codable {
    public let logs: [String]
    public let total_lines: Int
    public let returned_lines: Int
    public let error: String?
}

// MARK: - API Request Models

public struct PreferencesUpdate: Codable {
    public let preferred_courts: [String]?
    public let preferred_time_slots: [String]?
    public let check_interval_seconds: Int?
    public let alive_check_hour: Int?
    
    public init(preferred_courts: [String]? = nil, preferred_time_slots: [String]? = nil, check_interval_seconds: Int? = nil, alive_check_hour: Int? = nil) {
        self.preferred_courts = preferred_courts
        self.preferred_time_slots = preferred_time_slots
        self.check_interval_seconds = check_interval_seconds
        self.alive_check_hour = alive_check_hour
    }
}

public struct APIResponse<T: Codable>: Codable {
    public let status: String
    public let data: T?
    public let error: String?
}

// MARK: - Helper Models

public struct MonitorStatus {
    public let isRunning: Bool
    public let checksPerformedToday: Int
    public let slotsFoundToday: Int
    public let lastUpdate: Date
    public let nextCheckInSeconds: Int
    
    public init(from response: StatusResponse) {
        self.isRunning = response.is_running
        self.checksPerformedToday = response.checks_performed_today
        self.slotsFoundToday = response.slots_found_today
        
        let dateFormatter = ISO8601DateFormatter()
        self.lastUpdate = dateFormatter.date(from: response.last_update) ?? Date()
        self.nextCheckInSeconds = response.next_check_in_seconds
    }
}

public struct MonitorConfig {
    public let bookingSystemURL: String
    public let preferredCourts: [String]
    public let preferredTimeSlots: [String]
    public let checkIntervalSeconds: Int
    public let autoBookEnabled: Bool
    public let aliveCheckEnabled: Bool
    public let aliveCheckHour: Int
    
    public init(from response: ConfigResponse) {
        self.bookingSystemURL = response.booking_system_url
        self.preferredCourts = response.preferred_courts
        self.preferredTimeSlots = response.preferred_time_slots
        self.checkIntervalSeconds = response.check_interval_seconds
        self.autoBookEnabled = response.auto_book_enabled
        self.aliveCheckEnabled = response.alive_check_enabled
        self.aliveCheckHour = response.alive_check_hour
    }
}

// MARK: - Error Handling

enum APIError: LocalizedError {
    case invalidURL
    case invalidResponse
    case decodingError(String)
    case networkError(String)
    case authenticationError
    case serverError(Int)
    case unknownError
    
    var errorDescription: String? {
        switch self {
        case .invalidURL:
            return "Invalid URL"
        case .invalidResponse:
            return "Invalid server response"
        case .decodingError(let message):
            return "Failed to parse response: \(message)"
        case .networkError(let message):
            return "Network error: \(message)"
        case .authenticationError:
            return "Authentication failed - Invalid API key"
        case .serverError(let code):
            return "Server error: HTTP \(code)"
        case .unknownError:
            return "Unknown error occurred"
        }
    }
}
