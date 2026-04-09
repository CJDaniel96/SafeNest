import SwiftUI

/// 兒少端「體驗示範」按鈕區塊。
/// ChildHomeView 與 ProtectionStatusView 共用，消除重複實作。
///
/// - Parameters:
///   - subtitle: 按鈕上方的輔助說明文字（選填，預設不顯示）
///   - action: 按鈕點擊後的動作
///
/// 使用範例：
/// ```swift
/// // 有 subtitle（ChildHomeView 用法）
/// DemoSectionView(subtitle: "點擊下方按鈕，體驗網站被阻擋時的流程。") {
///     navigateToBlocked = true
/// }
///
/// // 無 subtitle（ProtectionStatusView 用法）
/// DemoSectionView {
///     navigateToBlocked = true
/// }
/// ```
struct DemoSectionView: View {
    var subtitle: String? = nil
    let action: () -> Void

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            SectionHeader(title: "體驗示範")

            if let subtitle {
                Text(subtitle)
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }

            Button(action: action) {
                HStack {
                    Image(systemName: "hand.raised.fill")
                        .foregroundStyle(.orange)
                    Text("模擬被阻擋的頁面")
                        .fontWeight(.medium)
                    Spacer()
                    Image(systemName: "chevron.right")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                }
                .padding()
                .cardContainer()
            }
            .buttonStyle(.plain)
        }
    }
}

#Preview {
    VStack(spacing: 24) {
        DemoSectionView(subtitle: "點擊下方按鈕，體驗網站被阻擋時的流程。") { }
        DemoSectionView { }
    }
    .padding()
}
