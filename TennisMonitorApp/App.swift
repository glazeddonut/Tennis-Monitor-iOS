import SwiftUI

@main
struct TennisMonitorApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
                .preferredColorScheme(nil)
        }
    }
}

struct ContentView: View {
    @State private var selectedTab: Tab = .home
    
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
