import Foundation

/// 兒少首頁顯示邏輯。
struct ChildHomeViewModel {
    let child: ChildProfile?
    let blockEvents: [BlockEvent]

    var childName: String         { child?.name        ?? "孩子"   }

    /// ageGroup 為 AgeGroup enum，透過 displayName 取得顯示文字
    var ageGroup: String          { child?.ageGroup.displayName ?? "" }

    var deviceDisplayName: String { child?.deviceName  ?? "此裝置"  }
    var protectionEnabled: Bool   { child?.protectionEnabled ?? false }

    var todayBlockedCount: Int {
        blockEvents.filter { $0.blockedAt.isToday }.count
    }
}
