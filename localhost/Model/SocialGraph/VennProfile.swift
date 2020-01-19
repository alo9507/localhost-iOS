import Foundation

class VennProfile: Codable {
    var giverMatch: [String] = []
    var benefactorMatch: [String] = []
    
    init(currentUser: User, otherUser: User) {
        
        currentUser.offering.forEach { (goal) in
            if otherUser.lookingFor.contains(goal) { giverMatch.append(goal) }
        }
        
        currentUser.lookingFor.forEach { (goal) in
            if otherUser.offering.contains(goal) { benefactorMatch.append(goal) }
        }
    }
    
    init() {}
    
    func getDisplayText() -> [String] {
        var vennDisplayText: [String] = []
        
        vennDisplayText.append(contentsOf: benefactorMatch)
        vennDisplayText.append(contentsOf: giverMatch)
        return vennDisplayText
    }
    
}
