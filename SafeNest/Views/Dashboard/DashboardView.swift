import SwiftUI
import SwiftData

struct DashboardView: View {
    @Query(sort: \BlockEvent.blockedAt, order: .reverse) private var blockEvents: [BlockEvent]
    @Query(sort: \AccessRequest.requestedAt, order: .reverse) private var accessRequests: [AccessRequest]
    @Query private var childProfiles: [ChildProfile]
    // 此 View 只顯示資料，寫入操作在子頁面（AccessRequestDetailView）執行，不需注入 AppState

    private var vm: DashboardViewModel {
        DashboardViewModel(
            child: childProfiles.first,
            blockEvents: blockEvents,
            accessRequests: accessRequests
        )
    }

    var body: some View {
        NavigationStack {
            // U-1：child == nil 時顯示引導空狀態，避免裸露的空 section 堆疊
            if vm.child == nil {
                EmptyStateView(
                    icon: "person.badge.plus",
                    title: "尚未設定孩子檔案",
                    description: "請至「設定」頁新增孩子資訊，即可開始監控上網安全。"
                )
                .frame(maxHeight: .infinity)
                .navigationTitle("SafeNest")
                .navigationBarTitleDisplayMode(.large)
            } else {
                ScrollView {
                    VStack(spacing: 20) {
                        if let child = vm.child {
                            NavigationLink(destination: ChildDeviceView()) {
                                ChildSummaryCardView(
                                    child: child,
                                    todayBlocked: vm.todayBlockedCount,
                                    weeklyBlocked: vm.weeklyBlockedCount
                                )
                            }
                            .buttonStyle(.plain)
                        }

                        pendingRequestsSection
                        categorySection
                        recentEventsSection
                    }
                    .padding(.horizontal)
                    .padding(.bottom, 24)
                }
                .navigationTitle("SafeNest")
                .navigationBarTitleDisplayMode(.large)
            }
        }
    }

    // MARK: - Pending Requests Section

    @ViewBuilder
    private var pendingRequestsSection: some View {
        if vm.pendingRequestCount > 0 || !vm.recentAccessRequests.isEmpty {
            VStack(alignment: .leading, spacing: 12) {
                HStack {
                    SectionHeader(title: "審核申請")
                    Spacer()
                    if vm.pendingRequestCount > 0 {
                        Text("\(vm.pendingRequestCount) 件待審核")
                            .font(.caption)
                            .fontWeight(.semibold)
                            .padding(.horizontal, 10)
                            .padding(.vertical, 4)
                            .background(Color.orange.opacity(0.15), in: Capsule())
                            .foregroundStyle(.orange)
                    }
                }

                if vm.recentAccessRequests.isEmpty {
                    Text("尚無申請紀錄")
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                        .frame(maxWidth: .infinity, alignment: .center)
                        .padding()
                        .cardContainer()
                } else {
                    VStack(spacing: 0) {
                        ForEach(Array(vm.recentAccessRequests.enumerated()), id: \.element.id) { index, request in
                            NavigationLink(destination: AccessRequestDetailView(request: request)) {
                                AccessRequestRow(request: request)
                                    .padding(.horizontal, 16)
                                    .padding(.vertical, 4)
                            }
                            .buttonStyle(.plain)

                            if index < vm.recentAccessRequests.count - 1 {
                                Divider().padding(.leading, 56)
                            }
                        }
                    }
                    .cardContainer()
                }
            }
        }
    }

    // MARK: - Category Section

    private var categorySection: some View {
        VStack(alignment: .leading, spacing: 12) {
            SectionHeader(title: "本週風險摘要")

            if vm.topCategories.isEmpty {
                Text("本週尚無阻擋紀錄")
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
                    .frame(maxWidth: .infinity, alignment: .center)
                    .padding()
                    .cardContainer()
            } else {
                VStack(spacing: 0) {
                    ForEach(vm.topCategories, id: \.label) { item in
                        HStack {
                            Text(item.label).font(.subheadline)
                            Spacer()
                            Text("\(item.count) 次")
                                .font(.subheadline)
                                .fontWeight(.semibold)
                                .foregroundStyle(.secondary)
                        }
                        .padding(.vertical, 10)
                        .padding(.horizontal, 16)

                        if item.label != vm.topCategories.last?.label {
                            Divider().padding(.leading, 16)
                        }
                    }
                }
                .cardContainer()
            }
        }
    }

    // MARK: - Recent Events Section

    private var recentEventsSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            SectionHeader(title: "最近阻擋紀錄")
            BlockEventList(
                events: vm.recentEvents,
                emptyTitle: "尚無阻擋紀錄",
                emptyIcon: "checkmark.shield",
                emptyDescription: "目前沒有任何被阻擋的紀錄"
            )
        }
    }
}

#Preview {
    DashboardView()
        .modelContainer(PreviewContainer.shared)
        .environment(AppState())
}
