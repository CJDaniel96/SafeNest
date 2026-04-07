import SwiftUI

/// App 主導覽架構。
/// AppState 由 SafeNestApp 注入 environment，SwiftUI 自動向下傳遞，
/// 此 View 本身不需要取用 AppState。
struct MainTabView: View {
    var body: some View {
        TabView {
            DashboardView()
                .tabItem { Label("總覽", systemImage: "shield.fill") }

            RuleManagementView()
                .tabItem { Label("規則", systemImage: "list.bullet.rectangle") }

            EventHistoryView()
                .tabItem { Label("紀錄", systemImage: "clock.fill") }

            SettingsView()
                .tabItem { Label("設定", systemImage: "gearshape.fill") }
        }
    }
}

#Preview {
    MainTabView()
        .environment(AppState())
}
