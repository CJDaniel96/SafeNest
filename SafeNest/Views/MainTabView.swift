import SwiftUI
import SwiftData

/// App 主導覽架構。
/// AppState 由 SafeNestApp 注入 environment，SwiftUI 自動向下傳遞。
struct MainTabView: View {
    @Query(filter: #Predicate<AccessRequest> { $0.status == .pending })
    private var pendingRequests: [AccessRequest]

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
                .badge(pendingRequests.count > 0 ? pendingRequests.count : 0)

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
