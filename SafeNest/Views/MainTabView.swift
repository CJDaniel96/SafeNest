import SwiftUI
import SwiftData

/// App 主導覽架構。
/// AppState 由 SafeNestApp 注入 environment，SwiftUI 自動向下傳遞。
struct MainTabView: View {
    // SwiftData #Predicate 不支援 Codable enum 比較，改為全撈後 Swift 端過濾
    @Query private var allRequests: [AccessRequest]
    private var pendingCount: Int { allRequests.filter { $0.status == .pending }.count }

    var body: some View {
        TabView {
            DashboardView()
                .tabItem { Label("總覽", systemImage: "shield.fill") }

            RuleManagementView()
                .tabItem { Label("規則", systemImage: "list.bullet.rectangle") }

            EventHistoryView()
                .tabItem { Label("紀錄", systemImage: "clock.fill") }

            AccessRequestInboxView()
                .tabItem { Label("審核", systemImage: "person.badge.key.fill") }
                .badge(pendingCount)   // count 為 0 時 SwiftUI 本就不顯示 badge

            SettingsView()
                .tabItem { Label("設定", systemImage: "gearshape.fill") }
        }
    }
}

#Preview {
    MainTabView()
        .modelContainer(PreviewContainer.shared)
        .environment(AppState())
}
