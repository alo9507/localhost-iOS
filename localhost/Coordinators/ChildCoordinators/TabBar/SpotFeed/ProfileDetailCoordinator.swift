//
//  ProfileDetailCoordinator.swift
//  Contact
//
//  Created by Andrew O'Brien on 12/3/19.
//  Copyright © 2019 Andrew O'Brien. All rights reserved.
//

import Foundation
import UIKit

class ProfileDetailCoordinator: Coordinator {
    
    private let navigationController: UINavigationController
    private var profileDetailViewController: ProfileDetailViewController
    private let reportingManager: UserReporter?
    
    private let featuredUser: User
    private let origin: Origin
    
    init(featuredUser: User, origin: Origin, navigationController: UINavigationController, reportingManager: UserReporter) {
        self.featuredUser = featuredUser
        self.origin = origin
        self.navigationController = navigationController
        self.reportingManager = reportingManager
        
        self.profileDetailViewController = AppDelegate.appContainer.makeProfileDetailViewController(featuredUser, origin)
    }
    
    override func start() {
        profileDetailViewController.viewModel.presentOptionsMenu = {
            self.showOptionsMenu()
        }
        
        profileDetailViewController.viewModel.pushChatRoom = { user in
            self.pushChatRoom(user)
        }
        
        profileDetailViewController.viewModel.presentNodComposer = {
            self.presentNodComposer()
        }
        
        profileDetailViewController.viewModel.noChat = {
            self.presentNoChat()
        }
        
        profileDetailViewController.viewModel.itsAMatch = {
            self.presentItsAMatch()
        }
        
        self.navigationController.present(profileDetailViewController, animated: true, completion: nil)
    }
    
    func presentItsAMatch() {
        let itsAMatchVC = MatchViewController(
            user: UserSessionStore.shared.userSession.user,
            profile: profileDetailViewController.featuredUser,
            uiConfig: LHUIConfiguration()
        )
        
        itsAMatchVC.modalPresentationStyle = .fullScreen
        
        itsAMatchVC.goToChat = { (user, datingMatchVC, threadsVC) in
            self.goToChatFromMatch(user, datingMatchVC, threadsVC)
        }
        
        profileDetailViewController.present(itsAMatchVC, animated: true, completion: nil)
    }
    
    func goToChatFromMatch(_ user: User, _ matchViewController: MatchViewController, _ threadsVC: ChatThreadViewController) -> Void {
        matchViewController.dismiss(animated: true) {
            self.profileDetailViewController.dismiss(animated: true) {
                self.navigationController.pushViewController(threadsVC, animated: true)
            }
        }
    }
    
    func presentNoChat() {
        let alert = UIAlertController(title: "No Chat", message: "You'll be able to chat once \(profileDetailViewController.featuredUser.firstName) nods back!", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
        profileDetailViewController.present(alert, animated: true, completion: nil)
    }
    
    func presentNodComposer() {
//        let nodAlertView = NodAlertView()
        
        let nodAlertView = UIAlertController(title: "Add message?", message: "Let \(profileDetailViewController.featuredUser.firstName) know what you want to relate about", preferredStyle: .alert)

        nodAlertView.addTextField { (textField) in
            textField.text = ""
        }

        nodAlertView.addAction(UIAlertAction(title: "Add", style: .default, handler: { (_) in
            self.profileDetailViewController.viewModel.sendNod(message: nodAlertView.textFields![0].text!)
        }))

        nodAlertView.addAction(UIAlertAction(title: "No", style: .cancel, handler: { (_) in
            self.profileDetailViewController.viewModel.sendNod()
        }))
        
        profileDetailViewController.present(nodAlertView, animated: true, completion: nil)
    }
    
    public func pushChatRoom(_ user: User) {
        let threadsVC = AppDelegate
            .appContainer
            .makeChatRoomViewController(
                currentUser: UserSessionStore.shared.userSession.user,
                recipient: profileDetailViewController.featuredUser)
        threadsVC.modalPresentationStyle = .fullScreen
        profileDetailViewController.dismiss(animated: true) {
            self.navigationController.pushViewController(threadsVC, animated: true)
        }
    }
    
    func showOptionsMenu() {
        guard let reportingManager = reportingManager else { return }
        let alert = UIAlertController(title: "Actions on " + self.profileDetailViewController.featuredUser.firstName,
                                      message: "",
                                      preferredStyle: UIAlertController.Style.actionSheet)
        alert.addAction(UIAlertAction(title: "Block user", style: .default, handler: {(action) in
            reportingManager.block(sourceUser: UserSessionStore.shared.userSession.user, destUser: self.profileDetailViewController.featuredUser, completion: {[weak self]  (success, error) in
                if error != nil { return print(error!.localizedDescription) }
                guard let success = success else { return print(LHError.illegalState("Nil User : Nil Error")) }
                
                guard let `self` = self else { return }
                self.showBlockMessage(success: success)
            })
        }))
        alert.addAction(UIAlertAction(title: "Report user", style: .default, handler: {(action) in
            self.showReportMenu()
        }))
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        if let popoverPresentationController = alert.popoverPresentationController {
            popoverPresentationController.sourceView = self.profileDetailViewController.profileDetailView.reportingButton
//            popoverPresentationController.sourceRect = CGRect(x: self.view.bounds.midX, y: self.view.bounds.midY, width: 0, height: 0)
        }
        profileDetailViewController.present(alert, animated: true, completion: nil)
    }
    
    private func showReportMenu() {
        let alert = UIAlertController(title: "Why are you reporting this account?", message: "", preferredStyle: UIAlertController.Style.actionSheet)
        alert.addAction(UIAlertAction(title: "Spam", style: .default, handler: {(action) in
            self.reportUser(reason: .spam)
        }))
        alert.addAction(UIAlertAction(title: "Sensitive photos", style: .default, handler: {(action) in
            self.reportUser(reason: .sensitiveImages)
        }))
        alert.addAction(UIAlertAction(title: "Abusive content", style: .default, handler: {(action) in
            self.reportUser(reason: .abusive)
        }))
        alert.addAction(UIAlertAction(title: "Harmful information", style: .default, handler: {(action) in
            self.reportUser(reason: .harmful)
        }))
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        if let popoverPresentationController = alert.popoverPresentationController {
            popoverPresentationController.sourceView = self.profileDetailViewController.profileDetailView.reportingButton
//            popoverPresentationController.sourceRect = mainMediaView.bounds
        }
        profileDetailViewController.present(alert, animated: true, completion: nil)
    }
    
    private func reportUser(reason: ReportingReason) {
        guard let reportingManager = reportingManager else { return }
        reportingManager.report(sourceUser: UserSessionStore.shared.userSession.user,
                                destUser: profileDetailViewController.featuredUser,
                                reason: reason) {[weak self] (success, error) in
                                    if error != nil { return print(error!.localizedDescription) }
                                    guard let success = success else { return print(LHError.illegalState("Nil success : Nil Error")) }
                                    
                                    guard let `self` = self else { return }
                                    self.showReportMessage(success: success)
        }
    }
    
    private func showBlockMessage(success: Bool) {
        let message = (success) ? "This user has been blocked successfully." : "An error has occured. Please try again."
        let alert = UIAlertController(title: "", message: message, preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        profileDetailViewController.present(alert, animated: true, completion: nil)
    }
    
    private func showReportMessage(success: Bool) {
        let message = (success) ? "This user has been reported successfully." : "An error has occured. Please try again."
        let alert = UIAlertController(title: "", message: message, preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        profileDetailViewController.present(alert, animated: true, completion: nil)
    }
}
