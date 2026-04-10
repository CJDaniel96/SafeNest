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
//   - ViewModel 不得持有任何可變狀態（@Observable 表單狀態 + service 依賴除外）
//
// Service 抽象層（Round 6）：
//   system-level side-effect 透過 4 個 protocol 解耦，預設使用 Mock 實作。
//   未來換真實 Apple framework 實作時，只需在 SafeNestApp 替換注入的 service instance。

/// App 全域狀態的唯一協調者。
@Observable
final class AppState {

    // MARK: - Role

    private(set) var currentRole: AppRole = .parent

    func switchRole(to role: AppRole) {
        guard role != currentRole else { return }
        currentRole = role
    }

    // MARK: - Service Dependencies（Apple framework 整合抽象層）

    let protectionService:     any ProtectionServiceProtocol
    let blockingService:       any BlockingServiceProtocol
    let activityMonitorService: any ActivityMonitorServiceProtocol
    let accessRequestService:  any AccessRequestServiceProtocol

    /// 所有 service 皆有 mock 預設值，現有呼叫端不需修改。
    /// 真實整合時，在 SafeNestApp 建立 AppState 時傳入真實 service：
    ///   `AppState(protectionService: RealProtectionService(), ...)`
    init(
        protectionService:      any ProtectionServiceProtocol     = MockProtectionService(),
        blockingService:        any BlockingServiceProtocol       = MockBlockingService(),
        activityMonitorService: any ActivityMonitorServiceProtocol = MockActivityMonitorService(),
        accessRequestService:   any AccessRequestServiceProtocol  = MockAccessRequestService()
    ) {
        self.protectionService      = protectionService
        self.blockingService        = blockingService
        self.activityMonitorService = activityMonitorService
        self.accessRequestService   = accessRequestService
    }

    // MARK: - Rule Mutations

    func addRule(type: RuleType, value: String,
                 childProfileId: String,
                 in context: ModelContext) {
        let trimmed = value.trimmingCharacters(in: .whitespaces)
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

    func toggleRule(_ rule: Rule) {
        rule.enabled.toggle()
    }

    /// 規則變更後，呼叫此方法將最新規則集同步至系統層。
    /// View 層在 addRule / deleteRule / toggleRule 後視情況呼叫。
    /// Mock 為 no-op；真實 app 推送至 ManagedSettings / NetworkExtension。
    func syncRules(_ rules: [Rule], for childId: String) {
        // 同步呼叫：BlockingServiceProtocol 不宣告 async，避免 @Model 跨 actor 邊界的 Sendable 問題
        blockingService.syncRules(rules, for: childId)
    }

    // MARK: - ChildProfile Mutations

    /// 切換保護狀態，同時通知 ProtectionService 更新系統層（Mock 為 no-op）。
    func toggleProtection(_ child: ChildProfile) {
        child.protectionEnabled.toggle()
        let childId = child.id
        let enabled = child.protectionEnabled
        Task {
            try? await enabled
                ? protectionService.enableProtection(for: childId)
                : protectionService.disableProtection(for: childId)
        }
    }

    // MARK: - Activity Monitor

    /// Demo 流程中手動記錄一筆阻擋事件（模擬 DeviceActivity extension 的行為）。
    /// 真實 app：由 DeviceActivity extension 觸發，View 層不需呼叫此 method。
    func recordBlockEvent(
        domain: String,
        url: String? = nil,
        category: BlockEventCategory,
        ruleType: RuleType,
        childProfileId: String,
        in context: ModelContext
    ) {
        activityMonitorService.logBlockEvent(
            domain: domain, url: url,
            category: category, ruleType: ruleType,
            childProfileId: childProfileId, in: context
        )
    }

    // MARK: - AccessRequest Mutations（委派至 AccessRequestService）

    func submitAccessRequest(domain: String,
                             childProfileId: String,
                             reason: String,
                             in context: ModelContext) {
        accessRequestService.submitAccessRequest(
            domain: domain, childProfileId: childProfileId,
            reason: reason, in: context
        )
    }

    func approveRequest(_ request: AccessRequest, note: String) {
        accessRequestService.approveRequest(request, note: note)
    }

    func denyRequest(_ request: AccessRequest, note: String) {
        accessRequestService.denyRequest(request, note: note)
    }
}
