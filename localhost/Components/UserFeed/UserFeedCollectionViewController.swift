//
//  ViewController.swift
//  spotifyAutoLayout
//
//  Created by admin on 10/31/19.
//  Copyright © 2019 Said Hayani. All rights reserved.
//

import UIKit

class UserFeedCollectionViewController: UICollectionViewController {
    
    let cellId : String = "userFeedCell"

    var viewModel: SpotFeedViewModel?
    
    init() {
        super.init(collectionViewLayout: UICollectionViewFlowLayout())
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.backgroundColor = UIColor.lhPurple
        collectionView.showsVerticalScrollIndicator = false
        collectionView.register(UserCategoryCell.self, forCellWithReuseIdentifier: cellId)
    }
 
    var userCategories = [UserCategory]() {
        didSet {
            self.collectionView.reloadData()
        }
    }
}

extension UserFeedCollectionViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = view.frame.width
        let height = CGFloat(600)
        
        return CGSize(width: width, height: height)
    }

    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return userCategories.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! UserCategoryCell
        cell.userCategory = userCategories[indexPath.item]
        cell.viewModel = viewModel
        return cell
    }
}
