import UIKit

class RoundedButton: UIButton {
    
    var originalSize: CGRect?
    
    override func awakeFromNib() {
        setUpButtonView()
    }
    
    func setUpButtonView() {
        originalSize = frame
        
        layer.cornerRadius = 5.0
        
        layer.shadowOpacity = 0.5
        layer.shadowRadius = 10.0
        layer.shadowColor = UIColor.darkGray.cgColor
        layer.shadowOffset = CGSize.zero
    }
    
    func animateButton(shouldLoad: Bool, withMessage message: String?) {
        let spinner = UIActivityIndicatorView()
        
        spinner.style = UIActivityIndicatorView.Style.large
        spinner.color = UIColor.white
        spinner.alpha = 0.0
        spinner.hidesWhenStopped = true
        spinner.tag = 21
        
        if (shouldLoad) {
            setTitle("", for: .normal)
            UIView.animate(withDuration: 0.2, animations: {
                self.layer.cornerRadius = self.frame.height / 2
                // self.frame.midX
                self.frame = CGRect(x: self.frame.midX - (self.frame.height / 2), y: self.frame.origin.y, width: self.frame.height, height: self.frame.height)
            }) { (finished) in
                if (finished == true) {
                    self.addSubview(spinner)
                    spinner.startAnimating()
                    spinner.center = CGPoint(x: self.frame.width / 2, y: self.frame.width / 2 + 1)
                    spinner.fadeTo(alphaValue: 1.0, duration: 0.2)
                }
            }
            self.isUserInteractionEnabled = false
        } else {
            self.isUserInteractionEnabled = true
            
            for subview in self.subviews {
                if (subview.tag == 21) {
                    subview.removeFromSuperview()
                }
            }
            
            UIView.animate(withDuration: 0.2) {
                self.layer.cornerRadius = 5.0
                self.frame = self.originalSize!
                self.setTitle(message, for: .normal)
            }
        }
    }

}
