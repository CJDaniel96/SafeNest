import Foundation
import SwiftData

/// 申請審核表單的狀態 ViewModel。
///
/// 設計說明（Round 6 MVVM 解耦）：
/// - 直接依賴 `AccessRequestServiceProtocol`，而非 AppState 或任何具體實作
/// - submit() 方法內聚了送出邏輯，View 只需傳入 domain / childProfileId / context
/// - 預設使用 MockAccessRequestService，不需要 View 層額外注入
///
/// 未來整合真實 service 時，在 View 的 init 或透過 environment 傳入不同 service instance，
/// ViewModel 邏輯本身不需修改。
@Observable
final class RequestAccessViewModel {
    var reason: String = ""
    var isSubmitting: Bool = false
    var didSubmitSuccessfully: Bool = false

    private let service: any AccessRequestServiceProtocol

    /// 預設使用 MockAccessRequestService。
    /// 真實 app 可在建立 View 時傳入 RealAccessRequestService：
    ///   `@State private var vm = RequestAccessViewModel(service: appState.accessRequestService)`
    init(service: any AccessRequestServiceProtocol = MockAccessRequestService()) {
        self.service = service
    }

    var canSubmit: Bool {
        !reason.trimmingCharacters(in: .whitespaces).isEmpty && !isSubmitting
    }

    /// 送出申請。View 層呼叫此方法，不再直接呼叫 AppState。
    func submit(domain: String, childProfileId: String, in context: ModelContext) {
        guard canSubmit, !childProfileId.isEmpty else { return }
        isSubmitting = true
        service.submitAccessRequest(
            domain: domain,
            childProfileId: childProfileId,
            reason: reason,
            in: context
        )
        isSubmitting = false
        didSubmitSuccessfully = true
    }

    func reset() {
        reason = ""
        isSubmitting = false
        didSubmitSuccessfully = false
    }
}
