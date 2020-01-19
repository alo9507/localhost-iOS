//
//  FirebaseMatchesDataSource.swift
//  DatingApp
//
//  Created by Florian Marcu on 3/31/19.
//  Copyright © 2019 Instamobile. All rights reserved.
//

import Firebase
import UIKit

class FirebaseMatchesDataSource: MatchesDataSource {
    var viewer: User? = nil
    weak var delegate: GenericCollectionViewControllerDataSourceDelegate?
    var matches: [User] = []

    let socialGraphRepository: SocialGraphRepository
    
    init(socialGraphRepository: SocialGraphRepository) {
        self.socialGraphRepository = socialGraphRepository
    }
    
    func object(at index: Int) -> GenericBaseModel? {
        if index < matches.count {
            return matches[index]
        }
        return nil
    }

    func numberOfObjects() -> Int {
        return matches.count
    }

    func loadFirst() {
        socialGraphRepository.fetchMatches(for: viewer!) { (matches, error) in
            if error != nil { return print(error!.localizedDescription) }
            guard let matches = matches else { return print(error!.localizedDescription) }
            
            self.matches = matches
            self.delegate?.genericCollectionViewControllerDataSource(self, didLoadFirst: matches)
        }
    }

    func loadBottom() {
        self.delegate?.genericCollectionViewControllerDataSource(self, didLoadBottom: [])
    }

    func loadTop() {
        self.delegate?.genericCollectionViewControllerDataSource(self, didLoadTop: [])
    }
}
