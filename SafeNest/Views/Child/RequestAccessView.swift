import SwiftUI
import SwiftData

/// 孩子向家長申請審核特定網站的表單。成功後顯示確認畫面。
///
/// Round 6 變更：
/// - 移除 `@Environment(AppState.self)`（submit 邏輯已移至 RequestAccessViewModel）
/// - 呼叫 `vm.submit(domain:childProfileId:in:)` 取代直接呼叫 AppState
struct RequestAccessView: View {
    let domain: String
    let category: BlockEventCategory

    @State private var vm = RequestAccessViewModel()
    @Environment(\.dismiss) private var dismiss
    @Environment(\.modelContext) private var modelContext
    @Query private var childProfiles: [ChildProfile]

    var body: some View {
        NavigationStack {
            if vm.didSubmitSuccessfully {
                successView
            } else {
                formView
            }
        }
    }

    // MARK: - Form

    private var formView: some View {
        ScrollView {
            VStack(spacing: 24) {
                siteInfoCard
                reasonInputSection
                submitButton
            }
            .padding()
        }
        .navigationTitle("申請家長審核")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .cancellationAction) {
                Button("取消") { dismiss() }
            }
        }
    }

    private var siteInfoCard: some View {
        VStack(spacing: 10) {
            Text(domain)
                .font(.headline)
                .lineLimit(1)
                .truncationMode(.middle)
            CategoryTagView(category: category)
        }
        .frame(maxWidth: .infinity)
        .padding()
        .cardContainer()
    }

    private var reasonInputSection: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("申請原因")
                .font(.subheadline)
                .fontWeight(.medium)

            Text("請告訴家長你為什麼需要瀏覽這個網站")
                .font(.caption)
                .foregroundStyle(.secondary)

            TextEditor(text: $vm.reason)
                .frame(minHeight: 120)
                .padding(10)
                .background(
                    RoundedRectangle(cornerRadius: 10)
                        .fill(Color(.systemGray6))
                )
                .overlay(
                    RoundedRectangle(cornerRadius: 10)
                        .stroke(Color(.systemGray4), lineWidth: 0.5)
                )
        }
    }

    private var submitButton: some View {
        Button {
            submitRequest()
        } label: {
            Group {
                if vm.isSubmitting {
                    ProgressView().tint(.white)
                } else {
                    Text("送出申請").fontWeight(.semibold)
                }
            }
            .frame(maxWidth: .infinity)
            .padding()
            .background(
                vm.canSubmit ? Color.blue : Color.gray.opacity(0.4),
                in: RoundedRectangle(cornerRadius: 14)
            )
            .foregroundStyle(.white)
        }
        .disabled(!vm.canSubmit)
    }

    // MARK: - Submit

    private func submitRequest() {
        guard let childId = childProfiles.first?.id else { return }
        // submit 邏輯完全在 ViewModel 內：依賴 AccessRequestServiceProtocol，不依賴 AppState
        vm.submit(domain: domain, childProfileId: childId, in: modelContext)
    }

    // MARK: - Success

    private var successView: some View {
        VStack(spacing: 24) {
            Spacer()

            Image(systemName: "checkmark.circle.fill")
                .font(.system(size: 72))
                .foregroundStyle(.green)

            VStack(spacing: 8) {
                Text("申請已送出！")
                    .font(.title2)
                    .fontWeight(.bold)

                Text("家長已收到你的審核申請。\n請稍等家長確認後再試看看。")
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
                    .multilineTextAlignment(.center)
                    .lineSpacing(4)

                // U-6：引導孩子到「我的申請」Tab 追蹤審核進度
                Label("可以去「我的申請」查看審核進度", systemImage: "paperplane.fill")
                    .font(.caption)
                    .foregroundStyle(.blue)
                    .padding(.top, 4)
            }

            Button("完成") { dismiss() }
                .buttonStyle(.borderedProminent)
                .controlSize(.large)

            Spacer()
        }
        .padding()
        .navigationTitle("申請完成")
        .navigationBarTitleDisplayMode(.inline)
    }
}

#Preview {
    RequestAccessView(domain: "gambling-site.com", category: .gambling)
        .modelContainer(PreviewContainer.shared)
        .environment(AppState())
}
