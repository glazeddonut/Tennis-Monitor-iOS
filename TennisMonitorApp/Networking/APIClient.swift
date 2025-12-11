import Foundation

public class APIClient {
    public static let shared = APIClient()
    
    private var baseURL: URL?
    private var apiKey: String = ""
    
    public init() {}
    
    // MARK: - Configuration
    
    public func configure(baseURL: String, apiKey: String) {
        if let url = URL(string: baseURL) {
            self.baseURL = url
            self.apiKey = apiKey
        }
    }
    
    public func isConfigured() -> Bool {
        return baseURL != nil && !apiKey.isEmpty
    }
    
    // MARK: - Health Check
    
    public func healthCheck() async throws -> HealthResponse {
        guard let baseURL = baseURL else {
            throw APIError.invalidURL
        }
        
        let url = baseURL.appendingPathComponent("health")
        return try await performRequest(url: url, method: "GET")
    }
    
    // MARK: - Monitor Status & Control
    
    public func getStatus() async throws -> MonitorStatus {
        let response: StatusResponse = try await performAuthenticatedRequest(
            endpoint: "/api/status",
            method: "GET"
        )
        return MonitorStatus(from: response)
    }
    
    public func startMonitor() async throws {
        struct StartResponse: Codable {
            let status: String
        }
        let _: StartResponse = try await performAuthenticatedRequest(
            endpoint: "/api/monitor/start",
            method: "POST"
        )
    }
    
    public func stopMonitor() async throws {
        struct StopResponse: Codable {
            let status: String
        }
        let _: StopResponse = try await performAuthenticatedRequest(
            endpoint: "/api/monitor/stop",
            method: "POST"
        )
    }
    
    // MARK: - Configuration
    
    public func getConfig() async throws -> MonitorConfig {
        let response: ConfigResponse = try await performAuthenticatedRequest(
            endpoint: "/api/config",
            method: "GET"
        )
        return MonitorConfig(from: response)
    }
    
    public func updatePreferences(
        courts: [String]? = nil,
        timeSlots: [String]? = nil,
        checkInterval: Int? = nil,
        aliveCheckHour: Int? = nil
    ) async throws -> MonitorConfig {
        let update = PreferencesUpdate(
            preferred_courts: courts,
            preferred_time_slots: timeSlots,
            check_interval_seconds: checkInterval,
            alive_check_hour: aliveCheckHour
        )
        
        let response: ConfigResponse = try await performAuthenticatedRequest(
            endpoint: "/api/config/preferences",
            method: "POST",
            body: update
        )
        return MonitorConfig(from: response)
    }
    
    // MARK: - Logs
    
    public func getLogs(lines: Int = 50) async throws -> [String] {
        guard let baseURL = baseURL else {
            throw APIError.invalidURL
        }
        
        var components = URLComponents(url: baseURL.appendingPathComponent("api/monitor/logs"), resolvingAgainstBaseURL: true)
        components?.queryItems = [URLQueryItem(name: "lines", value: String(lines))]
        
        guard let url = components?.url else {
            throw APIError.invalidURL
        }
        
        let response: LogsResponse = try await performAuthenticatedRequest(
            url: url,
            method: "GET"
        )
        return response.logs
    }
    
    // MARK: - Private Helper Methods
    
    private func performRequest<T: Decodable>(
        url: URL,
        method: String = "GET",
        body: Encodable? = nil
    ) async throws -> T {
        var request = URLRequest(url: url)
        request.httpMethod = method
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        if let body = body {
            request.httpBody = try JSONEncoder().encode(body)
        }
        
        do {
            let (data, response) = try await URLSession.shared.data(for: request)
            
            guard let httpResponse = response as? HTTPURLResponse else {
                throw APIError.invalidResponse
            }
            
            switch httpResponse.statusCode {
            case 200...299:
                break
            case 403:
                throw APIError.authenticationError
            case 400...499:
                throw APIError.serverError(httpResponse.statusCode)
            case 500...599:
                throw APIError.serverError(httpResponse.statusCode)
            default:
                throw APIError.serverError(httpResponse.statusCode)
            }
            
            let decoder = JSONDecoder()
            return try decoder.decode(T.self, from: data)
        } catch let error as APIError {
            throw error
        } catch let decodingError as DecodingError {
            throw APIError.decodingError(decodingError.localizedDescription)
        } catch {
            throw APIError.networkError(error.localizedDescription)
        }
    }
    
    private func performAuthenticatedRequest<T: Decodable>(
        endpoint: String,
        method: String = "GET",
        body: Encodable? = nil
    ) async throws -> T {
        guard let baseURL = baseURL else {
            throw APIError.invalidURL
        }
        
        let url = baseURL.appendingPathComponent(endpoint)
        return try await performAuthenticatedRequest(url: url, method: method, body: body)
    }
    
    private func performAuthenticatedRequest<T: Decodable>(
        url: URL,
        method: String = "GET",
        body: Encodable? = nil
    ) async throws -> T {
        var request = URLRequest(url: url)
        request.httpMethod = method
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue(apiKey, forHTTPHeaderField: "X-Token")
        
        if let body = body {
            request.httpBody = try JSONEncoder().encode(body)
        }
        
        do {
            let (data, response) = try await URLSession.shared.data(for: request)
            
            guard let httpResponse = response as? HTTPURLResponse else {
                throw APIError.invalidResponse
            }
            
            switch httpResponse.statusCode {
            case 200...299:
                break
            case 403:
                throw APIError.authenticationError
            case 400...499:
                throw APIError.serverError(httpResponse.statusCode)
            case 500...599:
                throw APIError.serverError(httpResponse.statusCode)
            default:
                throw APIError.serverError(httpResponse.statusCode)
            }
            
            let decoder = JSONDecoder()
            return try decoder.decode(T.self, from: data)
        } catch let error as APIError {
            throw error
        } catch let decodingError as DecodingError {
            throw APIError.decodingError(decodingError.localizedDescription)
        } catch {
            throw APIError.networkError(error.localizedDescription)
        }
    }
}
