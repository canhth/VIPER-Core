//
//  UserDefaultsDataStore.swift
//  Messenger
//
//  Created by Canh Tran Wizeline on 3/9/20.
//  Copyright © 2020 CanhTran. All rights reserved.
//

import Foundation

class UserDefaultsDataStore: DataStore {
    
    static let shared = UserDefaultsDataStore()
    
    private init () {}
    
    private let userDefaults = UserDefaults.standard
    
    func getString(_ key: DataStoreKey) -> String? {
        return userDefaults.string(forKey: key.description)
    }
    
    func getInt(_ key: DataStoreKey) -> Int {
        return userDefaults.integer(forKey: key.description)
    }
    
    func getBool(_ key: DataStoreKey) -> Bool {
        return userDefaults.bool(forKey: key.description)
    }
    
    func setValue<T>(key: DataStoreKey, val: T) {
        userDefaults.set(val, forKey: key.description)
    }
    
    func setModel<T: Encodable>(key: DataStoreKey, value: T) {
        if let data = try? JSONEncoder().encode(value) {
            self.setValue(key: key, val: data)
        }
    }
    
    func deleteModel(key: DataStoreKey) {
        userDefaults.removeObject(forKey: key.description)
    }
    
    func getModel<T: Decodable>(key: DataStoreKey) -> T? {
        if let data = userDefaults.value(forKey: key.description) as? Data,
            let model = try? JSONDecoder().decode(T.self, from: data) {
            return model
        }
        return nil
    }
}
