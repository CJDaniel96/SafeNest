import Foundation
import SwiftData

// MARK: - RuleType（Codable 供 SwiftData 儲存）

enum RuleType: String, CaseIterable, Hashable, Identifiable, Codable {
    case blacklist = "blacklist"
    case whitelist = "whitelist"
    case category  = "category"

    var id: String { rawValue }

    var displayName: String {
        switch self {
        case .blacklist: "黑名單"
        case .whitelist: "白名單"
        case .category:  "類別封鎖"
        }
    }
}

// MARK: - Rule

@Model
final class Rule {
    @Attribute(.unique) var id: String   // I-1：唯一約束，防止重複紀錄
    var childProfileId: String
    var type: RuleType   // enum，SwiftData 透過 Codable 序列化
    var value: String
    var enabled: Bool
    var createdAt: Date

    init(id: String = UUID().uuidString,
         childProfileId: String,
         type: RuleType,
         value: String,
         enabled: Bool = true,
         createdAt: Date = Date()) {
        self.id             = id
        self.childProfileId = childProfileId
        self.type           = type
        self.value          = value
        self.enabled        = enabled
        self.createdAt      = createdAt
    }
}
