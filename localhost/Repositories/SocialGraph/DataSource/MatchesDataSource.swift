//
//  MatchesDataSource.swift
//  DatingApp
//
//  Created by Florian Marcu on 1/23/19.
//  Copyright © 2019 Instamobile. All rights reserved.
//

import UIKit

protocol MatchesDataSource: GenericCollectionViewControllerDataSource {
    var delegate: GenericCollectionViewControllerDataSourceDelegate? {get set}
    var viewer: User? {get set}
}
