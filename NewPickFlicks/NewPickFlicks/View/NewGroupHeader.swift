//
//  NewGroupHeader.swift
//  NewPickFlicks
//
//  Created by John Padilla on 3/23/21.
//

import UIKit

class NewGroupHeader: UICollectionReusableView {
    
    //MARK: - Properties
    
    private let newGroupLabel: UILabel = {
       let label = UILabel()
        label.text = "New Group info"
        label.font = UIFont.boldSystemFont(ofSize: 16)
        label.textColor = #colorLiteral(red: 0.9137254902, green: 0.2509803922, blue: 0.3411764706, alpha: 1)
        return label
    }()
    
    private let plusPhotoButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(#imageLiteral(resourceName: "plus_photo"), for: .normal)
        button.tintColor = UIColor.lightGray
//        button.addTarget(self, action: #selector(handleProfilePhoto), for: .touchUpInside)
        return button
    }()
    
    private let groupNameField: UITextField = {
        let tf = UITextField()
        tf.placeholder = "Group Subject"
        tf.font = UIFont.systemFont(ofSize: 18)
        return tf
    }()
    
    private let lineTitleView: UIView = {
        let view = UIView()
        view.backgroundColor = .lightGray
        view.setHeight(0.5)
        return view
    }()
    
    private let infoLabel: UILabel = {
       let label = UILabel()
        label.text = "Please provide a group subject and optional group icon"
        label.textColor = .darkGray
        label.numberOfLines = 0
        label.font = UIFont.systemFont(ofSize: 14)
        return label
    }()
    
    //MARK: - Lifecycle
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addSubview(newGroupLabel)
        newGroupLabel.anchor(top: topAnchor, left: leftAnchor, paddingTop: 12, paddingLeft: 12)
        
        addSubview(plusPhotoButton)
        plusPhotoButton.setDimensions(height: 80, width: 80)
        plusPhotoButton.layer.cornerRadius = 80 / 2
        plusPhotoButton.anchor(top: newGroupLabel.bottomAnchor, left: leftAnchor, paddingTop: 12, paddingLeft: 18)
        
        configureTop()
        
        addSubview(infoLabel)
        infoLabel.anchor(top: lineTitleView.bottomAnchor, left: plusPhotoButton.rightAnchor, right: rightAnchor, paddingTop: 10, paddingLeft: 12, paddingRight: 12)
    }
    
    //MARK: - Helpers
    
    func configureTop() {
        
        let stack = UIStackView(arrangedSubviews: [groupNameField, lineTitleView])
        stack.axis = .vertical
        stack.spacing = 1
        
        addSubview(stack)
        stack.centerY(inView: plusPhotoButton, leftAnchor: plusPhotoButton.rightAnchor, paddingLeft: 12)
        stack.anchor(right: rightAnchor, paddingRight: 30)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
