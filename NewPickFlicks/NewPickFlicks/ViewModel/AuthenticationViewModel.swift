//
//  AuthenticationViewModel.swift
//  NewPickFlicks
//
//  Created by John Padilla on 3/17/21.
//

import UIKit

protocol FormViewModel {
    func updateForm()
}

protocol AuthenticationViewModel {
    var formIsValid: Bool { get }
    var buttonBackgroundColor:  UIColor { get }
    var buttonTitleColor: UIColor { get }
}

struct LoginViewModel: AuthenticationViewModel {
    
    var email: String?
    var password: String?
    
    var formIsValid: Bool {
        return email?.isEmpty == false && password?.isEmpty == false
    }
    
    var buttonBackgroundColor: UIColor {
        return formIsValid ? #colorLiteral(red: 0.8784313725, green: 0.04705882353, blue: 0.1725490196, alpha: 1) : #colorLiteral(red: 0.6000000238, green: 0.6000000238, blue: 0.6000000238, alpha: 1)
    }
    
    var buttonTitleColor: UIColor {
        return formIsValid ? .white : UIColor.white
    }
}

struct RegistrationViewModel: AuthenticationViewModel {
  
    var email: String?
    var password: String?
    var fullname: String?
    var country: String?

    var formIsValid: Bool {
        return email?.isEmpty == false && password?.isEmpty == false && fullname?.isEmpty == false && country?.isEmpty == false
    }
    
    var buttonBackgroundColor: UIColor {
        return formIsValid ? #colorLiteral(red: 0.8798516393, green: 0.115436472, blue: 0.1693672538, alpha: 1) : #colorLiteral(red: 0.6000000238, green: 0.6000000238, blue: 0.6000000238, alpha: 1)
    }
    
    var buttonTitleColor: UIColor {
        return formIsValid ? .white : UIColor.white
    }
}

struct ResetPasswordViewModel: AuthenticationViewModel {
    
    var email: String?

    var formIsValid: Bool {
        return email?.isEmpty == false
    }
    
    var buttonBackgroundColor: UIColor {
        return formIsValid ? #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1) : #colorLiteral(red: 0.9764705882, green: 0.7960784314, blue: 0.768627451, alpha: 1)
    }
    
    var buttonTitleColor: UIColor {
        return formIsValid ? #colorLiteral(red: 0.9450544715, green: 0.5218046308, blue: 0.4596670866, alpha: 1) : UIColor.white
    }
}
