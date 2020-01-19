import Foundation

enum MatchingFilters {
    case isMatch
    case isNotMatch
    case noddedAtCurrentUser
}

class MatchingFilter {
    class func userPassesFilters(currentUser: User?, otherUser: User, filters: [MatchingFilters]) -> Bool {
        var filterResult = true
        
        for filter in filters {
            switch filter {
            case .isMatch:
                if currentUser?.determineUserRelationship(userUid: otherUser.uid) != .match { filterResult = false; break }
            case .noddedAtCurrentUser:
                if currentUser?.determineUserRelationship(userUid: otherUser.uid) != .nodReceivedButNotSent { filterResult = false; break }
            case .isNotMatch:
                if currentUser?.determineUserRelationship(userUid: otherUser.uid) == .match { filterResult = false; break }
            if filterResult == false { break }
            }
        }
        return filterResult
    }
}
