import SwiftUI

/// `.regularMaterial` 圓角卡片外觀的 ViewModifier。
/// 使用方式：`.cardContainer()` 或 `.cardContainer(cornerRadius: 16)`
struct CardContainerModifier: ViewModifier {
    var cornerRadius: CGFloat

    func body(content: Content) -> some View {
        content
            .background(.regularMaterial, in: RoundedRectangle(cornerRadius: cornerRadius))
    }
}

extension View {
    func cardContainer(cornerRadius: CGFloat = 12) -> some View {
        modifier(CardContainerModifier(cornerRadius: cornerRadius))
    }
}
