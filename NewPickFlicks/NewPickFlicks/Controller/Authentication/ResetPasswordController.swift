//
//  ResetPasswordController.swift
//  NewPickFlicks
//
//  Created by John Padilla on 5/6/21.
//

import UIKit

protocol ResetPasswordControllerDelegate: class {
    func controllerDidSendResetPasswordLink(_ controller: ResetPasswordController)
}

class ResetPasswordController: UIViewController {
    
    //MARK: - Properties
    
    private var viewModel = ResetPasswordViewModel()
    
    weak var delegate: ResetPasswordControllerDelegate?
    
    var email: String?
    
    //Background

    
    private let headerWelcomeLabel: UILabel = {
       let label = UILabel()
        label.text = "Forgot Password"
        label.textColor = .white
        label.textAlignment = .center
        label.numberOfLines = 0
        label.font = UIFont.boldSystemFont(ofSize: 30)
        return label
    }()
    
    private let enterEmailLabel: UILabel = {
       let label = UILabel()
        label.text = "Enter your email address to reset your password"
        label.textColor = .white
        label.textAlignment = .center
        label.numberOfLines = 0
        label.font = UIFont.systemFont(ofSize: 14)
        return label
    }()
    
    private let emailTextField: UITextField = {
        let tf = CustomTextField(placeholder: "Email")
        tf.keyboardType = .emailAddress
        tf.clearButtonMode = .whileEditing
        tf.autocapitalizationType = .none
        return tf
    }()

    
    private let resetPasswordButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Reset Password", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = .white
        button.layer.cornerRadius = 10
        button.setHeight(50)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 18)
        button.addTarget(self, action: #selector(handleResetPassword), for: .touchUpInside)
        return button
    }()
    
    private let backButton: UIButton = {
        let button = UIButton(type: .system)
        button.tintColor = .white
        button.setImage(UIImage(systemName: "chevron.left"), for: .normal)
        button.addTarget(self, action: #selector(handleDismissal), for: .touchUpInside)
        return button
    }()
    
    //MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureUI()
        setUpTapGesture()
    }
    
    //MARK: - Actions
    
    @objc func handleResetPassword() {
        guard let email = emailTextField.text else { return }
        
        showLoader(true)
        AuthService.resetPassword(withEmail: email) { error in
            if let error = error {
                self.showMessage(withTitle: "Error", message: error.localizedDescription)
                self.showLoader(false)
                return
            }
            self.delegate?.controllerDidSendResetPasswordLink(self)
        }
    }
    
    @objc func handleDismissal() {
        navigationController?.popViewController(animated: true)
    }
    
    @objc func handleTapDismiss() {
        self.view.endEditing(true)
    }
    
    @objc func textDidChange(sender: UITextField) {
        if sender == emailTextField {
            viewModel.email = sender.text
        }
        updateForm()
    }
    
    //MARK: - Helpers
    
    func configureUI() {

        
        view.backgroundColor = #colorLiteral(red: 0.1957118511, green: 0.2142606378, blue: 0.3314321637, alpha: 1)

        view.addSubview(backButton)
        backButton.anchor(top:view.safeAreaLayoutGuide.topAnchor, left: view.leftAnchor, paddingTop: 16, paddingLeft: 16)
        
        emailTextField.text = email
        viewModel.email = email
        updateForm()
        emailTextField.addTarget(self, action: #selector(textDidChange), for: .editingChanged)
        
        configureHeader()
        
        let stack = UIStackView(arrangedSubviews: [emailTextField, resetPasswordButton])
        stack.axis = .vertical
        stack.spacing = 20
        
        view.addSubview(stack)
        stack.anchor(top: enterEmailLabel.bottomAnchor, left: view.leftAnchor, right: view.rightAnchor, paddingTop: 40, paddingLeft: 25, paddingRight: 25)
    }
    
    func configureHeader() {
        
        let stack = UIStackView(arrangedSubviews: [headerWelcomeLabel, enterEmailLabel])
        stack.axis = .vertical
        stack.spacing = 10
        
        view.addSubview(stack)
        stack.anchor(top: view.safeAreaLayoutGuide.topAnchor, left: view.leftAnchor, right: view.rightAnchor, paddingTop: 50, paddingLeft: 20, paddingRight: 20)
    }
    
    
    func setUpTapGesture() {
        view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleTapDismiss)))
    }
}

//MARK: - Update form

extension ResetPasswordController: FormViewModel {
    func updateForm() {
        resetPasswordButton.backgroundColor = viewModel.buttonBackgroundColor
        resetPasswordButton.setTitleColor(viewModel.buttonTitleColor, for: .normal)
        resetPasswordButton.isEnabled = viewModel.formIsValid
    }
}

