import SwiftUI
import SwiftData

/// Preview 專用 ModelContainer（in-memory）
/// 讓所有 #Preview 不需要真實資料庫即可顯示資料
enum PreviewContainer {
    @MainActor
    static let shared: ModelContainer = {
        let schema = Schema([Parent.self, ChildProfile.self, Rule.self, BlockEvent.self])
        let config = ModelConfiguration(schema: schema, isStoredInMemoryOnly: true)
        let container = try! ModelContainer(for: schema, configurations: [config])
        SeedDataService.seedIfNeeded(in: container.mainContext)
        return container
    }()
}
