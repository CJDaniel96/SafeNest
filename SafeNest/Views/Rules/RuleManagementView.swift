import SwiftUI

struct RuleManagementView: View {
    @Environment(AppState.self) private var appState

    // UI 狀態維持在 View 層
    @State private var selectedTab: RuleType = .blacklist
    @State private var showAddSheet = false

    private var vm: RuleManagementViewModel { RuleManagementViewModel(store: appState) }

    var body: some View {
        NavigationStack {
            VStack(spacing: 0) {

                // 分頁切換
                Picker("規則類型", selection: $selectedTab) {
                    ForEach(RuleType.allCases) { type in
                        Text(type.displayName).tag(type)
                    }
                }
                .pickerStyle(.segmented)
                .padding()

                // 規則列表
                List {
                    ForEach(vm.filteredRules(for: selectedTab)) { rule in
                        RuleRowView(rule: rule) {
                            vm.toggle(rule)
                        }
                    }
                    .onDelete { offsets in
                        vm.deleteByOffsets(offsets, tab: selectedTab)
                    }
                }
                .listStyle(.insetGrouped)
                .animation(.default, value: selectedTab)
            }
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
                    vm.addRule(type: type, value: value)
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
                Text(rule.value)
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

#Preview {
    RuleManagementView()
        .environment(AppState())
}
