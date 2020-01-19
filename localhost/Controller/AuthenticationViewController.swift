import UIKit
import SVProgressHUD

class AuthenticationViewController: NiblessViewController, AuthenticationViewControllerDelegate {
    var localhostLabel: UILabel = {
        let localhostLabel = UILabel()
        localhostLabel.text = "localhost"
        localhostLabel.textAlignment = .center
        localhostLabel.font = Fonts.avenirNext_bold(70)
        localhostLabel.textColor = UIColor.lhYellow
        return localhostLabel
    }()
    
    var sloganLabel: UILabel = {
        let sloganLabel = UILabel()
        sloganLabel.text = "make it happen"
        sloganLabel.textAlignment = .center
        sloganLabel.font = Fonts.avenirNext_demibold(30)
        sloganLabel.textColor = UIColor.lhTurquoise
        return sloganLabel
    }()
    
    var emailTextField: OnboardingTextField = {
        let emailTextField = OnboardingTextField(placeholder: "email or phone number", keyboardType: .default)
        return emailTextField
    }()
    
    var passwordTextField: OnboardingTextField = {
        let passwordTextField = OnboardingTextField(placeholder: "password", keyboardType: .default)
        passwordTextField.isSecureTextEntry = true
        return passwordTextField
    }()
    
    lazy var authenticationButton: UIButton = {
        let authenticationButton = UIButton()
        
        let attributedTitle = NSAttributedString(string: "login", attributes: [
            NSAttributedString.Key.foregroundColor : UIColor.lhYellow,
            NSAttributedString.Key.font: Fonts.avenirNext_bold(28)
        ])
        
        authenticationButton.setAttributedTitle(attributedTitle, for: .normal)
        authenticationButton.layer.cornerRadius = 20
        authenticationButton.contentEdgeInsets = UIEdgeInsets(top: 8, left: 8, bottom: 8, right: 8)
        
        authenticationButton.backgroundColor = UIColor.lhTurquoise
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(login))
        tapGesture.numberOfTapsRequired = 1
        authenticationButton.addGestureRecognizer(tapGesture)
        
        return authenticationButton
    }()
    
    lazy var forgotPasswordLabel: UILabel = {
        let forgotPasswordLabel = UILabel()
        forgotPasswordLabel.textAlignment = .right
        forgotPasswordLabel.text = "Forgot password?"
        forgotPasswordLabel.font = Fonts.avenirNext_boldItalic(14)
        forgotPasswordLabel.textColor = .white
        let tapGesture = UITapGestureRecognizer(target: viewModel, action: #selector(AuthenticationViewModel.forgotPassword))
        tapGesture.numberOfTapsRequired = 1
        forgotPasswordLabel.addGestureRecognizer(tapGesture)
        forgotPasswordLabel.isUserInteractionEnabled = true
        return forgotPasswordLabel
    }()
    
    lazy var registerButton: UIButton = {
        let authenticationButton = UIButton()
        
        let attributedTitle = NSAttributedString(string: "join localhost", attributes: [
            NSAttributedString.Key.foregroundColor : UIColor.lhYellow,
            NSAttributedString.Key.font: Fonts.avenirNext_bold(28)
        ])
        
        authenticationButton.setAttributedTitle(attributedTitle, for: .normal)
        authenticationButton.layer.cornerRadius = 20
        authenticationButton.contentEdgeInsets = UIEdgeInsets(top: 8, left: 8, bottom: 8, right: 8)
        
        authenticationButton.backgroundColor = UIColor.lhTurquoise
        
        let tapGesture = UITapGestureRecognizer(target: viewModel, action: #selector(AuthenticationViewModel.registerButtonPressed))
        tapGesture.numberOfTapsRequired = 1
        authenticationButton.addGestureRecognizer(tapGesture)
        
        return authenticationButton
    }()
    
    var currentUser: User? = nil
    let viewModel: AuthenticationViewModel
    
    init(viewModel: AuthenticationViewModel) {
        self.viewModel = viewModel
        super.init()
        viewModel.delegate = self
        view.backgroundColor = UIColor.init(hexString: "#4450C7", withAlpha: 1.0)
        render()
    }
    
    override func viewDidLoad() {
        let tap = UITapGestureRecognizer(target: viewModel, action: #selector(AuthenticationViewModel.hideKeyboard))
        view.addGestureRecognizer(tap)
    }
    
    deinit {
        UserSessionStore.unsubscribe(viewModel)
    }

}

// MARK: RENDER
extension AuthenticationViewController {
    func render() {
        setupView()
        configureNavigationBar()
    }
    
    func configureNavigationBar() {
        let backButton = UIBarButtonItem(title: "< Settings", style: UIBarButtonItem.Style.plain, target: self, action: #selector(goBack))
        navigationItem.leftBarButtonItem = backButton
        navigationItem.leftBarButtonItem?.setTitleTextAttributes([
            NSAttributedString.Key.font: UIFont(name: "AvenirNext-Bold", size: 22.0)!,
            NSAttributedString.Key.foregroundColor: UIColor.white
        ], for: .normal)
        navigationItem.leftBarButtonItem?.setTitleTextAttributes([
            NSAttributedString.Key.font: UIFont(name: "AvenirNext-Bold", size: 22.0)!,
            NSAttributedString.Key.foregroundColor: UIColor.white
        ], for: .selected)
    }
    
    @objc
    func goBack() {
        navigationController?.popViewController(animated: true)
    }
    
    func userSession(_ userSession: UserSession?) {
        self.currentUser = userSession?.user
    }
    
    @objc
    func login() {
        self.viewModel.signIn(emailTextField.text!, passwordTextField.text!)
    }
}

// MARK: VIEW
extension AuthenticationViewController {
    func setupView() {
        constructHierarchy()
        activateConstraints()
    }
    
    func constructHierarchy() {
        view.addSubview(localhostLabel)
        view.addSubview(sloganLabel)
        view.addSubview(emailTextField)
        view.addSubview(passwordTextField)
        view.addSubview(authenticationButton)
        view.addSubview(registerButton)
        view.addSubview(forgotPasswordLabel)
    }
    
    func activateConstraints() {
        activateSloganLabelConstraints()
        activateLocalhostLabelConstraints()
        activateEmailTextFieldConstraints()
        activatePasswordTextFieldConstraints()
        activateAuthButtonConstraints()
        activateRegisterButtonConstraints()
        activateForgotPasswordConstraints()
    }
    
    func activateLocalhostLabelConstraints() {
        localhostLabel.snp.makeConstraints { (make) in
            make.top.equalTo(self.view.safeAreaLayoutGuide.snp.top).offset(100)
            make.centerX.equalToSuperview()
            make.width.equalToSuperview()
        }
    }
    
    func activateSloganLabelConstraints() {
        sloganLabel.snp.makeConstraints { (make) in
            make.top.equalTo(localhostLabel.snp.bottom)
            make.centerX.equalToSuperview()
            make.width.equalToSuperview()
        }
    }
    
    func activateEmailTextFieldConstraints() {
        emailTextField.snp.makeConstraints { (make) in
            make.height.equalTo(40)
            make.width.equalToSuperview().inset(15)
            make.centerX.equalToSuperview()
            make.top.equalTo(sloganLabel.snp.bottom).offset(70)
        }
    }
    
    func activatePasswordTextFieldConstraints() {
        passwordTextField.snp.makeConstraints { (make) in
            make.height.equalTo(40)
            make.width.equalToSuperview().inset(15)
            make.centerX.equalToSuperview()
            make.top.equalTo(emailTextField.snp.bottom).offset(15)
        }
    }
    
    func activateForgotPasswordConstraints() {
        forgotPasswordLabel.snp.makeConstraints { (make) in
            make.width.equalToSuperview()
            make.right.equalTo(passwordTextField.snp.right)
            make.top.equalTo(passwordTextField.snp.bottom).offset(10)
        }
    }
    
    func activateAuthButtonConstraints() {
        authenticationButton.snp.makeConstraints { (make) in
            make.height.equalTo(50)
            make.width.equalToSuperview().inset(10)
            make.centerX.equalToSuperview()
            make.top.equalTo(forgotPasswordLabel.snp.bottom).offset(30)
        }
    }
    
    func activateRegisterButtonConstraints() {
        registerButton.snp.makeConstraints { (make) in
            make.height.equalTo(50)
            make.width.equalToSuperview().inset(10)
            make.centerX.equalToSuperview()
            make.top.equalTo(authenticationButton.snp.bottom).offset(10)
        }
    }
}

// MARK: STATE
extension AuthenticationViewController {
    
    func clearFields(_ clearFields: Bool) {
        if(clearFields) {
            self.passwordTextField.text = ""
            self.emailTextField.text = ""
        }
    }
    
    func errorMessage(_ error: LHError) {
        let alert = UIAlertController(title: "Whoops", message: error.localizedDescription, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Dismiss", style: .cancel, handler: nil))
        self.navigationController?.present(alert, animated: true, completion: nil)
    }
    
    func inputEnabled(_ inputEnabled: Bool) {
        emailTextField.isUserInteractionEnabled = inputEnabled
        passwordTextField.isUserInteractionEnabled = inputEnabled
        authenticationButton.isEnabled = inputEnabled
    }
    
    func signInActivityIndicatorAnimating(_ signInActivityIndicatorAnimating: Bool) {
        if(signInActivityIndicatorAnimating) {
            SVProgressHUD.show()
        } else {
            SVProgressHUD.dismiss()
        }
    }
    
    func endEditing(_ endEditing: Bool) {
        self.view.endEditing(true)
    }
}
