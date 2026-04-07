import Foundation

extension Date {
    /// 顯示用短日期時間，例如：04/06 14:30
    var shortDateTime: String {
        let f = DateFormatter()
        f.dateFormat = "MM/dd HH:mm"
        f.locale = Locale(identifier: "zh_TW")
        return f.string(from: self)
    }

    /// 相對時間描述，例如：30 分鐘前
    var relativeDescription: String {
        let formatter = RelativeDateTimeFormatter()
        formatter.locale = Locale(identifier: "zh_TW")
        formatter.unitsStyle = .short
        return formatter.localizedString(for: self, relativeTo: Date())
    }

    /// 判斷是否為今天
    var isToday: Bool {
        Calendar.current.isDateInToday(self)
    }
}
