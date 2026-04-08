import Foundation

/// 家長審核申請的本地狀態。不需持久化，送出後僅顯示成功提示。
@Observable
final class RequestAccessViewModel {
    var reason: String = ""
    var isSubmitting: Bool = false
    var didSubmitSuccessfully: Bool = false

    var canSubmit: Bool {
        !reason.trimmingCharacters(in: .whitespaces).isEmpty && !isSubmitting
    }

    /// 模擬送出申請（MVP：無真實後端，1 秒後標記成功）
    func submit(domain: String) async {
        guard canSubmit else { return }
        isSubmitting = true
        try? await Task.sleep(for: .seconds(1))
        // TODO: 未來連接後端 API，將 domain + reason 傳送給家長
        didSubmitSuccessfully = true
        isSubmitting = false
    }

    func reset() {
        reason = ""
        isSubmitting = false
        didSubmitSuccessfully = false
    }
}
