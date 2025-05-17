//
//  SearchEventBus.swift
//  SearchAndSave
//
//  Created by nakcheon.jung on 5/16/25.
//

import Foundation
import Combine

public class SearchEventBus {
    public static let shared = SearchEventBus()
    private init() {}
    
    public let bookmarkChanged = PassthroughSubject<Void, Never>()
}

