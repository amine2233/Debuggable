import Foundation

private struct Constants: Sendable {
    static let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd hh:mm:ssSSS"
        formatter.locale = Locale.current
        return formatter
    }()
}

extension Date {
    var toLoggerString: String {
        return Constants.dateFormatter.string(from: self as Date)
    }
}
