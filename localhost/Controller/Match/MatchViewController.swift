//
//  MatchViewController.swift
//  DatingApp
//
//  Created by Florian Marcu on 1/25/19.
//  Copyright © 2019 Instamobile. All rights reserved.
//

import UIKit

class MatchViewController: UIViewController {
    @IBOutlet var matchImageView: UIImageView!
    @IBOutlet var overlayView: UIView!
    @IBOutlet var matchLabel: UILabel!
    @IBOutlet var sendMessageButton: UIButton!
    @IBOutlet var keepSwipingButton: UIButton!
    @IBOutlet var actionsContainerView: UIView!

    let user: User
    let profile: User
    let uiConfig: UIGenericConfigurationProtocol
    let reportingManager: UserReporter?
    
    var goToChat: ((User, MatchViewController, ChatThreadViewController) -> Void)?
    
    init(user: User,
         profile: User,
         uiConfig: UIGenericConfigurationProtocol,
         reportingManager: UserReporter? = nil
         ) {
        self.profile = profile
        self.user = user
        self.uiConfig = uiConfig
        self.reportingManager = reportingManager
        super.init(nibName: "MatchViewController", bundle: nil)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override var prefersStatusBarHidden: Bool {
        return true
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        // Send a push notification to recipient
        let sender = MatchNotificationSender()
        sender.sendNotificationIfPossible(user: user, recipient: profile)

        matchImageView.kf.setImage(with: URL(string: profile.profileImageUrl))
//        if let photo = profile.profileImageUrl {
//
//        } else if let photos = profile.photos, photos.count > 0 {
//            matchImageView.kf.setImage(with: URL(string: photos[0]))
//        }

        matchImageView.contentMode = .scaleAspectFill

        overlayView.backgroundColor = UIColor(displayP3Red: 0, green: 0, blue: 0, alpha: 0.3)
        actionsContainerView.backgroundColor = .clear

        sendMessageButton.configure(color: .white, font: uiConfig.boldFont(size: 16), cornerRadius: 10, borderColor: nil, backgroundColor: uiConfig.mainThemeForegroundColor, borderWidth: nil)
        sendMessageButton.setTitle("SEND A MESSAGE", for: .normal)
        sendMessageButton.addTarget(self, action: #selector(didTapSendMessageButton), for: .touchUpInside)
        sendMessageButton.snp.makeConstraints { (maker) in
            maker.left.equalTo(view).offset(30)
            maker.right.equalTo(view).offset(-30)
            maker.height.equalTo(50.0)
        }

        keepSwipingButton.configure(color: .white, font: uiConfig.boldFont(size: 14), cornerRadius: 0, borderColor: nil, backgroundColor: .clear, borderWidth: nil)
        keepSwipingButton.setTitle("KEEP EXPLORING", for: .normal)
        keepSwipingButton.addTarget(self, action: #selector(didTapKeepSwipingButton), for: .touchUpInside)

        matchLabel.text = "Ya'll oughta chat"
        matchLabel.textColor = UIColor(hexString: "#11e19d")
        matchLabel.font = uiConfig.boldFont(size: 40)
        matchLabel.numberOfLines = 0
    }

    @objc func didTapSendMessageButton() {
        let id1 = user.uid
        let id2 = profile.uid
        let channelId = id1 < id2 ? id1 + id2 : id2 + id1
        var channel = ChatChannel(id: channelId, name: profile.fullName())
        channel.participants = [user, profile]
        
        let threadsVC = AppDelegate.appContainer.makeChatThreadViewController(user: user, channel: channel, uiConfig: self.uiConfig, recipients: [profile])
        
        self.goToChat?(profile, self, threadsVC)
    }

    @objc func didTapKeepSwipingButton() {
        self.dismiss(animated: true, completion: nil)
    }
}
