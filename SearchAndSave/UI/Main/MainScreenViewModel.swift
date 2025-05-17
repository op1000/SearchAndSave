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

class MainScreenViewModel: ObservableObject {
    // MARK: - SANE architecture
    
    struct State: Sendable {
        var results: [SearchedResultInfo] = []
        var redrawId = UUID()
    }
    
    actor Reactor {
    }
    
    struct Action {
        let onAppear = PassthroughSubject<Void, Never>()
    }
    
    @Published var state: State
    let action: Action
    let reactor: Reactor
    
    // MARK: - Private
    
    private var cancellableSet: Set<AnyCancellable> = []
    
    init() {
        self.state = State()
        self.action = Action()
        self.reactor = Reactor()
        
        bind()
    }
}

extension MainScreenViewModel {
    private func bind() {
        action.onAppear
            .sink { [weak self] in
                guard let self else { return }
                presentSearchBottomSheet()
            }
            .store(in: &cancellableSet)
    }
    
    private func presentSearchBottomSheet() {
        guard let topViewController = UIApplication.topViewController() else { return }
        let viewModel = SearchSheetViewModel()
        let view = SearchSheet(viewModel: viewModel)
        let viewController = SearchSheetViewController(rootView: view)
        viewController.isModalInPresentation = true
        
        if let sheet = viewController.sheetPresentationController {
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
        topViewController.present(viewController, animated: true)
    }
}
