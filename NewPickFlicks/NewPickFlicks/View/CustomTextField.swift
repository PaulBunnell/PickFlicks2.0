//
//  CustomTextField.swift
//  NewPickFlicks
//
//  Created by John Padilla on 3/17/21.
//

import UIKit

class CustomTextField: UITextField {
    
    //MARK: - Properties
    
    private lazy var eyeImageView: UIImageView = {
        let iv = UIImageView()
        iv.setDimensions(height: 24, width: 24)
        iv.tintColor = .white
        iv.contentMode = .scaleAspectFit
        iv.image = UIImage(systemName: "eye")
        iv.tag = 1
        iv.isUserInteractionEnabled = true
        let tap = UITapGestureRecognizer(target: self, action: #selector(visibiltyIconTapped(tapGestureRecognizer:)))
        iv.addGestureRecognizer(tap)
        return iv
    }()
    
    private lazy var eyeSlashImageView: UIImageView = {
        let iv = UIImageView()
        iv.setDimensions(height: 24, width: 24)
        iv.tintColor = .white
        iv.contentMode = .scaleAspectFit
        iv.image = UIImage(systemName: "eye.slash")
        iv.tag = 0
        iv.isUserInteractionEnabled = true
        let tap = UITapGestureRecognizer(target: self, action: #selector(visibiltyIconTapped(tapGestureRecognizer:)))
        iv.addGestureRecognizer(tap)
        return iv
    }()
    
    private lazy var visibilityView: UIView = {
        let rv = UIView()
        rv.setDimensions(height: 50, width: 30)
        rv.addSubview(eyeImageView)
        eyeImageView.centerY(inView: rv)
        eyeImageView.anchor(right: rv.rightAnchor, paddingRight: 6)
        return rv
    }()
    
    //MARK: - Lifecycle
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    convenience init(placeholder: String) {
        self.init(frame: .zero)
        configureUI(placeholder: placeholder)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override var isSecureTextEntry: Bool {
        didSet {
            if isSecureTextEntry {
                rightView = visibilityView
                rightViewMode = .always
                
                setVisibility (false)
            } else {
                setVisibility (true)
            }
        }
    }
    
    //MARK: - Selectors
    @objc func visibiltyIconTapped(tapGestureRecognizer: UITapGestureRecognizer) {
        print("DEBUG: CustomTextField: visibilityIconTapped")
        
        if let tappedImage = tapGestureRecognizer.view as? UIImageView {
            let tag = tappedImage.tag
            isSecureTextEntry = tag != 0
        }
    }
    
    //MARK: - Helpers
    func configureUI(placeholder: String) {
        
        let spacer = UIView()
        spacer.setDimensions(height: 45, width: 12)
        leftView = spacer
        leftViewMode = .always
        textColor = #colorLiteral(red: 0.9647058824, green: 0.968627451, blue: 0.9764705882, alpha: 1)
        layer.cornerRadius = 10
        borderStyle = .none
        
//        keyboardAppearance = .dark
        backgroundColor = UIColor(white: 1, alpha: 0.2)
        setHeight(45)
        attributedPlaceholder = NSAttributedString(string: placeholder, attributes: [.foregroundColor: UIColor(white: 1, alpha: 0.50) ])
    }
    
    func setVisibility(_ visibility: Bool) {
        print("DEBUG: Set visibilty \(visibility)")
        
        if visibility {
            eyeSlashImageView.removeFromSuperview()
            visibilityView.addSubview(eyeImageView)
            eyeImageView.centerY(inView: visibilityView)
            eyeImageView.anchor(right: visibilityView.rightAnchor, paddingRight: 6)
        } else {
            eyeImageView.removeFromSuperview()
            visibilityView.addSubview(eyeSlashImageView)
            eyeSlashImageView.centerY(inView: visibilityView)
            eyeSlashImageView.anchor(right: visibilityView.rightAnchor, paddingRight: 6)
        }
    }
}
