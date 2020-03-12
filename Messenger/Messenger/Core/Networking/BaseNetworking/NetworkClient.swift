//
//  NetworkClient.swift
//  Messenger
//
//  Created by Canh Tran Wizeline on 5/5/19.
//  Copyright © 2019 Canh Tran. All rights reserved.
//

import Foundation

/// A definition of a NetworkClient
public protocol NetworkRequestable {
    func fetch<T: Decodable>(endPoint: APIEndpoint,
                             type: T.Type,
                             completion: @escaping (Result<T, NetworkError>) -> Void)
}

/// A type represents network client
public final class NetworkClient: NetworkRequestable {

    public typealias NetworkClientResponse<T> = (Result<T, NetworkError>) -> Void

    private let session: URLSession

    /// Creates an instance of network client
    ///
    /// - Parameter session: The URLSession that coordinates a group of related network data transfer tasks
    public init(session: URLSession = URLSession.shared) {
        self.session = session
    }

    /// Fetches a network request with a relevant `Decodable.Type`to decode the response.
    ///
    /// - Parameters:
    ///   - endPoint: The endpoint to fetch
    ///   - type: The decode closure that expects a `Decodable` object and returns a relevant type
    ///   - completion: The completion handler of the request
    public func fetch<T: Decodable>(endPoint: APIEndpoint,
                                    type: T.Type,
                                    completion: @escaping NetworkClientResponse<T>) {
        guard let request = endPoint.buildRequest() else {
            completion(.failure(.unableToGenerateURLRequest))
            return
        }

        let task = session.dataTask(with: request) { data, response, error in
            guard let data = data, let httpResponse = response as? HTTPURLResponse else {
                if let error = error {
                    completion(.failure(.fetchError(error: error)))
                } else {
                    // Throw invalidResponse if there is no data, http response or error
                    completion(.failure(.invalidResponse))
                }
                return
            }
            
            // Check the status code is in range and make sure there is no Rate Limit error
            guard 200..<300 ~= httpResponse.statusCode else {
                self.checkRateLimitError(httpResponse: httpResponse, completion: completion)
                return
            }

            do {
                let genericModel = try endPoint.jsonDecoder.decode(T.self, from: data)
                completion(.success(genericModel))
            } catch {
                completion(.failure(.badDeserialization))
            }
        }

        task.resume()
    }
    
    // MARK: - Private
    
    /// The step to check exceed the Rate Limit.
    private func checkRateLimitError<T>(httpResponse: HTTPURLResponse, completion: @escaping NetworkClientResponse<T>) {
        do {
            let data = try JSONSerialization.data(withJSONObject: httpResponse.allHeaderFields as? [String: String] ?? [:],
                                                  options: [])
            let rateLimit = try JSONDecoder().decode(RateLimitError.self, from: data)
            completion(.failure(.exceedRateLimit(rateLimit: rateLimit)))
        } catch {
            completion(.failure(.noSuccessResponse(code: "\(httpResponse.statusCode)")))
        }
    }
}
