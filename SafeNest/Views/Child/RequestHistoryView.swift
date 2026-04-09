import SwiftUI
import SwiftData

/// 孩子端：自己提出的申請歷史
struct RequestHistoryView: View {
    @Query(sort: \AccessRequest.requestedAt, order: .reverse) private var requests: [AccessRequest]

    private var vm: RequestHistoryViewModel {
        RequestHistoryViewModel(requests: requests)
    }

    var body: some View {
        NavigationStack {
            Group {
                if requests.isEmpty {
                    // D-1：改用共用 EmptyStateView，移除重複的 private var emptyState
                    EmptyStateView(
                        icon: "paperplane.fill",
                        title: "還沒有申請紀錄",
                        description: "當你申請瀏覽被阻擋的網站時，\n紀錄會顯示在這裡"
                    )
                } else {
                    List {
                        if !vm.pendingRequests.isEmpty {
                            Section {
                                ForEach(vm.pendingRequests) { request in
                                    requestRow(request)
                                }
                            } header: {
                                Label("等待家長審核（\(vm.pendingRequests.count)）", systemImage: "clock.fill")
                                    .foregroundStyle(.orange)
                            }
                        }

                        if !vm.reviewedRequests.isEmpty {
                            Section("已處理") {
                                ForEach(vm.reviewedRequests) { request in
                                    requestRow(request)
                                }
                            }
                        }
                    }
                    .listStyle(.insetGrouped)
                }
            }
            .navigationTitle("我的申請")
            .navigationBarTitleDisplayMode(.large)
        }
    }

    // MARK: - Row（含家長回覆）

    @ViewBuilder
    private func requestRow(_ request: AccessRequest) -> some View {
        VStack(alignment: .leading, spacing: 10) {
            AccessRequestRow(request: request)

            // 若已審核且有備註，顯示家長回覆
            if request.status != .pending,
               let note = request.reviewerNote, !note.isEmpty {
                HStack(alignment: .top, spacing: 8) {
                    Image(systemName: "bubble.left.fill")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                    Text("家長回覆：\(note)")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                        .fixedSize(horizontal: false, vertical: true)
                }
                .padding(.leading, 40)
            }
        }
        .padding(.vertical, 2)
    }
}

#Preview {
    RequestHistoryView()
        .modelContainer(PreviewContainer.shared)
        .environment(AppState())
}
