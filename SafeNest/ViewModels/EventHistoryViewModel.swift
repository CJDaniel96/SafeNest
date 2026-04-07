import Foundation

@Observable
final class EventHistoryViewModel {
    private let allEvents: [BlockEvent]
    var selectedCategory: String = "全部"

    init(events: [BlockEvent] = MockData.blockEvents) {
        self.allEvents = events.sorted { $0.blockedAt > $1.blockedAt }
    }

    var availableCategories: [String] {
        let cats = Array(Set(allEvents.map { $0.category })).sorted()
        return ["全部"] + cats
    }

    var filteredEvents: [BlockEvent] {
        if selectedCategory == "全部" {
            return allEvents
        }
        return allEvents.filter { $0.category == selectedCategory }
    }
}
