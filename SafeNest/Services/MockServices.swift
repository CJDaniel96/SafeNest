import Foundation
import SwiftData

// MARK: - MockProtectionService

/// FamilyControls 的 Mock 實作。
/// 授權狀態永遠為 true，所有系統呼叫皆為 no-op。
///
/// 換成真實實作時：
///   - 改為 `RealProtectionService: ProtectionServiceProtocol`
///   - 在 SafeNestApp 建立 AppState 時傳入真實 service：
///     `AppState(protectionService: RealProtectionService())`
final class MockProtectionService: ProtectionServiceProtocol {
    var isAuthorized: Bool = true

    func requestAuthorization() async throws {
        // 真實：import FamilyControls
        //       try await AuthorizationCenter.shared
        //           .requestAuthorization(for: .individual(bundleIdentifier: "..."))
    }

    func enableProtection(for childId: String) async throws {
        // 真實：ManagedSettingsStore(named: ManagedSettingsStore.Name(childId))
        //           .webContent.blockedByFilter = .all()
    }

    func disableProtection(for childId: String) async throws {
        // 真實：ManagedSettingsStore(named: ManagedSettingsStore.Name(childId))
        //           .clearAllSettings()
    }
}

// MARK: - MockBlockingService

/// ManagedSettings / NetworkExtension 的 Mock 實作。
/// 規則已存入 SwiftData；系統層同步為 no-op，不實際封鎖任何網站。
///
/// 換成真實實作時：
///   - 改為 `RealBlockingService: BlockingServiceProtocol`
///   - 依 rule.type 分別呼叫 ManagedSettingsStore API
final class MockBlockingService: BlockingServiceProtocol {
    func syncRules(_ rules: [Rule], for childId: String) {
        // 真實：let store = ManagedSettingsStore(named: .init(childId))
        //
        // let enabledRules = rules.filter { $0.enabled }
        //
        // // Blacklist → blockedByFilter
        // let blockedDomains = enabledRules
        //     .filter { $0.type == .blacklist }
        //     .map { WebDomain(domain: $0.value) }
        // store.webContent.blockedByFilter = ContentPolicy(blockedWebDomains: Set(blockedDomains))
        //
        // // Whitelist → alwaysAllowedWebsites
        // let allowedDomains = enabledRules
        //     .filter { $0.type == .whitelist }
        //     .map { WebDomain(domain: $0.value) }
        // store.webContent.alwaysAllowedWebsites = Set(allowedDomains)
    }

    func clearAll(for childId: String) {
        // 真實：ManagedSettingsStore(named: .init(childId)).clearAllSettings()
    }
}

// MARK: - MockActivityMonitorService

/// DeviceActivity extension 的 Mock 實作。
/// 直接將事件寫入 SwiftData，模擬 extension 上報的行為。
///
/// 換成真實實作時：
///   - 不替換此 service（DeviceActivity extension 是獨立 process）
///   - 在 DeviceActivityReportExtension 中呼叫 `logBlockEvent` 寫入 SwiftData
///   - Mock 可保留供 Demo / QA 使用
final class MockActivityMonitorService: ActivityMonitorServiceProtocol {
    func logBlockEvent(
        domain: String,
        url: String?,
        category: BlockEventCategory,
        ruleType: RuleType,
        childProfileId: String,
        in context: ModelContext
    ) {
        context.insert(BlockEvent(
            childProfileId: childProfileId,
            domain: domain,
            url: url,
            category: category,
            matchedRuleType: ruleType
        ))
    }
}

// MARK: - MockAccessRequestService

/// AccessRequest 業務邏輯的 Mock 實作。
/// 直接操作 SwiftData，未來可在此加入推播通知或 FamilyActivityPicker 整合。
///
/// 換成真實實作時：
///   - 改為 `RealAccessRequestService: AccessRequestServiceProtocol`
///   - 在 submit 後呼叫 UNUserNotificationCenter 通知家長裝置
///   - 在 approve / deny 後呼叫遠端 API 通知孩子裝置
final class MockAccessRequestService: AccessRequestServiceProtocol {
    func submitAccessRequest(
        domain: String,
        childProfileId: String,
        reason: String,
        in context: ModelContext
    ) {
        let trimmed = reason.trimmingCharacters(in: .whitespaces)
        guard !trimmed.isEmpty, !childProfileId.isEmpty else { return }
        context.insert(AccessRequest(
            childProfileId: childProfileId,
            domain: domain,
            reason: trimmed
        ))
    }

    func approveRequest(_ request: AccessRequest, note: String) {
        request.status     = .approved
        request.reviewedAt = .now
        let trimmed = note.trimmingCharacters(in: .whitespaces)
        request.reviewerNote = trimmed.isEmpty ? nil : trimmed
    }

    func denyRequest(_ request: AccessRequest, note: String) {
        request.status     = .denied
        request.reviewedAt = .now
        let trimmed = note.trimmingCharacters(in: .whitespaces)
        request.reviewerNote = trimmed.isEmpty ? nil : trimmed
    }
}
