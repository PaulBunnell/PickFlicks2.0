//
//  PlayBottomControllerStackView.swift
//  NewPickFlicks
//
//  Created by John Padilla on 4/28/21.
//

import UIKit

protocol PlayBottomControlStackViewDelegate: class {
    func handleLike()
    func handleDislike()
    func refreshCards()
}

class PlayBottomControllerStackView: UIStackView {
    
    //MARK: - Properties
    
    weak var delegate: PlayBottomControlStackViewDelegate?

    let refreshButton = UIButton(type: .system)
    let dislikeButton = UIButton(type: .system)
    let superlikeButton = UIButton(type: .system)
    let likeButton = UIButton(type: .system)
    let boostButton = UIButton(type: .system)

    //MARK: - Lifecycle
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        heightAnchor.constraint(equalToConstant: 100).isActive = true
        distribution = .fillEqually
        
        refreshButton.setImage(#imageLiteral(resourceName: "refresh_circle").withRenderingMode(.alwaysOriginal), for: .normal)
        dislikeButton.setImage(#imageLiteral(resourceName: "dismiss_circle").withRenderingMode(.alwaysOriginal), for: .normal)
        superlikeButton.setImage(#imageLiteral(resourceName: "super_like_circle").withRenderingMode(.alwaysOriginal), for: .normal)
        likeButton.setImage(#imageLiteral(resourceName: "like_circle").withRenderingMode(.alwaysOriginal), for: .normal)
        boostButton.setImage(#imageLiteral(resourceName: "boost_circle").withRenderingMode(.alwaysOriginal), for: .normal)

        refreshButton.addTarget(self, action: #selector(handleRefresh), for: .touchUpInside)
        dislikeButton.addTarget(self, action: #selector(handleDislike), for: .touchUpInside)
        superlikeButton.addTarget(self, action: #selector(handleSuperlike), for: .touchUpInside)
        likeButton.addTarget(self, action: #selector(handleLike), for: .touchUpInside)
        boostButton.addTarget(self, action: #selector(handleBoost), for: .touchUpInside)

        [dislikeButton, refreshButton, likeButton].forEach { view in
            addArrangedSubview(view)
        }
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - Actions
    
    @objc func handleRefresh() {
        delegate?.refreshCards()
    }
    
    @objc func handleDislike() {
        delegate?.handleDislike()
    }
    
    @objc func handleSuperlike() {
        print("DEBUG; Tap superlike")
    }
    
    @objc func handleLike() {
        delegate?.handleLike()
    }
    
    @objc func handleBoost() {
        print("DEBUG: tap boost")
    }
    
}
