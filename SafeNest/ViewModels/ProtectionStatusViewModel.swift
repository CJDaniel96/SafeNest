import Foundation

/// 兒少保護狀態頁顯示邏輯。
struct ProtectionStatusViewModel {
    let child: ChildProfile?
    let rules: [Rule]
    let blockEvents: [BlockEvent]

    var protectionEnabled: Bool { child?.protectionEnabled ?? false }

    // 啟用規則數量（各類型）
    var blacklistCount:   Int { rules.filter { $0.type == .blacklist && $0.enabled }.count }
    var whitelistCount:   Int { rules.filter { $0.type == .whitelist && $0.enabled }.count }
    var categoryCount:    Int { rules.filter { $0.type == .category  && $0.enabled }.count }
    var enabledRulesCount: Int { rules.filter { $0.enabled }.count }

    var todayBlockedCount: Int {
        blockEvents.filter { $0.blockedAt.isToday }.count
    }

    var weeklyBlockedCount: Int {
        let cutoff = Calendar.current.date(byAdding: .day, value: -7, to: Date()) ?? Date()
        return blockEvents.filter { $0.blockedAt >= cutoff }.count
    }
}
