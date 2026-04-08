import Foundation
import SwiftData

/// 全域狀態協調者。
/// Round 3 起資料讀取改由各 View 的 @Query 負責（直接來自 SwiftData），
/// AppState 專注於集中提供寫入/刪除操作，保持各 View 一致的 mutation 入口。
@Observable
final class AppState {

    // MARK: - Rule Mutations

    func addRule(type: RuleType, value: String,
                 childProfileId: String,
                 in context: ModelContext) {
        let trimmed = value.trimmingCharacters(in: .whitespaces)
        guard !trimmed.isEmpty else { return }
        context.insert(Rule(
            childProfileId: childProfileId,
            type: type,
            value: trimmed
        ))
    }

    func deleteRule(_ rule: Rule, in context: ModelContext) {
        context.delete(rule)
    }

    func deleteRules(at offsets: IndexSet,
                     from rules: [Rule],
                     in context: ModelContext) {
        offsets.forEach { context.delete(rules[$0]) }
    }

    /// @Model 是 class（reference type），直接 mutate 即可，SwiftData 自動追蹤變更
    func toggleRule(_ rule: Rule) {
        rule.enabled.toggle()
    }

    // MARK: - Child Mutations

    func toggleProtection(_ child: ChildProfile) {
        child.protectionEnabled.toggle()
    }
}
