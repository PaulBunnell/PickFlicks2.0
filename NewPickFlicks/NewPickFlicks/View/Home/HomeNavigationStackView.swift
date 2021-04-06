//
//  HomeNavigationStackView.swift
//  NewPickFlicks
//
//  Created by John Padilla on 3/16/21.
//

import UIKit

protocol HomeNavigationStackViewDelegate: class {
    func ShowProfile()
    func refreshCards()
}

class HomeNavigationStackView: UIStackView {
    
    //MARK: - Properties
    
    weak var delegate: HomeNavigationStackViewDelegate?
    
    let refreshButton = UIButton(type: .system)
    let profileButton = UIButton(type: .system)
    let tinderIcon = UIImageView(image: #imageLiteral(resourceName: "app_icon"))
    
    //MARK: - Lifecycle
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        heightAnchor.constraint(equalToConstant: 80).isActive = true
        tinderIcon.contentMode = .scaleAspectFit
        
        refreshButton.setImage(#imageLiteral(resourceName: "icons8-refresh-50").withRenderingMode(.alwaysOriginal), for: .normal)
        profileButton.setImage(#imageLiteral(resourceName: "icons8-tune-50-2").withRenderingMode(.alwaysOriginal), for: .normal)

        
        [refreshButton, UIView(), tinderIcon, UIView(), profileButton].forEach { view in
            addArrangedSubview(view)
        }
        
        distribution = .equalCentering
        isLayoutMarginsRelativeArrangement = true
        layoutMargins = .init(top: 0, left: 0, bottom: 0, right: 0)
        
        profileButton.addTarget(self, action: #selector(handleShowProfile), for: .touchUpInside)
        refreshButton.addTarget(self, action: #selector(handleRefreshButton), for: .touchUpInside)

    }
    
    //MARK: - Actions
    
    @objc func handleShowProfile() {
        delegate?.ShowProfile()
    }
    
    @objc func handleRefreshButton() {
        delegate?.refreshCards()
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}


