//
//  DataStore.swift
//  Messenger
//
//  Created by Canh Tran Wizeline on 3/9/20.
//  Copyright © 2020 CanhTran. All rights reserved.
//

import Foundation

enum DataStoreKey: CustomStringConvertible {
    var description: String {
        switch self {
        case .comment(let userId):
            return userId
        default:
            return "\(self)"
        }
    }
    
    case comment(userId: String)
    case token
}

/// This protocol helps to abstract the logic of a data store, which is responsible for persisting data.
protocol DataStore {
    /// Stores an instance of a data model that conforms to the Encodable protocol.
    /// You just need to pass a DataStoreKey and the instance of the model itself
    /// - Parameter key: The key which the value will be linked with.
    /// - Parameter value: The instance of the model (The model must implement Encodable protocol)
    func setModel<T: Encodable>(key: DataStoreKey, value: T)
    
    /// Returns an instance of a data model if exists in disk.
    /// - Parameter key: The key which the value is linked with.
    func getModel<T: Decodable>(key: DataStoreKey) -> T?
    
    /// Stores a raw value type (not a model). Since it's generic, it could be an int, String, double, etc...
    /// - Parameter key: The key which the value will be linked with.
    /// - Parameter val: The value itself.
    func setValue<T>(key: DataStoreKey, val: T)
    
    /// Gets a String value that is persisted in disk. To get it you need to pass the associated key.
    /// The returned value could be nil.
    /// - Parameter key: The key which the value is linked with.
    func getString(_ key: DataStoreKey) -> String?
    
    /// Returns an Int value that is persisted in disk. To get it you need to pass the associated key.
    /// - Parameter key: The key which the value is linked with.
    func getInt(_ key: DataStoreKey) -> Int
    
    /// Deletes a model from the DataStore
    /// - Parameter key: The key which the value is linked with.
    func deleteModel(key: DataStoreKey)
}
