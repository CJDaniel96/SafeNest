import Foundation
import SwiftData

/// 第一次啟動時插入 Demo 資料。
/// 透過 Parent 筆數判斷是否已初始化，避免重複寫入。
enum SeedDataService {

    static func seedIfNeeded(in context: ModelContext) {
        let descriptor = FetchDescriptor<Parent>()
        let count = (try? context.fetchCount(descriptor)) ?? 0
        guard count == 0 else { return }

        let parentId = "parent-001"
        let childId  = "child-001"

        // Parent
        context.insert(Parent(
            id: parentId, name: "陳大明",
            email: "daming.chen@example.com",
            createdAt: daysAgo(30)
        ))

        // ChildProfile（ageGroup 使用 AgeGroup enum）
        context.insert(ChildProfile(
            id: childId, parentId: parentId,
            name: "小安", ageGroup: .elementary,
            deviceName: "小安的 iPhone",
            protectionEnabled: true,
            createdAt: daysAgo(20)
        ))

        // Rules
        let rules: [(String, RuleType, String, Bool, Date)] = [
            ("rule-001", .blacklist, "gambling-site.com",       true,  daysAgo(10)),
            ("rule-002", .blacklist, "adult-content.net",       true,  daysAgo(9)),
            ("rule-003", .blacklist, "violent-games.io",        false, daysAgo(8)),
            ("rule-004", .whitelist, "khanacademy.org",         true,  daysAgo(7)),
            ("rule-005", .whitelist, "nationalgeographic.com",  true,  daysAgo(6)),
            // S-1：category rule value 使用穩定英文 rawValue（對應 BlockEventCategory.rawValue）
            // 顯示名稱由 RuleRowView 透過 BlockEventCategory(rawValue:)?.displayName 解碼
            ("rule-006", .category,  BlockEventCategory.gambling.rawValue, true,  daysAgo(5)),
            ("rule-007", .category,  BlockEventCategory.adult.rawValue,    true,  daysAgo(4)),
            ("rule-008", .category,  BlockEventCategory.violence.rawValue, false, daysAgo(3))
        ]
        for (id, type, value, enabled, date) in rules {
            context.insert(Rule(
                id: id, childProfileId: childId,
                type: type, value: value,
                enabled: enabled, createdAt: date
            ))
        }

        // BlockEvents（category 使用英文 rawValue 的 BlockEventCategory enum）
        let events: [(String, String, String?, BlockEventCategory, RuleType, TimeInterval)] = [
            ("evt-001", "gambling-site.com",   "https://gambling-site.com/poker", .gambling,   .blacklist, -60 * 30),
            ("evt-002", "adult-content.net",   nil,                               .adult,      .blacklist, -60 * 90),
            ("evt-003", "violent-games.io",    nil,                               .violence,   .blacklist, -60 * 180),
            ("evt-004", "bad-ads-tracker.com", nil,                               .adTracking, .category,  -60 * 60 * 5),
            ("evt-005", "phishing-example.org",nil,                               .phishing,   .category,  -60 * 60 * 8),
            ("evt-006", "gambling-site.com",   nil,                               .gambling,   .blacklist, -60 * 60 * 25),
            ("evt-007", "adult-content.net",   nil,                               .adult,      .blacklist, -60 * 60 * 26),
            ("evt-008", "violent-games.io",    nil,                               .violence,   .blacklist, -60 * 60 * 30),
            ("evt-009", "spam-news.com",        nil,                               .spam,       .category,  -60 * 60 * 48),
            ("evt-010", "gambling-site.com",   nil,                               .gambling,   .blacklist, -60 * 60 * 72)
        ]
        for (id, domain, url, cat, ruleType, offset) in events {
            context.insert(BlockEvent(
                id: id, childProfileId: childId,
                domain: domain, url: url,
                category: cat, matchedRuleType: ruleType,
                blockedAt: Date(timeIntervalSinceNow: offset)
            ))
        }

        // AccessRequests
        let accessRequests: [(String, String, TimeInterval, String, AccessRequestStatus, TimeInterval?, String?)] = [
            (
                "req-001", "youtube.com", -60 * 60 * 2,
                "我需要看英文學習影片，這對我學英文很有幫助，老師也有推薦這些影片。",
                .pending, nil, nil
            ),
            (
                "req-002", "roblox.com", -60 * 60 * 48,
                "班上同學都在玩，我也想跟大家一起玩，不會花太多時間的。",
                .approved, -60 * 60 * 24, "可以玩，但每天最多一小時，功課做完才能玩。"
            ),
            (
                "req-003", "tiktok.com", -60 * 60 * 72,
                "我想看一些有趣的短影片，放鬆一下。",
                .denied, -60 * 60 * 60, "TikTok 的內容不適合你的年齡，等大一點再說。"
            )
        ]
        for (id, domain, reqOffset, reason, status, reviewOffset, note) in accessRequests {
            let reviewedAt = reviewOffset.map { Date(timeIntervalSinceNow: $0) }
            context.insert(AccessRequest(
                id: id,
                childProfileId: childId,
                domain: domain,
                requestedAt: Date(timeIntervalSinceNow: reqOffset),
                reason: reason,
                status: status,
                reviewedAt: reviewedAt,
                reviewerNote: note
            ))
        }

        try? context.save()
    }

    // MARK: - Helper

    private static func daysAgo(_ days: Int) -> Date {
        Date(timeIntervalSinceNow: -Double(days) * 86400)
    }
}
