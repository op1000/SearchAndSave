//
//  LoadingFooterView.swift
//  App
//
//  Created by NakCheon Jung on 5/18/25.
//

import UIKit
import SnapKit

class LoadingFooterView: UICollectionReusableView {
    static let identifier = "LoadingFooterView"
    private let activityIndicator = UIActivityIndicatorView(style: .medium)
    
    // MARK: - life cycle
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        addSubview(activityIndicator)
        activityIndicator.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
        activityIndicator.startAnimating()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
