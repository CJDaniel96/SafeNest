import Foundation

struct BlockEvent: Identifiable {
    let id: String
    let childProfileId: String
    let domain: String
    let url: String?
    let category: String
    let matchedRuleType: String
    let blockedAt: Date
}
