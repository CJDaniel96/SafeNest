import SwiftUI

/// 新增保護規則的 Sheet。
/// - domain 型別（blacklist / whitelist）：TextField 輸入網域
/// - category 型別：Picker 選擇 BlockEventCategory，寫入穩定英文 rawValue
struct AddRuleSheetView: View {
    let selectedType: RuleType
    let onAdd: (RuleType, String) -> Void

    @Environment(\.dismiss) private var dismiss
    @State private var ruleType: RuleType
    @State private var domainValue: String = ""
    /// S-2：category 型別改用 Picker，預設第一個類別
    @State private var selectedCategory: BlockEventCategory = .adult

    init(selectedType: RuleType, onAdd: @escaping (RuleType, String) -> Void) {
        self.selectedType = selectedType
        self.onAdd = onAdd
        _ruleType = State(initialValue: selectedType)
    }

    var body: some View {
        NavigationStack {
            Form {
                // MARK: 規則類型
                Section("規則類型") {
                    Picker("類型", selection: $ruleType) {
                        ForEach(RuleType.allCases, id: \.self) { type in
                            Text(type.displayName).tag(type)
                        }
                    }
                    .pickerStyle(.segmented)
                }

                // MARK: 規則值
                Section(valueSectionTitle) {
                    if ruleType == .category {
                        // S-2：Picker 取代自由文字，確保只能存有效的 BlockEventCategory.rawValue
                        Picker("封鎖類別", selection: $selectedCategory) {
                            ForEach(BlockEventCategory.allCases) { cat in
                                Label(cat.displayName, systemImage: cat.icon).tag(cat)
                            }
                        }
                    } else {
                        TextField(valuePlaceholder, text: $domainValue)
                            .autocorrectionDisabled()
                            .textInputAutocapitalization(.never)
                            .keyboardType(.URL)
                    }
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
                        // S-2：category 存 rawValue（穩定英文 key），其餘存使用者輸入的網域
                        let ruleValue = ruleType == .category
                            ? selectedCategory.rawValue
                            : domainValue.trimmingCharacters(in: .whitespaces)
                        onAdd(ruleType, ruleValue)
                        dismiss()
                    }
                    // category 永遠有效（Picker 預設已選定）；其餘需要非空輸入
                    .disabled(ruleType != .category
                              && domainValue.trimmingCharacters(in: .whitespaces).isEmpty)
                }
            }
        }
    }

    // MARK: - Helpers

    private var valueSectionTitle: String {
        switch ruleType {
        case .blacklist: "封鎖網域"
        case .whitelist: "允許網域"
        case .category:  "封鎖類別"
        }
    }

    private var valuePlaceholder: String {
        switch ruleType {
        case .blacklist: "例：gambling-site.com"
        case .whitelist: "例：khanacademy.org"
        case .category:  ""   // category 使用 Picker，不需要 placeholder
        }
    }
}

#Preview {
    AddRuleSheetView(selectedType: .blacklist) { _, _ in }
}
