import UIKit
import SDWebImage
import SnapKit

class SpotFeedProfileTableViewCell: UITableViewCell {
    lazy var profileImageView: UIImageView = {
        let profileImageView = UIImageView()
        profileImageView.layer.cornerRadius = profileImageView.bounds.height / 2
        
        let placeholderImage = UIImage(named: "noProfilePhoto")
        let placeholderImageView = UIImageView(image: UIImage(named: "noProfilePhoto"))
        
        guard let imageUrl = URL(string: featuredUser.profileImageUrl) else {
            return placeholderImageView
        }
        
        profileImageView.sd_setImage(with: imageUrl) { (image, error, _, _) in
            DispatchQueue.main.async {
                profileImageView.roundCorners()
            }
        }
        
        if self.currentUser.inboundNotOutbound.contains(self.featuredUser.uid) {
            // add badge
            
        }
        
        return profileImageView
    }()
    
    lazy var name: UILabel = {
        let name = UILabel()
        name.textColor = .white
        name.font = Fonts.avenirNext_bold(15)
        name.text = featuredUser.firstName
        
        name.textColor = UIColor.init(hexString: "#31CAFF", withAlpha: 0.75)
        
        return name
    }()
    
    lazy var occupation: UILabel = {
        let occupation = UILabel()
        occupation.numberOfLines = 0
        occupation.text = featuredUser.currentOccupation()
        return occupation
    }()
    
    lazy var whatAmIDoing: UILabel = {
        let whatAmIDoing = UILabel()
        whatAmIDoing.numberOfLines = 0
        whatAmIDoing.text = featuredUser.whatAmIDoing
        return whatAmIDoing
    }()
    
    lazy var nodMessage: UILabel = {
        let nodMessage = UILabel()
        nodMessage.numberOfLines = 0
        nodMessage.text = "Makeshift nod message"
        return nodMessage
    }()
    
    var featuredUser: User  = User(jsonDict: [:]) {
        didSet {
            render()
        }
    }
    
    var currentUser: User = User(jsonDict: [:])
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        layer.cornerRadius = 25
        layer.masksToBounds = true
        backgroundColor = UIColor.clear
        contentView.backgroundColor = UIColor.clear
        selectionStyle = .none
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
}

extension SpotFeedProfileTableViewCell {
    func render() {
        constructHierarchy()
        activateConstraints()
    }
    
    func constructHierarchy() {
        contentView.addSubview(profileImageView)
        contentView.addSubview(name)
        contentView.addSubview(occupation)
        contentView.addSubview(whatAmIDoing)
    }
    
    func activateConstraints() {
        activateProfileImageViewConstraints()
        activateNameConstraints()
        activateOccupationConstraints()
        activateWhatAmIDoingConstraints()
    }
    
    func activateProfileImageViewConstraints() {
        profileImageView.snp.updateConstraints { (make) in
            make.left.equalToSuperview().inset(10)
            make.top.equalToSuperview().offset(20)
            make.height.equalTo(80)
            make.width.equalTo(80)
        }
    }
    
    func activateNameConstraints() {
        name.snp.updateConstraints { (make) in
            make.right.equalToSuperview().offset(5)
            make.left.equalTo(profileImageView.snp.right).offset(5)
            make.top.equalToSuperview().offset(5)
            make.bottom.equalTo(occupation.snp_top)
        }
    }
    
    func activateOccupationConstraints() {
        occupation.snp.updateConstraints { (make) in
            make.right.equalToSuperview().inset(5)
            make.left.equalTo(profileImageView.snp.right).offset(5)
            make.right.equalToSuperview().inset(2)
            make.top.equalTo(name.snp.bottom)
//            make.bottom.equalTo(whatAmIDoing.snp_top)
        }
    }
    
    func activateWhatAmIDoingConstraints() {
        whatAmIDoing.snp.updateConstraints { (make) in
            make.right.equalToSuperview().inset(5)
            make.left.equalTo(profileImageView.snp.left)
            make.top.equalTo(profileImageView.snp.bottom).offset(5)
            make.bottom.equalToSuperview().inset(12)
        }
    }

}
