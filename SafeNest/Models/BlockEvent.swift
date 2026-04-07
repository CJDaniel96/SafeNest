import Foundation

// MARK: - BlockEventCategory

enum BlockEventCategory: String, CaseIterable, Identifiable, Hashable {
    case adult      = "成人內容"
    case gambling   = "賭博"
    case violence   = "暴力"
    case phishing   = "釣魚網站"
    case adTracking = "廣告追蹤"
    case spam       = "垃圾資訊"
    case other      = "其他"

    var id: String { rawValue }
    var displayName: String { rawValue }
}

// MARK: - BlockEvent

struct BlockEvent: Identifiable {
    let id: String
    let childProfileId: String
    let domain: String
    let url: String?
    let category: BlockEventCategory   // ← enum，不再用 String
    let matchedRuleType: RuleType      // ← enum，不再用 String
    let blockedAt: Date
}
