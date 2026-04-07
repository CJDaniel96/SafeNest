import Foundation

/// 阻擋紀錄的顯示邏輯。
/// selectedCategory（UI 篩選狀態）維持在 View 層的 @State。
struct EventHistoryViewModel {
    private let store: AppState

    init(store: AppState) {
        self.store = store
    }

    // MARK: - Computed Properties

    /// 依時間排序（最新優先）的完整事件列表
    var sortedEvents: [BlockEvent] {
        store.blockEvents.sorted { $0.blockedAt > $1.blockedAt }
    }

    /// 依指定類別篩選；nil 表示全部
    func filteredEvents(category: BlockEventCategory?) -> [BlockEvent] {
        guard let category else { return sortedEvents }
        return sortedEvents.filter { $0.category == category }
    }

    /// 只顯示事件中實際出現過的類別（避免篩選器出現空結果的選項）
    var availableCategories: [BlockEventCategory] {
        let present = Set(store.blockEvents.map { $0.category })
        return BlockEventCategory.allCases.filter { present.contains($0) }
    }
}
