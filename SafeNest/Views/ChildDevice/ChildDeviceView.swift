import SwiftUI
import SwiftData

struct ChildDeviceView: View {
    @Query(sort: \BlockEvent.blockedAt, order: .reverse) private var blockEvents: [BlockEvent]
    @Query private var childProfiles: [ChildProfile]
    @Environment(AppState.self) private var appState

    private var vm: ChildDeviceViewModel {
        ChildDeviceViewModel(
            child: childProfiles.first,
            recentEvents: Array(blockEvents.prefix(5))
        )
    }

    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                deviceInfoCard
                recentEventsSection
            }
            .padding(.horizontal)
            .padding(.bottom, 24)
        }
        .navigationTitle(vm.childName)
        .navigationBarTitleDisplayMode(.large)
    }

    // MARK: - Device Info Card

    private var deviceInfoCard: some View {
        VStack(spacing: 16) {
            HStack(spacing: 12) {
                Image(systemName: "iphone")
                    .font(.largeTitle)
                    .foregroundStyle(.blue)
                VStack(alignment: .leading, spacing: 4) {
                    Text(vm.deviceDisplayName)
                        .font(.headline)
                    Text(vm.ageGroup)
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                }
                Spacer()
            }

            Divider()

            HStack {
                Label("保護狀態", systemImage: "shield.fill").font(.subheadline)
                Spacer()
                HStack(spacing: 5) {
                    Circle()
                        .fill(vm.protectionEnabled ? Color.green : Color.red)
                        .frame(width: 8, height: 8)
                    Text(vm.protectionEnabled ? "已啟用" : "已停用")
                        .font(.subheadline)
                        .fontWeight(.medium)
                        .foregroundStyle(vm.protectionEnabled ? .green : .red)
                }
            }

            HStack {
                Label("年齡群組", systemImage: "person.fill").font(.subheadline)
                Spacer()
                Text(vm.ageGroup)
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
            }
        }
        .padding(20)
        .cardContainer(cornerRadius: 16)
    }

    // MARK: - Recent Events

    private var recentEventsSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            SectionHeader(title: "最近阻擋紀錄")
            BlockEventList(events: vm.recentEvents)
        }
    }
}

#Preview {
    NavigationStack {
        ChildDeviceView()
            .modelContainer(PreviewContainer.shared)
            .environment(AppState())
    }
}
