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
    var profileImageUrl: String
    
    var isCurrentUser: Bool {
        return Auth.auth().currentUser?.uid == uid
    }
    
    init(dictionary: [String: Any]) {
        self.email = dictionary["email"] as? String ?? ""
        self.fullname = dictionary["fullname"] as? String ?? ""
        self.username = dictionary["username"] as? String ?? ""
        self.profileImageUrl = dictionary["profileImageUrl"] as? String ?? ""
        self.uid = dictionary["uid"] as? String ?? ""
    }
}
