import SwiftUI
import SwiftData

struct ChildHomeView: View {
    @Query(sort: \BlockEvent.blockedAt, order: .reverse) private var blockEvents: [BlockEvent]
    @Query private var childProfiles: [ChildProfile]
    // 此 View 不執行任何寫入操作，不需要注入 AppState

    @State private var navigateToBlocked = false

    private var vm: ChildHomeViewModel {
        ChildHomeViewModel(child: childProfiles.first, blockEvents: blockEvents)
    }

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 24) {
                    heroSection
                    infoCard
                    DemoSectionView(subtitle: "點擊下方按鈕，體驗網站被阻擋時的流程。") {
                        navigateToBlocked = true
                    }
                }
                .padding()
                .padding(.bottom, 16)
            }
            .navigationTitle("SafeNest")
            .navigationBarTitleDisplayMode(.large)
            .navigationDestination(isPresented: $navigateToBlocked) {
                BlockedContentView(domain: "gambling-site.com", category: .gambling)
            }
        }
    }

    // MARK: - Hero

    private var heroSection: some View {
        VStack(spacing: 14) {
            Image(systemName: vm.protectionEnabled ? "checkmark.shield.fill" : "shield.slash.fill")
                .font(.system(size: 72))
                .foregroundStyle(vm.protectionEnabled ? Color.green : Color.orange)
                .padding(.top, 8)

            // U-3：去除監控感，改用更溫暖的語氣
            Text(vm.protectionEnabled ? "你的裝置受到保護" : "保護功能還沒開啟")
                .font(.title2)
                .fontWeight(.bold)

            Text(vm.protectionEnabled
                ? "SafeNest 幫你把關上網安全 🛡️"
                : "可以跟家長說要開啟保護功能"
            )
            .font(.subheadline)
            .foregroundStyle(.secondary)
            .multilineTextAlignment(.center)
        }
    }

    // MARK: - Info Card

    private var infoCard: some View {
        VStack(spacing: 0) {
            infoRow(icon: "person.fill",       color: .blue,   label: "名稱",    value: vm.childName)
            Divider().padding(.leading, 52)
            infoRow(icon: "iphone",            color: .indigo, label: "裝置",    value: vm.deviceDisplayName)
            Divider().padding(.leading, 52)
            infoRow(icon: "figure.child",      color: .teal,   label: "年齡群組", value: vm.ageGroup)
            Divider().padding(.leading, 52)
            infoRow(icon: "hand.raised.fill",  color: .orange, label: "今日攔截", value: "\(vm.todayBlockedCount) 次")
        }
        .cardContainer()
    }

    private func infoRow(icon: String, color: Color, label: String, value: String) -> some View {
        HStack(spacing: 12) {
            Image(systemName: icon)
                .foregroundStyle(color)
                .frame(width: 28)
            Text(label)
                .font(.subheadline)
                .foregroundStyle(.secondary)
            Spacer()
            Text(value)
                .font(.subheadline)
                .fontWeight(.medium)
        }
        .padding(.vertical, 12)
        .padding(.horizontal, 16)
    }
}

#Preview {
    ChildHomeView()
        .modelContainer(PreviewContainer.shared)
        .environment(AppState())
}
