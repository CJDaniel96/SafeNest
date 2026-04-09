import SwiftUI
import SwiftData

/// 家長端：審核申請收件匣
struct AccessRequestInboxView: View {
    @Query(sort: \AccessRequest.requestedAt, order: .reverse) private var requests: [AccessRequest]
    @Environment(AppState.self) private var appState

    private var vm: AccessRequestInboxViewModel {
        AccessRequestInboxViewModel(requests: requests)
    }

    var body: some View {
        NavigationStack {
            Group {
                if requests.isEmpty {
                    emptyState
                } else {
                    List {
                        if !vm.pendingRequests.isEmpty {
                            Section {
                                ForEach(vm.pendingRequests) { request in
                                    NavigationLink(destination: AccessRequestDetailView(request: request)) {
                                        AccessRequestRow(request: request)
                                    }
                                }
                            } header: {
                                Label("待審核（\(vm.pendingCount)）", systemImage: "clock.fill")
                                    .foregroundStyle(.orange)
                            }
                        }

                        if !vm.reviewedRequests.isEmpty {
                            Section("已處理") {
                                ForEach(vm.reviewedRequests) { request in
                                    NavigationLink(destination: AccessRequestDetailView(request: request)) {
                                        AccessRequestRow(request: request)
                                    }
                                }
                            }
                        }
                    }
                    .listStyle(.insetGrouped)
                }
            }
            .navigationTitle("審核申請")
            .navigationBarTitleDisplayMode(.large)
        }
    }

    // MARK: - Empty State

    private var emptyState: some View {
        VStack(spacing: 16) {
            Image(systemName: "tray.fill")
                .font(.system(size: 52))
                .foregroundStyle(.secondary.opacity(0.5))
            Text("目前沒有審核申請")
                .font(.headline)
                .foregroundStyle(.secondary)
            Text("孩子提出申請後會顯示在這裡")
                .font(.subheadline)
                .foregroundStyle(.tertiary)
                .multilineTextAlignment(.center)
        }
        .padding()
    }
}

#Preview {
    AccessRequestInboxView()
        .modelContainer(PreviewContainer.shared)
        .environment(AppState())
}
