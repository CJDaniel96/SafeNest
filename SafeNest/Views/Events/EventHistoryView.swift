import SwiftUI

struct EventHistoryView: View {
    @State private var vm = EventHistoryViewModel()

    var body: some View {
        NavigationStack {
            VStack(spacing: 0) {
                // Category Filter
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 8) {
                        ForEach(vm.availableCategories, id: \.self) { cat in
                            FilterChip(
                                title: cat,
                                isSelected: vm.selectedCategory == cat
                            ) {
                                vm.selectedCategory = cat
                            }
                        }
                    }
                    .padding(.horizontal)
                    .padding(.vertical, 10)
                }

                Divider()

                // Events List
                if vm.filteredEvents.isEmpty {
                    ContentUnavailableView(
                        "沒有符合的紀錄",
                        systemImage: "clock.badge.checkmark",
                        description: Text("目前沒有 \(vm.selectedCategory) 的阻擋紀錄")
                    )
                } else {
                    List(vm.filteredEvents) { event in
                        EventHistoryRow(event: event)
                    }
                    .listStyle(.plain)
                    .animation(.default, value: vm.selectedCategory)
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

    private func categoryTag(_ text: String) -> some View {
        Text(text)
            .font(.caption2)
            .fontWeight(.medium)
            .padding(.horizontal, 8)
            .padding(.vertical, 3)
            .background(Color.red.opacity(0.1), in: Capsule())
            .foregroundStyle(.red)
    }

    private func ruleTypeTag(_ text: String) -> some View {
        Text(text)
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
}
