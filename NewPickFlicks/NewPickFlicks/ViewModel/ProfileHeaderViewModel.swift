//
//  ProfileHeaderViewModel.swift
//  NewPickFlicks
//
//  Created by John Padilla on 3/18/21.
//

import Foundation

struct ProfileHeaderViewModel {
    
    var user: User
    
    var fullname: String {
        return user.fullname
    }
    
    var username: String {
        return user.username
    }
    
    var profileImageUrl: URL? {
        return URL(string: user.profileImageUrl)
    }
    
    init(user: User) {
        self.user = user
    }
}
