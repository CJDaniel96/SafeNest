import Foundation

/// 設定頁的顯示邏輯與操作代理。
/// notificationsEnabled / weeklySummaryEnabled / parentalPINEnabled 等純 UI 開關
/// 維持在 View 層的 @State（目前不影響其他頁面）。
struct SettingsViewModel {
    private let store: AppState

    init(store: AppState) {
        self.store = store
    }

    // MARK: - Computed Properties

    var parent: Parent       { store.parent }
    var child: ChildProfile  { store.childProfile }

    // MARK: - Actions

    func toggleProtection() {
        store.toggleProtection()
    }
}
