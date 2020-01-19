import UIKit

class CircleView: UIView {
    
    @IBInspectable var borderColor: UIColor? {
        didSet {
            setupStyle()
        }
    }
    
    override func awakeFromNib() {
        setupStyle()
    }
    
    func setupStyle() {
        layer.cornerRadius = frame.width / 2
        layer.borderWidth = 1.5
        layer.borderColor = borderColor?.cgColor
    }

}
