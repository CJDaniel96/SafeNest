import Foundation

/// 阻擋紀錄顯示邏輯。
struct EventHistoryViewModel {
    let events: [BlockEvent]  // 來自 @Query，已排序（最新優先）

    func filteredEvents(category: BlockEventCategory?) -> [BlockEvent] {
        guard let category else { return events }
        return events.filter { $0.category == category }
    }

    /// 只顯示事件中實際出現過的類別，避免篩選器出現空結果的選項
    var availableCategories: [BlockEventCategory] {
        let present = Set(events.map { $0.category })
        return BlockEventCategory.allCases.filter { present.contains($0) }
    }
}
