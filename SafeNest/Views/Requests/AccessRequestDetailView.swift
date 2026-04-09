import SwiftUI
import SwiftData

/// 家長端：審核申請詳細頁（可核准 / 拒絕並附備註）
struct AccessRequestDetailView: View {
    @Bindable var request: AccessRequest
    @Environment(AppState.self) private var appState
    @Environment(\.dismiss) private var dismiss

    @State private var noteInput: String = ""
    @State private var showConfirmApprove = false
    @State private var showConfirmDeny    = false

    var body: some View {
        List {
            // MARK: 申請資訊
            Section("申請資訊") {
                LabeledContent("網站", value: request.domain)
                LabeledContent("申請時間", value: DateFormatter.shortDateTime.string(from: request.requestedAt))
                LabeledContent("目前狀態") {
                    StatusBadge(status: request.status)
                }
            }

            // MARK: 申請原因
            Section("申請原因") {
                Text(request.reason)
                    .font(.subheadline)
                    .foregroundStyle(.primary)
                    .fixedSize(horizontal: false, vertical: true)
            }

            // MARK: 審核結果（已處理時顯示）
            if request.status != .pending {
                Section("審核結果") {
                    if let reviewedAt = request.reviewedAt {
                        LabeledContent("審核時間", value: DateFormatter.shortDateTime.string(from: reviewedAt))
                    }
                    if let note = request.reviewerNote, !note.isEmpty {
                        VStack(alignment: .leading, spacing: 6) {
                            Text("家長備註")
                                .font(.caption)
                                .foregroundStyle(.secondary)
                            Text(note)
                                .font(.subheadline)
                        }
                    }
                }
            }

            // MARK: 審核操作（待審核時顯示）
            if request.status == .pending {
                Section {
                    VStack(alignment: .leading, spacing: 8) {
                        Text("備註（選填）")
                            .font(.caption)
                            .foregroundStyle(.secondary)
                        TextField("輸入給孩子的回覆訊息…", text: $noteInput, axis: .vertical)
                            .lineLimit(3...5)
                            .font(.subheadline)
                    }
                } header: {
                    Text("審核備註")
                }

                Section {
                    Button {
                        showConfirmApprove = true
                    } label: {
                        Label("核准申請", systemImage: "checkmark.circle.fill")
                            .foregroundStyle(.green)
                            .frame(maxWidth: .infinity, alignment: .center)
                            .fontWeight(.semibold)
                    }

                    Button(role: .destructive) {
                        showConfirmDeny = true
                    } label: {
                        Label("拒絕申請", systemImage: "xmark.circle.fill")
                            .frame(maxWidth: .infinity, alignment: .center)
                            .fontWeight(.semibold)
                    }
                }
            }
        }
        .listStyle(.insetGrouped)
        .navigationTitle("申請詳情")
        .navigationBarTitleDisplayMode(.inline)
        .confirmationDialog("核准這個申請嗎？", isPresented: $showConfirmApprove, titleVisibility: .visible) {
            Button("確認核准") {
                appState.approveRequest(request, note: noteInput)
                dismiss()
            }
            Button("取消", role: .cancel) {}
        } message: {
            Text("孩子將可以瀏覽 \(request.domain)")
        }
        .confirmationDialog("拒絕這個申請嗎？", isPresented: $showConfirmDeny, titleVisibility: .visible) {
            Button("確認拒絕", role: .destructive) {
                appState.denyRequest(request, note: noteInput)
                dismiss()
            }
            Button("取消", role: .cancel) {}
        } message: {
            Text("申請將被標記為已拒絕")
        }
    }
}

#Preview {
    NavigationStack {
        AccessRequestDetailView(request: AccessRequest(
            childProfileId: "child-001",
            domain: "youtube.com",
            reason: "我需要看英文學習影片，這對我學英文很有幫助，老師也有推薦這些影片。",
            status: .pending
        ))
        .environment(AppState())
    }
}
