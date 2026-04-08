import SwiftUI

/// 各頁面區塊的標題列，統一字型與顏色。
struct SectionHeader: View {
    let title: String

    var body: some View {
        Text(title)
            .font(.headline)
            .foregroundStyle(.primary)
    }
}

#Preview {
    SectionHeader(title: "本週風險摘要")
        .padding()
}
