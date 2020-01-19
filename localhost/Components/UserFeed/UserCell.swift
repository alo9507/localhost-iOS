//
//  UserCell.swift
//  spotifyAutoLayout
//
//  Created by admin on 12/3/19.
//  Copyright © 2019 Said Hayani. All rights reserved.
//

import UIKit
import SnapKit

class UserCell: UICollectionViewCell {
    
    var user: User? {
        didSet{
            guard let user = self.user else {
                fatalError()
            }
            
            loadImage()
            self.titleLabel.text = user.firstName
            self.statusLabel.text = user.whatAmIDoing
            
            let indexIsValid = user.affiliations.indices.contains(0)
            
            if (indexIsValid) {
                self.occupationLabel.text = "\(user.affiliations[0].role) @ \(user.affiliations[0].organizationName)"
            }
        }
    }
    
    lazy var imageView: UIImageView = {
        let placeholderImage = UIImage(named: "noProfilePhoto")
        let placeholderImageView = UIImageView(image: UIImage(named: "noProfilePhoto"))
        return placeholderImageView
    }()
    
    let titleLabel : UILabel = {
        let lb = UILabel()
        lb.textColor = UIColor.lhTurquoise
        lb.font = Fonts.avenirNext_bold(20)
        return lb
    }()
    
    let statusLabel : UILabel = {
        let lb = UILabel()
        lb.textColor = UIColor.white
        lb.font = Fonts.avenirNext_demibold(15)
        return lb
    }()
    
    let occupationLabel: UILabel = {
        let lb = UILabel()
        lb.textColor = UIColor.white
        lb.numberOfLines = 0
        lb.sizeToFit()
        lb.font = Fonts.avenirNext_demibold(20)
        lb.textAlignment = .center
        return lb
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(imageView)
        addSubview(titleLabel)
        addSubview(statusLabel)
        addSubview(occupationLabel)
        
        imageView.snp.makeConstraints { (make) in
            make.top.equalToSuperview().offset(-100)
            make.left.equalToSuperview()
            make.right.equalToSuperview()
            make.height.equalTo(300)
            make.bottom.equalTo(titleLabel.snp.top).offset(-30)
        }
        
        titleLabel.snp.makeConstraints { (make) in
            make.top.equalTo(imageView.snp.bottom).offset(20)
            make.centerX.equalToSuperview()
        }
        
        statusLabel.snp.makeConstraints { (make) in
            make.top.equalTo(titleLabel.snp.bottom).offset(5)
            make.centerX.equalToSuperview()
        }
        
        occupationLabel.snp.makeConstraints { (make) in
            make.top.equalTo(statusLabel.snp.bottom).offset(5)
            make.centerX.equalToSuperview()
            make.width.equalToSuperview()
        }
    }
    
    func loadImage() {
        let profileImageView = UIImageView()
        profileImageView.layer.cornerRadius = profileImageView.bounds.height / 2
        
        guard let imageUrlString = user?.profileImageUrl else {
            print("Failed to get url")
            return
        }
        
        guard let imageUrl = URL(string: imageUrlString) else {
            print("Failed to cast url")
            return
        }
        
        profileImageView.sd_setImage(with: imageUrl) { (image, error, _, _) in
            DispatchQueue.main.async {
                self.imageView.image = profileImageView.image
                self.imageView.roundCorners()
                self.imageView.setNeedsDisplay()
            }
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
