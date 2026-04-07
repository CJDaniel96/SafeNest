import SwiftUI

struct DashboardView: View {
    @State private var vm = DashboardViewModel()
    @State private var navigateToDevice = false

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 20) {
                    // Child Summary Card
                    NavigationLink(destination: ChildDeviceView()) {
                        ChildSummaryCardView(
                            child: vm.child,
                            todayBlocked: vm.todayBlockedCount,
                            weeklyBlocked: vm.weeklyBlockedCount
                        )
                    }
                    .buttonStyle(.plain)

                    // Top Risk Categories
                    categorySection

                    // Recent Events
                    recentEventsSection
                }
                .padding(.horizontal)
                .padding(.bottom, 24)
            }
            .navigationTitle("SafeNest")
            .navigationBarTitleDisplayMode(.large)
        }
    }

    // MARK: - Category Section

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

    // MARK: - Recent Events Section

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

// MARK: - BlockEventRow (shared)

struct BlockEventRow: View {
    let event: BlockEvent

    var body: some View {
        HStack(alignment: .center, spacing: 12) {
            Image(systemName: categoryIcon(event.category))
                .foregroundStyle(categoryColor(event.category))
                .frame(width: 28, height: 28)
                .background(categoryColor(event.category).opacity(0.12),
                            in: RoundedRectangle(cornerRadius: 6))

            VStack(alignment: .leading, spacing: 2) {
                Text(event.domain)
                    .font(.subheadline)
                    .fontWeight(.medium)
                    .lineLimit(1)
                Text(event.category)
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

    private func categoryIcon(_ category: String) -> String {
        switch category {
        case "賭博":    return "suit.club.fill"
        case "成人內容": return "eye.slash.fill"
        case "暴力":    return "bolt.fill"
        case "釣魚網站": return "exclamationmark.triangle.fill"
        default:       return "xmark.shield.fill"
        }
    }

    private func categoryColor(_ category: String) -> Color {
        switch category {
        case "賭博":    return .purple
        case "成人內容": return .red
        case "暴力":    return .orange
        case "釣魚網站": return .yellow
        default:       return .gray
        }
    }
}

#Preview {
    DashboardView()
}
