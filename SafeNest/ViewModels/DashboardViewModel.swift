import Foundation
import Combine

@Observable
final class DashboardViewModel {
    private(set) var child: ChildProfile
    private(set) var recentEvents: [BlockEvent]
    private(set) var weeklySummary: WeeklySummary
    private(set) var todayBlockedCount: Int
    private(set) var weeklyBlockedCount: Int

    init(
        child: ChildProfile = MockData.childProfile,
        events: [BlockEvent] = MockData.blockEvents,
        summary: WeeklySummary = MockData.weeklySummary
    ) {
        self.child = child
        self.weeklySummary = summary

        let sorted = events.sorted { $0.blockedAt > $1.blockedAt }
        self.recentEvents = Array(sorted.prefix(5))
        self.todayBlockedCount = events.filter { $0.blockedAt.isToday }.count
        self.weeklyBlockedCount = summary.totalBlocked
    }

    /// 風險類別摘要列表，依數量排序
    var topCategories: [(label: String, count: Int)] {
        [
            ("成人內容", weeklySummary.adultCount),
            ("賭博",    weeklySummary.gamblingCount),
            ("暴力",    weeklySummary.violenceCount),
            ("其他",    weeklySummary.otherCount)
        ]
        .filter { $0.count > 0 }
        .sorted { $0.count > $1.count }
    }
}
