import Foundation

enum MockData {

    // MARK: - Parent
    static let parent = Parent(
        id: "parent-001",
        name: "陳大明",
        email: "daming.chen@example.com",
        createdAt: Date(timeIntervalSinceNow: -60 * 60 * 24 * 30)
    )

    // MARK: - ChildProfile
    static let childProfile = ChildProfile(
        id: "child-001",
        parentId: "parent-001",
        name: "小安",
        ageGroup: "6–12 歲",
        deviceName: "小安的 iPhone",
        protectionEnabled: true,
        createdAt: Date(timeIntervalSinceNow: -60 * 60 * 24 * 20)
    )

    // MARK: - Rules
    static let rules: [Rule] = [
        Rule(id: "rule-001", childProfileId: "child-001",
             type: RuleType.blacklist.rawValue, value: "gambling-site.com",
             enabled: true, createdAt: date(daysAgo: 10)),
        Rule(id: "rule-002", childProfileId: "child-001",
             type: RuleType.blacklist.rawValue, value: "adult-content.net",
             enabled: true, createdAt: date(daysAgo: 9)),
        Rule(id: "rule-003", childProfileId: "child-001",
             type: RuleType.blacklist.rawValue, value: "violent-games.io",
             enabled: false, createdAt: date(daysAgo: 8)),
        Rule(id: "rule-004", childProfileId: "child-001",
             type: RuleType.whitelist.rawValue, value: "khanacademy.org",
             enabled: true, createdAt: date(daysAgo: 7)),
        Rule(id: "rule-005", childProfileId: "child-001",
             type: RuleType.whitelist.rawValue, value: "nationalgeographic.com",
             enabled: true, createdAt: date(daysAgo: 6)),
        Rule(id: "rule-006", childProfileId: "child-001",
             type: RuleType.category.rawValue, value: "賭博",
             enabled: true, createdAt: date(daysAgo: 5)),
        Rule(id: "rule-007", childProfileId: "child-001",
             type: RuleType.category.rawValue, value: "成人內容",
             enabled: true, createdAt: date(daysAgo: 4)),
        Rule(id: "rule-008", childProfileId: "child-001",
             type: RuleType.category.rawValue, value: "暴力",
             enabled: false, createdAt: date(daysAgo: 3))
    ]

    // MARK: - BlockEvents
    static let blockEvents: [BlockEvent] = [
        BlockEvent(id: "evt-001", childProfileId: "child-001",
                   domain: "gambling-site.com", url: "https://gambling-site.com/poker",
                   category: "賭博", matchedRuleType: "blacklist",
                   blockedAt: Date(timeIntervalSinceNow: -60 * 30)),
        BlockEvent(id: "evt-002", childProfileId: "child-001",
                   domain: "adult-content.net", url: nil,
                   category: "成人內容", matchedRuleType: "blacklist",
                   blockedAt: Date(timeIntervalSinceNow: -60 * 90)),
        BlockEvent(id: "evt-003", childProfileId: "child-001",
                   domain: "violent-games.io", url: nil,
                   category: "暴力", matchedRuleType: "blacklist",
                   blockedAt: Date(timeIntervalSinceNow: -60 * 180)),
        BlockEvent(id: "evt-004", childProfileId: "child-001",
                   domain: "bad-ads-tracker.com", url: nil,
                   category: "廣告追蹤", matchedRuleType: "category",
                   blockedAt: Date(timeIntervalSinceNow: -60 * 60 * 5)),
        BlockEvent(id: "evt-005", childProfileId: "child-001",
                   domain: "phishing-example.org", url: nil,
                   category: "釣魚網站", matchedRuleType: "category",
                   blockedAt: Date(timeIntervalSinceNow: -60 * 60 * 8)),
        BlockEvent(id: "evt-006", childProfileId: "child-001",
                   domain: "gambling-site.com", url: nil,
                   category: "賭博", matchedRuleType: "blacklist",
                   blockedAt: Date(timeIntervalSinceNow: -60 * 60 * 25)),
        BlockEvent(id: "evt-007", childProfileId: "child-001",
                   domain: "adult-content.net", url: nil,
                   category: "成人內容", matchedRuleType: "blacklist",
                   blockedAt: Date(timeIntervalSinceNow: -60 * 60 * 26)),
        BlockEvent(id: "evt-008", childProfileId: "child-001",
                   domain: "violent-games.io", url: nil,
                   category: "暴力", matchedRuleType: "blacklist",
                   blockedAt: Date(timeIntervalSinceNow: -60 * 60 * 30)),
        BlockEvent(id: "evt-009", childProfileId: "child-001",
                   domain: "spam-news.com", url: nil,
                   category: "垃圾資訊", matchedRuleType: "category",
                   blockedAt: Date(timeIntervalSinceNow: -60 * 60 * 48)),
        BlockEvent(id: "evt-010", childProfileId: "child-001",
                   domain: "gambling-site.com", url: nil,
                   category: "賭博", matchedRuleType: "blacklist",
                   blockedAt: Date(timeIntervalSinceNow: -60 * 60 * 72))
    ]

    // MARK: - WeeklySummary
    static let weeklySummary = WeeklySummary(
        childProfileId: "child-001",
        weekStart: date(daysAgo: 7),
        totalBlocked: 10,
        adultCount: 2,
        gamblingCount: 3,
        violenceCount: 2,
        otherCount: 3
    )

    // MARK: - Helper
    private static func date(daysAgo days: Int) -> Date {
        Date(timeIntervalSinceNow: -Double(days) * 86400)
    }
}
