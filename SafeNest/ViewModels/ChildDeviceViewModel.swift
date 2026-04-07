import Foundation

@Observable
final class ChildDeviceViewModel {
    private(set) var child: ChildProfile
    private(set) var recentEvents: [BlockEvent]

    init(
        child: ChildProfile = MockData.childProfile,
        events: [BlockEvent] = MockData.blockEvents
    ) {
        self.child = child
        let sorted = events.sorted { $0.blockedAt > $1.blockedAt }
        self.recentEvents = Array(sorted.prefix(5))
    }

    var deviceDisplayName: String {
        child.deviceName ?? "未知裝置"
    }
}
