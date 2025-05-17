//
//  Storage.swift
//  SearchAndSave
//
//  Created by nakcheon.jung on 5/15/25.
//

import Foundation

protocol StorageType {
    func loadDefaults(key: Storage.DefaultsKey) -> Any?
    func saveDefaults(key: Storage.DefaultsKey, val: Any?)
}

class Storage: StorageType {
    
    // MARK: - life cycle
    
    static let shared = Storage()
    private init() {}
    
    // MARK: - types
    
    enum DefaultsKey: String {
        case bookmark
    }

    // MARK: - UserDefaults API

    func loadDefaults(key: DefaultsKey) -> Any? {
        return UserDefaults.standard.object(forKey: key.rawValue)
    }
    
    func saveDefaults(key: DefaultsKey, val: Any?) {
        UserDefaults.standard.set(val, forKey: key.rawValue)
        UserDefaults.standard.synchronize()
    }
}
