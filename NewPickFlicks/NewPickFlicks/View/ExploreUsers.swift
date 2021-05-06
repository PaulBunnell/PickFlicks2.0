//
//  ExploreMovies.swift
//  NewPickFlicks
//
//  Created by John Padilla on 4/1/21.
//

import UIKit

class ExploreUsers: UICollectionViewCell {
    
    //MARK: - Properties
    
    var viewModel: UserCellViewModel? { didSet { configure() } }

    private let categoryImageView: UIImageView = {
       let iv = UIImageView()
        iv.contentMode = .scaleAspectFill
        iv.clipsToBounds = true
        return iv
    }()
    
    //MARK: - Lifecycle
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        configureViewComponents()
    }
    
    //MARK: - Helper
    
    func configureViewComponents() {
        backgroundColor = .secondarySystemBackground
        
        addSubview(categoryImageView)
        categoryImageView.setDimensions(height: 125, width: 125)
        categoryImageView.layer.cornerRadius = 125 / 2
//        categoryImageView.fillSuperview()
    }
    
    func configure() {
        guard let viewModel = viewModel else { return }
        categoryImageView.sd_setImage(with: viewModel.profileImageUrl)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
