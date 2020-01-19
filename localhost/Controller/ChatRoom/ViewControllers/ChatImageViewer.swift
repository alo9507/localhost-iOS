//
//  ChatImageViewer.swift
//  Contact
//
//  Created by Andrew O'Brien on 11/17/19.
//  Copyright © 2019 Andrew O'Brien. All rights reserved.
//

import UIKit
import FirebaseStorage
import Kingfisher

class ChatImageViewer : UIViewController {

    let storage =  Storage.storage()
    
    let imageView : UIImageView = {
        let imageView = UIImageView()
        return imageView
    }()
    
    let scrollView = UIScrollView()
    
    let dismissButton : DismissButton = {
        let button = DismissButton()
        button.addTarget(self, action: #selector(handleDismissButton), for: .touchUpInside)
        return button
    }()

    var downloadURL : URL? {
        didSet {
            configureImageFromFirebase(url: downloadURL)
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .black
        render()
    }
    
    func configureImageFromFirebase(url: URL?) {
        guard let URL = url else { return }
        let stringGSURL = URL.absoluteString
        let gsReference = storage.reference(forURL: stringGSURL)
        gsReference.downloadURL { (url, error) in
            if let URL = url {
                self.imageView.kf.setImage(with: URL)
            } else {
                print(error ?? "")
            }
        }
    }
    
    @objc func handleDismissButton() {
        dismiss(animated: true)
    }
}

extension ChatImageViewer {
    func render() {
        configureScrollView()
        configureDismissButton()
        configureImageView()
    }
    func configureScrollView() {
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(scrollView)
        scrollView.delegate = self
        scrollView.maximumZoomScale = 5
        scrollView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        scrollView.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        scrollView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
    }
    
    func configureImageView() {
        imageView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.addSubview(imageView)
        imageView.backgroundColor = .black
        imageView.centerYAnchor.constraint(equalTo: scrollView.centerYAnchor).isActive = true
        imageView.widthAnchor.constraint(equalToConstant: self.view.frame.width).isActive = true
        imageView.heightAnchor.constraint(equalToConstant: 300).isActive = true
    }
    
    func configureDismissButton() {
        view.addSubview(dismissButton)
        dismissButton.translatesAutoresizingMaskIntoConstraints = false
        dismissButton.topAnchor.constraint(equalTo: view.topAnchor, constant: 40).isActive = true
        dismissButton.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -20).isActive = true
        dismissButton.heightAnchor.constraint(equalToConstant: 30).isActive = true
        dismissButton.widthAnchor.constraint(equalToConstant: 30).isActive = true
    }
}
    
    ///MARK: - UIScrollViewDelegate
extension ChatImageViewer : UIScrollViewDelegate {
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return imageView
    }

}
 
 


