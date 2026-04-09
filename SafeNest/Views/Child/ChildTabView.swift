import SwiftUI
import SwiftData

/// 兒少端主導覽。AppState 由環境自動傳遞，此 View 本身不需取用。
struct ChildTabView: View {
    var body: some View {
        TabView {
            ChildHomeView()
                .tabItem { Label("首頁", systemImage: "house.fill") }

            ProtectionStatusView()
                .tabItem { Label("狀態", systemImage: "shield.fill") }
        }
    }
}

#Preview {
    ChildTabView()
        .modelContainer(PreviewContainer.shared)
        .environment(AppState())
}
