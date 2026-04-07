import Foundation

struct ChildProfile: Identifiable {
    let id: String
    let parentId: String
    let name: String
    let ageGroup: String
    let deviceName: String?
    var protectionEnabled: Bool
    let createdAt: Date
}
