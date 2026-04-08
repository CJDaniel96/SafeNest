import Foundation

/// 非持久化 — 由 BlockEvent 動態計算，不存入 SwiftData。
/// 原因：Weekly Summary 是聚合統計值，任何 BlockEvent 變動都應即時反映，
/// 若存成獨立 Model 反而需要維護同步邏輯，不如每次從原始資料重新計算。
struct WeeklySummary {
    let totalBlocked: Int
    let adultCount: Int
    let gamblingCount: Int
    let violenceCount: Int
    let otherCount: Int

    /// 從過去 7 天的 BlockEvent 計算
    init(from events: [BlockEvent]) {
        let cutoff = Calendar.current.date(byAdding: .day, value: -7, to: Date()) ?? Date()
        let recent = events.filter { $0.blockedAt >= cutoff }

        totalBlocked  = recent.count
        adultCount    = recent.filter { $0.category == .adult    }.count
        gamblingCount = recent.filter { $0.category == .gambling }.count
        violenceCount = recent.filter { $0.category == .violence }.count

        let mainCats: Set<BlockEventCategory> = [.adult, .gambling, .violence]
        otherCount = recent.filter { !mainCats.contains($0.category) }.count
    }
}
