//
//  ProfileCell.swift
//  NewPickFlicks
//
//  Created by John Padilla on 3/17/21.
//

import UIKit

class ProfileCell: UICollectionViewCell {
    
    //MARK: - Properties
    
    //MARK: - Lifecycle
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = .darkGray
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
