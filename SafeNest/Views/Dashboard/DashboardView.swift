import SwiftUI
import SwiftData

struct DashboardView: View {
    // SwiftData 即時查詢
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

                    // Child Summary Card → 點進 ChildDeviceView
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
            sectionHeader("本週風險摘要")

            if vm.topCategories.isEmpty {
                Text("本週尚無阻擋紀錄")
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
                    .frame(maxWidth: .infinity, alignment: .center)
                    .padding()
                    .background(.regularMaterial, in: RoundedRectangle(cornerRadius: 12))
            } else {
                VStack(spacing: 0) {
                    ForEach(vm.topCategories, id: \.label) { item in
                        HStack {
                            Text(item.label)
                                .font(.subheadline)
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
                .background(.regularMaterial, in: RoundedRectangle(cornerRadius: 12))
            }
        }
    }

    private var recentEventsSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            sectionHeader("最近阻擋紀錄")

            if vm.recentEvents.isEmpty {
                ContentUnavailableView(
                    "尚無阻擋紀錄",
                    systemImage: "checkmark.shield",
                    description: Text("目前沒有任何被阻擋的紀錄")
                )
            } else {
                VStack(spacing: 0) {
                    ForEach(vm.recentEvents) { event in
                        BlockEventRow(event: event)
                        if event.id != vm.recentEvents.last?.id {
                            Divider().padding(.leading, 16)
                        }
                    }
                }
                .background(.regularMaterial, in: RoundedRectangle(cornerRadius: 12))
            }
        }
    }

    private func sectionHeader(_ title: String) -> some View {
        Text(title).font(.headline).foregroundStyle(.primary)
    }
}

// MARK: - BlockEventRow（Dashboard 與 ChildDeviceView 共用）

struct BlockEventRow: View {
    let event: BlockEvent

    var body: some View {
        HStack(alignment: .center, spacing: 12) {
            Image(systemName: event.category.icon)
                .foregroundStyle(event.category.color)
                .frame(width: 28, height: 28)
                .background(
                    event.category.color.opacity(0.12),
                    in: RoundedRectangle(cornerRadius: 6)
                )

            VStack(alignment: .leading, spacing: 2) {
                Text(event.domain)
                    .font(.subheadline)
                    .fontWeight(.medium)
                    .lineLimit(1)
                Text(event.category.displayName)
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }

            Spacer()

            Text(event.blockedAt.relativeDescription)
                .font(.caption)
                .foregroundStyle(.secondary)
        }
        .padding(.vertical, 10)
        .padding(.horizontal, 16)
    }
}

#Preview {
    DashboardView()
        .modelContainer(PreviewContainer.shared)
        .environment(AppState())
}
