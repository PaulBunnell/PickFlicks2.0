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
    
    //Profile Image
    private let profileImageView: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFill
        iv.clipsToBounds = true
        iv.backgroundColor = .lightGray
//        iv.layer.borderColor = #colorLiteral(red: 0.8784313725, green: 0.6941176471, blue: 0.04705882353, alpha: 1)
//        iv.layer.borderWidth = 3
        return iv
    }()
    
    private let whiteView: UIView = {
       let view = UIView()
        view.backgroundColor = .white
        view.layer.cornerRadius = 38
        return view
    }()
    
    //Name Label
    private let nameLabel: UILabel = {
        let label = UILabel()
        label.textColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        label.font = UIFont.boldSystemFont(ofSize: 26)
        label.numberOfLines = 0
//        label.textAlignment = .center
        return label
    }()
    
    //username Label
    private let usernameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 17)
        label.textColor = .darkGray
//        label.textAlignment = .center
        return label
    }()
    
    private lazy var editProfileFollowButton: UIButton = {
        let button = FillButtonController(type: .system)
        button.setTitle("Loading...", for: .normal)
        button.layer.cornerRadius = 5
        button.backgroundColor = #colorLiteral(red: 0.8784313725, green: 0.04705882353, blue: 0.1725490196, alpha: 1)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16)
        button.setTitleColor(.white, for: .normal)
        button.setWidth(150)
        button.setHeight(45)
//        button.addTarget(self, action: #selector(handleEditProfileFollowTapped), for: .touchUpInside)
        return button
    }()
    
    private lazy var infoButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(#imageLiteral(resourceName: "icons8-sent-50").withRenderingMode(.alwaysOriginal), for: .normal)
//        button.addTarget(self, action: #selector(handleShowMovieDetails), for: .touchUpInside)
        return button
    }()
    
    //MARK: - Lifecycle
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = .white

        addSubview(profileImageView)
//        profileImageView.centerXToSuperview()
//        profileImageView.setDimensions(height: 150, width: 150)
//        profileImageView.layer.cornerRadius = 150 / 2
//        profileImageView.anchor(top: safeAreaLayoutGuide.topAnchor, paddingTop: 20)
        profileImageView.anchor(top: topAnchor, left: leftAnchor, bottom: bottomAnchor, right: rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 150, paddingRight: 0)
        
        configureGradientLayer()

        
        addSubview(whiteView)
        whiteView.anchor(left: leftAnchor, bottom: bottomAnchor, right: rightAnchor, paddingBottom: 10, height: 200)
        
        addSubview(editProfileFollowButton)
        editProfileFollowButton.centerXToSuperview()
        editProfileFollowButton.anchor(top: whiteView.topAnchor, paddingTop: -20)
        
        configureTop()


    }
    
    //MARK: - Helpers
    
    
//    func configureTop() {
//
//        let stack = UIStackView(arrangedSubviews: [nameLabel, usernameLabel])
//        stack.axis = .vertical
//        stack.spacing = 1
//
//        addSubview(stack)
//        stack.centerXToSuperview()
//        stack.anchor(top: editProfileFollowButton.bottomAnchor, paddingTop: 10)
//    }
    
    func configureTop() {

        let stack = UIStackView(arrangedSubviews: [nameLabel, usernameLabel])
        stack.axis = .vertical
        stack.spacing = 5

        addSubview(stack)
        stack.anchor(top: editProfileFollowButton.bottomAnchor, left: leftAnchor, right: rightAnchor, paddingTop: 20, paddingLeft: 20, paddingRight: 20)
        
        addSubview(infoButton)
        infoButton.setDimensions(height: 45, width: 45)
        infoButton.centerY(inView: usernameLabel)
        infoButton.anchor(right: rightAnchor, paddingRight: 20)

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
        
    }
}
