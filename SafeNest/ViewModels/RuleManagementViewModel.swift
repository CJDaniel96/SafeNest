import Foundation

/// 規則管理的顯示邏輯與操作代理。
/// UI 狀態（selectedTab、showAddSheet）維持在 View 層的 @State，
/// 此 struct 只負責計算與把操作轉發給 AppState。
struct RuleManagementViewModel {
    private let store: AppState

    init(store: AppState) {
        self.store = store
    }

    // MARK: - Computed Properties

    func filteredRules(for tab: RuleType) -> [Rule] {
        store.rules.filter { $0.type == tab }
    }

    // MARK: - Actions（委派給 AppState）

    func toggle(_ rule: Rule) {
        store.toggleRule(rule)
    }

    func delete(_ rule: Rule) {
        store.deleteRule(rule)
    }

    func deleteByOffsets(_ offsets: IndexSet, tab: RuleType) {
        let filtered = filteredRules(for: tab)
        store.deleteRules(at: offsets, from: filtered)
    }

    func addRule(type: RuleType, value: String) {
        store.addRule(type: type, value: value)
    }
}
