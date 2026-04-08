import SwiftUI

/// 事件類別標籤，使用對應的顏色與圖示。
struct CategoryTagView: View {
    let category: BlockEventCategory

    var body: some View {
        Label(category.displayName, systemImage: category.icon)
            .font(.caption2)
            .fontWeight(.medium)
            .padding(.horizontal, 8)
            .padding(.vertical, 3)
            .background(category.color.opacity(0.1), in: Capsule())
            .foregroundStyle(category.color)
    }
}

/// 觸發規則類型標籤（黑名單 / 白名單 / 類別封鎖）。
struct RuleTypeTagView: View {
    let ruleType: RuleType

    var body: some View {
        Text(ruleType.displayName)
            .font(.caption2)
            .fontWeight(.medium)
            .padding(.horizontal, 8)
            .padding(.vertical, 3)
            .background(Color.blue.opacity(0.1), in: Capsule())
            .foregroundStyle(.blue)
    }
}

#Preview {
    VStack(spacing: 8) {
        HStack {
            CategoryTagView(category: .gambling)
            CategoryTagView(category: .adult)
            CategoryTagView(category: .violence)
        }
        HStack {
            RuleTypeTagView(ruleType: .blacklist)
            RuleTypeTagView(ruleType: .whitelist)
            RuleTypeTagView(ruleType: .category)
        }
    }
    .padding()
}
