//
//  CardViewModel.swift
//  NewPickFlicks
//
//  Created by John Padilla on 3/16/21.
//

import UIKit

class CardViewModel {
    
    let movies: Movies
    
    let moviesInfoText: NSAttributedString
    private var imageIndex = 0
    
    var imageToShow: UIImage?
    
    init(movies: Movies) {
        self.movies = movies
        
        let attributedText = NSMutableAttributedString(string: movies.name, attributes: [.font: UIFont.boldSystemFont(ofSize: 30), .foregroundColor: UIColor.white])
        attributedText.append(NSAttributedString(string: "  Rating: \(movies.rating)", attributes:  [.font: UIFont.systemFont(ofSize: 14), .foregroundColor: UIColor.white]))
        
        self.moviesInfoText = attributedText
    }
    
    func showNextPhoto() {
        guard imageIndex < movies.images.count - 1 else { return }
        imageIndex += 1
        self.imageToShow = movies.images[imageIndex]
        
    }
    
    func showPreviousPhoto() {
        guard imageIndex > 0 else { return }
        imageIndex -= 1
        self.imageToShow = movies.images[imageIndex]

    }
}
