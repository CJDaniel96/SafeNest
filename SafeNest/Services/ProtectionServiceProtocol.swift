import Foundation

/// 系統層保護授權與開關的抽象。
///
/// 真實整合點（FamilyControls）：
///   - `isAuthorized`          → `AuthorizationCenter.shared.authorizationStatus == .approved`
///   - `requestAuthorization`  → `AuthorizationCenter.shared.requestAuthorization(for: .individual(bundleIdentifier:))`
///   - `enableProtection`      → `ManagedSettingsStore` 套用預設封鎖政策
///   - `disableProtection`     → `ManagedSettingsStore.clearAllSettings()`
///
/// Mock 實作：`MockProtectionService`（見 MockServices.swift）。
///
/// ⚠️ 傳入 `childId: String` 而非 `@Model` 物件，
///    避免 @Model class 在 Swift 6 下跨 actor 邊界的 Sendable 問題。
protocol ProtectionServiceProtocol: AnyObject {
    /// 是否已取得 FamilyControls 使用授權
    var isAuthorized: Bool { get }
    /// 向系統請求授權（首次使用時顯示家長驗證提示）
    func requestAuthorization() async throws
    /// 啟用裝置保護（套用 ManagedSettings 封鎖政策）
    func enableProtection(for childId: String) async throws
    /// 停用裝置保護（清除 ManagedSettings 所有限制）
    func disableProtection(for childId: String) async throws
}
