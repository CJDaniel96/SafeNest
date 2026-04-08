import SwiftUI
import SwiftData

@main
struct SafeNestApp: App {
    @State private var appState = AppState()

    /// ModelContainer 在 App 層建立一次，供整個 App 共享
    let container: ModelContainer = {
        let schema = Schema([
            Parent.self,
            ChildProfile.self,
            Rule.self,
            BlockEvent.self
        ])
        let config = ModelConfiguration(schema: schema, isStoredInMemoryOnly: false)
        do {
            return try ModelContainer(for: schema, configurations: [config])
        } catch {
            fatalError("ModelContainer 建立失敗：\(error)")
        }
    }()

    init() {
        SeedDataService.seedIfNeeded(in: container.mainContext)
    }

    var body: some Scene {
        WindowGroup {
            // RootView 依 appState.currentRole 決定顯示家長端或兒少端
            RootView()
                .environment(appState)
        }
        .modelContainer(container)
    }
}
