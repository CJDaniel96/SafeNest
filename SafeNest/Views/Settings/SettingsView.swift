import SwiftUI

struct SettingsView: View {
    @Environment(AppState.self) private var appState

    // 純 UI 開關：目前不影響其他頁面，維持在 View 層的 @State
    @State private var notificationsEnabled = true
    @State private var weeklySummaryEnabled = true
    @State private var parentalPINEnabled   = false

    private var vm: SettingsViewModel { SettingsViewModel(store: appState) }

    var body: some View {
        NavigationStack {
            List {

                // 家長帳號
                Section("家長帳號") {
                    LabeledContent("姓名",    value: vm.parent.name)
                    LabeledContent("電子郵件", value: vm.parent.email)
                }

                // 受保護對象
                Section("受保護對象") {
                    LabeledContent("孩子名稱", value: vm.child.name)
                    LabeledContent("年齡群組", value: vm.child.ageGroup)
                    LabeledContent("裝置",    value: vm.child.deviceName ?? "尚未設定")

                    // 保護開關：寫入 AppState → Dashboard 同步更新
                    HStack {
                        Label("網路保護", systemImage: "shield.fill")
                        Spacer()
                        Toggle("", isOn: Binding(
                            get: { vm.child.protectionEnabled },
                            set: { _ in vm.toggleProtection() }
                        ))
                        .labelsHidden()
                    }
                }

                // 通知
                Section("通知") {
                    Toggle(isOn: $notificationsEnabled) {
                        Label("推播通知", systemImage: "bell.fill")
                    }
                    Toggle(isOn: $weeklySummaryEnabled) {
                        Label("每週摘要報告", systemImage: "chart.bar.fill")
                    }
                }

                // 安全性
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

                // 關於
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
        .environment(AppState())
}
