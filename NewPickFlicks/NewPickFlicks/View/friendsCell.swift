//
//  friendsCell.swift
//  NewPickFlicks
//
//  Created by John Padilla on 3/26/21.
//

import UIKit

class friendsCell: UICollectionViewCell {
    
    //MARK: - Properties
    
    var viewModel: UserCellViewModel? {
        didSet {
            configure()
        }
    }
    
    private let profileImageView: UIImageView = {
        let iv = UIImageView(image: #imageLiteral(resourceName: "e0c580fdd7a6191f7873b6071095117d_a8de0a69ff17e925e8233498ae3bc2d1"))
        iv.contentMode = .scaleAspectFill
        iv.clipsToBounds = true
        iv.layer.borderWidth = 3
        iv.layer.borderColor = UIColor.white.cgColor
        iv.setDimensions(height: 70, width: 70)
        iv.layer.cornerRadius = 70 / 2
        iv.backgroundColor = .lightGray
        return iv
    }()
    
    private let nameLabel: UILabel = {
        let label = UILabel()
        label.textColor = .darkGray
        label.font = UIFont.systemFont(ofSize: 10)
        label.text = "User Name"
        label.textAlignment = .center
        label.numberOfLines = 2
        return label
    }()
    
    //MARK: - Lifecycle
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        let stack = UIStackView(arrangedSubviews: [profileImageView, nameLabel])
        stack.axis = .vertical
        stack.distribution = .fillProportionally
        stack.alignment = .center
        stack.spacing = 1
        
        addSubview(stack)
        stack.fillSuperview()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure() {
//        guard let viewModel = viewModel else { return }

        nameLabel.text = viewModel?.fullname
    }
}
