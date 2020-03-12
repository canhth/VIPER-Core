//
//  APIEndpoint.swift
//  Messenger
//
//  Created by Canh Tran Wizeline on 5/5/19.
//  Copyright © 2019 Canh Tran. All rights reserved.
//

import Foundation

public typealias Parameters = [String: Any]
public typealias HTTPHeaders = [String: String]

public enum HTTPMethod: String {
    case get = "GET"
    case post = "POST"
    case put = "PUT"
}

/// A definition of an valid endpoint to create a URLRequest
public protocol APIEndpoint {
    var baseURLPath: String { get }
    var path: String { get }
    var headers: HTTPHeaders { get }
    var parameters: Parameters? { get }
    var method: HTTPMethod { get }
    var jsonDecoder: JSONDecoder { get }
}

public extension APIEndpoint {
    var baseURLPath: String {
        return DefaultNetworkConfiguration.networkConfiguration.baseURL
    }

    var headers: HTTPHeaders {
        return ["Content-Type": "application/json"]
    }

    var jsonDecoder: JSONDecoder {
        return JSONDecoder()
    }

    /// Build an URLRequest from provided endpoint properties
    ///
    /// - Returns: An URLRequest
    func buildRequest() -> URLRequest? {
        guard let url = urlComponents?.url else { return nil }

        var request = URLRequest(url: url)
        request.httpMethod = method.rawValue
        request.httpBody = parametersToHttpBody()
        request.timeoutInterval = 5 * 1000
        headers.forEach { request.addValue($0.value, forHTTPHeaderField: $0.key) }
        return request
    }
}

private extension APIEndpoint {
    /// A computed `URLComponents` property as a combination of `baseURLPath` and `path`
    var urlComponents: URLComponents? {
        guard var url = URL(string: baseURLPath) else { return nil }
        url.appendPathComponent(path)
        return URLComponents(url: url, resolvingAgainstBaseURL: false)
    }

    /// Converts a JSON object into Data to use as the HTTPBody
    ///
    /// - Returns: The converted data
    func parametersToHttpBody() -> Data? {
        return try? JSONSerialization.data(withJSONObject: parameters ?? [:], options: [])
    }
}
