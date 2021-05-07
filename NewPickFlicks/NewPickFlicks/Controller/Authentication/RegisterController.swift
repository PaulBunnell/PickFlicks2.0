//
//  RegisterController.swift
//  NewPickFlicks
//
//  Created by John Padilla on 3/16/21.
//

import UIKit

class RegisterController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    //MARK: - Properties
    
    private var viewModel = RegistrationViewModel()
    private var profileImage: UIImage?
    weak var delegate: AuthenticationDelegate?
    
    //Plus Photo
    private let plusPhotoButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Select Photo", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 20, weight: .heavy)
        button.layer.borderColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        button.layer.borderWidth = 1.5
        button.layer.cornerRadius = 20
        button.addTarget(self, action: #selector(handleProfilePhoto), for: .touchUpInside)
        return button
    }()
    //Email textfield
    private let emailTextField: UITextField = {
        let tf = CustomTextField(placeholder: "Email")
        tf.keyboardType = .emailAddress
        tf.clearButtonMode = .whileEditing
        tf.autocapitalizationType = .none
        tf.keyboardAppearance = .dark
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

    //Fullname textfield
    private let fullnameTextField: UITextField = {
        let tf = CustomTextField(placeholder: "Full name")
        tf.clearButtonMode = .whileEditing
        tf.keyboardAppearance = .dark
        return tf
    }()

    //username textfield
    private let usernameTextField: UITextField = {
        let tf = CustomTextField(placeholder: "Username")
        tf.clearButtonMode = .whileEditing
        tf.keyboardAppearance = .dark
        return tf
    }()
    
    //Signup button
    private let signUpButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Sign up", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = #colorLiteral(red: 0.6299297214, green: 0.6659753919, blue: 0.6834830046, alpha: 1)
        button.isEnabled = false
        button.layer.cornerRadius = 10
        button.setHeight(55)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 18)
        button.addTarget(self, action: #selector(handleSignUp), for: .touchUpInside)
        return button
    }()
    
    //Terms & condi
    private let termsAndConditionsLabel: UILabel = {
       let label = UILabel()
        label.text = "By clicking Sign up you agree to the following Termas and Conditions without reservation."
        label.textColor = .white
        label.textAlignment = .center
        label.numberOfLines = 0
        label.font = UIFont.systemFont(ofSize: 14)
        return label
    }()
    
    //Already have account
    private let alreadyHaveAccountButton: UIButton = {
        let button = UIButton(type: .system)
        button.attributedTitle(firstPart: "Already have an account? ", secondPart: "Log In")
        button.addTarget(self, action: #selector(handleShowLogin), for: .touchUpInside)
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
    
    @objc func handleSignUp() {
        
        guard let email = emailTextField.text?.lowercased() else { return }
        guard let password = passwordTextField.text else { return }
        guard let fullname = fullnameTextField.text else { return }
        guard let username = usernameTextField.text?.lowercased() else { return }
        guard let profileImage = self.profileImage else { return }

        let credentials = AuthCredentials(email: email, password: password, fullname: fullname, username: username, profileImage: profileImage)

        showLoader(true)
        AuthService.registerUser(withCredential: credentials) { (error) in
            if let error = error {
                self.showMessage(withTitle: "Error", message: error.localizedDescription)
                self.showLoader(false)
                return
            }
            self.delegate?.authenticationDidComplete()
        }
    }
    
    @objc func handleShowLogin() {
        navigationController?.popViewController(animated: true)
    }
    
    @objc func handleProfilePhoto() {
        let picker = UIImagePickerController()
        picker.delegate = self
        picker.allowsEditing = true
        
        present(picker, animated: true, completion: nil)
    }
    
    @objc func textDidChange(sender: UITextField) {
        if sender == emailTextField {
            viewModel.email = sender.text
        } else if sender == passwordTextField {
            viewModel.password = sender.text
        } else if sender == fullnameTextField {
            viewModel.fullname = sender.text
        } else {
            viewModel.country = sender.text
        }
        updateForm()
    }
    
    @objc func handleTapDismiss() {
        self.view.endEditing(true)
    }
    
    //MARK: - Helpers

    fileprivate func configureUI() {
        
        view.backgroundColor = #colorLiteral(red: 0.1957118511, green: 0.2142606378, blue: 0.3314321637, alpha: 1)

        view.addSubview(plusPhotoButton)
        plusPhotoButton.centerX(inView: view)
        plusPhotoButton.setDimensions(height: 275, width: 275)
        plusPhotoButton.anchor(top: view.safeAreaLayoutGuide.topAnchor, paddingTop: 20)
        
        let stack = UIStackView(arrangedSubviews: [usernameTextField, fullnameTextField, emailTextField, passwordTextField])
        stack.axis = .vertical
        stack.spacing = 13
        
        view.addSubview(stack)
        stack.anchor(top: plusPhotoButton.bottomAnchor, left: view.leftAnchor, right: view.rightAnchor, paddingTop: 25, paddingLeft: 25, paddingRight: 25)
        
        configurebuttons()
   
        view.addSubview(alreadyHaveAccountButton)
        alreadyHaveAccountButton.centerX(inView: view)
        alreadyHaveAccountButton.anchor(bottom: view.safeAreaLayoutGuide.bottomAnchor, paddingBottom: 15)
    }
    
    func configurebuttons() {
        
        let stack = UIStackView(arrangedSubviews: [signUpButton, termsAndConditionsLabel])
        stack.axis = .vertical
        stack.spacing = 40
        
        view.addSubview(stack)
        stack.anchor(top: passwordTextField.bottomAnchor, left: view.leftAnchor, right: view.rightAnchor, paddingTop: 25, paddingLeft: 25, paddingRight: 25)
    }
    
    func configureNotificationObservers() {
        emailTextField.addTarget(self, action: #selector(textDidChange), for: .editingChanged)
        passwordTextField.addTarget(self, action: #selector(textDidChange), for: .editingChanged)
        fullnameTextField.addTarget(self, action: #selector(textDidChange), for: .editingChanged)
        usernameTextField.addTarget(self, action: #selector(textDidChange), for: .editingChanged)
    }
    
    // UImagePicker Controller
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        guard let selectedImage = info[.editedImage] as? UIImage else { return }
        profileImage = selectedImage
        
        plusPhotoButton.layer.cornerRadius = 20
        plusPhotoButton.layer.masksToBounds = true
        plusPhotoButton.setImage(selectedImage.withRenderingMode(.alwaysOriginal), for: .normal)
        
        self.dismiss(animated: true, completion: nil)
    }
    
    //Tap Gesture
    func setUpTapGesture() {
        view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleTapDismiss)))
    }
}

//MARK: - Update form
extension RegisterController: FormViewModel {
    func updateForm() {
        signUpButton.backgroundColor = viewModel.buttonBackgroundColor
        signUpButton.setTitleColor(viewModel.buttonTitleColor, for: .normal)
        signUpButton.isEnabled = viewModel.formIsValid
    }
}

