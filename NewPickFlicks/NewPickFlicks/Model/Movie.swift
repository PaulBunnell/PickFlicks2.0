//
//  Movie.swift
//  NewPickFlicks
//
//  Created by Paul Bunnell on 3/22/21.
//

import Foundation

struct Movie: Codable, Equatable, Identifiable {
    
    var id: Int
    var title: String
    var overview: String
    var vote_average: Double
    var poster_path: String
    var release_date: String
    
//    var didLike = false
    
//    init(id: String, dictionary: [String: Any]) {
//        self.id = id
//        self.title = dictionary["title"] as? String ?? ""
//        self.overview = dictionary["overview"] as? String ?? ""
//        self.poster_path = dictionary["poster_path"] as? String ?? ""
//        self.release_date = dictionary["releaseease_date"] as? String ?? ""
//        self.likedMovie = dictionary["likedMovie"] as? Int ?? 0
//        self.vote_average = dictionary["vote_average"] as? Double ?? 0
//    }
}



struct MovieResults: Codable {
    let results: [Movie]
}
