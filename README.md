# SafeNest

iOS 家長監控 App 的 MVP 示範專案，以 SwiftUI + MVVM + SwiftData 打造，支援家長端與兒少端雙介面。

---

## 功能概覽

### 家長端（Parent Mode）

| 頁面 | 功能 |
|------|------|
| **總覽（Dashboard）** | 孩子裝置卡片、本週風險摘要、最近阻擋紀錄、待審核申請快覽 |
| **規則管理（Rules）** | 黑名單 / 白名單 / 類別規則的新增、啟用/停用、刪除 |
| **阻擋紀錄（Events）** | 完整封鎖歷史，支援依類別篩選 |
| **審核申請（Requests）** | 孩子提出的解鎖申請收件匣；可核准或拒絕並附備註 |
| **設定（Settings）** | 家長 & 孩子資訊、保護開關、角色切換 |

### 兒少端（Child Mode）

| 頁面 | 功能 |
|------|------|
| **首頁（Home）** | 保護狀態英雄區、今日封鎖數、體驗「被阻擋」示範流程 |
| **保護狀態（Status）** | 規則明細、本日 / 本週封鎖統計 |
| **我的申請（Requests）** | 提出申請的歷史紀錄；顯示家長回覆備註 |

### 完整 AccessRequest 流程
孩子在「被阻擋」頁面點擊申請 → 填寫原因送出 → 寫入 SwiftData → 家長端收件匣收到通知 badge → 家長核准或拒絕並附備註 → 孩子端申請頁顯示審核結果。

---

## 技術規格

- **平台**：iOS 17+，iPhone Only
- **語言**：Swift 5.9+（Swift 6 Sendable 相容）
- **UI 框架**：SwiftUI
- **資料層**：SwiftData（`@Model`、`@Query`、`ModelContext`）
- **狀態管理**：`@Observable`（iOS 17 Observation 框架）
- **架構**：MVVM — View 以 `@Query` 讀資料，ViewModel 為純 struct，AppState 統一處理寫入

---

## 架構說明

```
SafeNest/
├── Models/                  # SwiftData @Model 類別
│   ├── Parent.swift
│   ├── ChildProfile.swift
│   ├── Rule.swift           # + RuleType enum
│   ├── BlockEvent.swift     # + BlockEventCategory enum
│   ├── AccessRequest.swift  # + AccessRequestStatus enum
│   ├── AppRole.swift        # parent / child 角色切換
│   └── WeeklySummary.swift  # 非持久化統計 struct
│
├── Store/
│   └── AppState.swift       # @Observable 全域狀態；所有寫入操作集中於此
│
├── ViewModels/              # 純 struct，接受 @Query 結果計算顯示邏輯
│   ├── DashboardViewModel.swift
│   ├── RuleManagementViewModel.swift
│   ├── EventHistoryViewModel.swift
│   ├── SettingsViewModel.swift
│   ├── ChildDeviceViewModel.swift
│   ├── ChildHomeViewModel.swift
│   ├── ProtectionStatusViewModel.swift
│   ├── RequestAccessViewModel.swift    # 表單本地狀態
│   ├── AccessRequestInboxViewModel.swift
│   └── RequestHistoryViewModel.swift
│
├── Views/
│   ├── Root/                # RootView：依 AppRole 路由至家長/兒少端
│   ├── MainTabView.swift    # 家長端 TabView（含 pending badge）
│   ├── Dashboard/           # 總覽頁
│   ├── Rules/               # 規則管理
│   ├── Events/              # 阻擋紀錄
│   ├── Requests/            # 家長端：收件匣 + 審核詳情
│   ├── ChildDevice/         # 家長端：孩子裝置詳情
│   ├── Child/               # 兒少端：首頁、狀態、申請、被阻擋
│   ├── Settings/            # 設定
│   └── Components/          # 共用元件
│       ├── SectionHeader
│       ├── FilterChip
│       ├── TagView (Category / RuleType)
│       ├── BlockEventRow / BlockEventList
│       └── AccessRequestRow / StatusBadge
│
├── Services/
│   ├── SeedDataService.swift         # 首次啟動 Demo 資料植入（冪等）
│   └── ProtectionServiceProtocol.swift  # 未來 ContentFilterProvider 介面預留
│
└── Utilities/
    ├── PreviewContainer.swift         # Xcode Preview 專用 in-memory ModelContainer
    ├── CardContainer.swift            # .cardContainer() ViewModifier
    ├── DateFormatter+Extensions.swift # 靜態快取 DateFormatter
    ├── BlockEventCategory+UI.swift    # icon / color per category
    └── AccessRequestStatus+UI.swift   # icon / color per status
```

---

## 資料模型

### AccessRequest（Round 6 新增）
```swift
@Model final class AccessRequest {
    var id: String
    var childProfileId: String
    var domain: String
    var requestedAt: Date
    var reason: String
    var status: AccessRequestStatus   // .pending / .approved / .denied
    var reviewedAt: Date?
    var reviewerNote: String?
}
```

### Rule
```swift
@Model final class Rule {
    var id: String
    var childProfileId: String
    var type: RuleType                // .blacklist / .whitelist / .category
    var value: String
    var enabled: Bool
    var createdAt: Date
}
```

### BlockEvent
```swift
@Model final class BlockEvent {
    var id: String
    var childProfileId: String
    var domain: String
    var url: String?
    var category: BlockEventCategory  // .adult / .gambling / .violence / ...
    var matchedRuleType: RuleType
    var blockedAt: Date
}
```

---

## 開發慣例

### SwiftData + MVVM 模式
```swift
// View：@Query 負責讀取，傳給 ViewModel 計算
@Query(sort: \BlockEvent.blockedAt, order: .reverse) private var blockEvents: [BlockEvent]

private var vm: DashboardViewModel {
    DashboardViewModel(child: childProfiles.first, blockEvents: blockEvents, accessRequests: accessRequests)
}

// AppState：所有寫入集中管理
appState.approveRequest(request, note: noteInput)
```

### Swift 6 Sendable 注意事項
`@Model` class 不符合 `Sendable`，跨 actor 邊界的 Service 介面一律改用 ID（`String`）而非 model 物件：
```swift
// ✅ 正確
func syncRules(_ ruleIds: [String], for childId: String, ...)

// ❌ 錯誤：Rule 不可跨 actor 傳遞
func syncRules(_ rules: [Rule], ...)
```

### Preview 使用方式
```swift
#Preview {
    SomeView()
        .modelContainer(PreviewContainer.shared)  // in-memory，含 SeedData
        .environment(AppState())
}
```

---

## 開發迭代紀錄

| Round | 內容 |
|-------|------|
| **Round 1** | SwiftUI + MVVM MVP 骨架，TabView 五頁，Mock 資料 |
| **Round 2** | 共用 AppState，RuleType / BlockEventCategory 改為 enum |
| **Round 3** | 資料層遷移至 SwiftData，SeedDataService，PreviewContainer |
| **Round 4** | 抽出 SectionHeader / FilterChip / TagView / BlockEventRow / CardContainer，快取 DateFormatter |
| **Round 5** | 兒少端 UI：AppRole、RootView 路由、ChildTabView、BlockedContentView、RequestAccessView（假送出）、ProtectionStatusView |
| **Round 6** | 完整 AccessRequest 流程：孩子真實送出申請 → 家長收件匣審核（核准 / 拒絕 + 備註）→ 孩子端歷史顯示結果 |

---

## 未來擴展方向

- **ScreenTime / ContentFilterProvider**：串接 Apple Family Controls 框架實現真實封鎖（`ProtectionServiceProtocol` 已預留介面）
- **推播通知**：孩子送出申請時通知家長；審核完成後通知孩子
- **多孩子支援**：目前 `childProfiles.first` 簡化為單一孩子
- **家長端驗證**：Face ID / Passcode 保護家長模式切換
- **後端同步**：跨裝置資料同步（CloudKit 或自建 API）
