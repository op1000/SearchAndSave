//
//  SearchGridViewModel.swift
//  SearchAndSave
//
//  Created by nakcheon.jung on 5/16/25.
//

import Foundation
import Combine

class SearchGridViewModel: ObservableObject {
    // MARK: - SANE
    
    struct State: Sendable {
        var results: [SearchedResultInfo] = []
        var allListLoaded = true
        var redrawId = UUID()
    }
    
    @Published var state: State
    let action: Action
    let reactor: Reactor
    

    actor Reactor {
        private let bookmarkStorage: BookmarkStorageType
        
        init(bookmarkStorage: BookmarkStorageType = BookmarkStorage.shared) {
            self.bookmarkStorage = bookmarkStorage
        }
        
        // MARK: - list
        
        @MainActor func update(state: inout State, results: [SearchedResultInfo]) async {
            state.results = results
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
        let loadMoreSearchedList = PassthroughSubject<String, Never>()
        let bookmark = PassthroughSubject<SearchedResultInfo, Never>()
        let removeFromBookmark = PassthroughSubject<SearchedResultInfo, Never>()
    }
    
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
        Logger.log(#function)
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
        
        action.bookmark
            .sink { [weak self] info in
                Task { @MainActor [weak self] in
                    guard let self else { return }
                    await reactor.bookmark(state: &state, info: info)
                }
            }
            .store(in: &cancellableSet)
        
        action.removeFromBookmark
            .sink { [weak self] info in
                Task { @MainActor [weak self] in
                    guard let self else { return }
                    await reactor.removeFromBookmark(state: &state, info: info)
                }
            }
            .store(in: &cancellableSet)
    }
}

