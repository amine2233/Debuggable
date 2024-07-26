import Foundation

public struct SourceLocation: Sendable {
    /// File in which this location exists.
    public let file: String
    
    /// Function in which this location exists.
    public let function: String
    
    /// Line number this location belongs to.
    public let line: UInt
    
    /// Number of characters into the line this location starts at.
    public let column: UInt
    
    /// Optional start/end range of the source.
    public let range: Range<UInt>?
    
    /// Creates a new `SourceLocation`
    init(
        file: String,
        function: String,
        line: UInt,
        column: UInt,
        range: Range<UInt>?
    ) {
        self.file = file
        self.function = function
        self.line = line
        self.column = column
        self.range = range
    }
}

extension SourceLocation {
    /// Creates a new `SourceLocation` for the current call site.
    static func capture(
        file: String = #file,
        function: String = #function,
        line: UInt = #line,
        column: UInt = #column,
        range: Range<UInt>? = nil
    ) -> SourceLocation {
        return SourceLocation(file: file, function: function, line: line, column: column, range: range)
    }
}
