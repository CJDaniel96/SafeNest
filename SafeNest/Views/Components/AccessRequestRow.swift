import SwiftUI

/// 單一審核申請列表行（家長端收件匣 + 孩子端歷史共用）
struct AccessRequestRow: View {
    let request: AccessRequest

    var body: some View {
        HStack(spacing: 12) {
            Image(systemName: request.status.icon)
                .foregroundStyle(request.status.color)
                .frame(width: 28)

            VStack(alignment: .leading, spacing: 3) {
                Text(request.domain)
                    .font(.subheadline)
                    .fontWeight(.medium)
                    .lineLimit(1)
                    .truncationMode(.middle)
                Text(request.reason)
                    .font(.caption)
                    .foregroundStyle(.secondary)
                    .lineLimit(2)
            }

            Spacer()

            VStack(alignment: .trailing, spacing: 4) {
                StatusBadge(status: request.status)
                Text(request.requestedAt.relativeDescription)
                    .font(.caption2)
                    .foregroundStyle(.tertiary)
            }
        }
        .padding(.vertical, 4)
    }
}

// MARK: - StatusBadge

struct StatusBadge: View {
    let status: AccessRequestStatus

    var body: some View {
        Text(status.displayName)
            .font(.caption2)
            .fontWeight(.semibold)
            .padding(.horizontal, 8)
            .padding(.vertical, 3)
            .background(status.color.opacity(0.15), in: Capsule())
            .foregroundStyle(status.color)
    }
}

// MARK: - Preview

#Preview {
    List {
        AccessRequestRow(request: AccessRequest(
            childProfileId: "child-001",
            domain: "youtube.com",
            reason: "我需要看英文學習影片，對學習很有幫助。",
            status: .pending
        ))
        AccessRequestRow(request: AccessRequest(
            childProfileId: "child-001",
            domain: "roblox.com",
            reason: "同學都在玩，我想一起玩。",
            status: .approved,
            reviewedAt: Date(),
            reviewerNote: "可以，但每天最多一小時。"
        ))
        AccessRequestRow(request: AccessRequest(
            childProfileId: "child-001",
            domain: "tiktok.com",
            reason: "我想看搞笑影片。",
            status: .denied,
            reviewedAt: Date(),
            reviewerNote: "不適合你的年齡。"
        ))
    }
}
