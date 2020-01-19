import UIKit

class MainTabBarController: NiblessTabBarController {
    
    var yourCircleNavigationController: CustomNavigationViewController
    var spotFeedNavigationController: CustomNavigationViewController
    var settingsNavigationController: CustomNavigationViewController
    
    init(
        yourCircleNavigationController: CustomNavigationViewController,
        spotFeedNavigationController: CustomNavigationViewController,
        settingsNavigationController: CustomNavigationViewController) {
            self.yourCircleNavigationController = yourCircleNavigationController
            self.spotFeedNavigationController = spotFeedNavigationController
            self.settingsNavigationController = settingsNavigationController
            super.init()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        settingsNavigationController.tabBarItem = UITabBarItem(title: nil, image: LocalhostStyleKit.imageOfProfile(), tag: 0)
        settingsNavigationController.tabBarItem.imageInsets = UIEdgeInsets(top: 6, left: 0, bottom: -6, right: 0)
        
        spotFeedNavigationController.tabBarItem = UITabBarItem(title: nil, image: LocalhostStyleKit.imageOfTarget(), tag: 1)
        spotFeedNavigationController.tabBarItem.imageInsets = UIEdgeInsets(top: 6, left: 0, bottom: -6, right: 0)
        
        yourCircleNavigationController.tabBarItem = UITabBarItem(title: nil, image: LocalhostStyleKit.imageOfYourCircle(), tag: 2)
        yourCircleNavigationController.tabBarItem.imageInsets = UIEdgeInsets(top: 6, left: 0, bottom: -6, right: 0)
        
        let tabBarList = [settingsNavigationController, spotFeedNavigationController, yourCircleNavigationController]
        
        viewControllers = tabBarList
        
        delegate = self
        tabBarController?.delegate = self
        selectedIndex = 1
        
        tabBar.clear()
        
        // this clears the line above the tabbar
        tabBar.shadowImage = UIImage()
        tabBar.backgroundImage = UIImage()
        tabBar.clipsToBounds = true
    }

}

extension MainTabBarController: UITabBarControllerDelegate  {
    func tabBarController(_ tabBarController: UITabBarController, shouldSelect viewController: UIViewController) -> Bool {
        
        guard let fromView = selectedViewController?.view, let toView = viewController.view else {
            return false // Make sure you want this as false
        }
        
        if fromView != toView {
            UIView.transition(from: fromView, to: toView, duration: 0.15, options: [.transitionCrossDissolve], completion: nil)
        }
        
        return true
    }
}
