import Foundation
import SwiftData

// MARK: - 資料層架構說明
//
// SafeNest 的「集中式資料層」由三個部分共同構成：
//
//  ┌─────────────────────────────────────────────────────┐
//  │  ModelContainer（SafeNestApp 建立，全 App 唯一）      │  ← 單一資料來源（Single Source of Truth）
//  └───────────────┬─────────────────────────────────────┘
//                  │ 讀取（Reactive）              │ 寫入
//          ┌───────▼────────┐           ┌──────────▼──────────┐
//          │  @Query (Views) │           │   AppState (本檔)   │
//          │  自動訂閱變動    │           │  唯一的寫入入口      │
//          └───────┬────────┘           └─────────────────────┘
//                  │ 傳入
//          ┌───────▼────────┐
//          │  ViewModel     │
//          │  (pure struct) │  ← 純計算，無副作用，不持有任何資料副本
//          └────────────────┘
//
// ⚠️ 規則：
//   - 所有 INSERT / UPDATE / DELETE 必須透過 AppState 方法執行
//   - View 不得直接呼叫 modelContext.insert / delete
//   - ViewModel 不得持有任何可變狀態（@Observable 表單狀態除外）

/// App 全域狀態的唯一協調者。
/// - 讀取：由各 View 以 @Query 向 ModelContainer 訂閱，結果傳入 ViewModel 計算
/// - 寫入：所有資料異動集中於此，保持 ModelContainer 為唯一資料來源
@Observable
final class AppState {

    // MARK: - Role

    /// 目前使用角色（I-5：private(set) 強制外部必須透過 switchRole 切換，保留未來加入 PIN 防護的空間）
    private(set) var currentRole: AppRole = .parent

    /// 切換角色的唯一入口。未來可在此加入 PIN 驗證、日誌等前置邏輯。
    func switchRole(to role: AppRole) {
        guard role != currentRole else { return }
        currentRole = role
    }

    // MARK: - Rule Mutations

    func addRule(type: RuleType, value: String,
                 childProfileId: String,
                 in context: ModelContext) {
        let trimmed = value.trimmingCharacters(in: .whitespaces)
        // I-2：防止空 childProfileId 產生孤兒規則
        guard !trimmed.isEmpty, !childProfileId.isEmpty else { return }
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

    /// @Model 是 class，直接 mutate 即可，SwiftData 自動追蹤變動並通知所有 @Query
    func toggleRule(_ rule: Rule) {
        rule.enabled.toggle()
    }

    // MARK: - ChildProfile Mutations

    func toggleProtection(_ child: ChildProfile) {
        child.protectionEnabled.toggle()
    }

    // MARK: - AccessRequest Mutations

    /// 孩子送出審核申請
    func submitAccessRequest(domain: String,
                             childProfileId: String,
                             reason: String,
                             in context: ModelContext) {
        let trimmed = reason.trimmingCharacters(in: .whitespaces)
        guard !trimmed.isEmpty, !childProfileId.isEmpty else { return }
        context.insert(AccessRequest(
            childProfileId: childProfileId,
            domain: domain,
            reason: trimmed
        ))
    }

    /// 家長核准申請（狀態更新後，所有訂閱 AccessRequest 的 @Query 自動同步）
    func approveRequest(_ request: AccessRequest, note: String) {
        request.status     = .approved
        request.reviewedAt = .now
        let trimmed = note.trimmingCharacters(in: .whitespaces)
        request.reviewerNote = trimmed.isEmpty ? nil : trimmed
    }

    /// 家長拒絕申請（狀態更新後，所有訂閱 AccessRequest 的 @Query 自動同步）
    func denyRequest(_ request: AccessRequest, note: String) {
        request.status     = .denied
        request.reviewedAt = .now
        let trimmed = note.trimmingCharacters(in: .whitespaces)
        request.reviewerNote = trimmed.isEmpty ? nil : trimmed
    }
}
