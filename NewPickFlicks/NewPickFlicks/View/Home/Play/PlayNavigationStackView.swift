//
//  PlayNavigationStackView.swift
//  NewPickFlicks
//
//  Created by John Padilla on 4/28/21.
//

import UIKit

protocol PlayNavigationStackViewDelegate: class {
    func ShowProfile()
    func showMore()
    func showMovies()
}

class PlayNavigationStackView: UIStackView {
    
    //MARK: - Properties
    
    weak var delegate: PlayNavigationStackViewDelegate?
    
    let profileButton = UIButton(type: .system)
    let moreButton = UIButton(type: .system)
    let searchButton = UIButton(type: .system)
    let tinderIcon = UIImageView(image: #imageLiteral(resourceName: "app_icon"))
    
    //MARK: - Lifecycle
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        heightAnchor.constraint(equalToConstant: 80).isActive = true
        tinderIcon.contentMode = .scaleAspectFit
        
        profileButton.setImage(#imageLiteral(resourceName: "top_left_profile").withRenderingMode(.alwaysOriginal), for: .normal)
        moreButton.setImage(#imageLiteral(resourceName: "icons8-tune-50-2").withRenderingMode(.alwaysOriginal), for: .normal)
        searchButton.setImage(#imageLiteral(resourceName: "Search").withRenderingMode(.alwaysOriginal), for: .normal)

        
        [profileButton, UIView(), UIView(), searchButton, moreButton].forEach { view in
            addArrangedSubview(view)
        }
        
        distribution = .equalCentering
        isLayoutMarginsRelativeArrangement = true
        layoutMargins = .init(top: 0, left: 0, bottom: 0, right: 0)
        
        moreButton.addTarget(self, action: #selector(handleDismissButton), for: .touchUpInside)
        profileButton.addTarget(self, action: #selector(handleShowProfile), for: .touchUpInside)
        searchButton.addTarget(self, action: #selector(handleSearhMovies), for: .touchUpInside)

    }
    
    //MARK: - Actions
    
    @objc func handleShowProfile() {
        delegate?.ShowProfile()
    }
    
    @objc func handleDismissButton() {
        delegate?.showMore()
    }
    
    @objc func handleSearhMovies() {
        delegate?.showMovies()
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}


