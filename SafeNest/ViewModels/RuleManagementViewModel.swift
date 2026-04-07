import Foundation

@Observable
final class RuleManagementViewModel {
    private(set) var rules: [Rule]
    var selectedTab: RuleType = .blacklist

    init(rules: [Rule] = MockData.rules) {
        self.rules = rules
    }

    var filteredRules: [Rule] {
        rules.filter { $0.ruleType == selectedTab }
    }

    // MARK: - Actions

    func toggleEnabled(_ rule: Rule) {
        guard let idx = rules.firstIndex(where: { $0.id == rule.id }) else { return }
        rules[idx].enabled.toggle()
    }

    func delete(_ rule: Rule) {
        rules.removeAll { $0.id == rule.id }
    }

    func deleteByOffsets(_ offsets: IndexSet) {
        let filtered = filteredRules
        let idsToDelete = offsets.map { filtered[$0].id }
        rules.removeAll { idsToDelete.contains($0.id) }
    }

    func addRule(type: RuleType, value: String) {
        guard !value.trimmingCharacters(in: .whitespaces).isEmpty else { return }
        let newRule = Rule(
            id: UUID().uuidString,
            childProfileId: MockData.childProfile.id,
            type: type.rawValue,
            value: value.trimmingCharacters(in: .whitespaces),
            enabled: true,
            createdAt: Date()
        )
        rules.append(newRule)
    }
}
