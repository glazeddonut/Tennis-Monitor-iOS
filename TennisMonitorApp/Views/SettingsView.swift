import SwiftUI

struct SettingsView: View {
    @StateObject private var viewModel = SettingsViewModel()
    @State private var showApiKeyDialog = false
    
    var body: some View {
        NavigationStack {
            Form {
                // API Configuration Section
                Section(header: Text("Connection")) {
                    VStack(alignment: .leading, spacing: 8) {
                        Label("API Key", systemImage: "key.fill")
                        HStack {
                            if viewModel.showApiKey {
                                TextField("API Key", text: $viewModel.apiKey)
                                    .font(.system(.caption, design: .monospaced))
                            } else {
                                SecureField("API Key", text: $viewModel.apiKey)
                                    .font(.system(.caption, design: .monospaced))
                            }
                            Button(action: { viewModel.showApiKey.toggle() }) {
                                Image(systemName: viewModel.showApiKey ? "eye.slash" : "eye")
                            }
                        }
                    }
                    
                    VStack(alignment: .leading, spacing: 8) {
                        Label("Base URL", systemImage: "globe")
                        TextField("http://192.168.1.100:8000", text: $viewModel.baseURL)
                            .font(.system(.caption, design: .monospaced))
                    }
                    
                    Button(action: {
                        Task {
                            await viewModel.testConnection()
                        }
                    }) {
                        HStack {
                            Image(systemName: "checkmark.circle.fill")
                            Text("Test Connection")
                        }
                    }
                    .disabled(viewModel.isLoading)
                    
                    if viewModel.connectionTestPassed {
                        HStack {
                            Image(systemName: "checkmark.circle.fill")
                                .foregroundColor(.green)
                            Text("Connection OK")
                                .foregroundColor(.green)
                        }
                    }
                }
                
                // Monitor Preferences Section
                if let config = viewModel.config {
                    Section(header: Text("Monitor Preferences")) {
                        VStack(alignment: .leading, spacing: 8) {
                            Label("Preferred Courts", systemImage: "building.2")
                            TextField("Court11, Court12", text: $viewModel.preferredCourts)
                        }
                        
                        VStack(alignment: .leading, spacing: 8) {
                            Label("Preferred Times", systemImage: "clock")
                            TextField("18:00, 19:00, 20:00", text: $viewModel.preferredTimeSlots)
                        }
                        
                        VStack(alignment: .leading, spacing: 8) {
                            Label("Check Interval", systemImage: "timer")
                            HStack {
                                TextField("300", text: $viewModel.checkInterval)
                                    .keyboardType(.numberPad)
                                Text("seconds")
                                    .foregroundColor(.gray)
                            }
                        }
                        
                        VStack(alignment: .leading, spacing: 8) {
                            Label("Alive Check Hour", systemImage: "calendar")
                            HStack {
                                TextField("10", text: $viewModel.aliveCheckHour)
                                    .keyboardType(.numberPad)
                                Text("(0-23)")
                                    .foregroundColor(.gray)
                            }
                        }
                    }
                    
                    // Additional Info Section
                    Section(header: Text("Current Configuration")) {
                        VStack(alignment: .leading, spacing: 8) {
                            HStack {
                                Text("Auto-Booking")
                                    .foregroundColor(.gray)
                                Spacer()
                                Text(config.autoBookEnabled ? "Enabled" : "Disabled")
                                    .fontWeight(.semibold)
                            }
                            
                            HStack {
                                Text("Alive Check")
                                    .foregroundColor(.gray)
                                Spacer()
                                Text(config.aliveCheckEnabled ? "Enabled" : "Disabled")
                                    .fontWeight(.semibold)
                            }
                        }
                    }
                }
                
                // Save Button
                Section {
                    Button(action: {
                        Task {
                            await viewModel.savePreferences()
                        }
                    }) {
                        HStack {
                            Image(systemName: "checkmark.circle.fill")
                            Text("Save Changes")
                        }
                    }
                    .frame(maxWidth: .infinity)
                    .disabled(viewModel.isLoading)
                }
                
                // Messages
                if let error = viewModel.errorMessage {
                    Section {
                        HStack {
                            Image(systemName: "exclamationmark.circle.fill")
                                .foregroundColor(.red)
                            Text(error)
                                .foregroundColor(.red)
                        }
                    }
                }
                
                if let success = viewModel.successMessage {
                    Section {
                        HStack {
                            Image(systemName: "checkmark.circle.fill")
                                .foregroundColor(.green)
                            Text(success)
                                .foregroundColor(.green)
                        }
                    }
                }
            }
            .navigationTitle("Settings")
            .onAppear {
                Task {
                    await viewModel.loadConfig()
                }
            }
        }
    }
}

#Preview {
    SettingsView()
}
