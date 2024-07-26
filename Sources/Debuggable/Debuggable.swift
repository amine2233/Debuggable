import Foundation

/// `Debuggable` provides an interface that allows a type
/// to be more easily debugged in the case of an error.
public protocol Debuggable: CustomDebugStringConvertible, CustomStringConvertible, LocalizedError, Sendable {
    /// A readable name for the error's Type. This is usually
    /// similar to the Type name of the error with spaces added.
    /// This will normally be printed proceeding the error's reason.
    /// - note: For example, an error named `FooError` will have the
    /// `readableName` `"Foo Error"`.
    static var readableName: String { get }

    /// A unique identifier for the error's Type.
    /// - note: This defaults to `ModuleName.TypeName`,
    /// and is used to create the `identifier` property.
    static var typeIdentifier: String { get }

    /// Some unique identifier for this specific error.
    /// This will be used to create the `identifier` property.
    /// Do NOT use `String(reflecting: self)` or `String(describing: self)`
    /// or there will be infinite recursion
    var identifier: String { get }

    /// The reason for the error. Usually one sentence (that should end with a period).
    var reason: String { get }

    /// Optional source location for this error
    var sourceLocation: SourceLocation? { get }

    /// Stack trace from which this error originated (must set this from the error's init)
    var stackTrace: [String]? { get }

    /// A `String` array describing the possible causes of the error.
    /// - note: Defaults to an empty array.
    /// Provide a custom implementation to give more context.
    var possibleCauses: [String] { get }

    /// A `String` array listing some common fixes for the error.
    /// - note: Defaults to an empty array.
    /// Provide a custom implementation to be more helpful.
    var suggestedFixes: [String] { get }

    /// An array of string `URL`s linking to documentation pertaining to the error.
    /// - note: Defaults to an empty array.
    /// Provide a custom implementation with relevant links.
    var documentationLinks: [String] { get }

    /// An array of string `URL`s linking to related Stack Overflow questions.
    /// - note: Defaults to an empty array.
    /// Provide a custom implementation to link to useful questions.
    var stackOverflowQuestions: [String] { get }

    /// An array of string `URL`s linking to related issues on Vapor's GitHub repo.
    /// - note: Defaults to an empty array.
    /// Provide a custom implementation to a list of pertinent issues.
    var gitHubIssues: [String] { get }
}


/// MARK: Computed
extension Debuggable {
    /// Generates a stack trace from the call point. Must call this from the error's init.
    public static func makeStackTrace() -> [String] {
        return Thread.callStackSymbols
    }
}

public extension Debuggable {
    var fullIdentifier: String {
        return Self.typeIdentifier + "." + identifier
    }
}

// MARK: Defaults

public extension Debuggable {
    /// See `Debuggable`
    static var readableName: String {
        return typeIdentifier
    }

    /// See `Debuggable`
    static var typeIdentifier: String {
        let type = "\(self)"
        return type.split(separator: ".").last.flatMap(String.init) ?? type
    }

    /// See `Debuggable`
    var possibleCauses: [String] {
        return []
    }

    /// See `Debuggable`
    var suggestedFixes: [String] {
        return []
    }

    /// See `Debuggable`
    var documentationLinks: [String] {
        return []
    }

    /// See `Debuggable`
    var stackOverflowQuestions: [String] {
        return []
    }

    /// See `Debuggable`
    var gitHubIssues: [String] {
        return []
    }

    /// See `Debuggable`
    var sourceLocation: SourceLocation? {
        return nil
    }

    /// See `Debuggable`
    var stackTrace: [String]? {
        return Self.makeStackTrace()
    }
}

/// MARK: Custom...StringConvertible
public extension Debuggable {
    /// See `CustomDebugStringConvertible`
    var debugDescription: String {
        return debuggableHelp(format: .long)
    }

    /// See `CustomStringConvertible`
    var description: String {
        return debuggableHelp(format: .short)
    }
}

// MARK: Localized
public extension Debuggable {
    /// A localized message describing what error occurred.
    var errorDescription: String? { return description }

    /// A localized message describing the reason for the failure.
    var failureReason: String? { return reason }

    /// A localized message describing how one might recover from the failure.
    var recoverySuggestion: String? { return suggestedFixes.first }

    /// A localized message providing "help" text if the user requests help.
    var helpAnchor: String? { return documentationLinks.first }
}


// MARK: Representations
/// Available formatting options for generating debug info for `Debuggable` errors.
public enum HelpFormat {
    case short
    case long
}

public extension Debuggable {
    /// A computed property returning a `String` that encapsulates why the error occurred, suggestions on how to
    /// fix the problem, and resources to consult in debugging (if these are available).
    /// - note: This representation is best used with functions like print()
    func debuggableHelp(format: HelpFormat) -> String {
        var print: [String] = []

        switch format {
        case .long:
            print.append("⚠️ \(Self.readableName): \(reason)\n- id: \(fullIdentifier)")
        case .short:
            print.append("⚠️ [\(fullIdentifier): \(reason)]")
        }

        if let source = sourceLocation {
            switch format {
            case .long:
                var help: [String] = []
                help.append("File: \(source.file)")
                help.append(" - func: \(source.function)")
                help.append(" - line: \(source.line)")
                help.append(" - column: \(source.column)")
                if let range = source.range {
                    help.append("- range: \(range)")
                }
                print.append(help.joined(separator: "\n"))
            case .short:
                var string = "[\(source.file):\(source.line):\(source.column)"
                if let range = source.range {
                    string += " (\(range))"
                }
                string += "]"
                print.append(string)
            }
        }

        switch format {
        case .long:
            if !possibleCauses.isEmpty {
                print.append("Here are some possible causes: \(possibleCauses.bulletedList)")
            }

            if !suggestedFixes.isEmpty {
                print.append("These suggestions could address the issue: \(suggestedFixes.bulletedList)")
            }

            if !documentationLinks.isEmpty {
                print.append("Vapor's documentation talks about this: \(documentationLinks.bulletedList)")
            }

            if !stackOverflowQuestions.isEmpty {
                print.append("These Stack Overflow links might be helpful: \(stackOverflowQuestions.bulletedList)")
            }

            if !gitHubIssues.isEmpty {
                print.append("See these Github issues for discussion on this topic: \(gitHubIssues.bulletedList)")
            }
        case .short:
            if possibleCauses.count > 0 {
                print.append("[Possible causes: \(possibleCauses.joined(separator: " "))]")
            }
            if suggestedFixes.count > 0 {
                print.append("[Suggested fixes: \(suggestedFixes.joined(separator: " "))]")
            }
        }

        switch format {
        case .long:
            return print.joined(separator: "\n\n") + "\n"
        case .short:
            return print.joined(separator: " ")
        }
    }
}


extension Sequence where Iterator.Element == String {
    var bulletedList: String {
        return map { "\n- \($0)" } .joined()
    }
}
