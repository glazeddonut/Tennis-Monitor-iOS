import Foundation
import SwiftUI

@MainActor
class LogsViewModel: ObservableObject {
    @Published var logs: [String] = []
    @Published var isLoading = false
    @Published var errorMessage: String?
    @Published var lineCount = 50
    
    private let apiClient = APIClient.shared
    private var refreshTask: Task<Void, Never>?
    
    func refreshLogs() async {
        isLoading = true
        errorMessage = nil
        
        do {
            logs = try await apiClient.getLogs(lines: lineCount)
            isLoading = false
        } catch {
            errorMessage = error.localizedDescription
            isLoading = false
        }
    }
    
    func startAutoRefresh() {
        refreshTask?.cancel()
        refreshTask = Task {
            while !Task.isCancelled {
                try? await Task.sleep(nanoseconds: 5_000_000_000) // 5 seconds
                if !Task.isCancelled {
                    await refreshLogs()
                }
            }
        }
    }
    
    deinit {
        refreshTask?.cancel()
    }
}
