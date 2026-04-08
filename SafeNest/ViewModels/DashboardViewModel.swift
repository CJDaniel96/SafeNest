import Foundation

/// Dashboard 顯示邏輯。
/// 資料來源改為從 View 的 @Query 結果傳入，不再持有 AppState。
struct DashboardViewModel {
    let child: ChildProfile?
    let blockEvents: [BlockEvent]  // 由呼叫端傳入已排序（最新優先）的事件

    // MARK: - Computed

    var weeklySummary: WeeklySummary { WeeklySummary(from: blockEvents) }

    var todayBlockedCount: Int {
        blockEvents.filter { $0.blockedAt.isToday }.count
    }

    var weeklyBlockedCount: Int { weeklySummary.totalBlocked }

    /// 最近 5 筆（blockEvents 已排序，直接取 prefix）
    var recentEvents: [BlockEvent] {
        Array(blockEvents.prefix(5))
    }

    var topCategories: [(label: String, count: Int)] {
        let s = weeklySummary
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
