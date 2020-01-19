import UIKit

class RoundImageView: UIImageView {
    
    override func awakeFromNib() {
        setupStyle()
    }
    
    func setupStyle() {
        layer.cornerRadius = frame.width / 2
        clipsToBounds = true
    }

}
