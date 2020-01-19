import UIKit

class TokenCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var label: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setupStyle()
        setupContentViewConstraints()
    }
    
    func setupStyle() {
        contentView.layer.cornerRadius = 5
        contentView.layer.masksToBounds = true
        
        backgroundColor = UIColor.init(hexString: "#BAEDFF")!
        
        label.textColor = .black
    }
    
    func setupContentViewConstraints() {
        contentView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([contentView.leftAnchor.constraint(equalTo: leftAnchor),
                                     contentView.rightAnchor.constraint(equalTo: rightAnchor),
                                     contentView.topAnchor.constraint(equalTo: topAnchor),
                                     contentView.bottomAnchor.constraint(equalTo: bottomAnchor)])
    }
}
