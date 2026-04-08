import Foundation
import SwiftData

@Model
final class ChildProfile {
    var id: String
    var parentId: String
    var name: String
    var ageGroup: String
    var deviceName: String?
    var protectionEnabled: Bool
    var createdAt: Date

    init(id: String = UUID().uuidString,
         parentId: String,
         name: String,
         ageGroup: String,
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
