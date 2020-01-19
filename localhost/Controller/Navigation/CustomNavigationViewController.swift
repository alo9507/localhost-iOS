import UIKit

class CustomNavigationViewController: NiblessNavigationController {

    init(rootViewController: UIViewController) {
        super.init()
        setViewControllers([rootViewController], animated: false)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if #available(iOS 13.0, *) {
            let standard = UINavigationBarAppearance()
            standard.configureWithOpaqueBackground()
            standard.backgroundColor = UIColor.lhPurple
            standard.titleTextAttributes = [
                NSAttributedString.Key.foregroundColor: UIColor.white,
                NSAttributedString.Key.font: UIFont(name: "AvenirNext-Bold", size: 22.0)!
            ]
            navigationBar.standardAppearance = standard
        } else {
            UINavigationBar.appearance().titleTextAttributes = [
                NSAttributedString.Key.foregroundColor: UIColor.white
            ]
            UINavigationBar.appearance().barTintColor = UIColor.init(hexString: "#9917C4", withAlpha: 0.25)
        }
    }

}
