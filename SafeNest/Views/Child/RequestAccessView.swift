import SwiftUI

/// 孩子向家長申請審核特定網站的表單。成功後顯示確認畫面，不需真實後端。
struct RequestAccessView: View {
    let domain: String
    let category: BlockEventCategory

    @State private var vm = RequestAccessViewModel()
    @Environment(\.dismiss) private var dismiss

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
            Task { await vm.submit(domain: domain) }
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
}
