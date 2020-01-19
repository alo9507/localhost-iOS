//
//  EditStatusViewController.swift
//  Contact
//
//  Created by Andrew O'Brien on 11/10/19.
//  Copyright © 2019 Andrew O'Brien. All rights reserved.
//

import UIKit
import Foundation
import SnapKit

class EditStatusViewController: NiblessViewController {
    
    let exampleStatuses: [String] = {
        var exampleStatuses = [String]()
        exampleStatuses.append("Example status 1")
        exampleStatuses.append("Example status 2")
        exampleStatuses.append("Example status 3")
        return exampleStatuses
    }()
    
    lazy var exampleStatusesStackView: UIStackView = {
        let exampleStatusesStackView = UIStackView()
        exampleStatusesStackView.translatesAutoresizingMaskIntoConstraints = false
        exampleStatusesStackView.axis = .vertical
        exampleStatusesStackView.distribution = .equalSpacing
        exampleStatusesStackView.alignment = .center
        exampleStatusesStackView.spacing = 10
        
        for status in exampleStatuses {
            let label = UILabel()
            label.font = Fonts.avenirNext_UltraLightItalic(15)
            label.textColor = .white
            label.numberOfLines = 0
            label.sizeToFit()
            
            exampleStatusesStackView.addArrangedSubview(label)
            
            label.snp.makeConstraints { (make) in
                make.top.equalToSuperview()
                make.width.equalToSuperview()
            }
        }
        
        return exampleStatusesStackView
    }()
    
    lazy var statusTextView: ControlledTextView = {
        let statusTextView = ControlledTextView()
        statusTextView.backgroundColor = .white
        statusTextView.layer.cornerRadius = 15.0
        statusTextView.layer.borderWidth = 2.0
        statusTextView.layer.borderColor = UIColor.init(hexString: "#9917C4", withAlpha: 0.75).cgColor
        statusTextView.font = UIFont(name: "AvenirNext-Bold", size: 18)
        statusTextView.isScrollEnabled = false
        statusTextView.textContainerInset = UIEdgeInsets(top: 10, left: 10, bottom: 0, right: 10)
        return statusTextView
    }()
    
    var wordCountLabel: UILabel = {
        let wordCountLabel = UILabel()
        wordCountLabel.text = "0/141"
        wordCountLabel.font = UIFont(name: "AvenirNext-Bold", size: 12.0)
        wordCountLabel.textColor = .white
        wordCountLabel.sizeToFit()
        return wordCountLabel
    }()
    
    var hintLabel: UILabel = {
        let hintLabel = UILabel()
        hintLabel.text = "Keep your status short! Just a little tidbit into your mind!"
        hintLabel.font = UIFont(name: "AvenirNext-Bold", size: 16.0)
        hintLabel.textColor = .white
        hintLabel.numberOfLines = 2
        hintLabel.sizeToFit()
        hintLabel.isHidden = true
        return hintLabel
    }()
    
    lazy var postButton: UIButton = {
        let postButton = UIButton()
        postButton.setTitle("Send It!", for: .normal)
        postButton.titleLabel?.font = UIFont(name: "AvenirNext-Bold", size: 20.0)
        postButton.addTarget(viewModel, action: #selector(EditStatusViewModel.postStatus), for: .touchUpInside)
        postButton.backgroundColor = UIColor.init(hexString: "#31CAFF", alpha: 1.0)
        postButton.layer.cornerRadius = 20
        return postButton
    }()
    
    var viewModel: EditStatusViewModel
    var currentUser: User?
    
    var submissionSuccessful: (() -> Void)?
    
    init(
        viewModel: EditStatusViewModel
    ) {
        self.viewModel = viewModel
        super.init()
        viewModel.delegate = self
        self.title = "Hosting Status"
        statusTextView.delegate = self
        render()
    }
    
    override func viewDidLoad() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        statusTextView.becomeFirstResponder()
    }
    
    deinit {
        UserSessionStore.unsubscribe(viewModel)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: view.window)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: view.window)
    }
}

extension EditStatusViewController {
    func currentUserSession(_ userSession: UserSession?) {
        self.currentUser = userSession?.user
        self.render()
    }
    
    func render() {
        view.backgroundColor = UIColor.lhPurple
        constructHierarchy()
        activateConstraints()
        configureNavBar()
    }
    
    func constructHierarchy() {
        view.addSubview(statusTextView)
        view.addSubview(wordCountLabel)
        view.addSubview(hintLabel)
        view.addSubview(postButton)
        view.addSubview(exampleStatusesStackView)
    }
    
    func activateConstraints() {
        statusTextView.snp.makeConstraints { (make) in
            make.top.equalTo(view.safeAreaLayoutGuide).offset(50)
            make.left.right.equalToSuperview().inset(15)
            make.height.equalTo(120)
        }
        
        exampleStatusesStackView.snp.makeConstraints { (make) in
            make.top.equalTo(statusTextView.snp.bottom).offset(100)
            make.left.right.equalToSuperview().inset(15)
            make.height.equalTo(300)
        }
        
        wordCountLabel.snp.makeConstraints { (make) in
            make.top.equalTo(statusTextView.snp.bottom).offset(15)
            make.right.equalToSuperview().inset(15)
        }
        
        hintLabel.snp.makeConstraints { (make) in
            make.width.equalTo(300)
            make.top.equalTo(statusTextView.snp.bottom).offset(15)
            make.left.equalTo(statusTextView.snp.left)
        }
        
        postButton.snp.makeConstraints { (make) in
            make.height.equalTo(50)
            make.width.equalToSuperview().inset(15)
            make.trailing.equalToSuperview().inset(16)
            make.bottom.equalTo(view.safeAreaInsets).inset(50)
        }
    }
    
    func configureNavBar() {
//        let leftBarButtonItem = UIBarButtonItem(title: "Cancel", style: UIBarButtonItem.Style.plain, target: viewModel, action: #selector(EditStatusViewModel.cancel))
//        navigationItem.leftBarButtonItem = leftBarButtonItem
//
//        navigationItem.leftBarButtonItem?.setTitleTextAttributes([
//            NSAttributedString.Key.font: UIFont(name: "AvenirNext-Regular", size: 19.0)!,
//            NSAttributedString.Key.foregroundColor: UIColor.white
//        ], for: .normal)
//        navigationItem.leftBarButtonItem?.setTitleTextAttributes([
//            NSAttributedString.Key.font: UIFont(name: "AvenirNext-Regular", size: 19.0)!,
//            NSAttributedString.Key.foregroundColor: UIColor.white
//        ], for: .selected)
    }
    
    func configureStatusLengthHint(showHint: Bool) {
        hintLabel.isHidden = !showHint
    }
}

extension EditStatusViewController: EditStatusViewModelDelegate {
    func dismissSelf() {
        self.submissionSuccessful?()
    }
    
    func clearStatusTextField() {
        statusTextView.text = ""
    }
    
    func wordCount(_ wordCount: Int) {
        self.wordCountLabel.text = "\(wordCount)/140"
    }
}

extension EditStatusViewController: UITextViewDelegate {
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        guard let currentText = textView.text else {
            print("❌❌❌Somehow no text in status??❌❌❌")
            return true
        }
        
        // bulk backspace operation
        // cut paste operations?
        // is backspace
        if text == "" && range.length > 0 {
            viewModel.statusText = currentText
            if currentText.count <= 141 {
                configureStatusLengthHint(showHint: false)
                return true
            }
        }
        
        if currentText.count <= 140 {
            configureStatusLengthHint(showHint: false)
            viewModel.statusText = currentText
            return true
        } else {
            configureStatusLengthHint(showHint: true)
            return false
        }
    }
}

extension EditStatusViewController {
    @objc func keyboardWillShow(_ notification: Notification) {
        if let keyboardFrame: NSValue = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue {
            UIView.animate(withDuration: 0.47, delay: 0, usingSpringWithDamping: 0.91, initialSpringVelocity: 0, options: [.curveEaseInOut], animations: {
                self.postButton.snp.updateConstraints { update in
                    update.bottom.equalToSuperview().inset(keyboardFrame.cgRectValue.height + 25)
                }
                self.view.layoutIfNeeded()
            }, completion: nil)
        }
    }
    
    @objc func keyboardWillHide(_ notification: Notification) {
        UIView.animate(withDuration: 0.47, delay: 0, usingSpringWithDamping: 0.91, initialSpringVelocity: 0, options: [.curveEaseInOut], animations: {
            self.postButton.snp.updateConstraints { (update) in
                update.bottom.equalTo(self.view.safeAreaInsets).inset(50)
            }
            self.view.layoutIfNeeded()
        }, completion: nil)
    }
}
