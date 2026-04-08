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
        // 第一次啟動時插入 Demo 資料（有資料則跳過）
        SeedDataService.seedIfNeeded(in: container.mainContext)
    }

    var body: some Scene {
        WindowGroup {
            MainTabView()
                .environment(appState)
        }
        .modelContainer(container)
    }
}
