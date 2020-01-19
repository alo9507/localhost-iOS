import Foundation

extension Notification.Name {
    static let RegisteredUserInfoDidChange
        = NSNotification.Name("RegisteredUserInfoDidChange")
    
    static let CurrentUserDidChange = Notification.Name(rawValue: "CurrentUserDidChangeNotificationName")
}
