import Foundation

/// 兒少首頁顯示邏輯。
struct ChildHomeViewModel {
    let child: ChildProfile?
    let todayBlockedCount: Int

    init(child: ChildProfile?, blockEvents: [BlockEvent]) {
        self.child             = child
        self.todayBlockedCount = blockEvents.filter { $0.blockedAt.isToday }.count
    }

    var childName: String        { child?.name        ?? "孩子"  }
    var ageGroup: String         { child?.ageGroup    ?? ""      }
    var deviceDisplayName: String { child?.deviceName ?? "此裝置" }
    var protectionEnabled: Bool  { child?.protectionEnabled ?? false }
}
