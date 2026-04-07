import Foundation

/// 孩子裝置頁的顯示邏輯。
struct ChildDeviceViewModel {
    private let store: AppState

    init(store: AppState) {
        self.store = store
    }

    // MARK: - Computed Properties

    var child: ChildProfile { store.childProfile }

    var deviceDisplayName: String {
        store.childProfile.deviceName ?? "未知裝置"
    }

    var recentEvents: [BlockEvent] {
        Array(store.blockEvents
            .sorted { $0.blockedAt > $1.blockedAt }
            .prefix(5))
    }
}
