//
//  UserCategoryCell.swift
//  spotifyAutoLayout
//
//  Created by admin on 10/31/19.
//  Copyright © 2019 Said Hayani. All rights reserved.
//

import UIKit
import SnapKit

class UserCategoryCell: UICollectionViewCell ,UICollectionViewDelegateFlowLayout {
    
    let cellId : String = "userCategoryCell"
    
    var users = [User]()
    
    var showProfileDetail: (() -> Void)?
    
    var viewModel: SpotFeedViewModel?
    
    var userCategory : UserCategory? {
        didSet{
            guard let userCategory = self.userCategory else {return}
            self.userCategoryLabel.text = userCategory.title
            
            self.userCategory?.users.forEach({ (user) in
                self.users.append(user)
            })
            
            self.userCarousel.reloadData()
        }
    }
    
    let userCarousel : UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.backgroundColor = UIColor.lhPurple
        cv.translatesAutoresizingMaskIntoConstraints = false
        cv.showsHorizontalScrollIndicator = false
        return cv
        
    }()
    
    let userCategoryLabel: UILabel = {
        let userCategoryLabel = UILabel()
        userCategoryLabel.text = "Section Title"
        userCategoryLabel.textColor = .white
        userCategoryLabel.font = Fonts.avenirNext_bold(32)
        return userCategoryLabel
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(userCategoryLabel)
        
        userCategoryLabel.snp.makeConstraints { (make) in
            make.top.equalToSuperview().offset(8)
            make.left.equalToSuperview().offset(8)
        }

        setupUserCarousel()
        userCarousel.register(UserCell.self, forCellWithReuseIdentifier: cellId)
    }
    
    fileprivate  func setupUserCarousel() {
        addSubview(userCarousel)
        
        userCarousel.dataSource = self
        userCarousel.delegate = self
        
        userCarousel.snp.makeConstraints { (make) in
            make.top.equalTo(userCategoryLabel.snp.bottom)
            make.left.equalToSuperview()
            make.bottom.equalToSuperview()
            make.right.equalToSuperview()
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension UserCategoryCell: UICollectionViewDataSource, UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return  self.users.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! UserCell
        cell.user = users[indexPath.item]
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 50.0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = frame.height / 2
        let height = frame.height / 2
        
        return CGSize(width: width, height: height)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let cell = collectionView.cellForItem(at: indexPath) as! UserCell
        self.viewModel!.sendToProfileDetail(user: cell.user!)
    }
}
