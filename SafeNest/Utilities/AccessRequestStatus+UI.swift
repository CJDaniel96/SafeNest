import SwiftUI

extension AccessRequestStatus {
    var icon: String {
        switch self {
        case .pending:  return "clock.fill"
        case .approved: return "checkmark.circle.fill"
        case .denied:   return "xmark.circle.fill"
        }
    }

    var color: Color {
        switch self {
        case .pending:  return .orange
        case .approved: return .green
        case .denied:   return .red
        }
    }
}
