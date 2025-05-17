//
//  SearchGridViewModel.swift
//  SearchAndSave
//
//  Created by nakcheon.jung on 5/16/25.
//

import Foundation
import Combine
import domainKit
import RepositoryKit
import EnvironmentKit

class SearchGridViewModel: ObservableObject {
    // MARK: - SANE
    
    struct State: Sendable {
        var results: [SearchedResultInfo] = []
        var allListLoaded = true
        var redrawId = UUID()
    }
    actor Reactor {
        private let bookmarkStorage: BookmarkStorageType
        
        init(bookmarkStorage: BookmarkStorageType = BookmarkStorage.shared) {
            self.bookmarkStorage = bookmarkStorage
        }
        
        // MARK: - list
        
        @MainActor func update(state: inout State, results: [SearchedResultInfo]) async {
            state.results = results
        }
        
        @MainActor func update(state: inout State, allListLoaded: Bool) async {
            state.allListLoaded = allListLoaded
        }
        
        // MARK: - bookmark
        
        @MainActor func bookmark(state: inout State, info: SearchedResultInfo) async {
            guard let index = state.results.firstIndex(of: info) else { return }
            state.results[index].isBookmarked = true
            state.redrawId = UUID()
            await bookmarkStorage.saveBookmark(info)
        }
        
        @MainActor func removeFromBookmark(state: inout State, info: SearchedResultInfo) async {
            guard let index = state.results.firstIndex(of: info) else { return }
            state.results[index].isBookmarked = false
            state.redrawId = UUID()
            await bookmarkStorage.removeBookmark(info)
        }
    }
    
    struct Action {
        let setResults = PassthroughSubject<[SearchedResultInfo], Never>()
        let setAllListLoaded = PassthroughSubject<Bool, Never>()
        let loadMoreSearchedList = PassthroughSubject<String, Never>()
        let bookmark = PassthroughSubject<SearchedResultInfo, Never>()
        let removeFromBookmark = PassthroughSubject<SearchedResultInfo, Never>()
    }
    
    @Published var state: State
    let action: Action
    let reactor: Reactor
    
    // MARK: - Private
    
    private var cancellableSet: Set<AnyCancellable> = []
    
    init(
        bookmarkStorage: BookmarkStorageType = BookmarkStorage.shared
    ) {
        self.state = State()
        self.action = Action()
        self.reactor = Reactor()
        
        bind()
    }
    
    deinit {
        DLog.log(#function)
    }
}

extension SearchGridViewModel {
    func containsBookmark(info: SearchedResultInfo) -> Bool {
        guard let index = state.results.firstIndex(of: info) else { return false }
        return state.results[index].isBookmarked
    }
}

extension SearchGridViewModel {
    private func bind() {
        action.setResults
            .sink { results in
                Task { @MainActor [weak self] in
                    guard let self else { return }
                    await reactor.update(state: &state, results: results)
                }
            }
            .store(in: &cancellableSet)
        
        action.setAllListLoaded
            .sink { allListLoaded in
                Task { @MainActor [weak self] in
                    guard let self else { return }
                    await reactor.update(state: &state, allListLoaded: allListLoaded)
                }
            }
            .store(in: &cancellableSet)
        
        action.bookmark
            .sink { [weak self] info in
                Task { @MainActor [weak self] in
                    guard let self else { return }
                    await reactor.bookmark(state: &state, info: info)
                    SearchEventBus.shared.bookmarkChanged.send()
                }
            }
            .store(in: &cancellableSet)
        
        action.removeFromBookmark
            .sink { [weak self] info in
                Task { @MainActor [weak self] in
                    guard let self else { return }
                    await reactor.removeFromBookmark(state: &state, info: info)
                    SearchEventBus.shared.bookmarkChanged.send()
                }
            }
            .store(in: &cancellableSet)
    }
}

