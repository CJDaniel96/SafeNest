import Foundation

/// Dashboard 顯示邏輯。
/// 資料來源由 View 的 @Query 結果傳入，不再持有 AppState。
struct DashboardViewModel {
    let child: ChildProfile?
    let blockEvents: [BlockEvent]       // 已排序（最新優先）
    let accessRequests: [AccessRequest] // 已排序（最新優先）

    // MARK: - Block Events

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

    // MARK: - Access Requests

    var pendingRequestCount: Int {
        accessRequests.filter { $0.status == .pending }.count
    }

    /// 最近 3 筆申請（含所有狀態）
    var recentAccessRequests: [AccessRequest] {
        Array(accessRequests.prefix(3))
    }
}
