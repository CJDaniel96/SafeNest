import SwiftUI

/// Dashboard 頂部的孩子摘要卡片，顯示今日 / 本週阻擋統計與保護狀態。
struct ChildSummaryCardView: View {
    let child: ChildProfile
    let todayBlocked: Int
    let weeklyBlocked: Int

    var body: some View {
        VStack(alignment: .leading, spacing: 16) {

            // 孩子名稱與保護狀態徽章
            HStack {
                VStack(alignment: .leading, spacing: 4) {
                    HStack(spacing: 6) {
                        Image(systemName: "person.fill")
                            .foregroundStyle(.white.opacity(0.9))
                        Text(child.name)
                            .font(.title3)
                            .fontWeight(.bold)
                            .foregroundStyle(.white)
                    }
                    // ageGroup 為 AgeGroup enum，透過 displayName 取得顯示文字
                    Text(child.ageGroup.displayName)
                        .font(.caption)
                        .foregroundStyle(.white.opacity(0.8))
                }
                Spacer()
                protectionBadge
            }

            Divider().overlay(Color.white.opacity(0.3))

            // 統計數字
            HStack(spacing: 0) {
                statItem(label: "今日阻擋", value: "\(todayBlocked)")
                Spacer()
                statItem(label: "本週阻擋", value: "\(weeklyBlocked)")
                Spacer()
                statItem(label: "裝置", value: child.deviceName != nil ? "已連接" : "未連接")
            }

            // 裝置名稱 + 進入提示
            HStack(spacing: 4) {
                Text(child.deviceName ?? "尚未設定裝置")
                    .font(.caption)
                    .foregroundStyle(.white.opacity(0.7))
                Spacer()
                Image(systemName: "chevron.right")
                    .font(.caption)
                    .foregroundStyle(.white.opacity(0.7))
            }
        }
        .padding(20)
        .background(
            LinearGradient(
                colors: [Color.blue, Color.indigo],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            ),
            in: RoundedRectangle(cornerRadius: 16)
        )
        .shadow(color: .blue.opacity(0.3), radius: 8, y: 4)
    }

    // MARK: - Private

    private var protectionBadge: some View {
        HStack(spacing: 4) {
            Image(systemName: child.protectionEnabled ? "checkmark.shield.fill" : "shield.slash.fill")
            Text(child.protectionEnabled ? "保護中" : "未保護")
                .font(.caption)
                .fontWeight(.semibold)
        }
        .foregroundStyle(.white)
        .padding(.horizontal, 10)
        .padding(.vertical, 5)
        .background(
            child.protectionEnabled ? Color.green.opacity(0.35) : Color.red.opacity(0.35),
            in: Capsule()
        )
    }

    private func statItem(label: String, value: String) -> some View {
        VStack(spacing: 2) {
            Text(value)
                .font(.title3)
                .fontWeight(.bold)
                .foregroundStyle(.white)
            Text(label)
                .font(.caption2)
                .foregroundStyle(.white.opacity(0.75))
        }
    }
}

#Preview {
    // AgeGroup enum 取代裸字串 "6–12 歲"
    let child = ChildProfile(
        parentId: "p-001",
        name: "小安",
        ageGroup: .elementary,
        deviceName: "小安的 iPhone",
        protectionEnabled: true
    )
    return ChildSummaryCardView(child: child, todayBlocked: 4, weeklyBlocked: 10)
        .padding()
}
