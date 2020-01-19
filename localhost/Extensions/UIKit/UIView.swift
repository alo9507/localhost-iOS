import UIKit

extension UIView {
    
    public func applyShadow(color: CGColor, opacity: Float, radius: CGFloat, offset: CGSize) {
        layer.shadowColor = color
        layer.shadowOpacity = opacity
        layer.shadowOffset = offset
        layer.shadowRadius = radius
        layer.name = "shadow"
    }
    
    func fadeTo(alphaValue: CGFloat, duration: TimeInterval) {
        UIView.animate(withDuration: duration) {
            self.alpha = alphaValue
        }
    }
    
    func bindToKeyboard() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillChange(_:)), name: UIResponder.keyboardWillChangeFrameNotification, object: nil)
    }
    
    func addTapGestureRecognizer(tapHandler: Selector?) {
        let tap = UITapGestureRecognizer(target: self, action: tapHandler)
        self.addGestureRecognizer(tap)
    }
    
    @objc func keyboardWillChange(_ notification: NSNotification) {
        let duration = notification.userInfo![UIResponder.keyboardAnimationDurationUserInfoKey] as! Double
        let curve = notification.userInfo![UIResponder.keyboardAnimationCurveUserInfoKey] as! UInt
        let curFrame = (notification.userInfo![UIResponder.keyboardFrameBeginUserInfoKey] as! NSValue).cgRectValue
        let targetFrame = (notification.userInfo![UIResponder.keyboardFrameEndUserInfoKey] as! NSValue).cgRectValue
        let deltaY = targetFrame.origin.y - curFrame.origin.y
    
        UIView.animateKeyframes(withDuration: duration, delay: 0, options: UIView.KeyframeAnimationOptions(rawValue: curve), animations: {
            self.frame.origin.y += deltaY
        }, completion: nil)
    }
    
    func setGradientBackground(colorOne: UIColor, colorTwo: UIColor) {
        
        let gradientLayer = CAGradientLayer()
        
        gradientLayer.frame = bounds
        gradientLayer.colors = [colorOne.cgColor, colorTwo.cgColor]
        gradientLayer.locations = [0.0, 1.0]
        gradientLayer.startPoint = CGPoint(x: 1.0, y: 1.0)
        gradientLayer.endPoint = CGPoint(x: 0.0, y: 0.0)
        
        layer.insertSublayer(gradientLayer, at: 0)
        
    }
    
    func setGradientBackground(colorArray: [CGColor]) {
        
        backgroundColor = .clear
        
//        let gradientLayer = CAGradientLayer(start: .topLeft, end: .bottomRight, colors: colorArray, type: .axial)

        let gradientLayer = CAGradientLayer()
        gradientLayer.frame = bounds
        gradientLayer.colors = colorArray
        // top heavy
        gradientLayer.locations = [0.0, 1.0]

        // diagonal gradient
        gradientLayer.startPoint = CGPoint(x: 1.0, y: 1.0)
        gradientLayer.endPoint = CGPoint(x: 0.0, y: 0.0)
        
        layer.insertSublayer(gradientLayer, at: 0)
        
    }
    
    func findViewController() -> UIViewController? {
        if let nextResponder = self.next as? UIViewController {
            return nextResponder
        } else if let nextResponder = self.next as? UIView {
            return nextResponder.findViewController()
        } else {
            return nil
        }
    }
    
    func findNavigationController() -> UINavigationController? {
        if let nextResponder = self.next as? UINavigationController {
            return nextResponder
        } else if let nextResponder = self.next as? UIView {
            return nextResponder.findNavigationController()
        } else if let nextResponder = self.next as? UIViewController {
            return nextResponder.findNavigationController()
        } else {
            return nil
        }
    }
    
    func findTabBarController() -> UITabBarController? {
        if let nextResponder = self.next as? UITabBarController {
            return nextResponder
        } else if let nextResponder = self.next as? UIView {
            return nextResponder.findTabBarController()
        } else if let nextResponder = self.next as? UIViewController {
            return nextResponder.findTabBarController()
        } else {
            return nil
        }
    }
    
}

extension UIView {
    private static let kRotationAnimationKey = "rotationanimationkey"

    func rotate(duration: Double = 1) {
        if layer.animation(forKey: UIView.kRotationAnimationKey) == nil {
            let rotationAnimation = CABasicAnimation(keyPath: "transform.rotation")

            rotationAnimation.fromValue = 0.0
            rotationAnimation.toValue = Float.pi * 2.0
            rotationAnimation.duration = duration
            rotationAnimation.repeatCount = Float.infinity

            layer.add(rotationAnimation, forKey: UIView.kRotationAnimationKey)
        }
    }

    func stopRotating() {
        if layer.animation(forKey: UIView.kRotationAnimationKey) != nil {
            layer.removeAnimation(forKey: UIView.kRotationAnimationKey)
        }
    }
}
