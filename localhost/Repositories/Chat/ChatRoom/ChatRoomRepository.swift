import Foundation
import Firebase
import FirebaseFirestore

protocol ChatRoomRepository: Codable {
    static func subscribeToMessages(channel: ChatChannel, completion: @escaping LHResult<DocumentChange>)
    static func sendMessage(channel: ChatChannel, message: ChatMessage, completion: @escaping LHResult<ChatMessage>)
    static func uploadImage(_ image: UIImage, to channel: ChatChannel, completion: @escaping (URL?) -> Void)
    func updateCurrentUserIsTyping(currentUser: User, recipient: User, completion: @escaping LHResult<Bool>)
    func listenForTyping(currentUser: User, recipient: User, completion: @escaping LHResult<Bool>)
}
