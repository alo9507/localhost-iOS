import Foundation

enum MatchingFilters {
    case isNotCurrentUser
    case isMatch
    case isNotMatch
    case nodReceivedButNotSent
    case nodSentButNotReceived
}

class MatchingFilter {
    class func userPassesFilters(currentUser: User?, otherUser: User, filters: [MatchingFilters]) -> Bool {
        var filterResult = true
        
        for filter in filters {
            switch filter {
            case .isNotCurrentUser:
                if currentUser?.uid == otherUser.uid { filterResult = false; break }
            case .isMatch:
                if currentUser?.determineUserRelationship(userUid: otherUser.uid) != .match { filterResult = false; break }
            case .nodReceivedButNotSent:
                if currentUser?.determineUserRelationship(userUid: otherUser.uid) != .inbound { filterResult = false; break }
            case .nodSentButNotReceived:
                if currentUser?.determineUserRelationship(userUid: otherUser.uid) != .outbound { filterResult = false; break }
            case .isNotMatch:
                if currentUser?.determineUserRelationship(userUid: otherUser.uid) == .match { filterResult = false; break }
            if filterResult == false { break }
            }
        }
        return filterResult
    }
}
