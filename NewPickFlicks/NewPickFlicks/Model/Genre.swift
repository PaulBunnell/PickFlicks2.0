//
//  Genre.swift
//  NewPickFlicks
//
//  Created by Paul Bunnell on 4/2/21.
//

import Foundation

struct Genre: Codable {
    var id: Int
    var name: String
}

struct GenreResults: Codable {
    var genres: [Genre]
}
