import SwiftUI

struct ChildDeviceView: View {
    @Environment(AppState.self) private var appState

    private var vm: ChildDeviceViewModel { ChildDeviceViewModel(store: appState) }

    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                deviceInfoCard
                recentEventsSection
            }
            .padding(.horizontal)
            .padding(.bottom, 24)
        }
        .navigationTitle(vm.child.name)
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
                    Text(vm.child.ageGroup)
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                }
                Spacer()
            }

            Divider()

            HStack {
                Label("保護狀態", systemImage: "shield.fill")
                    .font(.subheadline)
                Spacer()
                HStack(spacing: 5) {
                    Circle()
                        .fill(vm.child.protectionEnabled ? Color.green : Color.red)
                        .frame(width: 8, height: 8)
                    Text(vm.child.protectionEnabled ? "已啟用" : "已停用")
                        .font(.subheadline)
                        .fontWeight(.medium)
                        .foregroundStyle(vm.child.protectionEnabled ? .green : .red)
                }
            }

            HStack {
                Label("年齡群組", systemImage: "person.fill")
                    .font(.subheadline)
                Spacer()
                Text(vm.child.ageGroup)
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
            }
        }
        .padding(20)
        .background(.regularMaterial, in: RoundedRectangle(cornerRadius: 16))
    }

    // MARK: - Recent Events

    private var recentEventsSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("最近阻擋紀錄")
                .font(.headline)

            if vm.recentEvents.isEmpty {
                ContentUnavailableView(
                    "暫無紀錄",
                    systemImage: "checkmark.shield",
                    description: Text("目前沒有阻擋紀錄")
                )
            } else {
                VStack(spacing: 0) {
                    ForEach(vm.recentEvents) { event in
                        BlockEventRow(event: event)
                        if event.id != vm.recentEvents.last?.id {
                            Divider().padding(.leading, 16)
                        }
                    }
                }
                .background(.regularMaterial, in: RoundedRectangle(cornerRadius: 12))
            }
        }
    }
}

#Preview {
    NavigationStack {
        ChildDeviceView()
            .environment(AppState())
    }
}
