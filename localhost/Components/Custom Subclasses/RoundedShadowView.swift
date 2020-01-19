import UIKit

class RoundedShadowView: UIView {

    override func awakeFromNib() {
        setupStyle()
    }
    
    func setupStyle() {
        layer.shadowOpacity = 0.3
        layer.shadowColor = UIColor.darkGray.cgColor
        layer.shadowRadius = 5
        
        // not changing width/height of shadow. Just how far left/right
        // width = 0 : don't slide on width of shape
        // height = 5 : positive number on y-axis moves it down
        layer.shadowOffset = CGSize(width: 0, height: 5)
        
        layer.cornerRadius = 5.0
    }

}
