import Foundation
import Models
import Networking

@MainActor
class SettingsViewModel: ObservableObject {
    @Published var apiKey = UserDefaults.standard.string(forKey: "apiKey") ?? ""
    @Published var baseURL = UserDefaults.standard.string(forKey: "baseURL") ?? ""
    @Published var showApiKey = false
    @Published var config: MonitorConfig?
    @Published var isLoading = false
    @Published var errorMessage: String?
    @Published var successMessage: String?
    @Published var connectionTestPassed = false
    
    @Published var preferredCourts = ""
    @Published var preferredTimeSlots = ""
    @Published var checkInterval = "300"
    @Published var aliveCheckHour = "10"
    
    private let apiClient = APIClient.shared
    
    func loadConfig() async {
        isLoading = true
        do {
            config = try await apiClient.getConfig()
            preferredCourts = config?.preferredCourts.joined(separator: ", ") ?? ""
            preferredTimeSlots = config?.preferredTimeSlots.joined(separator: ", ") ?? ""
            checkInterval = String(config?.checkIntervalSeconds ?? 300)
            aliveCheckHour = String(config?.aliveCheckHour ?? 10)
            errorMessage = nil
            isLoading = false
        } catch {
            errorMessage = "Failed to load configuration: \(error.localizedDescription)"
            isLoading = false
        }
    }
    
    func testConnection() async {
        isLoading = true
        errorMessage = nil
        successMessage = nil
        
        // Save credentials
        UserDefaults.standard.set(apiKey, forKey: "apiKey")
        UserDefaults.standard.set(baseURL, forKey: "baseURL")
        
        apiClient.configure(baseURL: baseURL, apiKey: apiKey)
        
        do {
            let _: HealthResponse = try await apiClient.healthCheck()
            connectionTestPassed = true
            successMessage = "Connected successfully!"
            await loadConfig()
            isLoading = false
        } catch {
            connectionTestPassed = false
            errorMessage = "Connection failed: \(error.localizedDescription)"
            isLoading = false
        }
    }
    
    func savePreferences() async {
        isLoading = true
        errorMessage = nil
        successMessage = nil
        
        let courts = preferredCourts
            .split(separator: ",")
            .map { $0.trimmingCharacters(in: .whitespaces) }
            .filter { !$0.isEmpty }
        
        let times = preferredTimeSlots
            .split(separator: ",")
            .map { $0.trimmingCharacters(in: .whitespaces) }
            .filter { !$0.isEmpty }
        
        let interval = Int(checkInterval) ?? 300
        let hour = Int(aliveCheckHour) ?? 10
        
        do {
            config = try await apiClient.updatePreferences(
                courts: courts.isEmpty ? nil : courts,
                timeSlots: times.isEmpty ? nil : times,
                checkInterval: interval,
                aliveCheckHour: hour
            )
            successMessage = "Settings saved successfully!"
            isLoading = false
        } catch {
            errorMessage = "Failed to save settings: \(error.localizedDescription)"
            isLoading = false
        }
    }
}
