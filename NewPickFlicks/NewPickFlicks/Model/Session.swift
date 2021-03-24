//
//  Session.swift
//  NewPickFlicks
//
//  Created by Ryan Anderson on 3/24/21.
//

import Foundation

class Session {
    
    var hostUser : User
    var users : [User]
    var time : Date
    var groupName : String
    var favoriteMovies : [Movie]
    var sessionID : String

    
    init(hostUser: User, users: [User], time: Date, groupName: String, favoriteMovies: [Movie], sessionID: String) {
        
        self.hostUser = hostUser
        self.users = users
        self.time = time
        self.groupName = groupName
        self.favoriteMovies = favoriteMovies
        self.sessionID = sessionID
        
    }
}
