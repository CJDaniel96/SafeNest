import Foundation

// MARK: - RuleType

enum RuleType: String, CaseIterable, Hashable, Identifiable {
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

struct Rule: Identifiable {
    let id: String
    let childProfileId: String
    let type: RuleType   // ← enum，不再用 String
    let value: String
    var enabled: Bool
    let createdAt: Date
}
