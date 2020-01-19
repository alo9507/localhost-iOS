import UIKit
import SnapKit

class NewUserEducationThirdViewController: OnboardingViewController {
    
    lazy var mainLabel: UILabel = {
        let mainLabel = UILabel()
        mainLabel.text = "be you in public"
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

extension NewUserEducationThirdViewController {
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
