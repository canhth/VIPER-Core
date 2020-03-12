//
//  ListUsersAPI.swift
//  Messenger
//
//  Created by Canh Tran Wizeline on 3/9/20.
//  Copyright © 2020 CanhTran. All rights reserved.
//

import Foundation

enum ListUserAPI {
    case fetchListUser(lastId: String?)
}

// MARK: Confirm protocol Endpoint

extension ListUserAPI: APIEndpoint {
    var method: HTTPMethod {
        return .get
    }

    var path: String {
        switch self {
        case .fetchListUser: return "/users"
        }
    }

    var parameters: Parameters? {
        switch self {
        case .fetchListUser(let lastId):
            return ["since": lastId ?? 0]
        }
    }

    var jsonDecoder: JSONDecoder {
        let decoder = JSONDecoder()
        switch self {
        case .fetchListUser:
            decoder.keyDecodingStrategy = .convertFromSnakeCase
        }
        return decoder
    }
}
