//
//  LoginController.swift
//  NewPickFlicks
//
//  Created by John Padilla on 3/16/21.
//

import UIKit

protocol AuthenticationDelegate: class {
    func authenticationDidComplete()
}

class LoginController: UIViewController {
    
    //MARK: - Properties
    
    private var viewModel = LoginViewModel()
    weak var delegate: AuthenticationDelegate?
    
    //Background
    private let imageBackground: UIImageView = {
        let iv = UIImageView(image: #imageLiteral(resourceName: "jeff-pierre-5X5I20O_Vbg-unsplash"))
        iv.contentMode = .scaleAspectFill
        return iv
    }()
    
    private let headerWelcomeLabel: UILabel = {
       let label = UILabel()
        label.text = "Welcome back"
        label.textColor = .white
        label.textAlignment = .center
        label.numberOfLines = 0
        label.font = UIFont.boldSystemFont(ofSize: 30)
        return label
    }()
    
    private let subHeaderWelcomeLabel: UILabel = {
       let label = UILabel()
        label.text = "Login with your account"
        label.textColor = .white
        label.textAlignment = .center
        label.numberOfLines = 0
        label.font = UIFont.systemFont(ofSize: 14)
        return label
    }()
    
    //Email textfield
    private let emailTextField: UITextField = {
        let tf = CustomTextField(placeholder: "Email")
        tf.keyboardType = .emailAddress
        tf.keyboardAppearance = .dark
        tf.clearButtonMode = .whileEditing
        tf.autocapitalizationType = .none
        return tf
    }()
    
    //Password textfield
    private let passwordTextField: UITextField = {
        let tf = CustomTextField(placeholder: "Password")
        tf.isSecureTextEntry = true
        tf.clearButtonMode = .whileEditing
        tf.keyboardAppearance = .dark
        return tf
    }()
    
    //Login Button
    private let loginButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Log In", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 0.5183295347)
        button.isEnabled = false
        button.layer.cornerRadius = 10
        button.setHeight(50)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 18)
        button.addTarget(self, action: #selector(handleLogin), for: .touchUpInside)
        return button
    }()
    
    //Forgot Password
    private let forgotPasswordButton: UIButton = {
        let button = UIButton(type: .system)
        button.attributedTitle(firstPart: "Forgot your", secondPart: "Password?")
//        button.addTarget(self, action: #selector(handleShowForgotPassword), for: .touchUpInside)
        return button
    }()
    
    //Don't have an Account
    private let dontHaveAccountButton: UIButton = {
        let button = UIButton(type: .system)
        button.attributedTitle(firstPart: "Don't have an account?" , secondPart: "Sign Up")
        button.addTarget(self, action: #selector(handleShowSignUp), for: .touchUpInside)
        return button
    }()

    //MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureUI()
        setUpTapGesture()
        configureNotificationObservers()
    }
    
    //MARK: - Actions
    
    @objc func handleLogin() {
        guard let email = emailTextField.text else { return }
        guard let password = passwordTextField.text else { return }
        
        showLoader(true)
        AuthService.logUserIn(withEmail: email, password: password) { (result, error) in
            if let error = error {
                self.showMessage(withTitle: "Error", message: error.localizedDescription)
                self.showLoader(false)
                return
            }
            self.delegate?.authenticationDidComplete()
        }
    }
    
    @objc func handleShowSignUp() {
        let controller = RegisterController()
//        controller.delegate = delegate
        navigationController?.pushViewController(controller, animated: true)
    }
    
    @objc func handleShowForgotPassword() {
//        let controller = ResetPasswordController()
//        controller.delegate = self
//        controller.email = emailTextField.text
//        navigationController?.pushViewController(controller, animated: true)
    }
    
    @objc func textDidChange(sender: UITextField) {
        if sender == emailTextField {
            viewModel.email = sender.text
        } else {
            viewModel.password = sender.text
        }
        updateForm()
    }
    
    @objc func handleTapDismiss() {
        self.view.endEditing(true)
    }
    
    //MARK: - Helpers

    func configureUI() {
        navigationController?.navigationBar.isHidden = true
        navigationController?.navigationBar.barStyle = .black
        
        view.addSubview(imageBackground)
        imageBackground.anchor(top: view.topAnchor, left: view.leftAnchor, bottom: view.bottomAnchor, right: view.rightAnchor)

        
        configureHeader()

        let stack = UIStackView(arrangedSubviews: [emailTextField, passwordTextField])
        stack.axis = .vertical
        stack.spacing = 13
        
        view.addSubview(stack)
        stack.anchor(top: subHeaderWelcomeLabel.bottomAnchor, left: view.leftAnchor, right: view.rightAnchor, paddingTop: 40, paddingLeft: 25, paddingRight: 25)
        
        configurebuttons()
        
        view.addSubview(dontHaveAccountButton)
        dontHaveAccountButton.centerX(inView: view)
        dontHaveAccountButton.anchor(bottom: view.safeAreaLayoutGuide.bottomAnchor, paddingBottom: 15)
    }
    
    func configureHeader() {
        
        let stack = UIStackView(arrangedSubviews: [headerWelcomeLabel, subHeaderWelcomeLabel])
        stack.axis = .vertical
        stack.spacing = 10
        
        view.addSubview(stack)
        stack.anchor(top: view.safeAreaLayoutGuide.topAnchor, left: view.leftAnchor, right: view.rightAnchor, paddingTop: 30, paddingLeft: 20, paddingRight: 20)
    }
    
    func configurebuttons() {
        
        let stack = UIStackView(arrangedSubviews: [loginButton, forgotPasswordButton])
        stack.axis = .vertical
        stack.spacing = 5
        
        view.addSubview(stack)
        stack.anchor(top: passwordTextField.bottomAnchor, left: view.leftAnchor, right: view.rightAnchor, paddingTop: 30, paddingLeft: 25, paddingRight: 25)
    }
    
    func configureNotificationObservers() {
        emailTextField.addTarget(self, action: #selector(textDidChange), for: .editingChanged)
        passwordTextField.addTarget(self, action: #selector(textDidChange), for: .editingChanged)
    }
    
    //Tap Gesture
    func setUpTapGesture() {
        view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleTapDismiss)))
    }
}

//MARK: - Update form

extension LoginController: FormViewModel {
    func updateForm() {
        loginButton.backgroundColor = viewModel.buttonBackgroundColor
        loginButton.setTitleColor(viewModel.buttonTitleColor, for: .normal)
        loginButton.isEnabled = viewModel.formIsValid
    }
}

////MARK: - Reset Password
//extension LoginController: ResetPasswordControllerDelegate {
//    func controllerDidSendResetPasswordLink(_ controller: ResetPasswordController) {
//        navigationController?.popViewController(animated: true)
//        showMessage(withTitle: "Success", message: "We send a link to your email to reset your password")
//    }
//}
