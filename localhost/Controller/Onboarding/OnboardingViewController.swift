//
//  OnboardingViewController.swift
//  Contact
//
//  Created by Andrew O'Brien on 12/12/19.
//  Copyright © 2019 Andrew O'Brien. All rights reserved.
//

import Foundation
import UIKit
import SnapKit

protocol OnboardingViewControllerDelegate: class {
    func onboardingViewController(_ onboardingViewController: OnboardingViewController, nextButtonPressed: Bool)
    func onboardingViewController(_ onboardingViewController: OnboardingViewController, backButtonPressed: Bool)
}

class OnboardingViewController: NiblessViewController {
    
    var titleString: String?
    var subTitleString: String?
    
    var isFirstVC = false
    
    lazy var pageControl: UIPageControl = {
        let pageControl = UIPageControl()
        pageControl.frame = CGRect(x: 100, y: 100, width: 300, height: 300)
        pageControl.numberOfPages = 5
        pageControl.currentPage = 0
        pageControl.tintColor = UIColor.red
        pageControl.pageIndicatorTintColor = UIColor.black
        pageControl.currentPageIndicatorTintColor = UIColor.green
        return pageControl
    }()
    
    let backButton = OnboardingButton()
    let titleLabel = OnboardingTitleLabel()
    let subtitleLabel  = OnboardingSubtitleLabel()
    let nextButton = OnboardingNextButton()
    let inputContainer = OnboardingInputContainer()
    let errorLabel = OnboardingErrorLabel()
    var progressLabel: OnboardingProgressLabel?
    
    lazy var fillOutLater: UILabel = {
        let fillInLater = UILabel()
        fillInLater.text = "Add Later >"
        fillInLater.textColor = .gray
        fillInLater.font = Fonts.avenirNext_regular(18)
        fillInLater.textAlignment = .center
        fillInLater.isUserInteractionEnabled = true
        fillInLater.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(skipForNow)))
        return fillInLater
    }()
    
    weak var delegate: OnboardingViewControllerDelegate?
    
    private var titleLabelTransform = CGAffineTransform(translationX: 200, y: 0)
    private var inputContainerTransform = CGAffineTransform(translationX: 300, y: 0)
    private var subTitleLabelTransform = CGAffineTransform(translationX: 200, y: 0)
    private var animationSpeed: Double = 0.75
    private var titleInset = 0
    
    var onboardingPageViewController: OnboardingPageViewController?
    
    var progressCount: ProgressCount? {
        didSet {
            guard let progressCount = progressCount else { return }
            if showProgressLabel { setProgressLabel(progressCount) }
        }
    }
    
    var showProgressLabel: Bool = true
    var showNextButton: Bool = true
    var showBackButton: Bool = true
    var skippable: Bool = false
    
    init(title: String? = nil,
         subtitle: String? = nil,
         showProgressLabel: Bool = true,
         showNextButton: Bool = true,
         showBackButton: Bool = true,
         skippable: Bool = false
         ) {
        super.init()
        self.titleString = title
        self.subTitleString = subtitle
        self.showProgressLabel = showProgressLabel
        self.showNextButton = showNextButton
        self.showBackButton = showBackButton
        self.skippable = skippable
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.lhPurple
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
        
        guard let onboardingPageViewController = onboardingPageViewController else {
            fatalError()
        }
        
        if onboardingPageViewController.swipable {
            let rightSwipeGestureRecognizer = UISwipeGestureRecognizer(target: self, action: #selector(handleSwipes(_:)))
            rightSwipeGestureRecognizer.direction = .right

            let leftSwipeGestureRecognizer = UISwipeGestureRecognizer(target: self, action: #selector(handleSwipes(_:)))
            leftSwipeGestureRecognizer.direction = .left

            view.addGestureRecognizer(rightSwipeGestureRecognizer)
            view.addGestureRecognizer(leftSwipeGestureRecognizer)
        }
        
        setBackButton()
        setTitleLabel()
        setSubtitleLabel()
        setInputContainer()
        if showNextButton { setNextButton() }
        setErrorLabel()
        setFillOutLater()
        //        setupPageControl()
    }
    
    @objc
    func handleSwipes(_ sender: UISwipeGestureRecognizer) {
        if sender.direction == .right {
            self.backButtonPressed(UIButton())
        } else {
            self.nextButtonPressed(UIButton())
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        UIView.animate(withDuration: animationSpeed, delay: 0.15, usingSpringWithDamping: 0.88, initialSpringVelocity: 0, options: [.curveEaseInOut],
                       animations: {
                        self.titleLabel.transform = .identity
                        self.subtitleLabel.transform = .identity
                        self.inputContainer.transform = .identity
        }, completion: { _ in
            self.didFinishAppearanceTransition()
        })
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        UIView.animate(withDuration: 0.35) { [weak self] in
            if !self!.isFirstVC {
                self?.backButton.alpha = 1
            }
            self?.nextButton.alpha = 1
        }
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
        UIView.animate(withDuration: 0.35) { [weak self] in
            self?.backButton.alpha = 0
            self?.nextButton.alpha = 0
        }
        
        titleLabel.transform = titleLabelTransform
        subtitleLabel.transform = subTitleLabelTransform
        inputContainer.transform = inputContainerTransform
    }
    
    func didFinishAppearanceTransition() {}
    
    @objc
    func didTapInputContainer() {}
}

extension OnboardingViewController {
    func setTitleLabel() {
        view.addSubview(titleLabel)
        
        titleLabel.snp.makeConstraints { (make) in
            make.top.equalTo(backButton.snp.bottom).inset(-28)
            make.centerX.equalToSuperview()
        }
        
        titleLabel.transform = CGAffineTransform(translationX: 200, y: 0)
        titleLabel.text = titleString
    }
    
    func setSubtitleLabel() {
        view.addSubview(subtitleLabel)
        titleInset = subTitleString != nil ? -5 : 0
        
        subtitleLabel.snp.makeConstraints { (make) in
            make.top.equalTo(titleLabel.snp.bottom).inset(titleInset)
            make.width.equalToSuperview().inset(15)
            make.centerX.equalToSuperview()
        }
        
        subtitleLabel.transform = CGAffineTransform(translationX: 200, y: 0)
        subtitleLabel.text = subTitleString
    }
    
    func setInputContainer() {
        view.addSubview(inputContainer)
        
        inputContainer.snp.makeConstraints { (make) in
            make.top.equalTo(subtitleLabel.snp.bottom).inset(-40)
            make.centerX.equalToSuperview()
            make.width.equalToSuperview().inset(30)
        }
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(didTapInputContainer))
        tapGesture.numberOfTapsRequired = 1
        inputContainer.addGestureRecognizer(tapGesture)
        inputContainer.transform = CGAffineTransform(translationX: 300, y: 0)
    }
    
    func setFillOutLater() {
        view.addSubview(fillOutLater)
        
        fillOutLater.snp.makeConstraints { (make) in
            make.top.equalTo(inputContainer.snp.bottom).offset(50)
            make.centerX.equalToSuperview()
        }
        
        fillOutLater.isHidden = !skippable
    }
    
    func setErrorLabel() {
        view.addSubview(errorLabel)
        
        errorLabel.snp.makeConstraints { (make) in
            make.top.equalTo(inputContainer.snp.bottom).offset(15)
            make.leading.trailing.equalToSuperview().inset(50)
        }
        
        errorLabel.text = "some text you wrong"
        errorLabel.alpha = 0
    }
    
    func setNextButton() {
        view.addSubview(nextButton)
        
        nextButton.snp.makeConstraints { (make) in
            make.right.equalToSuperview().inset(28)
            make.bottom.equalTo(view.safeAreaInsets).inset(50)
        }
        
        nextButton.addTarget(self, action: #selector(nextButtonPressed(_:)), for: .touchUpInside)
        nextButton.isActive = false
        
        nextButton.isHidden = !showNextButton
    }
    
    func setBackButton() {
        view.addSubview(backButton)
        
        backButton.snp.makeConstraints { (make) in
            make.leading.equalToSuperview().inset(16)
            make.top.equalTo(view.safeAreaLayoutGuide).inset(16)
        }
        
        backButton.addTarget(self, action: #selector(backButtonPressed(_:)), for: .touchUpInside)
        backButton.setImage(UIImage(named: "onboarding-back"), for: .normal)
        backButton.contentMode = .center
        backButton.alpha = 0
        if !showBackButton { backButton.isHidden = true }
    }
    
    func setProgressLabel(_ progressCount: ProgressCount) {
        progressLabel = OnboardingProgressLabel(progressCount: progressCount)
        guard let progressLabel = progressLabel else {return}
        view.addSubview(progressLabel)
        
        progressLabel.snp.makeConstraints { (make) in
            if (showBackButton) {
                make.centerY.equalTo(backButton)
            } else {
                make.top.equalToSuperview()
            }
            make.right.equalToSuperview().inset(28)
        }
        
        progressLabel.alpha = 1
        view.layoutSubviews()
        if !showProgressLabel { progressLabel.isHidden = true }
    }
    
    private func setupPageControl() {
        view.addSubview(pageControl)
        
        let appearance = UIPageControl.appearance()
        appearance.backgroundColor = UIColor.clear
        appearance.pageIndicatorTintColor = UIColor.white
        appearance.currentPageIndicatorTintColor = UIColor.init(hexString: "#31CAFF", withAlpha: 1.0)
        
        pageControl.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.bottom.equalToSuperview().offset(-50)
        }
    }
}

extension OnboardingViewController {
    @objc
    func nextButtonPressed(_ sender: UIButton) {
        titleLabelTransform = CGAffineTransform(translationX: -300 - titleLabel.frame.maxX, y: 0)
        subTitleLabelTransform = CGAffineTransform(translationX: -300 - subtitleLabel.frame.maxX, y: 0)
        inputContainerTransform = CGAffineTransform(translationX: -1000 - inputContainer.frame.maxX, y: 0)
        animationSpeed = 0.55
        
        playTapticFeedback(style: .light)
        delegate?.onboardingViewController(self, nextButtonPressed: true)
    }
    
    @objc
    func backButtonPressed(_ sender: UIButton) {
        backButton.alpha = 0
        delegate?.onboardingViewController(self, backButtonPressed: true)
        playTapticFeedback(style: .light)
        titleLabelTransform = CGAffineTransform(translationX: 200, y: 0)
        subTitleLabelTransform = CGAffineTransform(translationX: 200, y: 0)
        inputContainerTransform = CGAffineTransform(translationX: 300, y: 0)
        animationSpeed = 0.75
    }
}

extension OnboardingViewController {
    @objc
    func skipForNow() {
        self.nextButtonPressed(UIButton())
    }
    
    func pickerViewWillShow(_ picker: UIView) {
        UIView.animate(withDuration: 0.476543, delay: 0, usingSpringWithDamping: 0.91, initialSpringVelocity: 0,
                       options: [.curveEaseInOut], animations: {
                        if (self.showNextButton) {
                            self.nextButton.snp.updateConstraints { (update) in
                                update.bottom.equalToSuperview().inset(picker.frame.size.height + 25)
                            }
                            self.view.layoutIfNeeded()
                        }
        })
    }
    
    func pickerViewWillHide(_ picker: UIView) {
        if (self.showNextButton) {
            self.nextButton.snp.updateConstraints { (update) in
                update.bottom.equalTo(self.view.safeAreaInsets).inset(50)
            }
            self.view.layoutIfNeeded()
        }
    }
    
    @objc
    func keyboardWillShow(_ notification: Notification) {
        if let keyboardFrame: NSValue = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue {
            UIView.animate(withDuration: 0.476543, delay: 0, usingSpringWithDamping: 0.91, initialSpringVelocity: 0,
                           options: [.curveEaseInOut], animations: {
                            if (self.showNextButton) {
                                self.nextButton.snp.updateConstraints { (update) in
                                    update.bottom.equalToSuperview().inset(keyboardFrame.cgRectValue.height + 25)
                                }
                                self.view.layoutIfNeeded()
                            }
            })
        }
    }
    
    @objc
    func keyboardWillHide(_ notification: Notification) {
        if let keyboardFrame: NSValue = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue {
            UIView.animate(withDuration: 0.476543, delay: 0, usingSpringWithDamping: 0.91, initialSpringVelocity: 0,
                           options: [.curveEaseInOut], animations: {
                            if (self.showNextButton) {
                                self.nextButton.snp.updateConstraints { (update) in
                                    update.bottom.equalTo(self.view.safeAreaInsets).inset(50)
                                }
                                self.view.layoutIfNeeded()
                            }
            })
        }
    }
}

