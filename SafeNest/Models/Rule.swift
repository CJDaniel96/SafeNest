import Foundation

enum RuleType: String, CaseIterable {
    case blacklist = "blacklist"
    case whitelist = "whitelist"
    case category  = "category"

    var displayName: String {
        switch self {
        case .blacklist: return "黑名單"
        case .whitelist: return "白名單"
        case .category:  return "類別封鎖"
        }
    }
}

struct Rule: Identifiable {
    let id: String
    let childProfileId: String
    let type: String          // matches RuleType.rawValue
    let value: String
    var enabled: Bool
    let createdAt: Date

    var ruleType: RuleType {
        RuleType(rawValue: type) ?? .blacklist
    }
}
