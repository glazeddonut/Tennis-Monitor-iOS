import SwiftUI
import Models
import Networking
import Views

@main
struct TennisMonitorApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
                .preferredColorScheme(nil) // Allow system light/dark mode
        }
    }
}

struct ContentView: View {
    @State private var selectedTab: Tab = .home
    @State private var isFirstLaunch = true
    
    enum Tab: Hashable {
        case home
        case settings
        case logs
    }
    
    var body: some View {
        TabView(selection: $selectedTab) {
            HomeView()
                .tabItem {
                    Label("Monitor", systemImage: "play.rectangle.fill")
                }
                .tag(Tab.home)
            
            SettingsView()
                .tabItem {
                    Label("Settings", systemImage: "gear")
                }
                .tag(Tab.settings)
            
            LogsView()
                .tabItem {
                    Label("Logs", systemImage: "doc.text")
                }
                .tag(Tab.logs)
        }
        .onAppear {
            // Configure API client on app launch
            let apiKey = UserDefaults.standard.string(forKey: "apiKey") ?? ""
            let baseURL = UserDefaults.standard.string(forKey: "baseURL") ?? ""
            
            if !apiKey.isEmpty && !baseURL.isEmpty {
                APIClient.shared.configure(baseURL: baseURL, apiKey: apiKey)
            }
        }
    }
}

#Preview {
    ContentView()
}
