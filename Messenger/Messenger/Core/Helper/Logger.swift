//
//  Logger.swift
//  Messenger
//
//  Created by Canh Tran Wizeline on 3/9/20.
//  Copyright © 2020 CanhTran. All rights reserved.
//

import Foundation
import os.log

// MARK: - Definition

public extension Logger {
    enum Tag: String {
        case general, lifeCycle

        private static var osLogs: [Tag: OSLog] = [:]

        var osLog: OSLog {
            if let log = Tag.osLogs[self] {
                return log
            } else {
                let appBundle = Bundle.main.bundleIdentifier! // swiftlint:disable:this force_unwrapping
                let log = OSLog(subsystem: appBundle, category: rawValue.uppercased())
                Tag.osLogs[self] = log
                return log
            }
        }
    }

    enum Level {
        case verbose, debug, info, warning, error

        var osLogType: OSLogType {
            switch self {
            case .verbose: return .default
            case .debug: return .debug
            case .info: return .info
            case .warning: return .error
            case .error: return .fault
            }
        }

        var emoji: String {
            switch self {
            case .verbose: return "⚛"
            case .debug: return "🔵"
            case .info: return "✳️"
            case .warning: return "⚠️"
            case .error: return "🆘"
            }
        }

        var prefix: String {
            switch self {
            case .verbose: return "VERBOSE"
            case .debug: return "DEBUG"
            case .info: return "INFO"
            case .warning: return "WARNING"
            case .error: return "ERROR"
            }
        }
    }

    /// Log accessibility level
    ///
    /// - `public`: Log message will be visible in Console app
    /// - `private`: Log message won't be visible in Console app
    enum Visibility {
        case `public`, `private`
    }
}

// MARK: -

/// Wrapper for logger. There are 3 purposes:
/// 1. Don't have to re-import (#import os.log) in code base.
/// 2. Adapt to swap (or intergrate) to another logger library.
/// 3. Avoid to repeat adding boring parameters.
final public class Logger {
    public static let shared = Logger()

    private init() {
        guard Bundle.main.bundleIdentifier != nil else {
            fatalError("App bundle identifier doesn't exist.")
        }
    }

    /// Log message with several parameters. Basically we use `os_log` with some additional details.
    ///
    /// - Parameters:
    ///   - level: Level of logging, based on OSLogType.
    ///   - tag: Pre-defined category for meaning purpose, in human readability.
    ///   - visibility: Message can be visible on Console.app or not.
    ///   - message: main message to log.
    ///   - filePath: file where log occurs.
    ///   - function: function where log occurs.
    ///   - line: line number of file where log occurs.
    func log(_ level: Level = .verbose,
             tag: Tag = .general,
             visibility: Visibility = .public,
             object: Any,
             filePath: String = #file,
             function: String = #function,
             line: Int = #line) {
        let file: String = fileName(of: filePath)
        let thread: String = threadName()
        let message = String(describing: object)

        let format: StaticString
        switch visibility {
        case .private: format = "%{public}@|%{public}@ [%{public}@] [%{public}@.%{public}@:%{public}i] %{private}@"
        case .public: format = "%{public}@|%{public}@ [%{public}@] [%{public}@.%{public}@:%{public}i] %{public}@"
        }

        os_log(format, log: tag.osLog, type: level.osLogType, level.prefix, level.emoji, thread, file, function, line, message)
    }
}

// MARK: - Utilities

public extension Logger {
    func verbose(tag: Tag = .general,
                 object: Any,
                 filePath: String = #file,
                 function: String = #function,
                 line: Int = #line) {
        log(.verbose, tag: tag,
            visibility: .public,
            object: object,
            filePath: filePath,
            function: function,
            line: line)
    }

    func debug(tag: Tag = .general,
               object: Any,
               filePath: String = #file,
               function: String = #function,
               line: Int = #line) {
        log(.debug, tag: tag,
            visibility: .public,
            object: object,
            filePath: filePath,
            function: function,
            line: line)
    }

    func info(tag: Tag = .general,
              object: Any,
              filePath: String = #file,
              function: String = #function,
              line: Int = #line) {
        log(.info, tag: tag,
            visibility: .public,
            object: object,
            filePath: filePath,
            function: function,
            line: line)
    }

    func warning(tag: Tag = .general,
                 object: Any,
                 filePath: String = #file,
                 function: String = #function,
                 line: Int = #line) {
        log(.warning, tag: tag,
            visibility: .public,
            object: object,
            filePath: filePath,
            function: function,
            line: line)
    }

    func error(tag: Tag = .general,
               object: Any,
               filePath: String = #file,
               function: String = #function,
               line: Int = #line) {
        log(.error, tag: tag,
            visibility: .public,
            object: object,
            filePath: filePath,
            function: function,
            line: line)
    }
}

// MARK: - Helpers

private extension Logger {
    /// Get file name from file path.
    ///
    /// - Parameter filePath: Path of file.
    /// - Returns: file name, including extension (if has any).
    func fileName(of filePath: String) -> String {
        return filePath.components(separatedBy: "/").last ?? ""
    }

    /// Get current Thread name, or DispatchQueue name if found any. There are several ways to get it.
    ///
    /// - Returns: Thread name or Dispatch queue name.
    func threadName() -> String {
        if Thread.isMainThread {
            return "main"
        } else if let threadName = Thread.current.name, !threadName.isEmpty {
            return threadName
        } else if let operationQueueName = OperationQueue.current?.name, !operationQueueName.isEmpty {
            return operationQueueName
        } else if let dispatchQueueName = OperationQueue.current?.underlyingQueue?.label, !dispatchQueueName.isEmpty {
            return dispatchQueueName
        } else if let queueName = String(validatingUTF8: __dispatch_queue_get_label(nil)) {
            return queueName
        } else {
            return String(format: "[%p] ", Thread.current)
        }
    }
}
