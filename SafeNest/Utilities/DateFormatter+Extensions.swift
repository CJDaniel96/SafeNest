import Foundation

extension Date {
    // Formatters 宣告為 static，避免每次呼叫重複建立
    private static let shortDateTimeFormatter: DateFormatter = {
        let f = DateFormatter()
        f.dateFormat = "MM/dd HH:mm"
        f.locale = Locale(identifier: "zh_TW")
        return f
    }()

    private static let relativeDateTimeFormatter: RelativeDateTimeFormatter = {
        let f = RelativeDateTimeFormatter()
        f.locale = Locale(identifier: "zh_TW")
        f.unitsStyle = .short
        return f
    }()

    /// 短日期時間，例如：04/06 14:30
    var shortDateTime: String {
        Date.shortDateTimeFormatter.string(from: self)
    }

    /// 相對時間，例如：30 分鐘前
    var relativeDescription: String {
        Date.relativeDateTimeFormatter.localizedString(for: self, relativeTo: Date())
    }

    /// 是否為今天
    var isToday: Bool {
        Calendar.current.isDateInToday(self)
    }
}
