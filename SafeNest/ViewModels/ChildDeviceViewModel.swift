import Foundation

/// 孩子裝置頁顯示邏輯。
struct ChildDeviceViewModel {
    let child: ChildProfile?
    let recentEvents: [BlockEvent]  // 已排序，由呼叫端傳入 prefix(5)

    var childName: String        { child?.name ?? "未設定" }
    var deviceDisplayName: String { child?.deviceName ?? "未知裝置" }
    var ageGroup: String         { child?.ageGroup ?? "" }
    var protectionEnabled: Bool  { child?.protectionEnabled ?? false }
}
