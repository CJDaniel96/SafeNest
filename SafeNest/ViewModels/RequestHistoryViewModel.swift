import Foundation

/// 孩子端申請歷史的顯示邏輯
struct RequestHistoryViewModel {
    let requests: [AccessRequest]   // 呼叫端傳入已排序（最新優先）

    var pendingRequests: [AccessRequest] {
        requests.filter { $0.status == .pending }
    }

    var reviewedRequests: [AccessRequest] {
        requests.filter { $0.status != .pending }
    }
}
