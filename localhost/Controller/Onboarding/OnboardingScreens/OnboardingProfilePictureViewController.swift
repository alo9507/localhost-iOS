//
//  OnboardingProfilePictureViewController.swift
//  Contact
//
//  Created by Andrew O'Brien on 12/13/19.
//  Copyright © 2019 Andrew O'Brien. All rights reserved.
//

import UIKit
import PopBounceButton

class OnboardingProfilePictureViewController: OnboardingViewController {
    lazy var selectProfileImageView: UIImageView = {
        let selectProfileImageView = UIImageView()
        selectProfileImageView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleSelectProfileImageView)))
        selectProfileImageView.isUserInteractionEnabled = true
        selectProfileImageView.image = UIImage(named: "noProfilePhoto")
        selectProfileImageView.frame = CGRect(x: 0, y: 0, width: 150, height: 150)
        selectProfileImageView.layoutSubviews()
        return selectProfileImageView
    }()
    
    var joinButton: UIButton = {
        let frame = CGRect(origin: .zero, size: CGSize(width: 500, height: 100))
        let joinButton = PopBounceButton(frame: frame)
        
        joinButton.backgroundColor = .blue
        joinButton.titleLabel?.textColor = .white
        joinButton.layer.borderWidth = 1
        joinButton.layer.borderColor = UIColor.init(hexString: "#FFFFFF", withAlpha: 0.5)?.cgColor
        joinButton.layer.cornerRadius = 9
        joinButton.setTitle("Start Hosting!", for: .normal)
        joinButton.sizeToFit()
        
        joinButton.addTarget(self, action: #selector(finishRegistration), for: .touchUpInside)
        return joinButton
    }()
    
    lazy var beautifulLabel: OnboardingTitleLabel = {
        let beautifulLabel = OnboardingTitleLabel()
        beautifulLabel.text = "beautiful!"
        beautifulLabel.sizeToFit()
        beautifulLabel.alpha = 0
        beautifulLabel.textAlignment = .center
        return beautifulLabel
    }()
    
    lazy var startHosting: UIButton = {
        let startHosting = UIButton()
        
        let attributedTitle = NSAttributedString(string: "start hosting", attributes: [
            NSAttributedString.Key.foregroundColor : UIColor.lhPink,
            NSAttributedString.Key.font: Fonts.avenirNext_bold(28)
        ])
        
        startHosting.setAttributedTitle(attributedTitle, for: .normal)
        startHosting.layer.cornerRadius = 30
        startHosting.contentEdgeInsets = UIEdgeInsets(top: 8, left: 8, bottom: 8, right: 8)
        
        startHosting.backgroundColor = UIColor.lhTurquoise
        
        startHosting.addTarget(self, action: #selector(finishRegistration), for: .touchUpInside)
        return startHosting
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }
}

// MARK: UI Setup
extension OnboardingProfilePictureViewController {
    func setupView() {
        constructHierarchy()
        activateConstraints()
    }
    
    func constructHierarchy(){
        inputContainer.addSubview(selectProfileImageView)
        inputContainer.addSubview(beautifulLabel)
        view.addSubview(startHosting)
    }
    
    func activateConstraints() {
        selectProfileImageView.snp.makeConstraints { (make) in
            make.top.equalToSuperview()
            make.centerX.equalToSuperview()
            make.width.equalTo(150)
            make.height.equalTo(150)
        }
        
        inputContainer.resizeToFitSubviews()
        
        beautifulLabel.snp.makeConstraints { (make) in
            make.top.equalTo(selectProfileImageView.snp.bottom).offset(5)
            make.height.equalTo(50)
            make.width.equalToSuperview()
        }
        
        startHosting.snp.makeConstraints { (make) in
            make.height.equalTo(60)
            make.width.equalToSuperview().inset(20)
            make.centerX.equalToSuperview()
            make.bottom.equalToSuperview().offset(-100)
        }
    }
}

// MARK: Event Handlers
extension OnboardingProfilePictureViewController {
    @objc func handleSelectProfileImageView() {
        let picker = UIImagePickerController()
        picker.delegate = self
        picker.allowsEditing = true
        present(picker, animated: true, completion: nil)
    }
    
    @objc func finishRegistration(_ sender: Any) {
        self.onboardingPageViewController?.coordinatorDelegate?.didAddProfilePicture(self.selectProfileImageView.image!)
        self.onboardingPageViewController?.coordinatorDelegate?.didFinishRegistration()
    }
}

// MARK: UIImagePickerControllerDelegate Methods
extension OnboardingProfilePictureViewController: UIImagePickerControllerDelegate {
    @objc func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    
    @objc func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        var selectedImageFromPicker: UIImage?
        
        if let editedImage = info[.editedImage] as? UIImage {
            selectedImageFromPicker = editedImage
            dismiss(animated: true, completion: nil)
        } else if let originalImage = info[.originalImage] as? UIImage {
            selectedImageFromPicker = originalImage
            dismiss(animated: true, completion: nil)
        }
        
        if let selectedImage = selectedImageFromPicker {
            selectProfileImageView.image = selectedImage
            selectProfileImageView.layer.cornerRadius = 25
            self.showLabels()
        }
    }
}

extension OnboardingProfilePictureViewController {
    private func showLabels() {
        UIView.animate(withDuration: 1.0, animations: {
            self.beautifulLabel.alpha = 1
        }) { (true) in
            
        }
    }
}

extension OnboardingProfilePictureViewController: UINavigationControllerDelegate {}
