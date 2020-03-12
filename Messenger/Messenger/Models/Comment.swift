//
//  Comment.swift
//  Messenger
//
//  Created by Canh Tran Wizeline on 3/9/20.
//  Copyright © 2020 CanhTran. All rights reserved.
//

import Foundation

struct Comment: Codable {
    let createdAt: Date?
    let userName: String?
    let message: String
}
