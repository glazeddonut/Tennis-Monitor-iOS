import SwiftUI

struct HomeView: View {
    @StateObject private var viewModel = HomeViewModel()
    @State private var isRefreshing = false
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 16) {
                    // Status Card
                    if let status = viewModel.status {
                        StatusCard(status: status)
                    } else {
                        StatusCardPlaceholder()
                    }
                    
                    // Quick Stats
                    HStack(spacing: 12) {
                        StatCard(
                            icon: "checkmark.circle.fill",
                            title: "Checks Today",
                            value: String(viewModel.status?.checksPerformedToday ?? 0),
                            color: .blue
                        )
                        
                        StatCard(
                            icon: "star.fill",
                            title: "Slots Found",
                            value: String(viewModel.status?.slotsFoundToday ?? 0),
                            color: .green
                        )
                    }
                    
                    // Control Buttons
                    VStack(spacing: 12) {
                        if viewModel.status?.isRunning == true {
                            Button(action: {
                                Task {
                                    await viewModel.stopMonitor()
                                }
                            }) {
                                HStack {
                                    Image(systemName: "stop.circle.fill")
                                    Text("Stop Monitor")
                                }
                                .frame(maxWidth: .infinity)
                                .padding()
                                .background(Color.red.opacity(0.1))
                                .foregroundColor(.red)
                                .cornerRadius(8)
                            }
                            .disabled(viewModel.isLoading)
                        } else {
                            Button(action: {
                                Task {
                                    await viewModel.startMonitor()
                                }
                            }) {
                                HStack {
                                    Image(systemName: "play.circle.fill")
                                    Text("Start Monitor")
                                }
                                .frame(maxWidth: .infinity)
                                .padding()
                                .background(Color.green.opacity(0.1))
                                .foregroundColor(.green)
                                .cornerRadius(8)
                            }
                            .disabled(viewModel.isLoading)
                        }
                    }
                    
                    // Error Message
                    if let error = viewModel.errorMessage {
                        HStack {
                            Image(systemName: "exclamationmark.circle.fill")
                            Text(error)
                        }
                        .foregroundColor(.red)
                        .padding()
                        .background(Color.red.opacity(0.1))
                        .cornerRadius(8)
                    }
                    
                    Spacer()
                }
                .padding()
            }
            .navigationTitle("Tennis Monitor")
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button(action: {
                        Task {
                            await viewModel.refreshStatus()
                        }
                    }) {
                        Image(systemName: "arrow.clockwise")
                            .rotationEffect(.degrees(isRefreshing ? 360 : 0))
                            .animation(.linear(duration: 1), value: isRefreshing)
                    }
                    .disabled(viewModel.isLoading)
                }
            }
        }
        .onAppear {
            Task {
                await viewModel.loadInitialData()
            }
        }
    }
}

// MARK: - Component Views

struct StatusCard: View {
    let status: MonitorStatus
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                VStack(alignment: .leading, spacing: 4) {
                    Text("Monitor Status")
                        .font(.headline)
                    HStack {
                        Circle()
                            .fill(status.isRunning ? Color.green : Color.gray)
                            .frame(width: 12, height: 12)
                        Text(status.isRunning ? "Running" : "Stopped")
                            .font(.subheadline)
                    }
                }
                Spacer()
                VStack(alignment: .trailing, spacing: 4) {
                    Text("Next Check")
                        .font(.caption)
                        .foregroundColor(.gray)
                    Text("\(status.nextCheckInSeconds)s")
                        .font(.headline)
                }
            }
            
            Divider()
            
            VStack(alignment: .leading, spacing: 4) {
                Text("Last Updated")
                    .font(.caption)
                    .foregroundColor(.gray)
                Text(formattedDate(status.lastUpdate))
                    .font(.caption)
            }
        }
        .padding()
        .background(Color(.systemGray6))
        .cornerRadius(12)
    }
    
    private func formattedDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.timeStyle = .short
        formatter.dateStyle = .short
        return formatter.string(from: date)
    }
}

struct StatusCardPlaceholder: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                VStack(alignment: .leading, spacing: 4) {
                    Text("Monitor Status")
                        .font(.headline)
                    Text("Loading...")
                        .font(.subheadline)
                        .foregroundColor(.gray)
                }
                Spacer()
            }
        }
        .padding()
        .background(Color(.systemGray6))
        .cornerRadius(12)
        .redacted(reason: .placeholder)
    }
}

struct StatCard: View {
    let icon: String
    let title: String
    let value: String
    let color: Color
    
    var body: some View {
        VStack(alignment: .center, spacing: 8) {
            Image(systemName: icon)
                .font(.title2)
                .foregroundColor(color)
            
            Text(title)
                .font(.caption)
                .foregroundColor(.gray)
            
            Text(value)
                .font(.headline)
        }
        .frame(maxWidth: .infinity)
        .padding()
        .background(Color(.systemGray6))
        .cornerRadius(12)
    }
}

#Preview {
    HomeView()
}
