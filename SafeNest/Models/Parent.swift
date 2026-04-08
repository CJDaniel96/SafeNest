import Foundation
import SwiftData

@Model
final class Parent {
    var id: String
    var name: String
    var email: String
    var createdAt: Date

    init(id: String = UUID().uuidString,
         name: String,
         email: String,
         createdAt: Date = Date()) {
        self.id        = id
        self.name      = name
        self.email     = email
        self.createdAt = createdAt
    }
}
