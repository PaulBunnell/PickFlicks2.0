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
    
    private let imageBackground: UIImageView = {
        let iv = UIImageView(image: #imageLiteral(resourceName: "jeff-pierre-5X5I20O_Vbg-unsplash"))
        iv.contentMode = .scaleAspectFill
        iv.alpha = 0.3
        return iv
    }()
    
    //Profile Image
    private let profileImageView: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFill
        iv.clipsToBounds = true
        iv.backgroundColor = .lightGray
        iv.layer.borderColor = #colorLiteral(red: 0.8784313725, green: 0.6941176471, blue: 0.04705882353, alpha: 1)
        iv.layer.borderWidth = 3
        return iv
    }()
    
    //Name Label
    private let nameLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.font = UIFont.systemFont(ofSize: 28, weight: .heavy)
        label.numberOfLines = 0
        label.textAlignment = .center
        return label
    }()
    
    //username Label
    private let usernameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 18)
        label.textColor = #colorLiteral(red: 0.6299297214, green: 0.6659753919, blue: 0.6834830046, alpha: 1)
        label.textAlignment = .center
        return label
    }()
    
    private lazy var editProfileFollowButton: UIButton = {
        let button = FillButtonController(type: .system)
        button.setTitle("Loading...", for: .normal)
        button.layer.cornerRadius = 5
        button.backgroundColor = #colorLiteral(red: 0.8784313725, green: 0.04705882353, blue: 0.1725490196, alpha: 1)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 15)
        button.setTitleColor(.white, for: .normal)
        button.setWidth(120)
        button.setHeight(38)
//        button.addTarget(self, action: #selector(handleEditProfileFollowTapped), for: .touchUpInside)
        return button
    }()
    
    //MARK: - Lifecycle
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = #colorLiteral(red: 0.1610715091, green: 0.1607382596, blue: 0.1691181064, alpha: 1)

        addSubview(imageBackground)
        imageBackground.anchor(top: topAnchor, left: leftAnchor, bottom: bottomAnchor, right: rightAnchor, paddingBottom: 150)

        addSubview(profileImageView)
        profileImageView.centerXToSuperview()
        profileImageView.setDimensions(height: 150, width: 150)
        profileImageView.layer.cornerRadius = 150 / 2
        profileImageView.anchor(top: safeAreaLayoutGuide.topAnchor, paddingTop: 20)
        
        configureGradientLayer()

        configureTop()
        
        addSubview(editProfileFollowButton)
        editProfileFollowButton.centerXToSuperview()
        editProfileFollowButton.anchor(top: usernameLabel.bottomAnchor, paddingTop: 20)

    }
    
    //MARK: - Helpers
    
    
    func configureTop() {
        
        let stack = UIStackView(arrangedSubviews: [nameLabel, usernameLabel])
        stack.axis = .vertical
        stack.spacing = 1
        
        addSubview(stack)
        stack.centerXToSuperview()
        stack.anchor(top: profileImageView.bottomAnchor, paddingTop: 10)
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
