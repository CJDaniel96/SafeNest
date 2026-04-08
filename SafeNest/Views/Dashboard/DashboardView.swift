import SwiftUI
import SwiftData

struct DashboardView: View {
    @Query(sort: \BlockEvent.blockedAt, order: .reverse) private var blockEvents: [BlockEvent]
    @Query private var childProfiles: [ChildProfile]
    @Environment(AppState.self) private var appState

    private var vm: DashboardViewModel {
        DashboardViewModel(child: childProfiles.first, blockEvents: blockEvents)
    }

    var body: some View {
        NavigationStack {
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

    // MARK: - Sections

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
