//
//  NetworkError.swift
//  Messenger
//
//  Created by Canh Tran Wizeline on 5/5/19.
//  Copyright © 2019 Canh Tran. All rights reserved.
//

import Foundation

public enum NetworkError: Error {
    /// Unable to generate the URL request for the given options.
    case unableToGenerateURLRequest

    /// Expected deserialization of the response failed.
    case badDeserialization

    /// There was an invalid response from the network
    case invalidResponse

    /// Unable to fetch with the specified underlying error.
    case fetchError(error: Error)

    case exceedRateLimit(rateLimit: RateLimitError)
    
    /// The status code does not indicate success for the specified response.
    case noSuccessResponse(code: String)
}

public extension NetworkError {
    var localizedDescription: String {
        switch self {
        case .unableToGenerateURLRequest:
            return NSLocalizedString("Unable to generate the URL request for the given options.",
                                     comment: "Unable to generate the URL request for the given options.")
        case .badDeserialization:
            return NSLocalizedString("Deserialization failed.",
                                     comment: "Expected deserialization of the response failed.")
        case .invalidResponse:
            return NSLocalizedString("Fetch error. Found invalid response.",
                                     comment: "There was an invalid response from the network.")
        case .exceedRateLimit(let rateLimit):
            return NSLocalizedString("Exceed the rate limit.",
                                     comment: rateLimit.errorMessage())
        case .noSuccessResponse(let code):
            return NSLocalizedString("Server did not return success status. Code: \(code)",
                comment: "The status code does not indicate success for the specified response.")
        case .fetchError(let error):
            return NSLocalizedString("Error occured. No item found in local cache. Error: \(error)",
                comment: "Unable to fetch with the specified underlying error.")
        }
    }
}
