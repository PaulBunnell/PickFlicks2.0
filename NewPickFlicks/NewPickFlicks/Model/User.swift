//
//  User.swift
//  NewPickFlicks
//
//  Created by John Padilla on 3/18/21.
//

import Foundation
import Firebase

struct User {
    
    let uid: String
    let email: String
    var fullname: String
    var username: String
    var likedMovie: Int
    var profileImageUrl: String
    static var favoriteMovies: [Movie]?
        
    var isFollowed = false
    var startMatching = false
    
    var stats: UserStats!
    
    var isCurrentUser: Bool {
        return Auth.auth().currentUser?.uid == uid
    }
    
    init(dictionary: [String: Any]) {
        self.email = dictionary["email"] as? String ?? ""
        self.fullname = dictionary["fullname"] as? String ?? ""
        self.username = dictionary["username"] as? String ?? ""
        self.profileImageUrl = dictionary["profileImageUrl"] as? String ?? ""
        self.uid = dictionary["uid"] as? String ?? ""
        self.likedMovie = dictionary["likedmovies"] as? Int ?? 0
        self.stats = UserStats(followers: 0, following: 0)
    }

    
    static func addMovieToFavorites(movie: Movie) {
         guard let _ = favoriteMovies else {
             favoriteMovies = [movie]
             return
         }

         favoriteMovies?.append(movie)
     }

    
    
}

struct UserStats {
    let followers: Int
    let following: Int
//    let posts: Int

}
