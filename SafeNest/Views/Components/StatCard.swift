import SwiftUI

/// 統計數字卡片：大型數值 + 說明標籤 + 彩色強調。
/// 目前用於 ProtectionStatusView 的攔截統計區，未來 Dashboard 統計區可共用。
///
/// 使用範例：
/// ```swift
/// HStack(spacing: 12) {
///     StatCard(value: "4",  label: "今日攔截", color: .blue)
///     StatCard(value: "27", label: "本週攔截", color: .purple)
/// }
/// ```
struct StatCard: View {
    let value: String
    let label: String
    let color: Color

    var body: some View {
        VStack(spacing: 4) {
            Text(value)
                .font(.system(size: 36, weight: .bold))
                .foregroundStyle(color)
            Text(label)
                .font(.caption)
                .foregroundStyle(.secondary)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 20)
        .cardContainer()
    }
}

#Preview {
    HStack(spacing: 12) {
        StatCard(value: "4",  label: "今日攔截", color: .blue)
        StatCard(value: "27", label: "本週攔截", color: .purple)
    }
    .padding()
}
