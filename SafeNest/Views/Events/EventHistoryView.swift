import SwiftUI
import SwiftData

struct EventHistoryView: View {
    @Query(sort: \BlockEvent.blockedAt, order: .reverse) private var blockEvents: [BlockEvent]
    // 此 View 只顯示資料，不執行任何寫入操作，不需注入 AppState

    @State private var selectedCategory: BlockEventCategory? = nil

    private var vm: EventHistoryViewModel { EventHistoryViewModel(events: blockEvents) }

    var body: some View {
        NavigationStack {
            VStack(spacing: 0) {
                categoryFilterBar
                Divider()
                eventList
            }
            .navigationTitle("阻擋紀錄")
            .navigationBarTitleDisplayMode(.large)
        }
    }

    // MARK: - Subviews

    private var categoryFilterBar: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 8) {
                FilterChip(title: "全部", isSelected: selectedCategory == nil) {
                    selectedCategory = nil
                }
                ForEach(vm.availableCategories) { cat in
                    FilterChip(
                        title: cat.displayName,
                        isSelected: selectedCategory == cat
                    ) {
                        selectedCategory = cat
                    }
                }
            }
            .padding(.horizontal)
            .padding(.vertical, 10)
        }
    }

    @ViewBuilder
    private var eventList: some View {
        let filtered = vm.filteredEvents(category: selectedCategory)
        if filtered.isEmpty {
            // P2：移除 selectedCategory! 強制解包，改用 map
            let description = selectedCategory
                .map { "目前沒有「\($0.displayName)」的阻擋紀錄" }
                ?? "目前沒有阻擋紀錄"
            ContentUnavailableView(
                "沒有符合的紀錄",
                systemImage: "clock.badge.checkmark",
                description: Text(description)
            )
        } else {
            List(filtered) { event in
                EventHistoryRow(event: event)
            }
            .listStyle(.plain)
            .animation(.default, value: selectedCategory)
        }
    }
}

// MARK: - EventHistoryRow

struct EventHistoryRow: View {
    let event: BlockEvent

    var body: some View {
        VStack(alignment: .leading, spacing: 6) {
            HStack {
                Text(event.domain)
                    .font(.subheadline)
                    .fontWeight(.semibold)
                    .lineLimit(1)
                Spacer()
                Text(event.blockedAt.shortDateTime)
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }

            HStack(spacing: 8) {
                CategoryTagView(category: event.category)
                RuleTypeTagView(ruleType: event.matchedRuleType)
            }

            if let url = event.url {
                Text(url)
                    .font(.caption2)
                    .foregroundStyle(.secondary)
                    .lineLimit(1)
            }
        }
        .padding(.vertical, 4)
    }
}

#Preview {
    EventHistoryView()
        .modelContainer(PreviewContainer.shared)
        .environment(AppState())
}
