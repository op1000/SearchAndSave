//
//  SearchGridUIKitViewController.swift
//  App
//
//  Created by NakCheon Jung on 5/18/25.
//

import UIKit
import SnapKit
import Combine
import domainKit
import SwiftUI
import EnvironmentKit

struct SearchGridUIKitView: UIViewControllerRepresentable {
    let viewModel: SearchGridViewModel
    let searchKeyworkd: String
    
    func makeUIViewController(context: UIViewControllerRepresentableContext<Self>) -> SearchGridUIKitViewController {
        return SearchGridUIKitViewController(searchKeyworkd: searchKeyworkd, viewModel: viewModel)
    }
    
    func updateUIViewController(_ uiViewController: SearchGridUIKitViewController, context: Context) {}
}

class SearchGridUIKitViewController: UIViewController {
    let searchKeyworkd: String
    private let collectionView: UICollectionView
    private var collectionViewLayout: SearchGridUIKitLayout
    private let viewModel: SearchGridViewModel
    private var list: [SearchedResultInfo] = []
    private var cancellableSet: Set<AnyCancellable> = []
    private var shouldLoadMore = false
    
    // MARK: - life cycle
    
    init(
        searchKeyworkd: String,
        viewModel: SearchGridViewModel = SearchGridViewModel(),
        collectionViewLayout: SearchGridUIKitLayout = SearchGridUIKitLayout()
    ) {
        self.searchKeyworkd = searchKeyworkd
        self.collectionViewLayout = collectionViewLayout
        self.collectionView = UICollectionView(frame: .zero, collectionViewLayout: collectionViewLayout)
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: .module)
        
        bind()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - UIViewController life cycle

extension SearchGridUIKitViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        setupCollectionView()
    }
}

// MARK: - private

extension SearchGridUIKitViewController {
    private func bind() {
        viewModel.action.listChanged
            .sink { [weak self] list in
                guard let self else { return }
                setupCollectionViewLayout()
                self.list = list
                collectionView.reloadData()
            }
            .store(in: &cancellableSet)
        
        viewModel.action.indexChanged
            .sink { [weak self] index in
                guard let self else { return }
                setupCollectionViewLayout()
                list = viewModel.state.results
                collectionView.reloadItems(at: [IndexPath(row: index, section: 0)])
            }
            .store(in: &cancellableSet)
    }
    
    private func setupCollectionView() {
        collectionViewLayout.delegate = self
        collectionView.selfSizingInvalidation = .enabledIncludingConstraints
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.register(SearchGridCardUIKitCell.self, forCellWithReuseIdentifier: SearchGridCardUIKitCell.identifier)
        collectionView.register(LoadingFooterView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionFooter, withReuseIdentifier: LoadingFooterView.identifier)
        view.addSubview(collectionView)
        collectionView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    private func setupCollectionViewLayout() {
        collectionViewLayout = SearchGridUIKitLayout()
        collectionViewLayout.delegate = self
        collectionView.collectionViewLayout = collectionViewLayout
    }
}


// MARK: - SearchGridUIKitLayoutDelegate

extension SearchGridUIKitViewController: SearchGridUIKitLayoutDelegate {
    func collectionView(_ collectionView: UICollectionView, heightForItemAt indexPath: IndexPath, with width: CGFloat) -> CGFloat {
        guard let info = viewModel.state.results[safe: indexPath.row], let size = info.thumbnailImageSize else {
            return 100
        }
        if size.height < size.width {
            let aspectRatio = size.height / size.width
            let height = width * aspectRatio
            return height
        } else {
            let aspectRatio = size.width / size.height
            let height = width * aspectRatio
            return height
        }
    }
}

// MARK: - UICollectionViewDataSource

extension SearchGridUIKitViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return list.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let info = list[safe: indexPath.item] else {
            return UICollectionViewCell()
        }
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: SearchGridCardUIKitCell.identifier, for: indexPath) as? SearchGridCardUIKitCell else {
            return UICollectionViewCell()
        }
        cell.configure(info: info, at: indexPath, viewModel: viewModel)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        guard kind == UICollectionView.elementKindSectionFooter, let footer = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: LoadingFooterView.identifier, for: indexPath) as? LoadingFooterView else {
            return UICollectionReusableView()
        }
        return footer
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForFooterInSection section: Int) -> CGSize {
        return viewModel.state.allListLoaded ? .zero : CGSize(width: collectionView.bounds.width, height: 50)
    }
}

// MARK: - UICollectionViewDelegate

extension SearchGridUIKitViewController: UICollectionViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let offsetY = scrollView.contentOffset.y
        let contentHeight = scrollView.contentSize.height
        let height = scrollView.frame.size.height
        if offsetY + height > contentHeight {
            shouldLoadMore = true
        }
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        if shouldLoadMore {
            shouldLoadMore = false
            viewModel.action.loadMoreSearchedList.send(searchKeyworkd)
        }
    }
}
