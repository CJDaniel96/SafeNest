import Foundation

/// 家長審核收件匣的顯示邏輯
struct AccessRequestInboxViewModel {
    let requests: [AccessRequest]   // 呼叫端傳入已排序（最新優先）

    var pendingRequests: [AccessRequest] {
        requests.filter { $0.status == .pending }
    }

    var reviewedRequests: [AccessRequest] {
        requests.filter { $0.status != .pending }
    }

    var pendingCount: Int { pendingRequests.count }
}
