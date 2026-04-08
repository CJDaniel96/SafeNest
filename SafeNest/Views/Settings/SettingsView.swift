import SwiftUI
import SwiftData

struct SettingsView: View {
    @Query private var parents: [Parent]
    @Query private var childProfiles: [ChildProfile]
    @Environment(AppState.self) private var appState

    @State private var notificationsEnabled = true
    @State private var weeklySummaryEnabled = true
    @State private var parentalPINEnabled   = false

    private var vm: SettingsViewModel {
        SettingsViewModel(parent: parents.first, child: childProfiles.first)
    }

    var body: some View {
        NavigationStack {
            List {

                Section("家長帳號") {
                    LabeledContent("姓名",    value: vm.parentName)
                    LabeledContent("電子郵件", value: vm.parentEmail)
                }

                Section("受保護對象") {
                    LabeledContent("孩子名稱", value: vm.childName)
                    LabeledContent("年齡群組", value: vm.childAgeGroup)
                    LabeledContent("裝置",    value: vm.deviceName)

                    if let child = childProfiles.first {
                        HStack {
                            Label("網路保護", systemImage: "shield.fill")
                            Spacer()
                            Toggle("", isOn: Binding(
                                get: { child.protectionEnabled },
                                set: { _ in appState.toggleProtection(child) }
                            ))
                            .labelsHidden()
                        }
                    }
                }

                Section("通知") {
                    Toggle(isOn: $notificationsEnabled) {
                        Label("推播通知", systemImage: "bell.fill")
                    }
                    Toggle(isOn: $weeklySummaryEnabled) {
                        Label("每週摘要報告", systemImage: "chart.bar.fill")
                    }
                }

                Section("安全性") {
                    Toggle(isOn: $parentalPINEnabled) {
                        Label("家長 PIN 碼", systemImage: "lock.fill")
                    }
                    Button {
                        // TODO: PIN 設定頁
                    } label: {
                        Label("變更 PIN 碼", systemImage: "key.fill")
                            .foregroundStyle(parentalPINEnabled ? .primary : .secondary)
                    }
                    .disabled(!parentalPINEnabled)
                }

                Section("關於") {
                    LabeledContent("版本", value: "1.0.0 (MVP)")
                    Button {
                        // TODO: 隱私政策
                    } label: {
                        Label("隱私政策", systemImage: "hand.raised.fill")
                            .foregroundStyle(.primary)
                    }
                }
            }
            .navigationTitle("設定")
            .navigationBarTitleDisplayMode(.large)
        }
    }
}

#Preview {
    SettingsView()
        .modelContainer(PreviewContainer.shared)
        .environment(AppState())
}
