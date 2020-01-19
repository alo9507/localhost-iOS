import FirebaseFirestore
import FirebaseFirestore.FIRGeoPoint
import MessageKit

public class User: Codable, GenericBaseModel {
    // BASIC INFO
    var uid: String = ""
    var firstName: String = ""
    var lastName: String = ""
    var age: Int = 0
    var hometown: String = ""
    
    // VISIBILITY
    var isVisible: Bool = true
    var isOnline: Bool = false
    var location: GeoPoint = GeoPoint(latitude: 0.0, longitude: 0.0)
    var testLocation: String = ""
    var loadUsersFrom: String = ""
    var locationPreference: String? = nil
    var visibilitySettings: VisibilitySettings = VisibilitySettings()
    var showMy: [String]
    
    // IMAGES
    var profileImageUrl: String = ""
    var photos: [String]? = nil
    var instagramPhotos: [String]? = nil
    
    // CAREER
    var affiliations: [Affiliation]
    var education: [Education]
    var skills: [String] = []
    var whatAmIDoing: String = ""
    var maritalStatus: String = ""
    
    // ACCOUNT INFORMATION
    var email: String = ""
    var phoneNumber: String = ""
    var password: String = ""
    var pushToken: String = ""
    
    // SOCIALS
    var topics: [String]
    
    var lookingFor: [String] = []
    var offering: [String] = []
    
    // DATING
    var sex: Sex = .all
    var sexualOrientation: SexualOrientation = .all
    var gender: String? = nil
    var genderPreference: String? = nil
    
    // ABOUT ME
    var bio: String? = nil
    var modusOperandi: String? = nil
    
    // SOCIAL GRAPH
    var inbound: Set<String> = Set<String>()
    var outbound: Set<String> = Set<String>()
    
    required init(jsonDict: [String : Any]) {
        self.uid = ""
        self.firstName = jsonDict["firstName"] as? String ?? ""
        self.lastName = jsonDict["lastName"] as? String ?? ""
        self.location = jsonDict["location"] as? GeoPoint ?? GeoPoint(latitude: 0.0, longitude: 0.0)
        self.isVisible = jsonDict["isVisible"] as? Bool ?? true
        self.profileImageUrl = jsonDict["profileImageUrl"] as? String ?? ""
        self.whatAmIDoing = jsonDict["whatAmIDoing"] as? String ?? ""
        self.email = jsonDict["email"] as? String ?? ""
        self.password = jsonDict["password"] as? String ?? ""
        self.lookingFor = jsonDict["lookingFor"] as? [String] ?? []
        self.offering = jsonDict["offering"] as? [String] ?? []
        self.loadUsersFrom = jsonDict["loadUsersFrom"] as? String ?? ""
        self.testLocation = jsonDict["testLocation"] as? String ?? ""
        self.skills = jsonDict["skills"] as? [String] ?? []
        self.sex = .all
        self.sexualOrientation = jsonDict["sexualOrientation"] as? SexualOrientation ?? .all
        self.age = jsonDict["age"] as? Int ?? 0
        self.pushToken = jsonDict["fcmToken"] as? String ?? ""
        self.photos = jsonDict["photos"] as? [String] ?? []
        self.education = jsonDict["education"] as? [Education] ?? []
        self.bio = jsonDict["bio"] as? String ?? ""
        self.gender = jsonDict["gender"] as? String ?? ""
        self.genderPreference = jsonDict["genderPreference"] as? String ?? ""
        self.locationPreference = jsonDict["locationPreference"] as? String ?? ""
        self.instagramPhotos = jsonDict["instagramPhotos"] as? [String] ?? []
        self.modusOperandi = jsonDict["modusOperandi"] as? String ?? ""
        self.affiliations = jsonDict["affiliations"] as? [Affiliation] ?? []
        self.phoneNumber = jsonDict["phoneNumber"] as? String ?? ""
        self.topics = jsonDict["topics"] as? [String] ?? []
        self.showMy = jsonDict["showMy"] as? [String] ?? []
        self.hometown = jsonDict["hometown"] as? String ?? ""
        self.maritalStatus = jsonDict["maritalStatus"] as? String ?? ""
        
        let vizSettings = jsonDict["visibilitySettings"] as? [String:Any] ?? [
                "sex": "all",
                "upperAgeBound": 100,
                "lowerAgeBound": 0,
                "sexualOrientation": "all",
                "testSetting": "eclecticCafe"
        ]
        
        self.visibilitySettings = VisibilitySettings(dictionary: vizSettings)
        self.description = ""
    }
    
    public var description: String
    
    func copy() -> User {
        let copy = User(jsonDict: self.documentData)
        return copy
    }
    
    var initials: String {
        if let f = self.firstName.first, let l = self.lastName.first {
            return String(f) + String(l)
        }
        return "?"
    }
    
    public func fullName() -> String {
        return "\(self.firstName) \(self.lastName)"
    }
    
    public func currentOccupation() -> String {
        guard let currentOccupation = affiliations.filter({ $0.endDate == "Present" }).first else {
            return ""
        }
        return "\(currentOccupation.role) @ \(currentOccupation.organizationName)"
    }
    
    public func firstWordFromName() -> String {
        return self.firstName.components(separatedBy: " ").first!
    }
    
    var isComplete: Bool {
        if profileImageUrl == "" {
            return false
        }
        // return the fields which constitute done
        return true
    }
    
    var mutual: Set<String> {
        return self.inbound.intersection(self.outbound)
    }
    
    var outboundNotInbound: Set<String> {
        return self.outbound.subtracting(self.inbound)
    }
    
    var inboundNotOutbound: Set<String> {
        return self.inbound.subtracting(self.outbound)
    }
    
    convenience init(uid: String, firstName: String, lastName: String, profileImageUrl: String) {
        self.init(jsonDict: [:])
        self.uid = uid
        self.firstName = firstName
        self.lastName = lastName
        self.profileImageUrl = profileImageUrl
    }
    
    func parseAffiliations(_ dictionary: Array<Any>?) -> [Affiliation] {
        guard let affiliations = dictionary else { return [] }
        let parsedAffiliations: [Affiliation] = affiliations.compactMap { Affiliation($0 as? [String: String])}
        return parsedAffiliations
    }
    
    func parseEducation(_ dictionary: Array<Any>?) -> [Education] {
        guard let educations = dictionary else { return [] }
        let parsedEducations: [Education] = educations.compactMap { Education($0 as? [String: String])}
        return parsedEducations
    }
        
    convenience init(documentId: String, dictionary: [String:Any]) {
        self.init(jsonDict: [:])
        self.uid = documentId
        self.firstName = dictionary["firstName"] as? String ?? ""
        self.lastName = dictionary["lastName"] as? String ?? ""
        self.location = dictionary["location"] as? GeoPoint ?? GeoPoint(latitude: 0.0, longitude: 0.0)
        self.isVisible = dictionary["isVisible"] as? Bool ?? true
        self.profileImageUrl = dictionary["profileImageUrl"] as? String ?? ""
        self.whatAmIDoing = dictionary["whatAmIDoing"] as? String ?? ""
        self.email = dictionary["email"] as? String ?? ""
        self.password = dictionary["password"] as? String ?? ""
        self.lookingFor = dictionary["lookingFor"] as? [String] ?? []
        self.offering = dictionary["offering"] as? [String] ?? []
        self.loadUsersFrom = dictionary["loadUsersFrom"] as? String ?? ""
        self.testLocation = dictionary["testLocation"] as? String ?? ""
        self.skills = dictionary["skills"] as? [String] ?? []
        self.sex = Sex(rawValue: (dictionary["sex"] as! String))!
        self.sexualOrientation = dictionary["sexualOrientation"] as? SexualOrientation ?? .all
        self.age = dictionary["age"] as? Int ?? 0
        self.pushToken = dictionary["fcmToken"] as? String ?? ""
        self.photos = dictionary["photos"] as? [String] ?? []
        self.topics = dictionary["topics"] as? [String] ?? []
        self.education = parseEducation(dictionary["education"] as? Array<Any>)
        self.bio = dictionary["bio"] as? String ?? ""
        self.gender = dictionary["gender"] as? String ?? ""
        self.genderPreference = dictionary["genderPreference"] as? String ?? ""
        self.locationPreference = dictionary["locationPreference"] as? String ?? ""
        self.instagramPhotos = dictionary["instagramPhotos"] as? [String] ?? []
        self.modusOperandi = dictionary["modusOperandi"] as? String ?? ""
        self.affiliations = parseAffiliations(dictionary["affiliations"] as? Array<Any>)
        self.phoneNumber = dictionary["phoneNumber"] as? String ?? ""
        self.showMy = dictionary["showMy"] as? [String] ?? []
        self.hometown = dictionary["hometown"] as? String ?? ""
        self.maritalStatus = dictionary["maritalStatus"] as? String ?? ""
        
        let vizSettings = dictionary["visibilitySettings"] as? [String:Any] ?? [
                "sex": "all",
                "upperAgeBound": 100,
                "lowerAgeBound": 0,
                "sexualOrientation": "all",
                "testSetting": "eclecticCafe"
        ]
        
        self.visibilitySettings = VisibilitySettings(dictionary: vizSettings)
    }
    
    func determineUserRelationship(userUid: String) -> UserRelationship {
        let mutual = self.mutual.contains(userUid)
        let inboundNotOutbound = self.inboundNotOutbound.contains(userUid)
        let outboundNotInbound = self.outboundNotInbound.contains(userUid)
        
        if (mutual) {
            return UserRelationship.match
        } else if (outboundNotInbound) {
            return UserRelationship.outbound
        } else if (inboundNotOutbound) {
            return UserRelationship.inbound
        } else {
            return UserRelationship.noRelation
        }
    }
    
    func determineVennProfile(user: User) -> VennProfile {
        let vennProfile: VennProfile = VennProfile(currentUser: self, otherUser: user)
        return vennProfile
    }
    
}

extension User {
    
    convenience init?(document: QueryDocumentSnapshot) {
        self.init(documentId: document.documentID, dictionary: document.data())
    }

    convenience init?(document: DocumentSnapshot) {
        guard let data = document.data() else { return nil }
        self.init(documentId: document.documentID, dictionary: data)
    }
    
    var documentData: [String: Any] {
        let parsedAffiliations: [[String: String]] = {
            var affiliationsArray: [[String: String]] = [[String: String]]()

            for (index, affiliation) in self.affiliations.enumerated() {
                affiliationsArray.append(affiliation.documentData)
            }
            
            return affiliationsArray
        }()
        
        let parsedEducation: [[String: String]] = {
            var educationArray: [[String: String]] = [[String: String]]()

            for (index, education) in self.education.enumerated() {
                educationArray.append(education.documentData)
            }
            
            return educationArray
        }()
        
        return [
                "uid": self.uid,
                "firstName": self.firstName,
                "lastName": self.lastName,
                "location": self.location,
                "isVisible": self.isVisible,
                "profileImageUrl": self.profileImageUrl,
                "whatAmIDoing": self.whatAmIDoing,
                "email": self.email,
                "password": self.password,
                "lookingFor": self.lookingFor,
                "offering": self.offering,
                "testLocation": self.testLocation,
                "loadUsersFrom": self.loadUsersFrom,
                "skills": self.skills,
                "sex": self.sex.rawValue,
                "sexualOrientation": self.sexualOrientation.rawValue,
                "visibilitySettings": self.visibilitySettings.dictionary,
                "pushToken": self.pushToken,
                "photos": self.photos ?? "",
                "education": parsedEducation,
                "bio": self.bio ?? "",
                "gender": self.gender ?? "",
                "genderPreference": self.genderPreference ?? "",
                "locationPreference": self.locationPreference ?? "",
                "instagramPhotos": self.instagramPhotos ?? "",
                "modusOperandi": self.modusOperandi ?? "",
                "affiliations": parsedAffiliations,
                "phoneNumber": self.phoneNumber,
                "topics": self.topics,
                "age": self.age,
                "showMy": self.showMy,
                "hometown": self.hometown,
                "maritalStatus": self.maritalStatus
            ]
    }
}

extension User: Equatable {
    public static func ==(lhs: User, rhs: User) -> Bool {
        return lhs.uid == rhs.uid
    }
}
