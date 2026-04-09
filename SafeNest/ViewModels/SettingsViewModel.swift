import Foundation

/// 設定頁顯示邏輯。
struct SettingsViewModel {
    let parent: Parent?
    let child: ChildProfile?

    var parentName: String  { parent?.name  ?? "未設定" }
    var parentEmail: String { parent?.email ?? "" }
    var childName: String   { child?.name   ?? "未設定" }

    /// ageGroup 為 AgeGroup enum，透過 displayName 取得顯示文字
    var childAgeGroup: String { child?.ageGroup.displayName ?? "" }

    var deviceName: String  { child?.deviceName ?? "尚未設定" }
    var protectionEnabled: Bool { child?.protectionEnabled ?? false }
}
