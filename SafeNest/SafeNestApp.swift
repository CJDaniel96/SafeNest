import SwiftUI

@main
struct SafeNestApp: App {
    /// AppState 在 App 層建立一次，透過 .environment() 注入整棵 View tree
    @State private var appState = AppState()

    var body: some Scene {
        WindowGroup {
            MainTabView()
                .environment(appState)
        }
    }
}
