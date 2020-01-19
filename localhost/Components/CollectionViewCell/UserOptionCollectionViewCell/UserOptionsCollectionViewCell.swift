import UIKit

class UserOptionsCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var userOptionLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        let selectedBackgroundView = UIView(frame: self.frame)
        selectedBackgroundView.backgroundColor = UIColor.init(hexString: "#114B5E", withAlpha: 0.75)
        self.selectedBackgroundView = selectedBackgroundView
    }

}
