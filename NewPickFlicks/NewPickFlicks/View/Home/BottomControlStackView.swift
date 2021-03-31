//
//  BottomControlStackView.swift
//  NewPickFlicks
//
//  Created by John Padilla on 3/16/21.
//

import UIKit

protocol BottomControlStackViewDelegate: class {
    func handleLike()
    func handleDislike()
    func handleStartSession()
}

class BottomControlStackView: UIStackView {
    
    //MARK: - Properties
    
    weak var delegate: BottomControlStackViewDelegate?
    
    let dislikeButton = UIButton(type: .system)
    let startSessionButton = UIButton(type: .system)
    let likeButton = UIButton(type: .system)

    //MARK: - Lifecycle
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        heightAnchor.constraint(equalToConstant: 100).isActive = true
        distribution = .fillEqually
        
        dislikeButton.setImage(#imageLiteral(resourceName: "dismiss_circle").withRenderingMode(.alwaysOriginal), for: .normal)
        startSessionButton.setImage(#imageLiteral(resourceName: "icons8-movie-ticket-90").withRenderingMode(.alwaysOriginal), for: .normal)
        likeButton.setImage(#imageLiteral(resourceName: "like_circle").withRenderingMode(.alwaysOriginal), for: .normal)

        dislikeButton.addTarget(self, action: #selector(handleDislike), for: .touchUpInside)
        startSessionButton.addTarget(self, action: #selector(handleStartSession), for: .touchUpInside)
        likeButton.addTarget(self, action: #selector(handleLike), for: .touchUpInside)

        [dislikeButton, startSessionButton, likeButton].forEach { view in
            addArrangedSubview(view)
        }
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - Actions
    
    @objc func handleDislike() {
        delegate?.handleDislike()
        
    }
    
    @objc func handleLike() {
        delegate?.handleLike()
    }
    
    @objc func handleStartSession() {
        delegate?.handleStartSession()
    }
    
}
