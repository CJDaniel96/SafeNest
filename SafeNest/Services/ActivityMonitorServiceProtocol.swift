import Foundation
import SwiftData

/// 阻擋事件記錄的抽象。
///
/// 真實整合點（DeviceActivity 架構）：
///   1. NetworkExtension / ManagedSettings 攔截請求 → 觸發 DeviceActivity extension（獨立 process）
///   2. Extension 透過 App Group Shared Container 寫入原始事件
///   3. 主 App 實作 `DeviceActivityReportExtension`，排程讀取 → 呼叫 `logBlockEvent` 寫入 SwiftData
///
/// Mock 實作：直接將事件插入 SwiftData，模擬 extension 行為（見 MockServices.swift）。
/// Demo 流程中由 `AppState.recordBlockEvent(...)` 呼叫，讓阻擋示範同時產生可見紀錄。
///
/// ⚠️ 真實整合後，主 App 不應直接呼叫此 method（extension 負責）；
///    `AppState.recordBlockEvent` 可保留供 QA / 測試用途。
protocol ActivityMonitorServiceProtocol: AnyObject {
    /// 記錄一筆阻擋事件到 SwiftData
    func logBlockEvent(
        domain: String,
        url: String?,
        category: BlockEventCategory,
        ruleType: RuleType,
        childProfileId: String,
        in context: ModelContext
    )
}
