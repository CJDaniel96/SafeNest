import Foundation
import SwiftData

/// 全域狀態協調者。
/// - 資料讀取由各 View 的 @Query 負責
/// - AppState 提供寫入/刪除操作與角色切換
@Observable
final class AppState {

    // MARK: - Role

    /// 目前的使用角色，控制 RootView 顯示家長端或兒少端
    var currentRole: AppRole = .parent

    func switchRole(to role: AppRole) {
        currentRole = role
    }

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

    /// @Model 是 class，直接 mutate 即可，SwiftData 自動追蹤
    func toggleRule(_ rule: Rule) {
        rule.enabled.toggle()
    }

    // MARK: - Child Mutations

    func toggleProtection(_ child: ChildProfile) {
        child.protectionEnabled.toggle()
    }

    // MARK: - Access Request Mutations

    /// 孩子送出審核申請，寫入 SwiftData
    func submitAccessRequest(domain: String,
                             childProfileId: String,
                             reason: String,
                             in context: ModelContext) {
        let trimmed = reason.trimmingCharacters(in: .whitespaces)
        guard !trimmed.isEmpty else { return }
        context.insert(AccessRequest(
            childProfileId: childProfileId,
            domain: domain,
            reason: trimmed
        ))
    }

    /// 家長核准申請，並可附上備註
    func approveRequest(_ request: AccessRequest, note: String) {
        request.status = .approved
        request.reviewedAt = .now
        let trimmed = note.trimmingCharacters(in: .whitespaces)
        request.reviewerNote = trimmed.isEmpty ? nil : trimmed
    }

    /// 家長拒絕申請，並可附上原因
    func denyRequest(_ request: AccessRequest, note: String) {
        request.status = .denied
        request.reviewedAt = .now
        let trimmed = note.trimmingCharacters(in: .whitespaces)
        request.reviewerNote = trimmed.isEmpty ? nil : trimmed
    }
}
