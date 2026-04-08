import Foundation
import SwiftData

// MARK: - BlockEventCategory（Codable 供 SwiftData 儲存）

enum BlockEventCategory: String, CaseIterable, Identifiable, Hashable, Codable {
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

@Model
final class BlockEvent {
    var id: String
    var childProfileId: String
    var domain: String
    var url: String?
    var category: BlockEventCategory  // enum，SwiftData 透過 Codable 序列化
    var matchedRuleType: RuleType     // enum，SwiftData 透過 Codable 序列化
    var blockedAt: Date

    init(id: String = UUID().uuidString,
         childProfileId: String,
         domain: String,
         url: String? = nil,
         category: BlockEventCategory,
         matchedRuleType: RuleType,
         blockedAt: Date = Date()) {
        self.id             = id
        self.childProfileId = childProfileId
        self.domain         = domain
        self.url            = url
        self.category       = category
        self.matchedRuleType = matchedRuleType
        self.blockedAt      = blockedAt
    }
}
