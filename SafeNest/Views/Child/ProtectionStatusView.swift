import SwiftUI
import SwiftData

/// 兒少端保護狀態總覽，包含規則摘要、攔截統計，以及切換回家長模式入口。
struct ProtectionStatusView: View {
    @Query private var rules: [Rule]
    @Query(sort: \BlockEvent.blockedAt, order: .reverse) private var blockEvents: [BlockEvent]
    @Query private var childProfiles: [ChildProfile]
    @Environment(AppState.self) private var appState

    @State private var navigateToBlocked = false

    private var vm: ProtectionStatusViewModel {
        ProtectionStatusViewModel(
            child: childProfiles.first,
            rules: rules,
            blockEvents: blockEvents
        )
    }

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 20) {
                    protectionCard
                    statsSection
                    ruleBreakdownSection
                    demoSection
                    switchModeSection
                }
                .padding()
                .padding(.bottom, 16)
            }
            .navigationTitle("保護狀態")
            .navigationBarTitleDisplayMode(.large)
            .navigationDestination(isPresented: $navigateToBlocked) {
                BlockedContentView(domain: "adult-content.net", category: .adult)
            }
        }
    }

    // MARK: - Protection Card

    private var protectionCard: some View {
        HStack(spacing: 14) {
            Image(systemName: vm.protectionEnabled ? "shield.fill" : "shield.slash.fill")
                .font(.title)
                .foregroundStyle(vm.protectionEnabled ? Color.green : Color.red)

            VStack(alignment: .leading, spacing: 3) {
                Text(vm.protectionEnabled ? "SafeNest 保護中" : "保護已暫停")
                    .font(.headline)
                Text(vm.protectionEnabled
                    ? "此裝置目前受 SafeNest 保護"
                    : "請聯絡家長重新啟用保護")
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }
            Spacer()
        }
        .padding()
        .cardContainer()
    }

    // MARK: - Stats

    private var statsSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            SectionHeader(title: "攔截統計")
            HStack(spacing: 12) {
                statCard(value: "\(vm.todayBlockedCount)", label: "今日攔截", color: .blue)
                statCard(value: "\(vm.weeklyBlockedCount)", label: "本週攔截", color: .purple)
            }
        }
    }

    private func statCard(value: String, label: String, color: Color) -> some View {
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

    // MARK: - Rule Breakdown

    private var ruleBreakdownSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            SectionHeader(title: "規則摘要")
            VStack(spacing: 0) {
                ruleRow(icon: "xmark.circle.fill",     color: .red,    label: "封鎖規則",  count: vm.blacklistCount)
                Divider().padding(.leading, 52)
                ruleRow(icon: "checkmark.circle.fill", color: .green,  label: "允許規則",  count: vm.whitelistCount)
                Divider().padding(.leading, 52)
                ruleRow(icon: "tag.fill",              color: .orange, label: "類別封鎖",  count: vm.categoryCount)
            }
            .cardContainer()
        }
    }

    private func ruleRow(icon: String, color: Color, label: String, count: Int) -> some View {
        HStack(spacing: 12) {
            Image(systemName: icon)
                .foregroundStyle(color)
                .frame(width: 28)
            Text(label).font(.subheadline)
            Spacer()
            Text("\(count) 條")
                .font(.subheadline)
                .fontWeight(.semibold)
                .foregroundStyle(.secondary)
        }
        .padding(.vertical, 12)
        .padding(.horizontal, 16)
    }

    // MARK: - Demo Section

    private var demoSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            SectionHeader(title: "體驗示範")
            Button {
                navigateToBlocked = true
            } label: {
                HStack {
                    Image(systemName: "hand.raised.fill").foregroundStyle(.orange)
                    Text("模擬被阻擋的頁面").fontWeight(.medium)
                    Spacer()
                    Image(systemName: "chevron.right").font(.caption).foregroundStyle(.secondary)
                }
                .padding()
                .cardContainer()
            }
            .buttonStyle(.plain)
        }
    }

    // MARK: - Switch Mode

    private var switchModeSection: some View {
        Button {
            appState.switchRole(to: .parent)
        } label: {
            HStack(spacing: 8) {
                Image(systemName: "arrow.left.arrow.right")
                Text("切換至家長模式").fontWeight(.medium)
            }
            .font(.subheadline)
            .frame(maxWidth: .infinity)
            .padding()
            .background(Color.secondary.opacity(0.1), in: RoundedRectangle(cornerRadius: 12))
            .foregroundStyle(.secondary)
        }
        .padding(.top, 4)
    }
}

#Preview {
    ProtectionStatusView()
        .modelContainer(PreviewContainer.shared)
        .environment(AppState())
}
