import SwiftUI

/// 網站被阻擋時顯示的頁面。語氣溫和，提供返回與申請審核兩個出口。
struct BlockedContentView: View {
    let domain: String
    let category: BlockEventCategory

    @State private var showRequestAccess = false

    var body: some View {
        ScrollView {
            VStack(spacing: 32) {
                iconSection
                infoSection
                explanationSection
                Spacer(minLength: 8)
                actionSection
            }
            .padding()
            .padding(.bottom, 16)
        }
        .navigationTitle("網站已阻擋")
        .navigationBarTitleDisplayMode(.inline)
        .sheet(isPresented: $showRequestAccess) {
            RequestAccessView(domain: domain, category: category)
        }
    }

    // MARK: - Sections

    private var iconSection: some View {
        VStack(spacing: 16) {
            Image(systemName: "hand.raised.circle.fill")
                .font(.system(size: 72))
                .foregroundStyle(.orange)
                .padding(.top, 16)

            Text("這個網站目前無法瀏覽")
                .font(.title2)
                .fontWeight(.bold)
                .multilineTextAlignment(.center)
        }
    }

    private var infoSection: some View {
        VStack(spacing: 12) {
            VStack(spacing: 4) {
                Text("網站").font(.caption).foregroundStyle(.secondary)
                Text(domain)
                    .font(.headline)
                    .lineLimit(1)
                    .truncationMode(.middle)
            }
            CategoryTagView(category: category)
        }
        .frame(maxWidth: .infinity)
        .padding()
        .cardContainer()
    }

    private var explanationSection: some View {
        Text("這個網站的內容符合家長設定的過濾規則。\n如果你認為這是誤判，或有特殊需求，\n可以向家長申請審核。")
            .font(.subheadline)
            .foregroundStyle(.secondary)
            .multilineTextAlignment(.center)
            .lineSpacing(4)
    }

    private var actionSection: some View {
        VStack(spacing: 12) {
            Button {
                showRequestAccess = true
            } label: {
                Label("向家長申請審核", systemImage: "person.badge.key.fill")
                    .font(.headline)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.blue, in: RoundedRectangle(cornerRadius: 14))
                    .foregroundStyle(.white)
            }
        }
        .padding(.horizontal, 4)
    }
}

#Preview {
    NavigationStack {
        BlockedContentView(domain: "gambling-site.com", category: .gambling)
    }
}
