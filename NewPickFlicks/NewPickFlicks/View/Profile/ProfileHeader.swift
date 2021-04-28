//
//  ProfileHeader.swift
//  NewPickFlicks
//
//  Created by John Padilla on 3/17/21.
//

import UIKit
import SDWebImage

protocol ProfileHeaderDelegate: class {
    func header(_ profileHeader: ProfileHeader, didTapActionButtonFor user: User)
    func header(_ profileHeader: ProfileHeader, wantsToViewFollowingFor user: User)
    func header(_ profileHeader: ProfileHeader, wantsToViewFollowersFor user: User)
    func header(_ profileHeader: ProfileHeader, didTapMatchingButtonFor user: User)
}

class ProfileHeader: UICollectionReusableView {
    
    //MARK: - Properties
    
    weak var delegate: ProfileHeaderDelegate?

    let cellIdentifier = "collectionCell"
    
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
    
    private let whiteViewButton: UIView = {
       let view = UIView()
        view.backgroundColor = .white
        view.layer.cornerRadius = 20
        view.layer.shadowColor = UIColor(red: 0/255, green: 0/255, blue: 0/255, alpha: 1).cgColor
        view.layer.shadowOffset = CGSize(width: 0, height: 1.75)
        view.layer.shadowRadius = 5
        view.layer.shadowOpacity = 0.15
        return view
    }()
    
    private let nameLabel: UILabel = {
        let label = UILabel()
        label.textColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        label.font = UIFont.boldSystemFont(ofSize: 22)
        label.numberOfLines = 0
        label.textAlignment = .center
        return label
    }()
    
    private let emailLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 14)
        label.textColor = #colorLiteral(red: 0.9137254902, green: 0.2509803922, blue: 0.3411764706, alpha: 1)
        label.textAlignment = .center

        return label
    }()
    
    private lazy var editProfileFollowButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Edit Profile", for: .normal)
        button.layer.cornerRadius = 20
        button.backgroundColor = .white
        button.layer.borderColor = #colorLiteral(red: 0.9137254902, green: 0.2509803922, blue: 0.3411764706, alpha: 1)
        button.layer.borderWidth = 1
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 18)
        button.setTitleColor(.white, for: .normal)
        button.setWidth(150)
        button.setHeight(50)
        button.addTarget(self, action: #selector(handleEditProfileFollowTapped), for: .touchUpInside)
        
        return button
    }()
    
    private lazy var inviteButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(#imageLiteral(resourceName: "icons8-red-card-50").withRenderingMode(.alwaysOriginal), for: .normal)
        button.backgroundColor = #colorLiteral(red: 0.9137254902, green: 0.2509803922, blue: 0.3411764706, alpha: 1)
        button.addTarget(self, action: #selector(handleStartMatching), for: .touchUpInside)
        button.layer.cornerRadius = 40
        return button
    }()
    
    let favoriteMoviesButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("My Favorite Movies", for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 18)
        button.backgroundColor = #colorLiteral(red: 0.9137254902, green: 0.2509803922, blue: 0.3411764706, alpha: 1)
        button.addTarget(self, action: #selector(editMoviesList), for: .touchUpInside)
        button.tintColor = .white
        return button
    }()
    
    let editButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("   Edit   ", for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 18)
        button.backgroundColor = #colorLiteral(red: 0.9137254902, green: 0.2509803922, blue: 0.3411764706, alpha: 1)
        button.tintColor = .white
        return button
    }()
    
    private lazy var followersLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.textAlignment = .center
        label.backgroundColor = #colorLiteral(red: 0.9490196078, green: 0.4431372549, blue: 0.1294117647, alpha: 1)
        let tap = UITapGestureRecognizer(target: self, action: #selector(handleFollowersTapped))
        label.isUserInteractionEnabled = true
        label.addGestureRecognizer(tap)
        label.layer.cornerRadius = 40
        label.clipsToBounds = true
        return label
    }()

    private lazy var followingLabel: UILabel = {
       let label = UILabel()
        label.numberOfLines = 0
        label.textAlignment = .center
        label.backgroundColor = #colorLiteral(red: 0.5411764706, green: 0.137254902, blue: 0.5294117647, alpha: 1)
        let tap = UITapGestureRecognizer(target: self, action: #selector(handleFollowingTapped))
        label.isUserInteractionEnabled = true
        label.addGestureRecognizer(tap)
        label.layer.cornerRadius = 40
        label.clipsToBounds = true
        return label
    }()
    
    var localEditButtonTapped: Bool = true
    
    //MARK: - Lifecycle
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        inviteButton.applyDesign()

        backgroundColor = UIColor(white: 0.95, alpha: 1)

        addSubview(profileImageView)
        profileImageView.centerXToSuperview()
        profileImageView.setDimensions(height: 150, width: 150)
        profileImageView.layer.cornerRadius = 150 / 2
        profileImageView.anchor(top: safeAreaLayoutGuide.topAnchor, paddingTop: 20)
        
        configureMiddleView()
        configureTop()
        
        addSubview(editProfileFollowButton)
        editProfileFollowButton.centerXToSuperview()
        editProfileFollowButton.anchor(top: emailLabel.bottomAnchor, paddingTop: 30)
        
        favoriteMoviesButton.layer.cornerRadius = 20
        favoriteMoviesButton.clipsToBounds = true
        
        configureBottomToolBar()
    }
    
    //MARK: - Actions
    
    @objc func handleEditProfileFollowTapped() {
        guard let viewModel = viewModel else { return }
        delegate?.header(self, didTapActionButtonFor: viewModel.user)
    }
    
    @objc func handleFollowersTapped() {
        guard let viewModel = viewModel else { return }
        delegate?.header(self, wantsToViewFollowersFor: viewModel.user)
    }
    
    @objc func handleFollowingTapped() {
        guard let viewModel = viewModel else { return }
        delegate?.header(self, wantsToViewFollowingFor: viewModel.user)
    }
    
    @objc func handleStartMatching () {
        guard let viewModel = viewModel else { return }
        delegate?.header(self, didTapMatchingButtonFor: viewModel.user)
        
    }
    
    @objc func editMoviesList() {
        
        if localEditButtonTapped == true {
            favoriteMoviesButton.setTitle("Tap a Movie to delete", for: .normal)
            MovieDetail.editTapped = true
            localEditButtonTapped = false
        }
        else if localEditButtonTapped == false {
            favoriteMoviesButton.setTitle("Tap to Edit Movies", for: .normal)
            MovieDetail.editTapped = false
            localEditButtonTapped = true
        }
        
    }
    
    //MARK: - Helpers
    
    func configureTop() {

        let stack = UIStackView(arrangedSubviews: [nameLabel, emailLabel])
        stack.axis = .vertical
        stack.spacing = 5

        addSubview(stack)

        stack.centerXToSuperview()
        stack.anchor(top: inviteButton.bottomAnchor, paddingTop: 20)
    }
    
    func configureMiddleView() {
        
        addSubview(whiteViewButton)
        whiteViewButton.anchor(top: profileImageView.bottomAnchor, left: leftAnchor, right: rightAnchor, paddingTop: 55, paddingLeft: 16, paddingRight: 16, height: 170)
        
        let stack = UIStackView(arrangedSubviews: [followersLabel, inviteButton, followingLabel])
        stack.distribution = .fillEqually
        stack.spacing = 20
        
        addSubview(stack)
        stack.anchor(top: profileImageView.bottomAnchor, left: leftAnchor, right: rightAnchor, paddingTop: 20, paddingLeft: 60, paddingBottom: 20, paddingRight: 60, height: 80)
    }
    
    func configureBottomToolBar() {
        
        let topDividerView = UIView()
        topDividerView.backgroundColor = .lightGray
        
        let bottomDividerView = UIView()
        bottomDividerView.backgroundColor = .lightGray
        
        let stackView = UIStackView(arrangedSubviews: [favoriteMoviesButton])
        
        stackView.axis = .horizontal
        stackView.distribution = .equalSpacing
        
        addSubview(stackView)
        addSubview(bottomDividerView)

        stackView.anchor(top: nil, left: leftAnchor, bottom: self.bottomAnchor, right: rightAnchor, paddingTop: 20, paddingLeft: 16, paddingBottom: 5, paddingRight: 16, width: 0, height: 50)
        
    }

    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure() {
        guard let viewModel = viewModel else { return }

        nameLabel.text = viewModel.fullname
        emailLabel.text = viewModel.email
        profileImageView.sd_setImage(with: viewModel.profileImageUrl)
        
        if User.favoriteMovies == nil {
            favoriteMoviesButton.setTitle("No Favorite Movies", for: .normal)
        }
        else {
            favoriteMoviesButton.setTitle("Tap to Edit Movies", for: .normal)
        }
        
        editProfileFollowButton.setTitle(viewModel.followButtonText, for: .normal)
        editProfileFollowButton.setTitleColor(viewModel.followButtonTextcolor, for: .normal)
        editProfileFollowButton.backgroundColor = viewModel.followButtonBackgroundColor
        
        followingLabel.attributedText = viewModel.numberOfFollowings
        followersLabel.attributedText = viewModel.numberOfFollowers
        
        inviteButton.setImage(viewModel.matchingButtonImage, for: .normal)
        inviteButton.setTitleColor(viewModel.matchingButtonTextColor, for: .normal)
        inviteButton.backgroundColor = viewModel.matchingButtonBackgroundColor
    }
}

extension ProfileHeader: UICollectionViewDelegate {
    
}

extension UIButton {
    func applyDesign() {
        self.layer.shadowColor = UIColor.darkGray.cgColor
        self.layer.shadowRadius = 4
        self.layer.shadowOpacity = 0.9
        self.layer.shadowOffset = CGSize(width: 0, height: 4)
    }
}

