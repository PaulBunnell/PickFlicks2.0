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
    var timeRemaining : Int
    var groupName : String
    var favoriteMovies : [Movie]
    var sessionID : String
    var startSession : Bool
    
    
    init(hostUser: User, users: [User], movieHostID: String, time: Int, groupName: String, favoriteMovies: [Movie], sessionID: String, startSession: Bool) {
        
        self.hostUser = hostUser
        self.movieHostID = movieHostID
        self.users = users
        self.timeRemaining = time
        self.groupName = groupName
        self.favoriteMovies = favoriteMovies
        self.sessionID = sessionID
        self.startSession = startSession
        
    }
    
    
    func ToggleSession() {
        
        if Auth.auth().currentUser?.uid == hostUser.uid {
            startSession.toggle()
        } else {
            print("Error, non-host changing to toggle StartSession")
        }
    }
    
    func sessionTimer() {
    }
    
    
}


//identify who the Host is going to be and assgin Host and ID
//create a session over Firebase assign Host to session
//send session id
//need to get the instance of the current user " UserServices.fetchUser "
//have current users use session id and add current user to the session over firebase
