//
//  MainScreenViewModel.swift
//  SearchAndSave
//
//  Created by nakcheon.jung on 5/15/25.
//

import Foundation
import Combine
import UIKit
import SwiftUI
import domainKit
import RepositoryKit

class MainScreenViewModel: ObservableObject {
    // MARK: - SANE architecture
    
    struct State: Sendable {
        var results: [SearchedResultInfo] = []
        var redrawId = UUID()
    }
    
    actor Reactor {
        private let bookmarkStorage: BookmarkStorageType
        
        init(bookmarkStorage: BookmarkStorageType = BookmarkStorage.shared) {
            self.bookmarkStorage = bookmarkStorage
        }
        
        // MARK: - bookmark
        
        @MainActor func loadBookmarks(state: inout State) async {
            let bookmarks = await bookmarkStorage.loadSavedBookmarks()
            state.results = bookmarks.map {
                SearchedResultInfo(id: $0.id, thumbnail: $0.thumbnail, datetime: $0.datetime, playTime: $0.playTime, imageUrl: $0.imageUrl, isBookmarked: true)
            }
            state.redrawId = UUID()
        }
    }
    
    struct Action {
        let onAppear = PassthroughSubject<Void, Never>()
        let showSearchSheet = PassthroughSubject<Void, Never>()
    }
    
    @Published var state: State
    let action: Action
    let reactor: Reactor
    
    // MARK: - Private
    
    let searchGridViewModel: SearchGridViewModel
    private var cancellableSet: Set<AnyCancellable> = []
    
    init(
        searchGridViewModel: SearchGridViewModel = SearchGridViewModel(),
        bookmarkStorage: BookmarkStorageType = BookmarkStorage.shared
    ) {
        self.searchGridViewModel = searchGridViewModel
        self.state = State()
        self.action = Action()
        self.reactor = Reactor(bookmarkStorage: bookmarkStorage)
        
        bind()
    }
}

extension MainScreenViewModel {
    private func bind() {
        action.onAppear
            .delay(for: 0.5, scheduler: DispatchQueue.main)
            .sink { [weak self] in
                guard let self else { return }
                presentImplementationTypeBottomSheet()
            }
            .store(in: &cancellableSet)
        
        action.onAppear
            .merge(with: SearchEventBus.shared.bookmarkChanged)
            .sink { [weak self] in
                Task { @MainActor [weak self] in
                    guard let self else { return }
                    await reactor.loadBookmarks(state: &state)
                    searchGridViewModel.action.setResults.send(state.results)
                }
            }
            .store(in: &cancellableSet)
        
        action.showSearchSheet
            .sink { [weak self] in
                guard let self else { return }
                presentImplementationTypeBottomSheet()
            }
            .store(in: &cancellableSet)
    }
    
    private func presentSearchBottomSheet(type: SearchSheetViewModel.ImplementationType) {
        guard let topViewController = UIApplication.topViewController() else { return }
        let viewModel = SearchSheetViewModel(implementationType: type)
        let view = SearchSheet(viewModel: viewModel)
        let viewController = SearchSheetViewController(rootView: view)
        
        if let sheet = viewController.sheetPresentationController {
            if UIDevice.current.userInterfaceIdiom == .pad {
                sheet.detents = [
                    .large()
                ]
            } else {
                sheet.detents = [
                    .medium(),
                    .large(),
                    .custom { _ in
                        100
                    }
                ]
                sheet.prefersGrabberVisible = true
                sheet.largestUndimmedDetentIdentifier = .none
                sheet.prefersScrollingExpandsWhenScrolledToEdge = false
            }
        }
        topViewController.present(viewController, animated: true)
    }
    
    private func presentImplementationTypeBottomSheet() {
        guard let topViewController = UIApplication.topViewController() else { return }
        let actionSheet = UIAlertController(title: I18n.selectImplementationTypeForSearch, message: nil, preferredStyle: .actionSheet)
        
        actionSheet.addAction(UIAlertAction(title: "SwiftUI", style: .default) { [weak self] _ in
            guard let self else { return }
            presentSearchBottomSheet(type: .swiftui)
        })
        actionSheet.addAction(UIAlertAction(title: "UIKit", style: .default) { [weak self] _ in
            guard let self else { return }
            presentSearchBottomSheet(type: .uikit)
        })
        actionSheet.addAction(UIAlertAction(title: I18n.cancelButtonTitle, style: .cancel, handler: nil))
        
        if let popoverController = actionSheet.popoverPresentationController {
            // to prevent ipad crash
            popoverController.sourceView = topViewController.view
            popoverController.sourceRect = CGRect(x: topViewController.view.bounds.midX, y: topViewController.view.bounds.midY, width: 0, height: 0)
            popoverController.permittedArrowDirections = []
        }
        
        topViewController.present(actionSheet, animated: true, completion: nil)
    }
}
