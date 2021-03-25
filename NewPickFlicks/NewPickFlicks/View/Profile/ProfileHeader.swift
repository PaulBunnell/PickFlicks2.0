//
//  ProfileHeader.swift
//  NewPickFlicks
//
//  Created by John Padilla on 3/17/21.
//

import UIKit
import SDWebImage

class ProfileHeader: UICollectionReusableView {
    
    //MARK: - Properties
    
    var viewModel: ProfileHeaderViewModel? {
        didSet {
            configure()
        }
    }
    
    private let gradientLayer = CAGradientLayer()
    
    private let profileImageView: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFill
        iv.clipsToBounds = true
        iv.backgroundColor = .lightGray
        return iv
    }()
    
    private let whiteView: UIView = {
       let view = UIView()
        view.backgroundColor = .white
        view.layer.cornerRadius = 20
        return view
    }()
    
    private let nameLabel: UILabel = {
        let label = UILabel()
        label.textColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        label.font = UIFont.boldSystemFont(ofSize: 18)
        label.numberOfLines = 0
        return label
    }()
    
    private let usernameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14)
        label.textColor = .darkGray
        return label
    }()
    
    private lazy var editProfileFollowButton: UIButton = {
        let button = FillButtonController(type: .system)
        button.setTitle("Edit Profile", for: .normal)
        button.layer.cornerRadius = 5
        button.backgroundColor = #colorLiteral(red: 0.8784313725, green: 0.04705882353, blue: 0.1725490196, alpha: 1)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16)
        button.setTitleColor(.white, for: .normal)
        button.setWidth(150)
        button.setHeight(45)
        button.addTarget(self, action: #selector(handleEditProfileFollowTapped), for: .touchUpInside)
        return button
    }()
    
    private lazy var infoButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(#imageLiteral(resourceName: "icons8-sent-50").withRenderingMode(.alwaysOriginal), for: .normal)
        button.addTarget(self, action: #selector(handleStartMatching), for: .touchUpInside)
        return button
    }()
    
    let gridButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("My Favorites Movies", for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 18)
        button.tintColor = .black
        return button
    }()
    
    //MARK: - Lifecycle
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = UIColor(white: 0.95, alpha: 1)

        addSubview(profileImageView)
        profileImageView.centerXToSuperview()
        profileImageView.setDimensions(height: 150, width: 150)
        profileImageView.layer.cornerRadius = 150 / 2
        profileImageView.anchor(top: safeAreaLayoutGuide.topAnchor, paddingTop: 20)
        
        configureGradientLayer()

        addSubview(whiteView)
        whiteView.anchor(left: leftAnchor, bottom: bottomAnchor, right: rightAnchor, paddingLeft: 15, paddingBottom: 60, paddingRight: 16, height: 95)
        
        addSubview(editProfileFollowButton)
        editProfileFollowButton.centerXToSuperview()
        editProfileFollowButton.anchor(top: whiteView.topAnchor, paddingTop: -25)
        
        configureTop()
        configureBottomToolBar()
    }
    
    //MARK: - Actions
    
    @objc func handleEditProfileFollowTapped() {
        print("DEBUG: Invite friends")
        

    }
    
    @objc func handleStartMatching () {
        print("DEBUG: Start Matching")
    }
    
    //MARK: - Helpers
    
    func configureTop() {

        let stack = UIStackView(arrangedSubviews: [nameLabel, usernameLabel])
        stack.axis = .vertical
        stack.spacing = 2

        addSubview(stack)
        stack.anchor(top: editProfileFollowButton.bottomAnchor, left: leftAnchor, right: rightAnchor, paddingTop: 10, paddingLeft: 25, paddingRight: 20)
        
        addSubview(infoButton)
        infoButton.setDimensions(height: 45, width: 45)
        infoButton.centerY(inView: nameLabel)
        infoButton.anchor(right: rightAnchor, paddingRight: 25)
    }
    
    func configureBottomToolBar() {
        
        let topDividerView = UIView()
        topDividerView.backgroundColor = .lightGray
        
        let bottomDividerView = UIView()
        bottomDividerView.backgroundColor = .lightGray
        
        let stackView = UIStackView(arrangedSubviews: [gridButton])
        
        stackView.axis = .horizontal
        stackView.distribution = .fillEqually
        
        addSubview(stackView)
        addSubview(bottomDividerView)

        stackView.anchor(top: nil, left: leftAnchor, bottom: self.bottomAnchor, right: rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 50)
    }
    
    func configureGradientLayer() {
        gradientLayer.colors = [UIColor.clear.cgColor, UIColor.black.cgColor]
        gradientLayer.locations = [0.5, 1.1]
        layer.addSublayer(gradientLayer)

    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure() {
        guard let viewModel = viewModel else { return }

        nameLabel.text = viewModel.fullname
        usernameLabel.text = viewModel.username
        profileImageView.sd_setImage(with: viewModel.profileImageUrl)
        
        editProfileFollowButton.setTitle(viewModel.followButtonText, for: .normal)
    }
}
