import UIKit

class RoundedTextField: UITextField {

    var textRectOffset: CGFloat = 20
    
    override func awakeFromNib() {
        setupStyle()
    }
    
    func setupStyle() {
        layer.cornerRadius = frame.height
    }
    
//    override func textRect(forBounds bounds: CGRect) -> CGRect {
//        return CGRect(x: 0 + textRectOffset, y: 0+(textRectOffset / 2), width: self.frame.width - textRectOffset, height: self.frame.height + textRectOffset)
//    }
//
//    override func editingRect(forBounds bounds: CGRect) -> CGRect {
//            return CGRect(x: 0 + textRectOffset, y: 0+(textRectOffset / 2), width: self.frame.width - textRectOffset, height: self.frame.height + textRectOffset)
//    }
}
