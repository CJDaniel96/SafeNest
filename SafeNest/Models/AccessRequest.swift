import Foundation
import SwiftData

// MARK: - Status Enum

enum AccessRequestStatus: String, CaseIterable, Codable, Hashable {
    case pending  = "pending"
    case approved = "approved"
    case denied   = "denied"

    var displayName: String {
        switch self {
        case .pending:  return "待審核"
        case .approved: return "已核准"
        case .denied:   return "已拒絕"
        }
    }
}

// MARK: - Model

@Model
final class AccessRequest {
    @Attribute(.unique) var id: String
    var childProfileId: String
    var domain: String
    var requestedAt: Date
    var reason: String
    var status: AccessRequestStatus
    var reviewedAt: Date?
    var reviewerNote: String?

    init(
        id: String = UUID().uuidString,
        childProfileId: String,
        domain: String,
        requestedAt: Date = .now,
        reason: String,
        status: AccessRequestStatus = .pending,
        reviewedAt: Date? = nil,
        reviewerNote: String? = nil
    ) {
        self.id = id
        self.childProfileId = childProfileId
        self.domain = domain
        self.requestedAt = requestedAt
        self.reason = reason
        self.status = status
        self.reviewedAt = reviewedAt
        self.reviewerNote = reviewerNote
    }
}
