//
//  CommentDataRepository.swift
//  Messenger
//
//  Created by Canh Tran Wizeline on 3/9/20.
//  Copyright © 2020 CanhTran. All rights reserved.
//

import Foundation

final class CommentsDataStore {
    
    private let dataStore: DataStore
    
    init(dataStore: DataStore = UserDefaultsDataStore.shared) {
        self.dataStore = dataStore
    }
    
    func getComment(userId: String) -> [Comment]? {
        return dataStore.getModel(key: .comment(userId: userId))
    }
    
    func setComments(_ comments: [Comment], userId: String) {
        dataStore.setModel(key: .comment(userId: userId), value: comments)
    }
}
