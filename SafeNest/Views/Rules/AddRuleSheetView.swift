import SwiftUI

struct AddRuleSheetView: View {
    let selectedType: RuleType
    let onAdd: (RuleType, String) -> Void

    @Environment(\.dismiss) private var dismiss
    @State private var ruleType: RuleType
    @State private var value: String = ""

    init(selectedType: RuleType, onAdd: @escaping (RuleType, String) -> Void) {
        self.selectedType = selectedType
        self.onAdd = onAdd
        _ruleType = State(initialValue: selectedType)
    }

    var body: some View {
        NavigationStack {
            Form {
                Section("規則類型") {
                    Picker("類型", selection: $ruleType) {
                        ForEach(RuleType.allCases, id: \.self) { type in
                            Text(type.displayName).tag(type)
                        }
                    }
                    .pickerStyle(.segmented)
                }

                Section(valueSectionTitle) {
                    TextField(valuePlaceholder, text: $value)
                        .autocorrectionDisabled()
                        .textInputAutocapitalization(.never)
                        .keyboardType(ruleType == .category ? .default : .URL)
                }
            }
            .navigationTitle("新增規則")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("取消") { dismiss() }
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button("新增") {
                        onAdd(ruleType, value)
                        dismiss()
                    }
                    .disabled(value.trimmingCharacters(in: .whitespaces).isEmpty)
                }
            }
        }
    }

    private var valueSectionTitle: String {
        switch ruleType {
        case .blacklist: return "封鎖網域"
        case .whitelist: return "允許網域"
        case .category:  return "類別名稱"
        }
    }

    private var valuePlaceholder: String {
        switch ruleType {
        case .blacklist: return "例：gambling-site.com"
        case .whitelist: return "例：khanacademy.org"
        case .category:  return "例：賭博"
        }
    }
}

#Preview {
    AddRuleSheetView(selectedType: .blacklist) { _, _ in }
}
