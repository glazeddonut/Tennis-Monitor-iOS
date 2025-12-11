import SwiftUI

struct LogsView: View {
    @StateObject private var viewModel = LogsViewModel()
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 12) {
                HStack {
                    Button(action: {
                        Task {
                            await viewModel.refreshLogs()
                        }
                    }) {
                        HStack {
                            Image(systemName: "arrow.clockwise")
                            Text("Refresh")
                        }
                        .font(.subheadline)
                    }
                    .disabled(viewModel.isLoading)
                    
                    Spacer()
                    
                    Menu {
                        Button(action: { viewModel.lineCount = 20 }) {
                            HStack {
                                if viewModel.lineCount == 20 {
                                    Image(systemName: "checkmark")
                                }
                                Text("Last 20 lines")
                            }
                        }
                        Button(action: { viewModel.lineCount = 50 }) {
                            HStack {
                                if viewModel.lineCount == 50 {
                                    Image(systemName: "checkmark")
                                }
                                Text("Last 50 lines")
                            }
                        }
                        Button(action: { viewModel.lineCount = 100 }) {
                            HStack {
                                if viewModel.lineCount == 100 {
                                    Image(systemName: "checkmark")
                                }
                                Text("Last 100 lines")
                            }
                        }
                    } label: {
                        HStack {
                            Image(systemName: "line.3.horizontal.decrease.circle")
                            Text("Filter")
                        }
                        .font(.subheadline)
                    }
                }
                .padding(.horizontal)
                .padding(.vertical, 8)
                
                if viewModel.logs.isEmpty {
                    VStack(spacing: 12) {
                        Image(systemName: "doc.text")
                            .font(.system(size: 48))
                            .foregroundColor(.gray)
                        Text("No logs available")
                            .foregroundColor(.gray)
                        Text("Check back when the monitor is running")
                            .font(.caption)
                            .foregroundColor(.gray)
                    }
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                } else {
                    ScrollViewReader { reader in
                        ScrollView {
                            VStack(alignment: .leading, spacing: 0) {
                                ForEach(viewModel.logs.indices, id: \.self) { index in
                                    LogLineView(text: viewModel.logs[index])
                                        .id(index)
                                }
                            }
                            .font(.system(.caption, design: .monospaced))
                            .padding(.horizontal, 8)
                            .padding(.vertical, 12)
                        }
                        .onAppear {
                            if let lastIndex = viewModel.logs.indices.last {
                                reader.scrollTo(lastIndex, anchor: .bottom)
                            }
                        }
                    }
                }
                
                if let error = viewModel.errorMessage {
                    HStack {
                        Image(systemName: "exclamationmark.circle.fill")
                        Text(error)
                    }
                    .font(.caption)
                    .foregroundColor(.red)
                    .padding()
                    .background(Color.red.opacity(0.1))
                    .cornerRadius(6)
                    .padding(.horizontal)
                }
            }
            .navigationTitle("Logs")
            .onAppear {
                Task {
                    await viewModel.refreshLogs()
                }
            }
        }
    }
}

// MARK: - Log Line Component

struct LogLineView: View {
    let text: String
    
    var body: some View {
        HStack(alignment: .top, spacing: 8) {
            VStack(alignment: .leading, spacing: 2) {
                Text(text)
                    .lineLimit(nil)
                    .textSelection(.enabled)
            }
            Spacer(minLength: 0)
        }
        .padding(.vertical, 4)
        .frame(maxWidth: .infinity, alignment: .leading)
    }
}

#Preview {
    LogsView()
}
