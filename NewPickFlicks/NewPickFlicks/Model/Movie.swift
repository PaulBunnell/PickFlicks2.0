//
//  Movie.swift
//  NewPickFlicks
//
//  Created by Paul Bunnell on 3/22/21.
//

import Foundation

struct Movie: Codable {
    var title: String
    var overview: String
    var vote_average: Double
    var poster_path: String
    var release_date: String
}

struct MovieResults: Codable {
    let results: [Movie]
}
