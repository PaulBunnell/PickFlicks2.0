//
//  MovieDetailController.swift
//  NewPickFlicks
//
//  Created by John Padilla on 3/18/21.
//

import UIKit

class MovieDetailController: UIViewController {
    
    //MARK: - Properties
    
    private let movies: Movies
    
    //MARK: - Lifecycle
    
    init(movies: Movies) {
        self.movies = movies
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .lightGray
    }
    
}
