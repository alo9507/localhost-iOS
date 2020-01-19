//
//  OnboardingPageViewController.swift
//  Contact
//
//  Created by Andrew O'Brien on 12/12/19.
//  Copyright © 2019 Andrew O'Brien. All rights reserved.
//

import Foundation
import UIKit

class OnboardingPageViewController: UIPageViewController {
    var coordinatorDelegate: RegistrationCoordinatable?
    
    var signUpWithChoice: String = "no_option"
    
    private var currentViewController: OnboardingViewController? {
        didSet { currentViewController?.delegate = self }
    }
    
    private var onboardingPageCount: Int {
        return orderedViewControllers.count
    }
    
    var swipable: Bool = false
    
    lazy var orderedViewControllers: [OnboardingViewController] = {
        let signUpWithVC = SignUpWith(title: "sign up with _____", subtitle: "we don't use social media logins because they cause depression", showProgressLabel: true, showNextButton: false, showBackButton: true)
        
        signUpWithVC.didChooseSignUpOption = { choice in
            self.signUpWithChoice = choice
        }
        
        let orderedViewController = [
            OnboardingKickoffScreen(
                title: "welcome to localhost",
                subtitle: "only add what matters to you most!",
                showProgressLabel: false
            ),
            NameOnboardingViewController(
                title: "what's your name?",
                subtitle: "so we don't have to call you Anonymous"
            ),
            BirthdayOnboarding(
                title: "birthday?",
                subtitle: "so we know you're old enough to partake"
            ),
            MyOrganizationsOnboardingViewController(
                title: "works and schools?",
                subtitle: "how else will you know when you cross paths with a connection"
            ),
            signUpWithVC,
            EmailOnboardingViewController(
                title: "best email?",
                subtitle: "for login. nothing else."
            ),
            MobileOnboardingViewController(title: "digits?"),
            PasswordOnboardingViewController(
                title: "hush hush password time",
                subtitle: "for login and such"
            ),
            SexOnboardingViewController(
                title: "your sex?",
                subtitle: "feel free to skip this if you choose not to identify",
                showProgressLabel: true,
                showNextButton: true,
                showBackButton: true,
                skippable: true
            ),
            SkillsOnboardingViewController(
                title: "got any skills?",
                subtitle: "anything from programming to bear wrestling",
                showProgressLabel: false,
                showNextButton: true,
                showBackButton: true,
                skippable: true
            ),
            TalkToMeAbout(
                title: "conversational approaches",
                subtitle: "localhost is all about real conversations. what are some things you're down to talk about with people where you are?",
                skippable: true
            ),
            MaritalStatusOnboarding(
                title: "relationship?",
                subtitle: "for people who want to use localhost socially",
                showProgressLabel: true,
                showNextButton: true,
                showBackButton: true,
                skippable: false
            ),
            AppDelegate.appContainer.makeLocationAccessVC(),
            OnboardingProfilePictureViewController(
                title: "profile picture",
                subtitle: "you know the drill",
                showProgressLabel: false,
                showNextButton: false,
                showBackButton: true
            )
        ]
        
        orderedViewController.first?.onboardingPageViewController = self
        
        return orderedViewController
    }()
    
    override init(
        transitionStyle style: UIPageViewController.TransitionStyle,
        navigationOrientation: UIPageViewController.NavigationOrientation,
        options: [UIPageViewController.OptionsKey: Any]? = nil
    ) {
        super.init(transitionStyle: .scroll, navigationOrientation: .horizontal, options: nil)
    }
    
    convenience init(orderedViewControllers: [OnboardingViewController], swipable: Bool) {
        self.init(transitionStyle: .scroll, navigationOrientation: .horizontal, options: nil)
        self.orderedViewControllers = orderedViewControllers
        self.swipable = swipable
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        delegate = self
        
        orderedViewControllers.first!.progressCount = (1, onboardingPageCount)
        orderedViewControllers.first!.isFirstVC = true
        
        setViewControllers([orderedViewControllers.first!], direction: .forward, animated: false, completion: nil)
        currentViewController = orderedViewControllers.first!
        currentViewController?.onboardingPageViewController = self
    }
}

extension OnboardingPageViewController: UIPageViewControllerDelegate, UIPageViewControllerDataSource {
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        guard let viewController = viewController as? OnboardingViewController,
            let index = orderedViewControllers.firstIndex(of: viewController),
            (index - 1) >= 0 else {
                return nil
        }
        
        currentViewController = orderedViewControllers[index - 1]
        currentViewController?.onboardingPageViewController = self
        currentViewController?.progressCount = (index, onboardingPageCount)
        
        if let _ = viewController as? EmailOnboardingViewController {
                currentViewController = orderedViewControllers[index - 1]
                currentViewController?.onboardingPageViewController = self
                currentViewController?.progressCount = (index, onboardingPageCount)
        }
        
        if let _ = viewController as? MobileOnboardingViewController {
            currentViewController = orderedViewControllers[index - 2]
            currentViewController?.onboardingPageViewController = self
            currentViewController?.progressCount = (index, onboardingPageCount)
        }
        
        if let _ = viewController as? PasswordOnboardingViewController {
            if signUpWithChoice == "mobile" {
                currentViewController = orderedViewControllers[index - 1]
                currentViewController?.onboardingPageViewController = self
                currentViewController?.progressCount = (index, onboardingPageCount)
            } else if signUpWithChoice == "email" {
                currentViewController = orderedViewControllers[index - 2]
                currentViewController?.onboardingPageViewController = self
                currentViewController?.progressCount = (index, onboardingPageCount)
            } else {
                fatalError()
            }
        }
        
        let isFirstViewController = index - 1 == 0
        if isFirstViewController {
            currentViewController?.isFirstVC = true
        }
        
        return currentViewController
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        guard let viewController = viewController as? OnboardingViewController,
            let index = orderedViewControllers.firstIndex(of: viewController),
            index + 1 < orderedViewControllers.endIndex else {
                return nil
        }
        
        currentViewController = orderedViewControllers[index + 1]
        currentViewController?.onboardingPageViewController = self
        currentViewController?.progressCount = (index + 2, onboardingPageCount)
        
        if let signUpWithVC = viewController as? SignUpWith {
            switch signUpWithVC.signUpChoice {
            case "email":
                currentViewController = orderedViewControllers[index + 1]
                currentViewController?.onboardingPageViewController = self
                currentViewController?.progressCount = (index + 2, onboardingPageCount)
            case "mobile":
                currentViewController = orderedViewControllers[index + 2]
                currentViewController?.onboardingPageViewController = self
                currentViewController?.progressCount = (index + 2, onboardingPageCount)
            default:
                break
            }
        }
        
        if let _ = viewController as? EmailOnboardingViewController {
            currentViewController = orderedViewControllers[index + 2]
            currentViewController?.onboardingPageViewController = self
            currentViewController?.progressCount = (index + 2, onboardingPageCount)
        }
        
        return currentViewController
    }
}

extension OnboardingPageViewController: OnboardingViewControllerDelegate {
    func onboardingViewController(_ onboardingViewController: OnboardingViewController, nextButtonPressed: Bool) {
        guard let currentViewController = currentViewController, let nextViewController = pageViewController(self, viewControllerAfter: currentViewController) else {
            return
        }
        
        self.updateUser(onboardingViewController)
        
        setViewControllers([nextViewController], direction: .forward, animated: true, completion: nil)
    }
    
    func onboardingViewController(_ onboardingViewController: OnboardingViewController, backButtonPressed: Bool) {
        guard let currentViewContrller = currentViewController, let prevViewController = pageViewController(self, viewControllerBefore: currentViewContrller) else {
            return
        }
        
        setViewControllers([prevViewController], direction: .reverse, animated: true, completion: nil)
    }
    
    private func updateUser(_ onboardingViewController: OnboardingViewController) {
        if let nameVC = onboardingViewController as? NameOnboardingViewController {
            self.coordinatorDelegate?.didSetFirstName(nameVC.firstNameTextField.text!)
            self.coordinatorDelegate?.didSetLastName(nameVC.lastNameTextField.text!)
        }
        
        if let mobileVC = onboardingViewController as? MobileOnboardingViewController {
            self.coordinatorDelegate?.didSetPhoneNumber(mobileVC.phoneNumberTextField.text!)
            guard let credential = mobileVC.credential else { return }
            self.coordinatorDelegate?.didSetPhoneCredential(credential)
        }
        
        if let emailVC = onboardingViewController as? EmailOnboardingViewController {
            self.coordinatorDelegate?.didSetEmail(emailVC.emailTextField.text!)
        }
        
        if let passwordVC = onboardingViewController as? PasswordOnboardingViewController {
            self.coordinatorDelegate?.didSetPassword(passwordVC.passwordTextField.text!)
        }
        
        if let sexVC = onboardingViewController as? SexOnboardingViewController {
            self.coordinatorDelegate?.didAddSex(sexVC.selectedSex)
        }
        
        if let birthdayVC = onboardingViewController as? BirthdayOnboarding {
            self.coordinatorDelegate?.didAddBirthday(birthdayVC.birthday)
        }
        
        if let locationVC = onboardingViewController as? LocationAccess {
            if locationVC.isHometown {
                self.coordinatorDelegate?.didAddHometown(locationVC.location)
            }
        }
        
        if let maritalStatusVC = onboardingViewController as? MaritalStatusOnboarding {
            self.coordinatorDelegate?.didAddMaritalStatus(maritalStatusVC.selectedMaritalStatus)
        }
        
        if let topicsVC = onboardingViewController as? TalkToMeAbout {
            var topics = [String]()
            topics.append(topicsVC.firstTopic.text!)
            topics.append(topicsVC.secondTopic.text!)
            topics.append(topicsVC.thirdTopic.text!)
            self.coordinatorDelegate?.didAddTopics(topics)
        }
        
        if let skillsVC = onboardingViewController as? SkillsOnboardingViewController {
            var skills = [String]()
            skills.append(skillsVC.firstSkill.text!)
            skills.append(skillsVC.secondSkill.text!)
            skills.append(skillsVC.thirdSkill.text!)
            self.coordinatorDelegate?.didSetSkills(skills)
        }
        
        if let myOrganizationsVC = onboardingViewController as? MyOrganizationsOnboardingViewController {
            self.coordinatorDelegate?.didAddEducations(myOrganizationsVC.educations)
            self.coordinatorDelegate?.didAddAffiliations(myOrganizationsVC.affiliations)
        }
    }
    
}
