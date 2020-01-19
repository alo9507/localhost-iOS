//
//  MainViewController.swift
//  Contact
//
//  Created by Andrew O'Brien on 8/20/19.
//  Copyright © 2019 Andrew O'Brien. All rights reserved.
//

import UIKit

public class MainViewController: NiblessViewController {
    let viewModel: MainViewModel
    
    let backgroundImageView: UIImageView = {
        let backgroundImageView = UIImageView(frame: .zero)
        backgroundImageView.image = UIImage(named: "LocalhostAppIconRound")
        return backgroundImageView
    }()
    
    init(viewModel: MainViewModel) {
        self.viewModel = viewModel
        super.init()
        render()
    }
    
    public override func viewDidLoad() {
        view.backgroundColor = UIColor.lhPurple
    }
    
    public override func viewDidAppear(_ animated: Bool) {
        viewModel.checkForFirstLaunch()
        viewModel.loadUserSession()
    }
    
    func render() {
        view.addSubview(backgroundImageView)
        backgroundImageView.snp.makeConstraints { (make) in
            make.width.height.equalTo(0)
        }
    }
}
