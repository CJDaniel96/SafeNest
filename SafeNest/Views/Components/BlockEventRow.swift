import SwiftUI
import SwiftData

/// 單筆阻擋事件的行元件，用於 Dashboard 與 ChildDeviceView。
struct BlockEventRow: View {
    let event: BlockEvent

    var body: some View {
        HStack(alignment: .center, spacing: 12) {
            // 類別圖示
            Image(systemName: event.category.icon)
                .foregroundStyle(event.category.color)
                .frame(width: 28, height: 28)
                .background(
                    event.category.color.opacity(0.12),
                    in: RoundedRectangle(cornerRadius: 6)
                )

            VStack(alignment: .leading, spacing: 2) {
                Text(event.domain)
                    .font(.subheadline)
                    .fontWeight(.medium)
                    .lineLimit(1)
                Text(event.category.displayName)
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }

            Spacer()

            Text(event.blockedAt.relativeDescription)
                .font(.caption)
                .foregroundStyle(.secondary)
        }
        .padding(.vertical, 10)
        .padding(.horizontal, 16)
    }
}

// MARK: - BlockEventList

/// 阻擋事件清單，含空狀態處理。
/// Dashboard 與 ChildDeviceView 共用此元件，避免重複實作。
struct BlockEventList: View {
    let events: [BlockEvent]
    var emptyTitle: String       = "暫無紀錄"
    var emptyIcon: String        = "checkmark.shield"
    var emptyDescription: String = "目前沒有阻擋紀錄"

    var body: some View {
        if events.isEmpty {
            ContentUnavailableView(
                emptyTitle,
                systemImage: emptyIcon,
                description: Text(emptyDescription)
            )
        } else {
            VStack(spacing: 0) {
                // P4：改用 index 判斷是否為最後一筆，不依賴 id 比對
                ForEach(events.indices, id: \.self) { index in
                    BlockEventRow(event: events[index])
                    if index < events.count - 1 {
                        Divider().padding(.leading, 16)
                    }
                }
            }
            .cardContainer()
        }
    }
}

#Preview {
    let container = PreviewContainer.shared
    return BlockEventList(events: [])
        .modelContainer(container)
}
