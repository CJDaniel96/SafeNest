import SwiftUI
import SwiftData

struct RuleManagementView: View {
    @Query private var rules: [Rule]
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
                        childProfileId: "child-001",
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
        .modelContainer(PreviewContainer.shared)
        .environment(AppState())
}
