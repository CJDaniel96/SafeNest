import SwiftUI

struct EventHistoryView: View {
    @Environment(AppState.self) private var appState

    // nil = 全部；有值 = 指定類別
    @State private var selectedCategory: BlockEventCategory? = nil

    private var vm: EventHistoryViewModel { EventHistoryViewModel(store: appState) }

    var body: some View {
        NavigationStack {
            VStack(spacing: 0) {

                // 類別篩選器
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

                Divider()

                let filtered = vm.filteredEvents(category: selectedCategory)

                if filtered.isEmpty {
                    ContentUnavailableView(
                        "沒有符合的紀錄",
                        systemImage: "clock.badge.checkmark",
                        description: Text(
                            selectedCategory != nil
                                ? "目前沒有「\(selectedCategory!.displayName)」的阻擋紀錄"
                                : "目前沒有阻擋紀錄"
                        )
                    )
                } else {
                    List(filtered) { event in
                        EventHistoryRow(event: event)
                    }
                    .listStyle(.plain)
                    .animation(.default, value: selectedCategory)
                }
            }
            .navigationTitle("阻擋紀錄")
            .navigationBarTitleDisplayMode(.large)
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
                categoryTag(event.category)
                ruleTypeTag(event.matchedRuleType)
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

    private func categoryTag(_ cat: BlockEventCategory) -> some View {
        Label(cat.displayName, systemImage: cat.icon)
            .font(.caption2)
            .fontWeight(.medium)
            .padding(.horizontal, 8)
            .padding(.vertical, 3)
            .background(cat.color.opacity(0.1), in: Capsule())
            .foregroundStyle(cat.color)
    }

    private func ruleTypeTag(_ type: RuleType) -> some View {
        Text(type.displayName)
            .font(.caption2)
            .fontWeight(.medium)
            .padding(.horizontal, 8)
            .padding(.vertical, 3)
            .background(Color.blue.opacity(0.1), in: Capsule())
            .foregroundStyle(.blue)
    }
}

// MARK: - FilterChip

struct FilterChip: View {
    let title: String
    let isSelected: Bool
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            Text(title)
                .font(.subheadline)
                .fontWeight(isSelected ? .semibold : .regular)
                .padding(.horizontal, 14)
                .padding(.vertical, 7)
                .background(
                    isSelected ? Color.blue : Color.secondary.opacity(0.12),
                    in: Capsule()
                )
                .foregroundStyle(isSelected ? .white : .primary)
        }
        .buttonStyle(.plain)
    }
}

#Preview {
    EventHistoryView()
        .environment(AppState())
}
