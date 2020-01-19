//
//  GenericLocalHeteroDataSource.swift
//  RestaurantApp
//
//  Created by Florian Marcu on 5/19/18.
//  Copyright © 2018 iOS App Templates. All rights reserved.
//

import UIKit

class GenericLocalHeteroDataSource: GenericCollectionViewControllerDataSource {
    weak var delegate: GenericCollectionViewControllerDataSourceDelegate?

    let items: [GenericBaseModel]

    init(items: [GenericBaseModel]) {
        self.items = items
    }

    func object(at index: Int) -> GenericBaseModel? {
        if index < items.count {
            return items[index]
        }
        return nil
    }

    func numberOfObjects() -> Int {
        return items.count
    }

    func loadFirst() {
        self.delegate?.genericCollectionViewControllerDataSource(self, didLoadFirst: items)
    }

    func loadBottom() {
    }

    func loadTop() {
    }
}
