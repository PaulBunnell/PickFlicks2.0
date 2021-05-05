//
//  NotificationCell.swift
//  NewPickFlicks
//
//  Created by John Padilla on 4/23/21.
//

import UIKit

protocol NotificationCellDelegate: class {
    func cell(_ cell: NotificationCell, wantsToFollow uid: String)
    func cell(_ cell: NotificationCell, wantsToUnfollow uid: String)
    func cell(_ cell: NotificationCell, wantsToViewPost postId: String)
}

class NotificationCell: UITableViewCell {
    
    //MARK: - Properties
    
    var viewModel: NotificationViewModel? {
        didSet { configure() }
    }
    
    weak var delegate: NotificationCellDelegate?
    
    private let profileImageview: UIImageView = {
       let iv = UIImageView()
        iv.contentMode = .scaleAspectFill
        iv.clipsToBounds = true
        iv.backgroundColor = .lightGray
        return iv
    }()
    
    private let infoLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 14)
        label.numberOfLines = 0
        return label
    }()
    
    private lazy var followButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Loading", for: .normal)
        button.layer.cornerRadius = 5
        button.layer.borderColor = #colorLiteral(red: 0.9176470588, green: 0.2784511745, blue: 0.3646823168, alpha: 1)
        button.layer.borderWidth = 0.5
        button.setHeight(35)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 14)
        button.setTitleColor(.black, for: .normal)
        button.addTarget(self, action: #selector(handleFollowTapped), for: .touchUpInside)
        return button
    }()
    
    private lazy var playImageView: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFill
        iv.clipsToBounds = true
        iv.image = #imageLiteral(resourceName: "icons8-red-card-50-2")
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(handlePostTapped))
        iv.isUserInteractionEnabled = true
        iv.addGestureRecognizer(tap)
        return iv
    }()
    
    private let postTimeLabel: UILabel = {
        let label = UILabel()
        label.textColor = .lightGray
        label.font = UIFont.boldSystemFont(ofSize: 12)
        return label
    }()
    
    //MARK: - Lifecycle
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        selectionStyle = .none
        
        addSubview(profileImageview)
        profileImageview.setDimensions(height: 50, width: 50)
        profileImageview.layer.cornerRadius = 50 / 2
        profileImageview.centerY(inView: self, leftAnchor: leftAnchor, paddingLeft: 15)
        
        contentView.addSubview(followButton)
        followButton.centerY(inView: self)
        followButton.anchor(right: rightAnchor, paddingRight: 12)
        
        configureUiTop()
        
        followButton.isHidden = true
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - Actions
    
    @objc func handleFollowTapped() {
        guard let viewModel = viewModel else { return }
        
        if viewModel.notification.userIsFollowed {
            delegate?.cell(self, wantsToUnfollow: viewModel.notification.uid)
        } else {
            delegate?.cell(self, wantsToFollow: viewModel.notification.uid)
        }
    }
    
    @objc func handlePostTapped() {
        //If there is a post
    }
    
    //MARK: - Helpers
    
    func configureUiTop() {
        
        let stack = UIStackView(arrangedSubviews: [infoLabel, postTimeLabel])
        stack.axis = .vertical
        stack.spacing = 3
        
        contentView.addSubview(stack)
        stack.centerY(inView: profileImageview, leftAnchor: profileImageview.rightAnchor, paddingLeft: 10)
        stack.anchor(right: followButton.leftAnchor, paddingRight: 4)
    }
    
    func configure() {
        guard let viewModel = viewModel else { return }
        
        profileImageview.sd_setImage(with: viewModel.postImageUrl)
        
        infoLabel.attributedText = viewModel.notificationMessage
        
        followButton.isHidden = !viewModel.shouldHidePlayButton
        playImageView.isHidden = viewModel.shouldHidePlayButton
        postTimeLabel.text = viewModel.timestampString
        
        followButton.setTitle(viewModel.followButtonText, for: .normal)
        followButton.backgroundColor = viewModel.followButtonBackgroundColor
        followButton.setTitleColor(viewModel.followButtonTextColor, for: .normal)    }
}
