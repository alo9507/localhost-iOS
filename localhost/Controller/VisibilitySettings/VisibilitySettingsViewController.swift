//
//  VisibilitySettingsViewController.swift
//  Contact
//
//  Created by Andrew O'Brien on 9/14/19.
//  Copyright © 2019 Andrew O'Brien. All rights reserved.
//

import UIKit
import Foundation
import SnapKit
import RangeSeekSlider

class VisibilitySettingsViewController: NiblessViewController {
    lazy var explanatoryLabel: UILabel = {
        let explanatoryLabel = UILabel(frame: .zero)
        explanatoryLabel.text = "You are visible EXCLUSIVELY to people who are visible to you!"
        explanatoryLabel.numberOfLines = 2
        explanatoryLabel.sizeToFit()
        explanatoryLabel.textAlignment = .center
        explanatoryLabel.textColor = .white
        explanatoryLabel.font = Fonts.avenirNext_regular(20)
        explanatoryLabel.font = UIFont(name: "AvenirNext-Regular", size: 18.0)
        return explanatoryLabel
    }()
    
    lazy var testLocationControlLabel: UILabel = {
        let testLocationControlLabel = UILabel()
        testLocationControlLabel.text = "In this beta tester setting"
        testLocationControlLabel.numberOfLines = 0
        testLocationControlLabel.sizeToFit()
        testLocationControlLabel.textColor = .white
        testLocationControlLabel.font = Fonts.avenirNext_regular(20)
        testLocationControlLabel.font = UIFont(name: "AvenirNext-Bold", size: 20.0)
        return testLocationControlLabel
    }()
    
    lazy var testLocationControl: UISegmentedControl = {
        let testLocationControl = UISegmentedControl(frame: .zero)
        testLocationControl.insertSegment(withTitle: "Tech Networking Event", at: 0, animated: true)
        testLocationControl.insertSegment(withTitle: "Eclectic Cafe", at: 1, animated: true)
        
        testLocationControl.setTitleTextAttributes([
            // foregroundColor sets text color
            NSAttributedString.Key.foregroundColor: UIColor.white,
            NSAttributedString.Key.font: UIFont(name: "AvenirNext-Bold", size: 15.0)!
        ], for: .normal)
        
        testLocationControl.setTitleTextAttributes([
            NSAttributedString.Key.foregroundColor: UIColor.white,
            NSAttributedString.Key.font: UIFont(name: "AvenirNext-Bold", size: 15.0)!
        ], for: .selected)
        
        if #available(iOS 13.0, *) {
            testLocationControl.selectedSegmentTintColor = UIColor.init(hexString: "#9917C4", withAlpha: 0.7)
        } else {
            testLocationControl.tintColor = UIColor.init(hexString: "#9917C4", withAlpha: 0.7)
        }
        
        testLocationControl.addTarget(viewModel, action: #selector(VisibilitySettingsViewModel.testUserLocationSet(sender:)), for: .valueChanged)
        
        var selectedIndex = 0
        switch userSession.user.visibilitySettings.testSetting {
        case .techEvent:
            selectedIndex = 0
        case .eclecticCafe:
            selectedIndex = 1
        }
        
        testLocationControl.selectedSegmentIndex = selectedIndex
        
        return testLocationControl
    }()
    
    lazy var sexControlLabel: UILabel = {
        let sexControlLabel = UILabel(frame: .zero)
        sexControlLabel.text = "Show me"
        sexControlLabel.numberOfLines = 0
        sexControlLabel.sizeToFit()
        sexControlLabel.textColor = .white
        sexControlLabel.font = Fonts.avenirNext_regular(20)
        return sexControlLabel
    }()
    
    lazy var sexControl: UISegmentedControl = {
        let sexControl = UISegmentedControl(frame: .zero)
        sexControl.insertSegment(withTitle: "Everyone", at: 0, animated: true)
        sexControl.insertSegment(withTitle: "Women", at: 1, animated: true)
        sexControl.insertSegment(withTitle: "Men", at: 2, animated: true)
        
        sexControl.setTitleTextAttributes([
            NSAttributedString.Key.foregroundColor: UIColor.white,
            NSAttributedString.Key.font: UIFont(name: "AvenirNext-Bold", size: 15.0)!
        ], for: .normal)
        
        sexControl.setTitleTextAttributes([
            NSAttributedString.Key.foregroundColor: UIColor.white,
            NSAttributedString.Key.font: UIFont(name: "AvenirNext-Bold", size: 15.0)!
        ], for: .selected)
        
        if #available(iOS 13.0, *) {
            sexControl.selectedSegmentTintColor = UIColor.init(hexString: "#9917C4", withAlpha: 0.7)
        } else {
            sexControl.tintColor = UIColor.init(hexString: "#9917C4", withAlpha: 0.7)
        }
        
        sexControl.addTarget(viewModel, action: #selector(VisibilitySettingsViewModel.sexControlSet(sender:)), for: .valueChanged)
        
        var selectedIndex = 0
        switch userSession.user.visibilitySettings.sex {
        case .all:
            selectedIndex = 0
        case .female:
            selectedIndex = 1
        case .male:
            selectedIndex = 2
        case .unknown:
            selectedIndex = 0
        }
        
        sexControl.selectedSegmentIndex = selectedIndex
        return sexControl
    }()
    
    lazy var ageRangeLabel: UILabel = {
        let ageRangeLabel = UILabel(frame: .zero)
        ageRangeLabel.text = "Between the ages of"
        ageRangeLabel.numberOfLines = 0
        ageRangeLabel.sizeToFit()
        ageRangeLabel.textColor = .white
        ageRangeLabel.font = Fonts.avenirNext_regular(20)
        ageRangeLabel.font = UIFont(name: "AvenirNext-Bold", size: 20.0)
        return ageRangeLabel
    }()
    
    lazy var ranger: RangeSeekSlider = {
        let ranger = RangeSeekSlider()
        ranger.delegate = self.viewModel
        ranger.minDistance = 1
        ranger.selectedMaxValue = CGFloat(Float(userSession.user.visibilitySettings.upperAgeBound))
        ranger.selectedMinValue = CGFloat(Float(userSession.user.visibilitySettings.lowerAgeBound))
        ranger.tintColor = UIColor.white
        ranger.minValue = 18
        ranger.maxValue = 100
        ranger.colorBetweenHandles = UIColor.init(hexString: "#31CAFF")
        ranger.labelPadding = -63.0
        ranger.maxLabelFont = UIFont(name: "AvenirNext-Bold", size: 22.0)!
        ranger.minLabelFont = UIFont(name: "AvenirNext-Bold", size: 22.0)!
        ranger.lineHeight = 3.0
        ranger.handleBorderWidth = 1.0
        ranger.handleBorderColor = UIColor.init(hexString: "#31CAFF")
        ranger.handleDiameter = 22.0
        return ranger
    }()
    
    let viewModel: VisibilitySettingsViewModel
    
    var userSession: UserSession {
        return UserSessionStore.shared.userSession
    }
    
    init(viewModel: VisibilitySettingsViewModel) {
        self.viewModel = viewModel
        super.init()
        
        viewModel.delegate = self
        title = "Your Visibility"
        view.backgroundColor = UIColor.lhPurple
        render()
    }
    
    deinit {
        UserSessionStore.unsubscribe(viewModel)
    }

}

// MARK: RENDER
extension VisibilitySettingsViewController {
    func render() {
        constructHierarchy()
        activateConstraints()
        configureNavBar()
    }
}

// MARK: VIEW
extension VisibilitySettingsViewController {
    
    func configureNavBar() {
        let rightBarButtonItem = UIBarButtonItem(title: "Save", style: UIBarButtonItem.Style.plain, target: viewModel, action: #selector(VisibilitySettingsViewModel.updateVisibilitySettings))
        navigationItem.rightBarButtonItem = rightBarButtonItem
        
        navigationItem.rightBarButtonItem?.setTitleTextAttributes([
            NSAttributedString.Key.font: UIFont(name: "AvenirNext-Bold", size: 19.0)!,
            NSAttributedString.Key.foregroundColor: UIColor.white
        ], for: .normal)
        navigationItem.rightBarButtonItem?.setTitleTextAttributes([
            NSAttributedString.Key.font: UIFont(name: "AvenirNext-Bold", size: 19.0)!,
            NSAttributedString.Key.foregroundColor: UIColor.white
        ], for: .selected)
        
        let leftBarButtonItem = UIBarButtonItem(title: "Cancel", style: UIBarButtonItem.Style.plain, target: viewModel, action: #selector(VisibilitySettingsViewModel.cancel))
        navigationItem.leftBarButtonItem = leftBarButtonItem
        
        navigationItem.leftBarButtonItem?.setTitleTextAttributes([
            NSAttributedString.Key.font: UIFont(name: "AvenirNext-Regular", size: 19.0)!,
            NSAttributedString.Key.foregroundColor: UIColor.white
        ], for: .normal)
        navigationItem.leftBarButtonItem?.setTitleTextAttributes([
            NSAttributedString.Key.font: UIFont(name: "AvenirNext-Regular", size: 19.0)!,
            NSAttributedString.Key.foregroundColor: UIColor.white
        ], for: .selected)
    }
    
    func constructHierarchy() {
        view.addSubview(explanatoryLabel)
        view.addSubview(ranger)
        view.addSubview(testLocationControl)
        view.addSubview(sexControl)
        view.addSubview(sexControlLabel)
        view.addSubview(ageRangeLabel)
        view.addSubview(testLocationControlLabel)
    }
    
    func activateConstraints() {
        let betweenControls = 50
        let betweenLabelAndControl = 17
        
        explanatoryLabel.snp.makeConstraints { (make) in
            make.top.equalToSuperview().offset(100)
            make.centerX.equalToSuperview()
            make.width.equalTo(350)
        }
        
        sexControlLabel.snp.makeConstraints { (make) in
            make.top.equalTo(explanatoryLabel.snp.bottom).offset(20)
            make.left.equalToSuperview().offset(10)
            make.width.equalToSuperview()
            make.height.equalTo(40)
        }
        
        sexControl.snp.makeConstraints { (make) in
            make.top.equalTo(sexControlLabel.snp.bottom).offset(betweenLabelAndControl)
            make.centerX.equalToSuperview()
            make.width.equalToSuperview().inset(20)
            make.height.equalTo(40)
        }
        
        ageRangeLabel.snp.makeConstraints { (make) in
            make.top.equalTo(sexControl.snp.bottom).offset(betweenControls)
            make.left.equalToSuperview().offset(10)
            make.width.equalToSuperview()
            make.height.equalTo(40)
        }
        
        ranger.snp.makeConstraints { (make) in
            make.top.equalTo(ageRangeLabel.snp.bottom).offset(betweenLabelAndControl + 25)
            make.centerX.equalToSuperview()
            make.width.equalToSuperview().inset(10)
            make.height.equalTo(20)
        }
        
        testLocationControlLabel.snp.makeConstraints { (make) in
            make.top.equalTo(ranger.snp.bottom).offset(betweenControls)
            make.left.equalToSuperview().offset(10)
            make.width.equalToSuperview()
            make.height.equalTo(40)
        }
        
        testLocationControl.snp.makeConstraints { (make) in
            make.top.equalTo(testLocationControlLabel.snp.bottom).offset(betweenLabelAndControl)
            make.centerX.equalToSuperview()
            make.width.equalToSuperview().inset(20)
            make.height.equalTo(40)
        }
        
    }
}

extension VisibilitySettingsViewController: VisibilitySettingsViewModelDelegate {
    func userSession(_ userSession: UserSession) {
        // rerender
    }
    
    func dismissSelf() {
        self.dismiss(animated: true)
    }
}

