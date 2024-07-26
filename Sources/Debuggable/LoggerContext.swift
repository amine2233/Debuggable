import Foundation

/// Context for debugging
public protocol LoggerContext: Sendable {
    var name: String { get }
}

extension LoggerContext where Self: Equatable {
    
    /// Returns a Boolean value indicating whether two values are equal.
    ///
    /// Equality is the inverse of inequality. For any values `a` and `b`,
    /// `a == b` implies that `a != b` is `false`.
    ///
    /// - Parameters:
    ///   - lhs: A value to compare.
    ///   - rhs: Another value to compare.
    public static func == (lhs: Self, rhs: Self) -> Bool {
        return lhs.name == rhs.name
    }
}

struct ContextEmpty: LoggerContext {
    let name: String = ""
}
