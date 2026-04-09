import Foundation
import SwiftData

@Model
final class Parent {
    @Attribute(.unique) var id: String   // I-1：唯一約束，防止 seed 重複執行時產生重複紀錄
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
