//
//  ChatThreadViewController.swift
//  ChatApp
//
//  Created by Florian Marcu on 8/26/18.
//  Copyright © 2018 Instamobile. All rights reserved.
//

import UIKit
import Photos
import Firebase
import FirebaseFirestore
import FirebaseStorage
import MessageKit
import InputBarAccessoryView
import Kingfisher

class ChatThreadViewController: MessagesViewController, MessagesDataSource {

    lazy var cameraItem: InputBarButtonItem = {
        let cameraItem = InputBarButtonItem(type: .system)
        cameraItem.tintColor = uiConfig.primaryColor
        cameraItem.image = UIImage.localImage("camera-filled-icon", template: true)
        cameraItem.addTarget(
            self,
            action: #selector(cameraButtonPressed),
            for: .primaryActionTriggered
        )
        cameraItem.setSize(CGSize(width: 30, height: 30), animated: false)
        return cameraItem
    }()
    
    var user: User
    var recipients: [User]
    private var messages: [ChatMessage] = []

    private let storage = Storage.storage().reference()

    private var isSendingPhoto = false {
        didSet {
            DispatchQueue.main.async {
                self.messageInputBar.leftStackViewItems.forEach { item in
                    item.inputBarAccessoryView?.sendButton.isEnabled = !self.isSendingPhoto
                }
            }
        }
    }

    var channel: ChatChannel
    var uiConfig: ChatUIConfigurationProtocol
    
    var channelsRepository: ChannelsRepository
    
    init(user: User,
         channel: ChatChannel,
         uiConfig: ChatUIConfigurationProtocol,
         recipients: [User] = [],
         channelsRepository: ChannelsRepository
         ) {
        self.user = user
        self.channel = channel
        self.uiConfig = uiConfig
        self.recipients = recipients
        self.channelsRepository = channelsRepository

        super.init(nibName: nil, bundle: nil)
        
        self.title = channel.name
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.becomeFirstResponder()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.tabBarController?.tabBar.isHidden = false
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.tabBarController?.tabBar.isHidden = true
        subscribeToMessages()
        
        maintainPositionOnKeyboardFrameChanged = true
        navigationItem.largeTitleDisplayMode = .never
        
        setupInputTextView()
        setupSendButton()
        setupMessageInputBar()
        
        messagesCollectionView.messagesDataSource = self
        messagesCollectionView.messagesLayoutDelegate = self
        messagesCollectionView.messagesDisplayDelegate = self
        messagesCollectionView.messageCellDelegate = self

        messagesCollectionView.backgroundColor = uiConfig.backgroundColor
        view.backgroundColor = uiConfig.backgroundColor
    }
    
    func setupInputTextView() {
        let inputTextView = messageInputBar.inputTextView
        inputTextView.tintColor = uiConfig.primaryColor
        inputTextView.textColor = uiConfig.inputTextViewTextColor
        inputTextView.backgroundColor = uiConfig.inputTextViewBgColor
        inputTextView.layer.cornerRadius = 14.0
        inputTextView.layer.borderWidth = 0.0
        inputTextView.font = UIFont.systemFont(ofSize: 16.0)
        inputTextView.placeholderLabel.textColor = uiConfig.inputPlaceholderTextColor
        inputTextView.placeholderLabel.text = "Start typing..."
        inputTextView.textContainerInset = UIEdgeInsets(top: 6, left: 12, bottom: 6, right: 12)
        inputTextView.placeholderLabelInsets = UIEdgeInsets(top: 6, left: 15, bottom: 6, right: 15)
    }
    
    func setupSendButton() {
        let sendButton = messageInputBar.sendButton
        sendButton.setTitleColor(uiConfig.primaryColor, for: .normal)
        sendButton.setImage(UIImage.localImage("share-icon", template: true), for: .normal)
        sendButton.title = ""
        sendButton.setSize(CGSize(width: 30, height: 30), animated: false)
        sendButton.tintColor = uiConfig.primaryColor
    }
    
    func setupMessageInputBar() {
        messageInputBar.delegate = self
        
        messageInputBar.leftStackView.alignment = .center
        messageInputBar.setLeftStackViewWidthConstant(to: 50, animated: false)
        messageInputBar.setRightStackViewWidthConstant(to: 35, animated: false)
        messageInputBar.setStackViewItems([cameraItem], forStack: .left, animated: false)
        messageInputBar.backgroundColor = uiConfig.backgroundColor
        messageInputBar.backgroundView.backgroundColor = uiConfig.backgroundColor
        messageInputBar.separatorLine.isHidden = true
    }
    
    func subscribeToMessages() {
        FirebaseChatRoomRepository.subscribeToMessages(channel: channel) { (change, error) in
            guard let document = change else {
                return print("SHTUFF")
            }
            
            self.handleDocumentChange(document)
        }
    }

    @objc private func cameraButtonPressed() {
        let picker = UIImagePickerController()
        picker.delegate = self

        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            picker.sourceType = .camera
        } else {
            picker.sourceType = .photoLibrary
        }

        present(picker, animated: true, completion: nil)
    }

    private func save(_ message: ChatMessage) {
        FirebaseChatRoomRepository.sendMessage(channel: channel, message: message) { (message, error) in
            self.channelsRepository.updateChannelParticipationIfNeeded(channel: self.channel)
            self.sendOutPushNotificationsIfNeeded(message: message!)
            self.messagesCollectionView.scrollToBottom()
        }
    }

    private func sendOutPushNotificationsIfNeeded(message: ChatMessage) {
        var lastMessage = ""
        switch message.kind {
        case let .text(text):
//            if let firstName = user.firstName {
//                lastMessage = firstName + ": " + text
//            } else {
                lastMessage = text
//            }
        case .photo(_):
            lastMessage = "Someone sent a photo."
        default:
            break
        }

        let notificationSender = PushNotificationSender()
        recipients.forEach { (recipient) in
            if recipient.uid != user.uid {
                notificationSender.sendPushNotification(
                        to: recipient.pushToken,
                        title: user.firstName,
                        body: lastMessage,
                        senderId: self.user.uid,
                        target: "chat"
                    )
            }
        }
    }

    private func insertNewMessage(_ message: ChatMessage) {
        guard !messages.contains(message) else {
            return
        }

        messages.append(message)
        messages.sort()

        let isLatestMessage = messages.firstIndex(of: message) == (messages.count - 1)
        let shouldScrollToBottom = messagesCollectionView.isAtBottom && isLatestMessage

        messagesCollectionView.reloadData()

        if shouldScrollToBottom {
            DispatchQueue.main.async {
                self.messagesCollectionView.scrollToBottom(animated: true)
            }
        }
    }

    private func handleDocumentChange(_ change: DocumentChange) {
        guard let message = ChatMessage(document: change.document) else {
            return
        }
        switch change.type {
        case .added:
            if let url = message.downloadURL {
                downloadImage(at: url) { [weak self] image in
                    guard let `self` = self else {
                        return
                    }
                    guard let image = image else {
                        return
                    }

                    message.image = image
                    self.insertNewMessage(message)
                }
            } else {
                insertNewMessage(message)
            }
        default:
            break
        }
    }

    private func uploadImage(_ image: UIImage, to channel: ChatChannel, completion: @escaping (URL?) -> Void) {
        let hud = CPKProgressHUD.progressHUD(style: .loading(text: "Sending"))
        hud.show(in: view)
        
        FirebaseChatRoomRepository.uploadImage(image, to: channel) { (url) in
            hud.dismiss()
            completion(url)
        }
    }

    private func sendPhoto(_ image: UIImage) {
        isSendingPhoto = true
        uploadImage(image, to: channel) { [weak self] url in
            guard let `self` = self else {
                return
            }
            self.isSendingPhoto = false

            guard let url = url else {
                return
            }
            let message = ChatMessage(user: self.user, image: image, url: url)
            message.downloadURL = url

            self.save(message)
            self.messagesCollectionView.scrollToBottom()
        }
    }

    private func downloadImage(at url: URL, completion: @escaping (UIImage?) -> Void) {
        let ref = Storage.storage().reference(forURL: url.absoluteString)
        let megaByte = Int64(1 * 1024 * 1024)

        ref.getData(maxSize: megaByte) { data, error in
            guard let imageData = data else {
                completion(nil)
                return
            }

            completion(UIImage(data: imageData))
        }
    }

    fileprivate func otherUser() -> User? {
        for recipient in recipients {
            if recipient.uid != user.uid {
                return recipient
            }
        }
        return nil
    }

    @objc private func actionsButtonTapped() {
        let alert = UIAlertController(title: "Group Settings", message: "", preferredStyle: UIAlertController.Style.actionSheet)
        alert.addAction(UIAlertAction(title: "Rename Group", style: .default, handler: {[weak self] (action) in
            guard let strongSelf = self else { return }
            strongSelf.didTapRenameButton()
        }))
        alert.addAction(UIAlertAction(title: "Leave Group", style: .destructive, handler: {[weak self] (action) in
            guard let strongSelf = self else { return }
            strongSelf.didTapLeaveGroupButton()
        }))
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        if let popoverPresentationController = alert.popoverPresentationController {
            popoverPresentationController.sourceView = self.view
            popoverPresentationController.sourceRect = self.view.bounds
        }
        self.present(alert, animated: true)
    }

    private func didTapRenameButton() {
        let alert = UIAlertController(title: "Change Name", message: "", preferredStyle: UIAlertController.Style.alert)
        alert.addTextField(configurationHandler: { (textField) in
            textField.placeholder = "Enter Group Name"
        })
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: {[weak self] (action) in
            guard let strongSelf = self else { return }
            guard let name = alert.textFields?.first?.text else {
                return
            }
            if name.count == 0 {
                strongSelf.didTapRenameButton()
                return
            }
            strongSelf.channelsRepository.renameGroup(channel: strongSelf.channel, name: name)
            strongSelf.title = name
        }))
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        self.present(alert, animated: true)
    }

    private func didTapLeaveGroupButton() {
        let alert = UIAlertController(title: "Are you sure?", message: "", preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "Yes", style: .default, handler: {[weak self] (action) in
            guard let strongSelf = self else { return }
            strongSelf.channelsRepository.leaveGroup(channel: strongSelf.channel, user: strongSelf.user)
            strongSelf.navigationController?.popViewController(animated: true)
        }))
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        self.present(alert, animated: true)
    }

    // MARK: - MessagesDataSource

    func currentSender() -> SenderType {
        return Sender(senderId: user.uid, displayName: "You")
    }

    func numberOfMessages(in messagesCollectionView: MessagesCollectionView) -> Int {
        return messages.count
    }

    func messageForItem(at indexPath: IndexPath,
                        in messagesCollectionView: MessagesCollectionView) -> MessageType {
        if indexPath.section < messages.count {
            return messages[indexPath.section]
        }
        fatalError()
    }

    func numberOfSections(in messagesCollectionView: MessagesCollectionView) -> Int {
        return messages.count
    }

    func cellTopLabelAttributedText(for message: MessageType,
                                    at indexPath: IndexPath) -> NSAttributedString? {

        let name = message.sender.displayName
        return NSAttributedString(
            string: name,
            attributes: [
                .font: UIFont.preferredFont(forTextStyle: .caption1),
                .foregroundColor: UIColor(white: 0.3, alpha: 1)
            ]
        )
    }
}

// MARK: - MessagesLayoutDelegate

extension ChatThreadViewController: MessagesLayoutDelegate {

    func avatarSize(for message: MessageType, at indexPath: IndexPath,
                    in messagesCollectionView: MessagesCollectionView) -> CGSize {

        return .zero
    }

    func footerViewSize(for message: MessageType, at indexPath: IndexPath,
                        in messagesCollectionView: MessagesCollectionView) -> CGSize {

        return CGSize(width: 0, height: 8)
    }

    func heightForLocation(message: MessageType, at indexPath: IndexPath,
                           with maxWidth: CGFloat, in messagesCollectionView: MessagesCollectionView) -> CGFloat {

        return 0
    }
}

// MAR: - MessageInputBarDelegate

extension ChatThreadViewController: InputBarAccessoryViewDelegate {
    func inputBar(_ inputBar: InputBarAccessoryView, didPressSendButtonWith text: String) {
//        let feedbackGenerator = UIImpactFeedbackGenerator(style: .light)
//        feedbackGenerator.impactOccurred()
        let message = ChatMessage(messageId: UUID().uuidString,
                                    messageKind: MessageKind.text(text),
                                    createdAt: Date(),
                                    atcSender: user,
                                    recipient: recipients[0],
                                    seenByRecipient: false)
        
        save(message)
        inputBar.inputTextView.text = ""
    }

    func inputBar(_ inputBar: InputBarAccessoryView, didChangeIntrinsicContentTo size: CGSize) {}
    func inputBar(_ inputBar: InputBarAccessoryView, textViewTextDidChangeTo text: String) {}
    func inputBar(_ inputBar: InputBarAccessoryView, didSwipeTextViewWith gesture: UISwipeGestureRecognizer) {}
}

// MARK: - MessagesDisplayDelegate

extension ChatThreadViewController: MessagesDisplayDelegate {

    func backgroundColor(for message: MessageType, at indexPath: IndexPath,
                         in messagesCollectionView: MessagesCollectionView) -> UIColor {
        return isFromCurrentSender(message: message) ? uiConfig.primaryColor : UIColor(hexString: "#f0f0f0")
    }

    func shouldDisplayHeader(for message: MessageType, at indexPath: IndexPath,
                             in messagesCollectionView: MessagesCollectionView) -> Bool {
        return false
    }

    func messageStyle(for message: MessageType, at indexPath: IndexPath,
                      in messagesCollectionView: MessagesCollectionView) -> MessageStyle {

        let corner: MessageStyle.TailCorner = isFromCurrentSender(message: message) ? .bottomRight : .bottomLeft
        return .bubbleTail(corner, .curved)
    }

    func configureAvatarView(_ avatarView: AvatarView, for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) {
        // but not when its fucking setting the image
        if let message = message as? ChatMessage {
            avatarView.initials = message.lhSender.initials
            avatarView.kf.setImage(with: URL(string: message.lhSender.profileImageUrl))
        }
    }
    
    func enabledDetectors(for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> [DetectorType] {
        return [.url]
    }
    
    func detectorAttributes(for detector: DetectorType, and message: MessageType, at indexPath: IndexPath) -> [NSAttributedString.Key: Any] {
        if (detector == .url) {
            return [ NSAttributedString.Key.underlineStyle: NSUnderlineStyle.single.rawValue ]
        }
            return [NSAttributedString.Key.foregroundColor : UIColor.white]
    }
}

extension ChatThreadViewController : MessageCellDelegate, MessageLabelDelegate {
    
    func didTapMessage(in cell: MessageCollectionViewCell) {
        let indexPath = messagesCollectionView.indexPath(for: cell)
        guard let tappedCellIndexPath = indexPath else { return }
        let tappedMessage = messageForItem(at: tappedCellIndexPath, in: messagesCollectionView)
        if let message = tappedMessage as? ChatMessage {
            if let downloadURL = message.downloadURL {
                let imageViewerVC = ChatImageViewer()
                imageViewerVC.downloadURL = downloadURL
                present(imageViewerVC, animated: true)
            } else {
                print("Message does not contain image")
            }
        }
    }
    
    func didSelectURL(_ url: URL) {
        var comps = URLComponents(url: url, resolvingAgainstBaseURL: false)!
        comps.scheme = "https"
        let https = comps.url
        guard let httpsURL = https else { return }
        let webViewController = WebViewController(url: httpsURL, title: "Web")
        navigationController?.pushViewController(webViewController, animated: true)
    }
}
// MARK: - UIImagePickerControllerDelegate

extension ChatThreadViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        picker.dismiss(animated: true, completion: nil)
        if let asset = info[UIImagePickerController.InfoKey.phAsset] as? PHAsset {
            let size = CGSize(width: 500, height: 500)
            PHImageManager.default().requestImage(for: asset, targetSize: size, contentMode: .aspectFit, options: nil) { result, info in
                guard let image = result else {
                    return
                }

                self.sendPhoto(image)
            }
        } else if let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            sendPhoto(image)
        }
    }

    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }

}
