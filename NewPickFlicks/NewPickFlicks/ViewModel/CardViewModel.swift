//
//  CardViewModel.swift
//  NewPickFlicks
//
//  Created by John Padilla on 3/16/21.
//

import UIKit

class CardViewModel {
    
    let movie: Movie
    
    let moviesInfoText: NSAttributedString
    private var imageIndex = 0
    
    var shownImage: UIImage?
    
    init(movie: Movie) {
        self.movie = movie
        
        let attributedText = NSMutableAttributedString(string: movie.title, attributes: [.font: UIFont.boldSystemFont(ofSize: 30), .foregroundColor: UIColor.white])
        attributedText.append(NSAttributedString(string: "  Ratings: \(movie.vote_average)", attributes:  [.font: UIFont.systemFont(ofSize: 14), .foregroundColor: UIColor.white]))
        
        
        
        self.moviesInfoText = attributedText
    }
    
}
