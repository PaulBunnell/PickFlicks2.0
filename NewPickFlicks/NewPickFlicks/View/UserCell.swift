//
//  UserCell.swift
//  NewPickFlicks
//
//  Created by John Padilla on 3/23/21.
//

import UIKit

class UserCell: UITableViewCell {
    
    //MARK: - Properties
    
    var viewModel: UserCellViewModel? { didSet { configure() } }
    
    private let profileImageView: UIImageView = {
       let iv = UIImageView()
        iv.contentMode = .scaleAspectFill
        iv.clipsToBounds = true
        iv.backgroundColor = .lightGray
        iv.image = #imageLiteral(resourceName: "e0c580fdd7a6191f7873b6071095117d_a8de0a69ff17e925e8233498ae3bc2d1")
        return iv
    }()
    
    private let fullnameLabel: UILabel = {
       let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 15)
        label.text = "John Padilla"
        return label
    }()
    
    private let usernameLabel: UILabel = {
       let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 13)
        label.textColor = .lightGray
        label.text = "johnpadi28"
        return label
    }()
    
    //MARK: - Lifecycle
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
//        
//        addSubview(backdView)
//        backdView.anchor(top: topAnchor, left: leftAnchor, bottom: bottomAnchor, right: rightAnchor, paddingTop: 1, paddingBottom: 1)
        
        addSubview(profileImageView)
        profileImageView.setDimensions(height: 45, width: 45)
        profileImageView.layer.cornerRadius = 45 / 2
        profileImageView.centerY(inView: self, leftAnchor: leftAnchor, paddingLeft: 20)
        
        let stack = UIStackView(arrangedSubviews: [fullnameLabel, usernameLabel])
        stack.axis = .vertical
        stack.spacing = 2
        stack.alignment = .leading
        
        addSubview(stack)
        stack.centerY(inView: profileImageView, leftAnchor: profileImageView.rightAnchor, paddingLeft: 8)
    }
    
    //MARK: - Helpers
    
    func configure() {
        guard let viewModel = viewModel else { return }
        
        profileImageView.sd_setImage(with: viewModel.profileImageUrl)
        fullnameLabel.text = viewModel.fullname
        usernameLabel.text = viewModel.username
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
