import SwiftUI

/// App 根視圖：依 AppState.currentRole 切換家長端或兒少端導覽。
struct RootView: View {
    @Environment(AppState.self) private var appState

    var body: some View {
        switch appState.currentRole {
        case .parent: MainTabView()
        case .child:  ChildTabView()
        }
    }
}

#Preview {
    RootView()
        .modelContainer(PreviewContainer.shared)
        .environment(AppState())
}
