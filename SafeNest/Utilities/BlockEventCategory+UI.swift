import SwiftUI

/// BlockEventCategory 的 UI 相關擴充（icon / color）
/// 放在 Utilities 而非 Models，讓 Model 層保持無 SwiftUI 依賴
extension BlockEventCategory {
    var icon: String {
        switch self {
        case .adult:      "eye.slash.fill"
        case .gambling:   "suit.club.fill"
        case .violence:   "bolt.fill"
        case .phishing:   "exclamationmark.triangle.fill"
        case .adTracking: "antenna.radiowaves.left.and.right"
        case .spam:       "trash.fill"
        case .other:      "xmark.shield.fill"
        }
    }

    var color: Color {
        switch self {
        case .adult:      .red
        case .gambling:   .purple
        case .violence:   .orange
        case .phishing:   .yellow
        case .adTracking: .teal
        case .spam:       .brown
        case .other:      .gray
        }
    }
}
