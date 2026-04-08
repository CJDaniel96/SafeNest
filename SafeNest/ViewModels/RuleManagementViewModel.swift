import Foundation

/// 規則管理顯示邏輯。
/// 寫入操作（add / delete / toggle）透過 View 的 AppState + ModelContext 執行。
struct RuleManagementViewModel {
    let rules: [Rule]  // 來自 @Query，SwiftData 自動保持最新

    func filteredRules(for tab: RuleType) -> [Rule] {
        rules
            .filter { $0.type == tab }
            .sorted { $0.createdAt < $1.createdAt }
    }
}
