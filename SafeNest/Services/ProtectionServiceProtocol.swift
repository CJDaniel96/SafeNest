import Foundation

/// 擴充點：未來對接 NetworkExtension / ManagedSettings / Family Controls 時實作此 protocol。
/// MVP 階段不實作任何真實能力，僅作介面佔位。
protocol ProtectionServiceProtocol {
    /// 啟用保護
    func enableProtection(for childId: String) async throws
    /// 停用保護
    func disableProtection(for childId: String) async throws
    /// 同步規則至系統
    func syncRules(_ rules: [Rule], for childId: String) async throws
}

/// Stub 實作：MVP 期間使用，不做任何真實操作。
final class StubProtectionService: ProtectionServiceProtocol {
    func enableProtection(for childId: String) async throws {
        // TODO: 接 NetworkExtension / ManagedSettings
    }
    func disableProtection(for childId: String) async throws {
        // TODO: 接 NetworkExtension / ManagedSettings
    }
    func syncRules(_ rules: [Rule], for childId: String) async throws {
        // TODO: 同步規則到系統層
    }
}
