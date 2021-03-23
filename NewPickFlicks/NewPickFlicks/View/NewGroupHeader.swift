//
//  NewGroupHeader.swift
//  NewPickFlicks
//
//  Created by John Padilla on 3/23/21.
//

import UIKit

class NewGroupHeader: UICollectionReusableView {
    
    //MARK: - Properties
    
    private let newGroupLabel: UILabel = {
       let label = UILabel()
        label.text = "New Group info"
        label.font = UIFont.boldSystemFont(ofSize: 18)
        label.textColor = #colorLiteral(red: 0.9137254902, green: 0.2509803922, blue: 0.3411764706, alpha: 1)
        return label
    }()
    
    
    //MARK: - Lifecycle
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addSubview(newGroupLabel)
        newGroupLabel.anchor(top: topAnchor, left: leftAnchor, paddingTop: 12, paddingLeft: 12)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
