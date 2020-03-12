//
//  RateLimitError.swift
//  Messenger
//
//  Created by Canh Tran Wizeline on 3/9/20.
//  Copyright © 2020 CanhTran. All rights reserved.
//

import Foundation

public struct RateLimitError: Error, Decodable {
    let limit: Int
    let remaining: Int
    let timeReset: Int
    
    private enum CodingKeys: String, CodingKey {
        case limit = "X-RateLimit-Limit"
        case remaining = "X-RateLimit-Remaining"
        case timeReset = "X-RateLimit-Reset"
    }
    
    func errorMessage() -> String {
        return """
        API rate limit exceeded!!
        - Number of requests you're permitted to make per hour: \(limit)
        - Rate limit remaining: \(remaining)
        - Please retry after: \(Date(timeIntervalSince1970: TimeInterval(timeReset)))
        """
    }
}
