//
//  DatingChatUserStoryAdapter.swift
//  DatingApp
//
//  Created by Florian Marcu on 1/26/19.
//  Copyright © 2019 Instamobile. All rights reserved.
//

import UIKit

class NewMatchAdapter: GenericCollectionRowAdapter {
    let uiConfig: UIGenericConfigurationProtocol

    init(uiConfig: UIGenericConfigurationProtocol) {
        self.uiConfig = uiConfig
    }

    func configure(cell: UICollectionViewCell, with object: GenericBaseModel) {
        guard let viewModel = object as? User, let cell = cell as? UserStoryCollectionViewCell else { return }
        
        let url = viewModel.profileImageUrl
        cell.storyImageView.kf.setImage(with: URL(string: url))
        
        cell.storyImageView.contentMode = .scaleAspectFill
        cell.storyImageView.clipsToBounds = true
        cell.storyImageView.layer.cornerRadius = 65.0/2.0

        cell.storyTitleLabel.text = viewModel.firstWordFromName()
        cell.storyTitleLabel.font = uiConfig.boldFont(size: 14)
        cell.storyTitleLabel.textColor = uiConfig.mainTextColor

        cell.onlineStatusView.isHidden = viewModel.isOnline
        cell.onlineStatusView.layer.cornerRadius = 15.0/2.0
        cell.onlineStatusView.layer.borderColor = UIColor.white.cgColor
        cell.onlineStatusView.layer.borderWidth = 3
        cell.onlineStatusView.backgroundColor = uiConfig.mainThemeForegroundColor

        cell.containerView.backgroundColor = uiConfig.mainThemeBackgroundColor
        cell.imageContainerView.backgroundColor = uiConfig.mainThemeBackgroundColor

        cell.setNeedsLayout()
    }

    func cellClass() -> UICollectionViewCell.Type {
        return UserStoryCollectionViewCell.self
    }

    func size(containerBounds: CGRect, object: GenericBaseModel) -> CGSize {
        guard object is User else { return .zero }
        return CGSize(width: 95, height: 105)
    }
}
