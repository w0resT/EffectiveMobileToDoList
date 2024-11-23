import Foundation

final class DateFormatterHelper {
    static let shared: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .short
        formatter.timeStyle = .none
        return formatter
    }()
    
    static func string(from date: Date) -> String {
        return shared.string(from: date)
    }
    
    static func date(from string: String) -> Date? {
        return shared.date(from: string)
    }
}
