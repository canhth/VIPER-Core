//
//  NetworkConfiguration.swift
//  Messenger
//
//  Created by Canh Tran Wizeline on 9/17/19.
//

import Foundation

/// List of environment Types in App
public enum Environment: String {
    case dev = "DEV"
    case prod = "PROD"
}

/// Base protocol for NetworkConfiguration
public protocol NetworkConfiguration {
    var baseURL: String { get }
    var environment: Environment { get }
}

public final class DefaultNetworkConfiguration: NetworkConfiguration {

    public static var networkConfiguration = DefaultNetworkConfiguration(environment: .dev)

    // MARK: Properties
    public var baseURL: String {
        return configuration?["baseURL"] as? String ?? ""
    }
    public let environment: Environment

    private let fileName: String
    private let type: String

    /// Init the Network configuration by Plist file and environment Type
    public init(file: String = "APIConfiguration", type: String = "plist", environment: Environment) {
        self.fileName = file
        self.type = type
        self.environment = environment
    }

    /// Contains all the configuration properties of Plist file
    public lazy var configuration: [String: Any]? = {
        guard let fileUrl = Bundle.main.url(forResource: fileName, withExtension: type),
            let data = try? Data(contentsOf: fileUrl) else { return nil }
        guard let dict = try? PropertyListSerialization.propertyList(from: data,
                                                                     options: [],
                                                                     format: nil) as? [String: Any],
            let result = dict[environment.rawValue] as? [String: Any] else { return nil }
        return result
    }()
}
