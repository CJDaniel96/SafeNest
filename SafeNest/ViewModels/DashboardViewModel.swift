import Foundation

/// Dashboard 的顯示邏輯。
/// struct 持有 AppState 參考，所有計算屬性都即時從 AppState 讀取，
/// 因此當 AppState 的 @Observable 屬性被修改時，SwiftUI 會自動重新渲染 View。
struct DashboardViewModel {
    private let store: AppState

    init(store: AppState) {
        self.store = store
    }

    // MARK: - Computed Properties

    var child: ChildProfile { store.childProfile }
    var weeklySummary: WeeklySummary { store.weeklySummary }

    var todayBlockedCount: Int {
        store.blockEvents.filter { $0.blockedAt.isToday }.count
    }

    var weeklyBlockedCount: Int {
        store.weeklySummary.totalBlocked
    }

    var recentEvents: [BlockEvent] {
        Array(store.blockEvents
            .sorted { $0.blockedAt > $1.blockedAt }
            .prefix(5))
    }

    var topCategories: [(label: String, count: Int)] {
        let s = store.weeklySummary
        return [
            ("成人內容", s.adultCount),
            ("賭博",    s.gamblingCount),
            ("暴力",    s.violenceCount),
            ("其他",    s.otherCount)
        ]
        .filter { $0.count > 0 }
        .sorted { $0.count > $1.count }
    }
}
