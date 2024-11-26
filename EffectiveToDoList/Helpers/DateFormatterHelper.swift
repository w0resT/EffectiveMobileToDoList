import Foundation

final class DateFormatterHelper {
    static let shared: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "MM/dd/yyyy"
        formatter.timeZone = TimeZone.current
        return formatter
    }()
    
    static func string(from date: Date) -> String {
        return shared.string(from: date)
    }
    
    static func date(from string: String) -> Date? {
        return shared.date(from: string)
    }
}
