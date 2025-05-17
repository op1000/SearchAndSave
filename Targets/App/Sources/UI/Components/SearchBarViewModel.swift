//
//  SearchBarViewModel.swift
//  SearchAndSave
//
//  Created by nakcheon.jung on 5/15/25.
//

import Foundation
import Combine

class SearchBarViewModel: ObservableObject {
    let searchButtonPressed = PassthroughSubject<String, Never>()
    let clearButtonPressed = PassthroughSubject<Void, Never>()
    
    init() {
        bind()
    }
}

// MARK: - Private

extension SearchBarViewModel {
    private func bind() {}
}

