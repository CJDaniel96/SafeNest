import Foundation

/// 保護規則同步至系統網路過濾層的抽象。
///
/// 真實整合點：
///   - `syncRules`
///       - `.blacklist` → `ManagedSettingsStore.webContent.blockedByFilter`（自訂封鎖清單）
///       - `.whitelist` → `ManagedSettingsStore.webContent.alwaysAllowedWebsites`
///       - `.category`  → `ManagedSettingsStore.webContent.blockedByFilter`（ContentPolicy Shield）
///                        或 `NEFilterDataProvider` 的 DNS-level 過濾
///   - `clearAll`       → `ManagedSettingsStore(named:).clearAllSettings()`
///
/// Mock 實作：`MockBlockingService`（見 MockServices.swift）。
///
/// ⚠️ `syncRules` 接受完整規則清單，實作內部自行過濾 `enabled == true`，
///    AppState 不在此處做過濾，保留彈性（例如未來支援「預覽模式」）。
///
/// ⚠️ 方法設計為同步（非 async）：
///    ManagedSettings API 本身是同步的，且 [Rule] 為 @Model（非 Sendable），
///    async 方法會強制跨 actor 邊界傳遞 @Model 物件，在 Swift 6 下是編譯錯誤。
///    真實實作若需要非同步工作（例如網路呼叫），應在實作內部建立 Task，不應在 protocol 宣告 async。
protocol BlockingServiceProtocol: AnyObject {
    /// 將目前所有規則同步到系統過濾層
    func syncRules(_ rules: [Rule], for childId: String)
    /// 清除指定孩子的所有系統層封鎖規則（保護停用時呼叫）
    func clearAll(for childId: String)
}
