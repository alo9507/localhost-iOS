//
//  CarouselAdapter.swift
//  RestaurantApp
//
//  Created by Florian Marcu on 4/25/18.
//  Copyright © 2018 iOS App Templates. All rights reserved.
//

import UIKit

class CarouselAdapter : GenericCollectionRowAdapter {
    let uiConfig: UIGenericConfigurationProtocol

    init(uiConfig: UIGenericConfigurationProtocol) {
        self.uiConfig = uiConfig
    }

    func configure(cell: UICollectionViewCell, with object: GenericBaseModel) {
        guard let viewModel = object as? CarouselViewModel, let cell = cell as? CarouselCollectionViewCell else { return }
        cell.configure(viewModel: viewModel, uiConfig: self.uiConfig)
    }

    func cellClass() -> UICollectionViewCell.Type {
        return CarouselCollectionViewCell.self
    }

    func size(containerBounds: CGRect, object: GenericBaseModel) -> CGSize {
        guard let viewModel = object as? CarouselViewModel else { return .zero }
        return CGSize(width: containerBounds.width, height: viewModel.cellHeight)
    }
}
