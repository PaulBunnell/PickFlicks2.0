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
    
    var posterImageView: UIImageView = {
        var posterView = UIImageView()
        posterView.contentMode = .scaleAspectFit
        
        return posterView
    } ()
    
    
    let movieController = MovieController()
    
    let blurEffect = UIBlurEffect(style: UIBlurEffect.Style.systemUltraThinMaterial)
    let blurEffectView = UIVisualEffectView(effect: UIBlurEffect(style: UIBlurEffect.Style.dark))
    
    
    override init(frame: CGRect) {
        
        super.init(frame: frame)
        
        addSubview(posterImageView)
                
        blurEffectView.frame = posterImageView.bounds
        blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        
        posterImageView.translatesAutoresizingMaskIntoConstraints = false
        posterImageView.topAnchor.constraint(equalTo: topAnchor).isActive = true
        posterImageView.leftAnchor.constraint(equalTo: leftAnchor).isActive = true
        posterImageView.rightAnchor.constraint(equalTo: rightAnchor).isActive = true
        posterImageView.heightAnchor.constraint(equalToConstant: 200).isActive = true
        
        posterImageView.layer.cornerRadius = 20
        posterImageView.clipsToBounds = true
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
