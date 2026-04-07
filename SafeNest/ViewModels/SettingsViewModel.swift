import Foundation

@Observable
final class SettingsViewModel {
    private(set) var parent: Parent
    var child: ChildProfile

    var notificationsEnabled: Bool = true
    var weeklySummaryEnabled: Bool = true
    var parentalPINEnabled: Bool = false

    init(
        parent: Parent = MockData.parent,
        child: ChildProfile = MockData.childProfile
    ) {
        self.parent = parent
        self.child = child
    }

    func toggleProtection() {
        child.protectionEnabled.toggle()
    }
}
