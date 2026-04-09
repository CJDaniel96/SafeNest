import SwiftUI

/// 通用空狀態元件。
/// 取代各頁面重複的 VStack empty-state 實作（icon + headline + subheadline）。
///
/// 使用範例：
/// ```swift
/// EmptyStateView(
///     icon: "tray.fill",
///     title: "目前沒有資料",
///     description: "新增後會顯示在這裡"
/// )
/// ```
struct EmptyStateView: View {
    let icon: String
    let title: String
    let description: String

    var body: some View {
        VStack(spacing: 16) {
            Image(systemName: icon)
                .font(.system(size: 52))
                .foregroundStyle(.secondary.opacity(0.5))
            Text(title)
                .font(.headline)
                .foregroundStyle(.secondary)
            Text(description)
                .font(.subheadline)
                .foregroundStyle(.tertiary)
                .multilineTextAlignment(.center)
        }
        .padding()
    }
}

#Preview {
    VStack(spacing: 32) {
        EmptyStateView(
            icon: "tray.fill",
            title: "目前沒有審核申請",
            description: "孩子提出申請後會顯示在這裡"
        )
        EmptyStateView(
            icon: "paperplane.fill",
            title: "還沒有申請紀錄",
            description: "當你申請瀏覽被阻擋的網站時，\n紀錄會顯示在這裡"
        )
    }
}
