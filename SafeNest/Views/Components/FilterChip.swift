import SwiftUI

/// 橫向篩選列的膠囊按鈕，選中時以藍色填滿。
struct FilterChip: View {
    let title: String
    let isSelected: Bool
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            Text(title)
                .font(.subheadline)
                .fontWeight(isSelected ? .semibold : .regular)
                .padding(.horizontal, 14)
                .padding(.vertical, 7)
                .background(
                    isSelected ? Color.blue : Color.secondary.opacity(0.12),
                    in: Capsule()
                )
                .foregroundStyle(isSelected ? .white : .primary)
        }
        .buttonStyle(.plain)
    }
}

#Preview {
    HStack {
        FilterChip(title: "全部",   isSelected: true)  { }
        FilterChip(title: "賭博",   isSelected: false) { }
        FilterChip(title: "成人內容", isSelected: false) { }
    }
    .padding()
}
