import Foundation
import SwiftData

// MARK: - BlockEventCategory

/// 封鎖事件的內容類別。
///
/// ⚠️ rawValue 使用穩定英文 key（作為 SwiftData Codable 儲存鍵）。
/// displayName 獨立定義，未來修改顯示文字不影響已儲存資料。
enum BlockEventCategory: String, CaseIterable, Identifiable, Hashable, Codable {
    case adult      = "adult"
    case gambling   = "gambling"
    case violence   = "violence"
    case phishing   = "phishing"
    case adTracking = "adTracking"
    case spam       = "spam"
    case other      = "other"

    var id: String { rawValue }

    /// 介面顯示名稱（與 rawValue 解耦，可自由修改不影響儲存）
    var displayName: String {
        switch self {
        case .adult:      "成人內容"
        case .gambling:   "賭博"
        case .violence:   "暴力"
        case .phishing:   "釣魚網站"
        case .adTracking: "廣告追蹤"
        case .spam:       "垃圾資訊"
        case .other:      "其他"
        }
    }
}

// MARK: - BlockEvent

@Model
final class BlockEvent {
    @Attribute(.unique) var id: String
    var childProfileId: String
    var domain: String
    var url: String?
    var category: BlockEventCategory  // enum，SwiftData 透過 Codable 以英文 rawValue 序列化
    var matchedRuleType: RuleType     // enum，SwiftData 透過 Codable 序列化
    var blockedAt: Date

    init(id: String = UUID().uuidString,
         childProfileId: String,
         domain: String,
         url: String? = nil,
         category: BlockEventCategory,
         matchedRuleType: RuleType,
         blockedAt: Date = Date()) {
        self.id              = id
        self.childProfileId  = childProfileId
        self.domain          = domain
        self.url             = url
        self.category        = category
        self.matchedRuleType = matchedRuleType
        self.blockedAt       = blockedAt
    }
}
