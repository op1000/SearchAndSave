//
//  Storage.swift
//  SearchAndSave
//
//  Created by nakcheon.jung on 5/15/25.
//

import Foundation

public protocol StorageType {
    func loadDefaults(key: Storage.DefaultsKey) -> Any?
    func saveDefaults(key: Storage.DefaultsKey, val: Any?)
}

public class Storage: StorageType {
    
    // MARK: - life cycle
    
    public static let shared = Storage()
    private init() {}
    
    // MARK: - types
    
    public enum DefaultsKey: String {
        case bookmark
    }

    // MARK: - UserDefaults API

    public func loadDefaults(key: DefaultsKey) -> Any? {
        return UserDefaults.standard.object(forKey: key.rawValue)
    }
    
    public func saveDefaults(key: DefaultsKey, val: Any?) {
        UserDefaults.standard.set(val, forKey: key.rawValue)
        UserDefaults.standard.synchronize()
    }
}
