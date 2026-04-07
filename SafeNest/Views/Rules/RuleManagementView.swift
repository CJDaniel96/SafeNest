import SwiftUI

struct RuleManagementView: View {
    @State private var vm = RuleManagementViewModel()
    @State private var showAddSheet = false

    var body: some View {
        NavigationStack {
            VStack(spacing: 0) {
                // Tab Picker
                Picker("規則類型", selection: $vm.selectedTab) {
                    ForEach(RuleType.allCases, id: \.self) { type in
                        Text(type.displayName).tag(type)
                    }
                }
                .pickerStyle(.segmented)
                .padding()

                // Rules List
                List {
                    ForEach(vm.filteredRules) { rule in
                        RuleRowView(rule: rule) {
                            vm.toggleEnabled(rule)
                        }
                    }
                    .onDelete { offsets in
                        vm.deleteByOffsets(offsets)
                    }
                }
                .listStyle(.insetGrouped)
                .animation(.default, value: vm.selectedTab)
            }
            .navigationTitle("規則管理")
            .navigationBarTitleDisplayMode(.large)
            .toolbar {
                ToolbarItem(placement: .primaryAction) {
                    Button {
                        showAddSheet = true
                    } label: {
                        Image(systemName: "plus")
                    }
                }
            }
            .sheet(isPresented: $showAddSheet) {
                AddRuleSheetView(selectedType: vm.selectedTab) { type, value in
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
                Text(rule.ruleType.displayName)
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
}
