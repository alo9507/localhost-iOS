import UIKit
import SnapKit
import SDWebImage

class ProfileDetailView: NiblessView {
    lazy var profileDetailStackView: UIStackView = {
        let profileDetailStackView = UIStackView()
        profileDetailStackView.translatesAutoresizingMaskIntoConstraints = false
        profileDetailStackView.axis = .vertical
        profileDetailStackView.distribution = .fill
        profileDetailStackView.alignment = .center
        profileDetailStackView.spacing = 10
        return profileDetailStackView
    }()
    
    lazy var basicInfoStackView: ProfileDetailGroupStackView = ProfileDetailGroupStackView()
    
    lazy var profileImageView: UIImageView = {
        let profileImageView = UIImageView()
        profileImageView.frame = CGRect.zero
        profileImageView.isUserInteractionEnabled = true
        
        profileImageView.contentMode = .scaleAspectFill
        profileImageView.clipsToBounds = true
        
        let placeholderImage = UIImage(named: "noProfilePhoto")
        let placeholderImageView = UIImageView(image: UIImage(named: "noProfilePhoto"))
        
        guard let imageUrl = URL(string: featuredUser.profileImageUrl) else {
            return placeholderImageView
        }
        
        profileImageView.sd_setImage(with: imageUrl) { (image, error, _, _) in
            DispatchQueue.main.async {
                profileImageView.layoutIfNeeded()
                profileImageView.layoutSubviews()
            }
        }
        
        return profileImageView
    }()
    
    lazy var age: UILabel = {
        let age = UILabel()
        age.text = String(featuredUser.age)
        age.textAlignment = .left
        age.numberOfLines = 0
        age.textColor = .white
        
        age.addImage(imageName: "birthday", afterLabel: false)
        
        return age
    }()
    
    lazy var name: UILabel = {
        let name = UILabel()
        name.font = Fonts.avenirNext_bold(50)
        name.textColor = .white
        name.text = featuredUser.firstName
        name.textAlignment = .left
        name.numberOfLines = 0
        name.textColor = .white
        return name
    }()
    
    lazy var hometown: UILabel = {
        let hometown = UILabel()
        hometown.text = featuredUser.hometown
        age.textAlignment = .left
        hometown.numberOfLines = 0
        hometown.textColor = .white
        hometown.addImage(imageName: "pin", afterLabel: false)
        return hometown
    }()
    
    lazy var whatAmIDoing: UILabel = {
        let whatAmIDoing = UILabel()
        whatAmIDoing.text = featuredUser.whatAmIDoing
        whatAmIDoing.textAlignment = .center
        whatAmIDoing.numberOfLines = 0
        whatAmIDoing.textColor = .white
        return whatAmIDoing
    }()
    
    lazy var occupation: UILabel = {
        let occupation = UILabel()
        occupation.textAlignment = .center
        occupation.numberOfLines = 0
        occupation.sizeToFit()
        occupation.font = Fonts.avenirNext_bold(25)
        occupation.text = featuredUser.currentOccupation()
        occupation.textColor = .white
        return occupation
    }()
    
    lazy var currentSchool: UILabel = {
        let school = UILabel()
        if !featuredUser.education.isEmpty {
            school.text = featuredUser.education[0].school
        }
        school.font = Fonts.avenirNext_regular(20)
        school.textColor = .white
        school.textAlignment = .left
        school.numberOfLines = 0
        school.sizeToFit()
        school.addImage(imageName: "educate-school-icon", afterLabel: false)
        return school
    }()
    
    lazy var letsTalkeAboutStackView: ProfileDetailGroupStackView = ProfileDetailGroupStackView()
    lazy var topicsLabel: ProfileDetailGroupLabel = ProfileDetailGroupLabel("Let's talk about...")
    lazy var topics: UIStackView = {
        let topics = UIStackView()
        topics.translatesAutoresizingMaskIntoConstraints = false
        topics.axis = .vertical
        topics.distribution = .equalSpacing
        topics.alignment = .leading
        topics.spacing = 10
        for topic in featuredUser.topics {
            let topicLabel = UILabel()
            topicLabel.text = topic
            topicLabel.textColor = .white
            topicLabel.font = Fonts.avenirNext_demibold(25)
            topicLabel.textAlignment = .left
            topics.insertArrangedSubview(topicLabel, at: 0)
        }
        return topics
    }()
    
    lazy var skillsStackView: ProfileDetailGroupStackView = ProfileDetailGroupStackView()
    
    lazy var skillsLabel: UILabel = {
        let skillsLabel = UILabel()
        skillsLabel.textAlignment = .left
        skillsLabel.numberOfLines = 0
        skillsLabel.sizeToFit()
        skillsLabel.textColor = UIColor.lhPink
        skillsLabel.font = Fonts.avenirNext_bold(24)
        skillsLabel.text = "\(self.featuredUser.firstName)'s Skills"
        return skillsLabel
    }()
    lazy var skills: MyOrganizationsStackView = {
        let skillsStackView = MyOrganizationsStackView()
        skillsStackView.spacing = 0
        skillsStackView.alignment = .leading
        for skill in featuredUser.skills {
            let skillLabel = UILabel()
            skillLabel.text = skill
            skillLabel.textColor = .white
            skillLabel.font = Fonts.avenirNext_demibold(25)
            skillLabel.textAlignment = .left
            skillsStackView.insertArrangedSubview(skillLabel, at: 0)
        }
        return skillsStackView
    }()
    
    lazy var educationLabel: ProfileDetailGroupLabel = ProfileDetailGroupLabel("Education")
    lazy var educations: ProfileDetailGroupStackView = {
        let educationsStackView = ProfileDetailGroupStackView()
        educationsStackView.insertArrangedSubview(educationLabel, at: 0)
        for education in featuredUser.education {
            educationsStackView.insertArrangedSubview(EducationDescription(education, showEditIcon: self.origin == .myProfile), at: 1)
        }
        return educationsStackView
    }()
    
    lazy var affiliationLabel: ProfileDetailGroupLabel = ProfileDetailGroupLabel("Affiliations")
    lazy var affiliations: ProfileDetailGroupStackView = {
        let affiliationsStackView = ProfileDetailGroupStackView()
        affiliationsStackView.insertArrangedSubview(affiliationLabel, at: 0)
        for affiliation in featuredUser.affiliations {
            affiliationsStackView.insertArrangedSubview(AffiliationDescription(affiliation, showEditIcon: self.origin == .myProfile), at: 1)
        }
        return affiliationsStackView
    }()
    
    lazy var reportingButton: UIImageView = {
        let reportingButton = UIImageView(frame: .zero)
        reportingButton.image = UIImage(named: "flag")
        reportingButton.isUserInteractionEnabled = true
        reportingButton.contentMode = .scaleAspectFit
        reportingButton.addGestureRecognizer(UITapGestureRecognizer(target: self.viewModel, action: #selector(ProfileDetailViewModel.showOptionsMenu)))
        return reportingButton
    }()
    
    lazy var invisibleButton: UIImageView = {
        let invisibleButtonImageView = UIImageView(image: UIImage(named: "ghost"))
        invisibleButtonImageView.addGestureRecognizer(UITapGestureRecognizer(target: viewModel, action: #selector(ProfileDetailViewModel.makeSelfInvisible)))
        return invisibleButtonImageView
    }()
    lazy var questionMark: UILabel = {
        let questionMark = UILabel()
        questionMark.text = "?"
        return questionMark
    }()
    
    lazy var mutualConnectionCount: UILabel = {
        let mutualConnectionCount = UILabel()
        mutualConnectionCount.textColor = .white
        mutualConnectionCount.font = UIFont(name: "AvenirNext-Regular", size: 15)
        mutualConnectionCount.textAlignment = .left
        mutualConnectionCount.numberOfLines = 3
        mutualConnectionCount.sizeToFit()
        mutualConnectionCount.text = self.mutualConnectionsText
        return mutualConnectionCount
    }()
    
    var mutualConnectionsCount: Int {
        get {
            self.viewModel!.userSession.user.uid != self.featuredUser.uid ? self.viewModel!.userSession.user.mutual.intersection(self.viewModel!.featuredUser.mutual).count : 0
        }
    }
    
    var mutualConnectionsText: String {
        get {
            if self.mutualConnectionsCount == 0 {
                return ""
            } else {
                return self.mutualConnectionsCount == 1 ? "\(self.mutualConnectionsCount) mutual connection" : "\(self.mutualConnectionsCount) mutual connections"
            }
        }
    }
    
    let featuredUser: User
    weak var viewModel: ProfileDetailViewModel?
    let origin: Origin
    
    init(_ featuredUser: User, _ origin: Origin, _ viewModel: ProfileDetailViewModel) {
        self.featuredUser = featuredUser
        self.origin = origin
        self.viewModel = viewModel
        
        // can this just be .zero?
        super.init(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 2000))
        render()
    }
}

// MARK: Render
extension ProfileDetailView {
    public func render() {
        backgroundColor = UIColor.lhPurple
        
        constructHierarchy()
        activateConstraints()
    }
    
    func constructHierarchy() {
        addSubview(name)
        addSubview(profileImageView)
        addSubview(whatAmIDoing)
        addSubview(mutualConnectionCount)
        
        addSubview(profileDetailStackView)
        
        profileDetailStackView.addArrangedSubview(occupation)
        basicInfoStackView.addArrangedSubview(age)
        basicInfoStackView.addArrangedSubview(hometown)
        basicInfoStackView.addArrangedSubview(currentSchool)
        profileDetailStackView.addArrangedSubview(basicInfoStackView)
        
        profileDetailStackView.addArrangedSubview(affiliations)
        profileDetailStackView.addArrangedSubview(educations)
        
        letsTalkeAboutStackView.addArrangedSubview(topicsLabel)
        letsTalkeAboutStackView.addArrangedSubview(topics)
        profileDetailStackView.addArrangedSubview(letsTalkeAboutStackView)
        
        skillsStackView.addArrangedSubview(skillsLabel)
        skillsStackView.addArrangedSubview(skills)
        profileDetailStackView.addArrangedSubview(skillsStackView)
        
        profileDetailStackView.addArrangedSubview(reportingButton)
        profileDetailStackView.addArrangedSubview(invisibleButton)
    }
    
    func activateConstraints() {
        name.snp.makeConstraints { (make) in
            make.top.equalToSuperview()
            make.width.equalToSuperview()
            make.left.equalToSuperview().offset(10)
        }
        
        profileImageView.snp.makeConstraints { (make) in
            make.top.equalTo(name.snp.bottom).offset(5)
            make.width.height.equalTo(UIScreen.main.bounds.width)
        }
        
        occupation.snp.makeConstraints { (make) in
            make.top.equalTo(profileImageView.snp.bottom)
            make.width.equalToSuperview()
        }
        
        whatAmIDoing.snp.makeConstraints { (make) in
            make.top.equalTo(occupation.snp.bottom).offset(15)
            make.width.equalToSuperview().inset(5)
            make.centerX.equalToSuperview()
        }
        
        profileDetailStackView.snp.makeConstraints { (make) in
            make.top.equalTo(whatAmIDoing.snp.bottom).offset(15)
            make.right.equalTo(profileImageView.snp.right)
            make.left.equalTo(profileImageView.snp.left)
            make.bottom.equalToSuperview()
        }
        
        basicInfoStackView.snp.makeConstraints { (make) in
            make.top.equalToSuperview()
            make.width.equalToSuperview().inset(15)
        }
        
        age.snp.makeConstraints { (make) in
            make.height.equalTo(50)
            make.width.equalToSuperview()
        }
        
        hometown.snp.makeConstraints { (make) in
            make.height.equalTo(50)
            make.width.equalToSuperview()
        }
        
        affiliations.snp.makeConstraints { (make) in
            make.top.equalTo(basicInfoStackView.snp.bottom).offset(30)
            make.width.equalToSuperview().inset(15)
            make.centerX.equalToSuperview()
        }
        
        educations.snp.makeConstraints { (make) in
            make.top.equalTo(affiliations.snp.bottom).offset(30)
            make.width.equalToSuperview().inset(15)
            make.centerX.equalToSuperview()
        }
        
        mutualConnectionCount.snp.makeConstraints { (make) in
            make.width.equalToSuperview().inset(5)
            make.top.equalTo(whatAmIDoing.snp.bottom).offset(10)
            make.left.equalToSuperview().offset(15)
        }
        
        skillsStackView.snp.makeConstraints { (make) in
            make.top.equalTo(basicInfoStackView.snp.bottom)
            make.width.equalToSuperview().inset(15)
        }
        
        letsTalkeAboutStackView.snp.makeConstraints { (make) in
            make.top.equalTo(skillsStackView.snp.bottom)
            make.width.equalToSuperview().inset(15)
        }
        
        invisibleButton.snp.makeConstraints { (make) in
            make.height.width.equalTo(50)
        }
        
        // final thing MUST have its bottom pinned to the end
        reportingButton.snp.makeConstraints { (make) in
            make.height.width.equalTo(50)
            make.bottom.equalToSuperview()
        }
    }
}

extension UIStackView {
    func addBackground(color: UIColor = .clear,
                       borderColor: UIColor = .clear,
                       borderWidth: CGFloat = 0,
                       cornerRadius: CGFloat = 0,
                       shadowColor: UIColor = .clear,
                       shadowOpacity: Float = 0,
                       shadowRadius: CGFloat = 0,
                       shadowOffset: CGSize = .zero) {
        let subView = UIView(frame: bounds)
        subView.backgroundColor = color
        subView.layer.borderColor = borderColor.cgColor
        subView.layer.borderWidth = borderWidth
        subView.layer.cornerRadius = cornerRadius
        subView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        subView.applyShadow(color: shadowColor.cgColor, opacity: shadowOpacity, radius: shadowRadius, offset: shadowOffset)
        insertSubview(subView, at: 0)
    }
    
    func addSpacer(height: Int) {
        let spacer = UIView(frame: CGRect(x: 0, y: 0, width: Int(bounds.width), height: height))
        spacer.backgroundColor = .clear
        spacer.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        addSubview(spacer)
    }
}

extension UILabel
{
    func addImage(imageName: String, afterLabel bolAfterLabel: Bool = false)
    {
        let attachment: NSTextAttachment = NSTextAttachment()
        attachment.image = UIImage(named: imageName)
        let attachmentString: NSAttributedString = NSAttributedString(attachment: attachment)

        if (bolAfterLabel)
        {
            let strLabelText: NSMutableAttributedString = NSMutableAttributedString(string: self.text!)
            strLabelText.append(attachmentString)

            self.attributedText = strLabelText
        }
        else
        {
            if let text = self.text {
                let strLabelText: NSAttributedString = NSAttributedString(string: text)
                let mutableAttachmentString: NSMutableAttributedString = NSMutableAttributedString(attributedString: attachmentString)
                mutableAttachmentString.append(strLabelText)

                self.attributedText = mutableAttachmentString
            } else {
                let strLabelText: NSAttributedString = NSAttributedString(string: "")
                let mutableAttachmentString: NSMutableAttributedString = NSMutableAttributedString(attributedString: attachmentString)
                mutableAttachmentString.append(strLabelText)

                self.attributedText = mutableAttachmentString
            }
        }
    }

    func removeImage()
    {
        let text = self.text
        self.attributedText = nil
        self.text = text
    }
}
