import UIKit
import SnapKit

class NewUserEducationFirstViewController: OnboardingViewController {
    
    lazy var mainLabel: UILabel = {
        let mainLabel = UILabel()
        mainLabel.text = "social media isn't social anymore"
        mainLabel.numberOfLines = 2
        mainLabel.textAlignment = .center
        mainLabel.textColor = .white
        mainLabel.font = Fonts.avenirNext_bold(20)
        return mainLabel
    }()
    
    var showRegistration: (() -> Void)?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.lhPurple
        render()
    }
    
}

extension NewUserEducationFirstViewController {
    private func render() {
        constructHierarchy()
        activateConstraints()
    }
    
    func constructHierarchy() {
        inputContainer.addSubview(mainLabel)
    }
    
    func activateConstraints() {
        mainLabel.snp.makeConstraints { (make) in
            make.width.equalTo(view.bounds.width/1.8)
            make.top.equalToSuperview()
            make.centerX.equalToSuperview()
        }
    }
}
