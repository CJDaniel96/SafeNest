import Foundation

/// 家長審核申請表單的本地狀態。
/// 送出操作由 View 呼叫 AppState.submitAccessRequest(...)，
/// 此 ViewModel 僅管理表單輸入與送出後的 UI 狀態。
@Observable
final class RequestAccessViewModel {
    var reason: String = ""
    var isSubmitting: Bool = false
    var didSubmitSuccessfully: Bool = false

    var canSubmit: Bool {
        !reason.trimmingCharacters(in: .whitespaces).isEmpty && !isSubmitting
    }

    func reset() {
        reason = ""
        isSubmitting = false
        didSubmitSuccessfully = false
    }
}
