//
//  RegistrationCoordinator.swift
//  Contact
//
//  Created by Andrew O'Brien on 12/12/19.
//  Copyright © 2019 Andrew O'Brien. All rights reserved.
//

import Foundation
import UIKit
import SVProgressHUD
import FirebaseAuth

protocol RegistrationCoordinatable: class {
    func didSetEmail(_ email: String)
    func didSetFirstName(_ firstName: String)
    func didSetLastName(_ lastName: String)
    func didAddBirthday(_ birthday: String)
    func didSetPassword(_ password: String)
    func didSetPhoneNumber(_ mobileNumber: String)
    func didSetPhoneCredential(_ credential: PhoneAuthCredential)
    func didAddSex(_ sex: Sex)
    func didAddAffiliations(_ affiliations: [Affiliation])
    func didAddEducations(_ educations: [Education])
    func didSetSkills(_ skills: [String])
    func didAddTopics(_ topic: [String])
    func didAddHometown(_ hometown: String)
    func didAddMaritalStatus(_ maritalStatus: String)
    func didAddProfilePicture(_ profilePicture: UIImage)
    func didFinishRegistration()
}

class RegistrationCoordinator: Coordinator {
    private let presenter: UIViewController
    private let userRepository: UserRepository
    private let userSessionRepository: UserSessionRepository
    
    var user: User = User(jsonDict: [:])
    var profileImage: UIImage? = UIImage(named: "noProfilePhoto")
    var credential: PhoneAuthCredential?
    var registrationPageViewController: OnboardingPageViewController?
    
    init(presenter: UIViewController, userRepository: UserRepository, userSessionRepository: UserSessionRepository) {
        self.presenter = presenter
        self.userRepository = userRepository
        self.userSessionRepository = userSessionRepository
    }
    
    override func start() {
        let registrationPageViewController = OnboardingPageViewController()
        self.registrationPageViewController = registrationPageViewController
        registrationPageViewController.coordinatorDelegate = self
        registrationPageViewController.modalPresentationStyle = .fullScreen
        presenter.present(registrationPageViewController, animated: true, completion: nil)
    }
}

extension RegistrationCoordinator: RegistrationCoordinatable {
    func didSetPhoneCredential(_ credential: PhoneAuthCredential) {
        self.credential = credential
    }
    
    func didSetSkills(_ skills: [String]) {
        user.skills = skills
    }
    
    func didSetPhoneNumber(_ mobileNumber: String) {
        user.phoneNumber = mobileNumber
    }
    
    func didSetFirstName(_ firstName: String) {
        user.firstName = firstName
    }
    
    func didSetLastName(_ lastName: String) {
        user.lastName = lastName
    }
    
    func didSetEmail(_ email: String) {
        user.email = email
    }
    
    func didSetPassword(_ password: String) {
        user.password = password
    }
    
    func didAddAffiliations(_ affiliations: [Affiliation]) {
        user.affiliations = affiliations
    }
    
    func didAddEducations(_ educations: [Education]) {
        user.education = educations
    }
    
    func didAddProfilePicture(_ profilePicture: UIImage) {
        self.profileImage = profilePicture
    }
    
    func didAddSex(_ sex: Sex) {
        user.sex = sex
    }
    
    func didAddTopics(_ topic: [String]) {
        user.topics = topic
    }
    
    func didAddHometown(_ hometown: String) {
        user.hometown = hometown
    }
    
    func didAddMaritalStatus(_ maritalStatus: String) {
        user.maritalStatus = maritalStatus
    }
    
    func didAddBirthday(_ birthday: String) {
        guard let birthdate = Date.birthdate(birthday) else {
            let birthdate = Date.birthdate("01/01/1995")
            user.age = Date.age(birthdate!)
            return
        }
        user.age = Date.age(birthdate)
    }
    
    func didFinishRegistration() {
        SVProgressHUD.show()

        guard let profileImageData = profileImage!.pngData() else { return print("Could not get png data") }
        
        userSessionRepository.signUp(registeringUser: user, profileImageData: profileImageData) { (userSession, error) in
            if error != nil { return print(error!.localizedDescription) }
            guard let user = userSession?.user else { return print(LHError.illegalState("Nil User : Nil Error")) }

            self.userSessionRepository.signIn(email: user.email, password: user.password) { (userSession, error) in
                SVProgressHUD.dismiss()
                if error != nil { return print(error!.localizedDescription) }
                guard let _ = userSession else { return print("No User Session?") }
                
                self.showMainTabBar()
            }
        }
    }
    
    private func showMainTabBar() {
        // Get a reference to the last VC in OnboardingPageViewController and use it to present the MainTabBar
        let lastVC = registrationPageViewController?.orderedViewControllers.last
        let tabBarCoordinator = AppDelegate.appContainer.makeMainTabBarCoordinator(presenter: lastVC!, userSession: UserSessionStore.shared.userSession)
        tabBarCoordinator.start()
    }
}
