import Foundation
import Firebase
import FirebaseFirestore
import FirebaseStorage

let DB_BASE = Firestore.firestore()

class FirestoreDataService {
    static let instance = FirestoreDataService()
    
    private let _REF_BASE = DB_BASE
    private let _REF_USERS = DB_BASE.collection("users")
    private let _REF_CHATS = DB_BASE.collection("channels")
    private let _STORAGE = Storage.storage().reference()
    
    var REF_BASE: Firestore {
        return _REF_BASE
    }
    
    var REF_USERS: CollectionReference {
        return _REF_USERS
    }
    
    var REF_CHATS: CollectionReference {
        return _REF_CHATS
    }
    
    var STORAGE: StorageReference {
        return _STORAGE
    }
    
}
