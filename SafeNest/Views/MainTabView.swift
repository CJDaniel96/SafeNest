import SwiftUI

struct MainTabView: View {
    var body: some View {
        TabView {
            DashboardView()
                .tabItem {
                    Label("總覽", systemImage: "shield.fill")
                }

            RuleManagementView()
                .tabItem {
                    Label("規則", systemImage: "list.bullet.rectangle")
                }

            EventHistoryView()
                .tabItem {
                    Label("紀錄", systemImage: "clock.fill")
                }

            SettingsView()
                .tabItem {
                    Label("設定", systemImage: "gearshape.fill")
                }
        }
    }
}

#Preview {
    MainTabView()
}
