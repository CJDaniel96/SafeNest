import Foundation

/// 全域狀態中心。
/// 所有頁面透過 SwiftUI Environment 共享同一個實例，
/// 任何資料變動都在此集中處理，確保各 View 自動同步更新。
@Observable
final class AppState {

    // MARK: - Shared Data

    var parent: Parent
    var childProfile: ChildProfile
    var rules: [Rule]
    var blockEvents: [BlockEvent]
    var weeklySummary: WeeklySummary

    // MARK: - Init

    init(
        parent: Parent           = MockData.parent,
        childProfile: ChildProfile = MockData.childProfile,
        rules: [Rule]            = MockData.rules,
        blockEvents: [BlockEvent]  = MockData.blockEvents,
        weeklySummary: WeeklySummary = MockData.weeklySummary
    ) {
        self.parent        = parent
        self.childProfile  = childProfile
        self.rules         = rules
        self.blockEvents   = blockEvents
        self.weeklySummary = weeklySummary
    }

    // MARK: - Rule Mutations

    func addRule(type: RuleType, value: String) {
        let trimmed = value.trimmingCharacters(in: .whitespaces)
        guard !trimmed.isEmpty else { return }
        rules.append(Rule(
            id: UUID().uuidString,
            childProfileId: childProfile.id,
            type: type,
            value: trimmed,
            enabled: true,
            createdAt: Date()
        ))
    }

    func deleteRule(_ rule: Rule) {
        rules.removeAll { $0.id == rule.id }
    }

    /// 由 List onDelete 使用，傳入已篩選後的子陣列偏移
    func deleteRules(at offsets: IndexSet, from filtered: [Rule]) {
        let ids = offsets.map { filtered[$0].id }
        rules.removeAll { ids.contains($0.id) }
    }

    func toggleRule(_ rule: Rule) {
        guard let idx = rules.firstIndex(where: { $0.id == rule.id }) else { return }
        rules[idx].enabled.toggle()
    }

    // MARK: - Child Mutations

    func toggleProtection() {
        childProfile.protectionEnabled.toggle()
    }
}
