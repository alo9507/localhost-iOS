import Foundation
import Firebase
import FirebaseFirestore
import FirebaseAuth
import GeoFire

public protocol UserRepository: class {
    var socialGraphRepository: SocialGraphRepository { get set }
    
    func createUser(registeringUser: User, profileImageData: Data, authSession: LHAuthSession, completion: @escaping LHResult<User>)
    
    func getUser(uid: String, completion: @escaping LHResult<User>)
    func getAllUsers(completion: @escaping LHResult<[User]>)
    func getLocalUsers(currentUser: User, completion: @escaping LHResult<[User]>)
    func getLocalAndFilteredUsers(currentUser: User, completion: @escaping LHResult<[User]>)
    
    func updateUser(userUid: String, data: Dictionary<String, Any>, completion: @escaping LHResult<User>)

    func deleteUser(user: User, completion: @escaping LHAuthErrorResponse)
}
