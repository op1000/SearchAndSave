//
//  SearchGridCardUIKitCell.swift
//  App
//
//  Created by NakCheon Jung on 5/18/25.
//

import UIKit
import SnapKit
import domainKit
import EnvironmentKit
import RepositoryKit

class SearchGridCardUIKitCell: UICollectionViewCell {
    static let identifier = "SearchGridCardUIKitCell"
    
    private let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private let dateLabel: UILabel = {
        let dateLabel = UILabel()
        dateLabel.font = UIFont.preferredFont(forTextStyle: .caption1)
        dateLabel.textColor = .white
        dateLabel.clipsToBounds = true
        return dateLabel
    }()
    
    private let descriptionLabel: UILabel = {
        let descriptionLabel = UILabel()
        descriptionLabel.font = UIFont.preferredFont(forTextStyle: .caption1)
        descriptionLabel.textColor = .white
        descriptionLabel.clipsToBounds = true
        return descriptionLabel
    }()
    
    private let bookmarkButton: UIButton = {
        let bookmarkButton = UIButton()
        return bookmarkButton
    }()
    
    private var imageLoadingTask: Task<Void, Never>?
    private var indexPath: IndexPath?
    private var info: SearchedResultInfo?
    weak var viewModel: SearchGridViewModel?
    
    // MARK: - life cycle
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        initializeUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - overrides

extension SearchGridCardUIKitCell {
    override func prepareForReuse() {
        super.prepareForReuse()
        imageLoadingTask?.cancel()
        imageLoadingTask = nil
        imageView.image = nil
    }
}

// MARK: - public

extension SearchGridCardUIKitCell {
    func configure(info: SearchedResultInfo, at indexPath: IndexPath, viewModel: SearchGridViewModel) {
        guard let url = URL(string: info.thumbnail) else { return }
        self.indexPath = indexPath
        self.info = info
        self.viewModel = viewModel
        
        do {
            let isBookmarked = viewModel.containsBookmark(info: info)
            let symbol = isBookmarked ? "bookmark.fill" : "bookmark"
            bookmarkButton.setImage(UIImage(systemName: symbol)?.withTintColor(.blue), for: .normal)
        }
        
        do {
            dateLabel.text = info.dateString
            if info.playTime != nil {
                descriptionLabel.text = info.formatPlayTime
            } else {
                descriptionLabel.text = I18n.image
            }
        }
        
        do {
            imageLoadingTask?.cancel()
            imageLoadingTask = Task { [weak self] in
                guard let self else { return }
                do {
                    let image = try await CachedImageStorage.cachedImage(for: url)
                    if let image, info.thumbnailImageSize == nil {
                        viewModel.action.setImageSize.send((info, image.size, indexPath.row))
                    }
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) { [weak self] in
                        guard let self else { return }
                        guard !Task.isCancelled, self.indexPath == indexPath else { return }
                        imageView.image = image
                    }
                } catch {
                    DLog.log("\(error)")
                }
            }
        }
    }
}

// MARK: - private

extension SearchGridCardUIKitCell {
    private func initializeUI() {
        do {
            contentView.backgroundColor = .gray.withAlphaComponent(0.5)
            contentView.layer.cornerRadius = 16
            contentView.clipsToBounds = true
        }
        do {
            contentView.addSubview(imageView)
            imageView.snp.makeConstraints { make in
                make.edges.equalToSuperview()
            }
        }
        do {
            contentView.addSubview(bookmarkButton)
            bookmarkButton.addTarget(self, action: #selector(bookmarkTapped), for: .touchUpInside)
            bookmarkButton.snp.makeConstraints { make in
                make.trailing.equalTo(-8)
                make.top.equalTo(8)
                make.width.equalTo(24)
                make.height.equalTo(24)
            }
        }
        let descContainerView = UIView()
        do {
            descContainerView.backgroundColor = UIColor.black.withAlphaComponent(0.8)
            contentView.addSubview(descContainerView)
            descContainerView.snp.makeConstraints { make in
                make.leading.equalTo(8)
                make.bottom.equalTo(-8)
            }
            
            descContainerView.addSubview(descriptionLabel)
            descriptionLabel.snp.makeConstraints { make in
                make.leading.equalToSuperview().offset(3)
                make.top.equalToSuperview().offset(3)
                make.trailing.equalToSuperview().offset(-3)
                make.bottom.equalToSuperview().offset(-3)
            }
        }
        do {
            let dateContainerView = UIView()
            dateContainerView.backgroundColor = UIColor.black.withAlphaComponent(0.8)
            contentView.addSubview(dateContainerView)
            dateContainerView.snp.makeConstraints { make in
                make.leading.equalTo(8)
                make.bottom.equalTo(descContainerView.snp.top)
            }
            
            dateContainerView.addSubview(dateLabel)
            dateLabel.snp.makeConstraints { make in
                make.leading.equalToSuperview().offset(3)
                make.top.equalToSuperview().offset(3)
                make.trailing.equalToSuperview().offset(-3)
                make.bottom.equalToSuperview().offset(-3)
            }
        }
    }
    
    @objc private func bookmarkTapped() {
        guard let info, let viewModel else { return }
        if viewModel.containsBookmark(info: info) {
            viewModel.action.removeFromBookmark.send(info)
        } else {
            viewModel.action.bookmark.send(info)
        }
    }
}
