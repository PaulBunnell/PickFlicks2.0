//
//  ExploreMovies.swift
//  NewPickFlicks
//
//  Created by John Padilla on 4/1/21.
//

import UIKit

class ExploreMovies: UICollectionViewCell {
    
    //MARK: - Properties
    
    private let moviePoster: UIImageView = {
       let image = UIImageView()
        image.image = #imageLiteral(resourceName: "MV5BN2JlZTBhYTEtZDE3OC00NTA3LTk5NTQtNjg5M2RjODllM2M0XkEyXkFqcGdeQXVyNjk1Njg5NTA@._V1_")
        image.contentMode = .scaleAspectFit
        image.layer.cornerRadius = 10
        image.clipsToBounds = true
        return image
    }()
    
    //MARK: - Lifecycle
    
    override init(frame: CGRect) {
        super.init(frame: frame)
                
        addSubview(moviePoster)
        moviePoster.fillSuperview()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
