import Foundation
import UIKit

extension UINavigationBar {
    func clear() {
        setBackgroundImage(UIImage(), for: .default)
        shadowImage = UIImage()
        isTranslucent = true
    }
}
