//
//  Session.swift
//  NewPickFlicks
//
//  Created by Ryan Anderson on 3/24/21.
//

import Foundation
import Firebase
import FirebaseFirestore

class Session {
    
    var hostUser : User
    var movieHostID : String
    var users : [User]
    var time : Date
    var groupName : String
    var favoriteMovies : [Movie]
    var sessionID : String
<<<<<<< HEAD
    var startSession : Bool

=======
>>>>>>> 4af8ba1839705ae887f3428094d2042481137947
    
    init(hostUser: User, users: [User], movieHostID: String, time: Date, groupName: String, favoriteMovies: [Movie], sessionID: String, startSession: Bool) {
        
        self.hostUser = hostUser
        self.movieHostID = movieHostID
        self.users = users
        self.time = time
        self.groupName = groupName
        self.favoriteMovies = favoriteMovies
        self.sessionID = sessionID
<<<<<<< HEAD
        self.startSession = startSession
        
    }
}


=======
    }
}

>>>>>>> 4af8ba1839705ae887f3428094d2042481137947
//identify who the Host is going to be and assgin Host and ID
//create a session over Firebase assign Host to session
//send session id
//need to get the instance of the current user " UserServices.fetchUser "
//have current users use session id and add current user to the session over firebase
