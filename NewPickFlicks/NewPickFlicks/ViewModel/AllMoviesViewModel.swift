//
//  AllMoviesViewModel.swift
//  NewPickFlicks
//
//  Created by John Padilla on 3/31/21.
//

import UIKit

class AllMoviesViewModel {
    
    var movies: Movie
    
    var title: String {
        return movies.title
    }
    
    var shownImage: UIImage?
    
    init(movies: Movie) {
        self.movies = movies
    }

}
