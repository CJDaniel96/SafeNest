import SwiftUI
import SwiftData

/// 家長端：審核申請收件匣
struct AccessRequestInboxView: View {
    @Query(sort: \AccessRequest.requestedAt, order: .reverse) private var requests: [AccessRequest]
    // 審核操作在子頁面（AccessRequestDetailView）執行，此 View 不需注入 AppState

    private var vm: AccessRequestInboxViewModel {
        AccessRequestInboxViewModel(requests: requests)
    }

    var body: some View {
        NavigationStack {
            Group {
                if requests.isEmpty {
                    // D-1：改用共用 EmptyStateView，移除重複的 private var emptyState
                    EmptyStateView(
                        icon: "tray.fill",
                        title: "目前沒有審核申請",
                        description: "孩子提出申請後會顯示在這裡"
                    )
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
}

#Preview {
    AccessRequestInboxView()
        .modelContainer(PreviewContainer.shared)
        .environment(AppState())
}
