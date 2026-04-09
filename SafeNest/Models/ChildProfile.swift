import Foundation
import SwiftData

// MARK: - AgeGroup

/// 孩子的年齡群組。
///
/// rawValue 使用穩定英文 key（SwiftData Codable 儲存鍵）。
/// displayName 回傳中文範圍字串供介面顯示。
enum AgeGroup: String, CaseIterable, Codable, Hashable {
    case earlyChildhood = "earlyChildhood"  // 0–5 歲
    case elementary     = "elementary"      // 6–12 歲
    case middleSchool   = "middleSchool"    // 13–15 歲
    case highSchool     = "highSchool"      // 16–18 歲

    var displayName: String {
        switch self {
        case .earlyChildhood: "0–5 歲"
        case .elementary:     "6–12 歲"
        case .middleSchool:   "13–15 歲"
        case .highSchool:     "16–18 歲"
        }
    }
}

// MARK: - ChildProfile

@Model
final class ChildProfile {
    @Attribute(.unique) var id: String
    var parentId: String
    var name: String
    var ageGroup: AgeGroup      // 由裸 String 改為 enum，型別安全
    var deviceName: String?
    var protectionEnabled: Bool
    var createdAt: Date

    init(id: String = UUID().uuidString,
         parentId: String,
         name: String,
         ageGroup: AgeGroup,    // 參數型別同步改為 AgeGroup
         deviceName: String? = nil,
         protectionEnabled: Bool = true,
         createdAt: Date = Date()) {
        self.id                = id
        self.parentId          = parentId
        self.name              = name
        self.ageGroup          = ageGroup
        self.deviceName        = deviceName
        self.protectionEnabled = protectionEnabled
        self.createdAt         = createdAt
    }
}
