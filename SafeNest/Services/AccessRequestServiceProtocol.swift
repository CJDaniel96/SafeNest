import Foundation
import SwiftData

/// 審核申請業務邏輯的抽象。
///
/// 真實整合點（可擴充）：
///   - `submitAccessRequest` → 發送推播通知到家長裝置；
///                             或整合 FamilyActivityPicker 流程
///   - `approveRequest`      → 通知孩子裝置結果；
///                             觸發 BlockingService 更新該網域的例外清單
///   - `denyRequest`         → 通知孩子裝置結果
///
/// Mock 實作：直接操作 SwiftData（見 MockServices.swift）。
///
/// ⚠️ 此 protocol 是 `RequestAccessViewModel` 的直接依賴，
///    是本輪 MVVM 解耦的核心接縫：ViewModel 依賴 protocol，不依賴 AppState 或具體實作。
protocol AccessRequestServiceProtocol: AnyObject {
    func submitAccessRequest(
        domain: String,
        childProfileId: String,
        reason: String,
        in context: ModelContext
    )
    func approveRequest(_ request: AccessRequest, note: String)
    func denyRequest(_ request: AccessRequest, note: String)
}
