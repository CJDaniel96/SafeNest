import Foundation

/// App 的使用角色。控制根導覽要顯示家長端或兒少端介面。
enum AppRole: String, CaseIterable {
    case parent = "parent"
    case child  = "child"

    var displayName: String {
        switch self {
        case .parent: "家長模式"
        case .child:  "孩子模式"
        }
    }

    var icon: String {
        switch self {
        case .parent: "person.fill"
        case .child:  "figure.child"
        }
    }
}
