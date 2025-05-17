//
//  SearchSheetViewModel.swift
//  SearchAndSave
//
//  Created by nakcheon.jung on 5/15/25.
//

import Foundation
import Combine
import EnvironmentKit
import domainKit
import RepositoryKit
import BackendKit

class SearchSheetViewModel: ObservableObject {
    // MARK: - SANE
    
    struct State: Sendable {
        var results: [SearchedResultInfo] = []
        var allListLoaded = true
        var redrawId = UUID()
    }
    
    actor Reactor {
        @MainActor private var searchedImageResults: [String: [SearchedResultInfo]] = [:]
        @MainActor private var searchedVClipResults: [String: [SearchedResultInfo]] = [:]
        @MainActor private var searchedImagePage: [String: Int] = [:]
        @MainActor private var searchedVClipPage: [String: Int] = [:]
        @MainActor var imageAllListLoaded = false
        @MainActor var vClipAllListLoaded = false
        private let bookmarkStorage: BookmarkStorageType
        
        init(bookmarkStorage: BookmarkStorageType = BookmarkStorage.shared) {
            self.bookmarkStorage = bookmarkStorage
        }
        
        // MARK: - search
        
        @MainActor func imagePage(state: State, searchText: String) -> Int {
            return (searchedImagePage[searchText] ?? 0) + 1
        }
        
        @MainActor func vClipPage(state: State, searchText: String) -> Int {
            return (searchedVClipPage[searchText] ?? 0) + 1
        }
        
        @MainActor func update(state: inout State, searchText: String, count: Int, items: [SearchApi.ImageDocument], isEnd: Bool) {
            if isEnd, items.isEmpty {
                DLog.log("fetch image max")
                imageAllListLoaded = true
                state.allListLoaded = imageAllListLoaded && vClipAllListLoaded
                return
            }
            let results = items.compactMap { SearchedResultInfo.fromResponeDTO($0) }
            let allResults = (searchedVClipResults[searchText] ?? []) + (searchedImageResults[searchText] ?? []) + results
            searchedImageResults[searchText] = (searchedImageResults[searchText] ?? []) + results
            if let page = searchedImagePage[searchText] {
                searchedImagePage[searchText] = page + 1
            } else {
                searchedImagePage[searchText] = 1
            }
            state.results = allResults.sorted { $0.datetime > $1.datetime }
            imageAllListLoaded = isEnd
            state.allListLoaded = imageAllListLoaded && vClipAllListLoaded
        }
        
        @MainActor func update(state: inout State, searchText: String, count: Int, items: [SearchApi.VClipDocument], isEnd: Bool) {
            if isEnd, items.isEmpty {
                DLog.log("fetch vclip max")
                vClipAllListLoaded = true
                state.allListLoaded = imageAllListLoaded && vClipAllListLoaded
                return
            }
            let results = items.compactMap { SearchedResultInfo.fromResponeDTO($0) }
            let allResults = (searchedVClipResults[searchText] ?? []) + (searchedImageResults[searchText] ?? []) + results
            searchedVClipResults[searchText] = (searchedVClipResults[searchText] ?? []) + results
            if let page = searchedVClipPage[searchText] {
                searchedVClipPage[searchText] = page + 1
            } else {
                searchedVClipPage[searchText] = 1
            }
            state.results = allResults.sorted { $0.datetime > $1.datetime }
            vClipAllListLoaded = isEnd
            state.allListLoaded = imageAllListLoaded && vClipAllListLoaded
        }
        
        @MainActor func clear(state: inout State) {
            state.results = []
            state.allListLoaded = false
            imageAllListLoaded = false
            vClipAllListLoaded = false
        }
        
        @MainActor func clear(state: inout State, keyword: String) {
            searchedImageResults[keyword] = nil
            searchedVClipResults[keyword] = nil
            searchedImagePage[keyword] = nil
            searchedVClipPage[keyword] = nil
        }
        
        // MARK: - bookmark
        
        @MainActor func applyBookmark(state: inout State) async {
            let bookmarks = await bookmarkStorage.loadSavedBookmarks()
            let withBookmarks = state.results.map { bookmark in
                var newBookmark = bookmark
                if bookmarks.first(where: { $0.thumbnail == bookmark.thumbnail }) != nil {
                    newBookmark.isBookmarked = true
                }
                return newBookmark
            }
            state.results = withBookmarks
        }
    }
    
    struct Action {
        let search = PassthroughSubject<String, Never>()
    }
    
    @Published var state: State
    let action: Action
    let reactor: Reactor
    
    // MARK: - Public
    
    let searchbarViewModel: SearchBarViewModel
    let searchGridViewModel: SearchGridViewModel
    
    // MARK: - Private
    
    private let searchApi: SearchApiType
    private var cancellableSet: Set<AnyCancellable> = []
    
    init(
        searchbarViewModel: SearchBarViewModel = SearchBarViewModel(),
        searchGridViewModel: SearchGridViewModel = SearchGridViewModel(),
        searchApi: SearchApiType = SearchApi.shared,
        bookmarkStorage: BookmarkStorageType = BookmarkStorage.shared
    ) {
        self.searchbarViewModel = searchbarViewModel
        self.searchGridViewModel = searchGridViewModel
        self.searchApi = searchApi
        self.state = State()
        self.action = Action()
        self.reactor = Reactor()
        
        bind()
    }
    
    deinit {
        DLog.log(#function)
    }
}

extension SearchSheetViewModel {
    private func bind() {
        action.search
            .merge(with: searchbarViewModel.searchButtonPressed
                .flatMap { [weak self] keyword in
                    Future<String, Never> { [weak self] promise in
                        Task { @MainActor [weak self] in
                            guard let self else {
                                return promise(.success(keyword))
                            }
                            reactor.clear(state: &state)
                            reactor.clear(state: &state, keyword: keyword)
                            return promise(.success(keyword))
                        }
                    }
                }
                .delay(for: 0.5, scheduler: DispatchQueue.global(qos: .userInitiated))
                .eraseToAnyPublisher()
            )
            .merge(with: searchGridViewModel.action.loadMoreSearchedList)
            .filter { !$0.isEmpty }
            .flatMap { searchText in
                Future<(SearchApi.ImageResponseDTO, String), Never> { [weak self] promise in
                    guard let self else {
                        return promise(.success((SearchApi.ImageResponseDTO.emptyResponse(), searchText)))
                    }
                    return requstSearchImage(query: searchText)
                        .replaceError(with: SearchApi.ImageResponseDTO.emptyResponse())
                        .map {
                            ($0, searchText)
                        }
                        .sink { result in
                            promise(.success(result))
                        }
                        .store(in: &cancellableSet)
                }
            }
            .flatMap { result in
                Future<(SearchApi.ImageResponseDTO, SearchApi.VClipResponseDTO, String), Never> { [weak self] promise in
                    let imageResponse = result.0
                    let searchText = result.1
                    guard let self else {
                        return promise(.success((imageResponse, SearchApi.VClipResponseDTO.emptyResponse(), searchText)))
                    }
                    return requstSearchVClip(query: searchText)
                        .replaceError(with: SearchApi.VClipResponseDTO.emptyResponse())
                        .map {
                            (imageResponse, $0, searchText)
                        }
                        .sink { result in
                            promise(.success(result))
                        }
                        .store(in: &cancellableSet)
                }
            }
            .receive(on: DispatchQueue.main)
            .sink { [weak self] result in
                let responseImage = result.0
                let responseVClip = result.1
                let searchText = result.2
                Task { @MainActor [weak self] in
                    guard let self else { return }
                    reactor.update(
                        state: &state,
                        searchText: searchText,
                        count: responseImage.documents.count,
                        items: responseImage.documents,
                        isEnd: responseImage.meta.isEnd
                    )
                    reactor.update(
                        state: &state,
                        searchText: searchText,
                        count: responseVClip.documents.count,
                        items: responseVClip.documents,
                        isEnd: responseVClip.meta.isEnd
                    )
                    await reactor.applyBookmark(state: &state)
                    searchGridViewModel.action.setResults.send(state.results)
                    searchGridViewModel.action.setAllListLoaded.send(state.allListLoaded)
                }
            }
            .store(in: &cancellableSet)
        
        searchbarViewModel.clearButtonPressed
            .sink { [weak self] in
                Task { @MainActor [weak self] in
                    guard let self else { return }
                    reactor.clear(state: &state)
                }
            }
            .store(in: &cancellableSet)
    }
    
    private func requstSearchImage(query: String) -> AnyPublisher<SearchApi.ImageResponseDTO, Error> {
        Deferred {
            Future<SearchApi.ImageResponseDTO, Error> { promise in
                Task { [weak self] in
                    guard let self else {
                        promise(.failure(ApplicaionError.nilSelf))
                        return
                    }
                    do {
                        let page = await reactor.imagePage(state: state, searchText: query)
                        let searched = try await searchApi.searchImage(query: query, page: page)
                        DLog.log("fetch Image page = \(page), count = \(searched.documents.count)")
                        promise(.success(searched))
                    } catch {
                        DLog.log("error = \(error)")
                        promise(.failure(error))
                    }
                }
            }
        }
        .eraseToAnyPublisher()
    }
    
    private func requstSearchVClip(query: String) -> AnyPublisher<SearchApi.VClipResponseDTO, Error> {
        Deferred {
            Future<SearchApi.VClipResponseDTO, Error> { promise in
                Task { [weak self] in
                    guard let self else {
                        promise(.failure(ApplicaionError.nilSelf))
                        return
                    }
                    do {
                        let page = await reactor.vClipPage(state: state, searchText: query)
                        let searched = try await searchApi.searchVClip(query: query, page: page)
                        DLog.log("fetch VClip page = \(page), count = \(searched.documents.count)")
                        promise(.success(searched))
                    } catch {
                        DLog.log("error = \(error)")
                        promise(.failure(error))
                    }
                }
            }
        }
        .eraseToAnyPublisher()
    }
}

private extension SearchApi.ImageResponseDTO {
    static func emptyResponse() -> Self {
        SearchApi.ImageResponseDTO(meta: .init(totalCount: 0, pageableCount: 0, isEnd: true), documents: [])
    }
}

private extension SearchApi.VClipResponseDTO {
    static func emptyResponse() -> Self {
        SearchApi.VClipResponseDTO(meta: .init(totalCount: 0, pageableCount: 0, isEnd: true), documents: [])
    }
}
