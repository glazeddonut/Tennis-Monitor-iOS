import Foundation
import SwiftUI

@MainActor
class HomeViewModel: ObservableObject {
    @Published var status: MonitorStatus?
    @Published var isLoading = false
    @Published var errorMessage: String?
    
    private let apiClient = APIClient.shared
    private var refreshTask: Task<Void, Never>?
    
    func loadInitialData() async {
        isLoading = true
        await refreshStatus()
        startAutoRefresh()
    }
    
    func refreshStatus() async {
        do {
            status = try await apiClient.getStatus()
            errorMessage = nil
            isLoading = false
        } catch {
            errorMessage = error.localizedDescription
            isLoading = false
        }
    }
    
    func startMonitor() async {
        isLoading = true
        do {
            try await apiClient.startMonitor()
            await refreshStatus()
        } catch {
            errorMessage = "Failed to start monitor: \(error.localizedDescription)"
            isLoading = false
        }
    }
    
    func stopMonitor() async {
        isLoading = true
        do {
            try await apiClient.stopMonitor()
            await refreshStatus()
        } catch {
            errorMessage = "Failed to stop monitor: \(error.localizedDescription)"
            isLoading = false
        }
    }
    
    private func startAutoRefresh() {
        refreshTask?.cancel()
        refreshTask = Task {
            while !Task.isCancelled {
                try? await Task.sleep(nanoseconds: 10_000_000_000) // 10 seconds
                if !Task.isCancelled {
                    await refreshStatus()
                }
            }
        }
    }
    
    deinit {
        refreshTask?.cancel()
    }
}
