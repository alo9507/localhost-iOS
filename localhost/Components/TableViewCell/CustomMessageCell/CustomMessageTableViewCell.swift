import UIKit
import SnapKit

class CustomMessageTableViewCell: UITableViewCell {
    lazy var senderImageView: UIImageView = {
        let senderImageView = UIImageView()
        senderImageView.roundCorners()
        
        let placeholderImage = UIImage(named: "noProfilePhoto")
        let placeholderImageView = UIImageView(image: UIImage(named: "noProfilePhoto"))
        
        let imageUrlString =
        message?.lhSender.uid == currentUser.uid ? currentUser.profileImageUrl : recipient.profileImageUrl
        
        guard let imageUrl = URL(string: imageUrlString) else {
            return placeholderImageView
        }
        
        senderImageView.sd_setImage(with: imageUrl) { (image, error, _, _) in
            DispatchQueue.main.async {
                senderImageView.roundCorners()
            }
        }
        
        return senderImageView
    }()
    
    lazy var textBody: UITextView = {
        let textBody = UITextView()
        textBody.isUserInteractionEnabled = false
        textBody.text = message?.content
        textBody.frame = CGRect(x: 0, y: 0, width: 300, height: 30)
        
        if (message?.lhSender.uid == currentUser.uid) {
            textBody.backgroundColor =  UIColor.flatSkyBlue()
            textBody.textColor = .white
        } else {
            textBody.backgroundColor  =  UIColor.lightGray
            textBody.textColor = .black
        }
        
        textBody.font = UIFont(name: "AvenirNext-Bold", size: 15.0)!
        
        textBody.clipsToBounds = true
        textBody.layer.cornerRadius = 6.0
        
        return textBody
    }()
    
    var recipient: User = User(jsonDict: [:])
    var currentUser: User = User(jsonDict: [:])
    
    var message: ChatMessage? = nil {
        didSet {
            render()
        }
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
}

// MARK: Setup UI
extension CustomMessageTableViewCell {
    func render() {
        constructHierarchy()
        activateConstraints()
        generalSetup()
    }
    
    func generalSetup() {
        selectionStyle = .none
        contentView.backgroundColor = .clear
        backgroundColor = .clear
    }
    
    func constructHierarchy() {
        contentView.addSubview(senderImageView)
        contentView.addSubview(textBody)
    }
    
    func activateConstraints() {
        activateRecipientImageViewConstraints()
        activateTextBodyConstraints()
    }
    
    func activateRecipientImageViewConstraints() {
        senderImageView.snp.makeConstraints { (make) in
            make.width.height.equalTo(30)
            make.left.equalToSuperview()
            make.centerY.equalToSuperview()
        }
    }
    
    func activateTextBodyConstraints() {
        textBody.snp.makeConstraints { (make) in
            make.width.equalTo(300)
            make.height.equalTo(30)
            make.centerY.equalToSuperview()
            make.left.equalTo(senderImageView.snp.right).inset(-10)
        }
    }
}
