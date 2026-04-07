import SwiftUI

struct SettingsView: View {
    @State private var vm = SettingsViewModel()

    var body: some View {
        NavigationStack {
            List {
                // Parent Info
                Section("家長帳號") {
                    LabeledContent("姓名", value: vm.parent.name)
                    LabeledContent("電子郵件", value: vm.parent.email)
                }

                // Child Info
                Section("受保護對象") {
                    LabeledContent("孩子名稱", value: vm.child.name)
                    LabeledContent("年齡群組", value: vm.child.ageGroup)
                    LabeledContent("裝置", value: vm.child.deviceName ?? "尚未設定")

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

                // Notification Settings
                Section("通知") {
                    Toggle(isOn: $vm.notificationsEnabled) {
                        Label("推播通知", systemImage: "bell.fill")
                    }
                    Toggle(isOn: $vm.weeklySummaryEnabled) {
                        Label("每週摘要報告", systemImage: "chart.bar.fill")
                    }
                }

                // Security Settings
                Section("安全性") {
                    Toggle(isOn: $vm.parentalPINEnabled) {
                        Label("家長 PIN 碼", systemImage: "lock.fill")
                    }
                    Button {
                        // TODO: 接實際 PIN 設定頁
                    } label: {
                        Label("變更 PIN 碼", systemImage: "key.fill")
                            .foregroundStyle(vm.parentalPINEnabled ? .primary : .secondary)
                    }
                    .disabled(!vm.parentalPINEnabled)
                }

                // About
                Section("關於") {
                    LabeledContent("版本", value: "1.0.0 (MVP)")
                    Button {
                        // TODO: 開啟隱私政策
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
}
