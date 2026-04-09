import SwiftUI
import SwiftData

struct RuleManagementView: View {
    @Query private var rules: [Rule]
    @Query private var childProfiles: [ChildProfile]   // P1：從 SwiftData 取得，不再硬編碼
    @Environment(\.modelContext) private var modelContext
    @Environment(AppState.self) private var appState

    @State private var selectedTab: RuleType = .blacklist
    @State private var showAddSheet = false

    private var vm: RuleManagementViewModel { RuleManagementViewModel(rules: rules) }

    var body: some View {
        NavigationStack {
            VStack(spacing: 0) {

                Picker("規則類型", selection: $selectedTab) {
                    ForEach(RuleType.allCases) { type in
                        Text(type.displayName).tag(type)
                    }
                }
                .pickerStyle(.segmented)
                .padding()

                let filtered = vm.filteredRules(for: selectedTab)

                if filtered.isEmpty {
                    ContentUnavailableView(
                        "沒有\(selectedTab.displayName)規則",
                        systemImage: "list.bullet.rectangle",
                        description: Text("點右上角 + 新增規則")
                    )
                    .frame(maxHeight: .infinity)
                } else {
                    List {
                        ForEach(filtered) { rule in
                            RuleRowView(rule: rule) {
                                appState.toggleRule(rule)
                            }
                        }
                        .onDelete { offsets in
                            appState.deleteRules(at: offsets, from: filtered, in: modelContext)
                        }
                    }
                    .listStyle(.insetGrouped)
                }
            }
            .animation(.default, value: selectedTab)
            .navigationTitle("規則管理")
            .navigationBarTitleDisplayMode(.large)
            .toolbar {
                ToolbarItem(placement: .primaryAction) {
                    Button { showAddSheet = true } label: {
                        Image(systemName: "plus")
                    }
                }
            }
            .sheet(isPresented: $showAddSheet) {
                AddRuleSheetView(selectedType: selectedTab) { type, value in
                    appState.addRule(
                        type: type, value: value,
                        childProfileId: childProfiles.first?.id ?? "",  // P1：使用實際 ID
                        in: modelContext
                    )
                }
            }
        }
    }
}

// MARK: - RuleRowView

struct RuleRowView: View {
    let rule: Rule
    let onToggle: () -> Void

    var body: some View {
        HStack {
            VStack(alignment: .leading, spacing: 3) {
                Text(rule.valueDisplayName)
                    .font(.subheadline)
                    .fontWeight(.medium)
                    .foregroundStyle(rule.enabled ? .primary : .secondary)
                Text(rule.type.displayName)
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }
            Spacer()
            Toggle("", isOn: Binding(
                get: { rule.enabled },
                set: { _ in onToggle() }
            ))
            .labelsHidden()
        }
    }
}

// MARK: - Rule display helper

private extension Rule {
    /// S-3：category 規則的 value 存的是 BlockEventCategory.rawValue；
    /// 解碼為 displayName 以顯示中文名稱，fallback 顯示原始字串（相容舊資料）。
    var valueDisplayName: String {
        guard type == .category else { return value }
        return BlockEventCategory(rawValue: value)?.displayName ?? value
    }
}

#Preview {
    RuleManagementView()
        .modelContainer(PreviewContainer.shared)
        .environment(AppState())
}
