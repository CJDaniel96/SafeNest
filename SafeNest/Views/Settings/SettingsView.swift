import SwiftUI
import SwiftData

struct SettingsView: View {
    @Query private var parents: [Parent]
    @Query private var childProfiles: [ChildProfile]
    @Environment(AppState.self) private var appState
    @Environment(\.modelContext) private var modelContext

    @State private var notificationsEnabled = true
    @State private var weeklySummaryEnabled = true
    @State private var parentalPINEnabled   = false

    private var vm: SettingsViewModel {
        SettingsViewModel(parent: parents.first, child: childProfiles.first)
    }

    var body: some View {
        NavigationStack {
            List {

                // MARK: 裝置模式（角色切換）
                Section {
                    // I-5：currentRole 是 private(set)，必須透過 switchRole(to:) 切換
                    Picker("目前模式", selection: Binding(
                        get: { appState.currentRole },
                        set: { appState.switchRole(to: $0) }
                    )) {
                        ForEach(AppRole.allCases, id: \.self) { role in
                            Label(role.displayName, systemImage: role.icon).tag(role)
                        }
                    }
                    .pickerStyle(.segmented)
                } header: {
                    Text("裝置模式")
                } footer: {
                    Text("切換到「孩子模式」後，App 將顯示兒少專用介面。")
                }

                // MARK: 家長帳號
                Section("家長帳號") {
                    LabeledContent("姓名",     value: vm.parentName)
                    LabeledContent("電子郵件", value: vm.parentEmail)
                }

                // MARK: 受保護對象
                Section("受保護對象") {
                    LabeledContent("孩子名稱", value: vm.childName)
                    LabeledContent("年齡群組", value: vm.childAgeGroup)
                    LabeledContent("裝置",     value: vm.deviceName)

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

                // MARK: 通知
                Section("通知") {
                    Toggle(isOn: $notificationsEnabled) {
                        Label("推播通知", systemImage: "bell.fill")
                    }
                    Toggle(isOn: $weeklySummaryEnabled) {
                        Label("每週摘要報告", systemImage: "chart.bar.fill")
                    }
                }

                // MARK: 安全性
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

                // MARK: 關於
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
