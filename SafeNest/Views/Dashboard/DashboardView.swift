import SwiftUI

struct DashboardView: View {
    @Environment(AppState.self) private var appState

    /// ViewModel 以計算屬性方式建立：
    /// 因為 AppState 是 @Observable，SwiftUI 在 body 執行時
    /// 會追蹤所有 appState 屬性的讀取，變動時自動重新渲染。
    private var vm: DashboardViewModel { DashboardViewModel(store: appState) }

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 20) {

                    // Child Summary Card → 點進 ChildDeviceView
                    NavigationLink(destination: ChildDeviceView()) {
                        ChildSummaryCardView(
                            child: vm.child,
                            todayBlocked: vm.todayBlockedCount,
                            weeklyBlocked: vm.weeklyBlockedCount
                        )
                    }
                    .buttonStyle(.plain)

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

    private var recentEventsSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            sectionHeader("最近阻擋紀錄")

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

    private func sectionHeader(_ title: String) -> some View {
        Text(title)
            .font(.headline)
            .foregroundStyle(.primary)
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
        .environment(AppState())
}
